-- ============================================================
-- SIPANDU — RESET DATA NILAI DUMMY
-- Mengembalikan sistem ke kondisi sebelum seed_dummy_data.sql
-- ============================================================
-- CARA PAKAI:
--   Jalankan di Supabase SQL Editor sebagai postgres / service role.
--
-- APA YANG DIHAPUS:
--   ✓ behavior_final_scores (semua siswa di periode aktif)
--   ✓ peer_review_sessions + submissions + x3_scores + progress
--     (CASCADE dari sessions)
--   ✓ behavior_point_transactions dengan notes = 'Data dummy ...'
--   ✓ student_behavior_scores → direset ke initial_score (75)
--   ✓ monthly_attendance tahun 2026 di periode aktif
--
-- APA YANG TIDAK DIHAPUS:
--   ✗ Data siswa, guru, kelas, dan periode
--   ✗ Transaksi perilaku yang BUKAN dummy (notes berbeda)
--   ✗ Konfigurasi fuzzy
--
-- CATATAN:
--   Jika ada transaksi perilaku nyata (bukan dummy), skor perilaku
--   akan dihitung ulang dari transaksi yang tersisa.
-- ============================================================

BEGIN;

DO $$
DECLARE
  v_period_id   UUID;
  n_scores      BIGINT := 0;
  n_sessions    BIGINT := 0;
  n_tx          BIGINT := 0;
  n_att         BIGINT := 0;
  n_sbs         BIGINT := 0;
BEGIN
  SELECT id INTO v_period_id
  FROM public.academic_periods WHERE status = 'active' LIMIT 1;

  IF v_period_id IS NULL THEN
    RAISE EXCEPTION 'Tidak ada periode aktif. Tidak ada yang dihapus.';
  END IF;

  RAISE NOTICE 'Reset data dummy untuk periode: %', v_period_id;

  -- ── 1. Hapus behavior_final_scores ───────────────────────
  DELETE FROM public.behavior_final_scores bfs
  WHERE EXISTS (
    SELECT 1
    FROM   public.student_class_enrollments sce
    JOIN   public.class_period_assignments  cpa
           ON cpa.id = sce.class_period_assignment_id
    WHERE  cpa.period_id = v_period_id
    AND    sce.id        = bfs.enrollment_id
  );
  GET DIAGNOSTICS n_scores = ROW_COUNT;

  -- ── 2. Hapus peer_review_sessions
  --       → CASCADE ke submissions, student_x3_scores, progress ───
  DELETE FROM public.peer_review_sessions prs
  WHERE EXISTS (
    SELECT 1
    FROM   public.class_period_assignments cpa
    WHERE  cpa.period_id = v_period_id
    AND    cpa.id        = prs.class_period_assignment_id
  );
  GET DIAGNOSTICS n_sessions = ROW_COUNT;

  -- ── 3. Hapus transaksi poin perilaku dummy ────────────────
  DELETE FROM public.behavior_point_transactions bpt
  WHERE bpt.notes = 'Data dummy semester genap 2025/2026'
  AND EXISTS (
    SELECT 1
    FROM   public.student_class_enrollments sce
    JOIN   public.class_period_assignments  cpa
           ON cpa.id = sce.class_period_assignment_id
    WHERE  cpa.period_id = v_period_id
    AND    sce.id        = bpt.enrollment_id
  );
  GET DIAGNOSTICS n_tx = ROW_COUNT;

  -- ── 4. Reset student_behavior_scores ke nilai setelah
  --       transaksi non-dummy yang tersisa ───────────────────
  UPDATE public.student_behavior_scores sbs
  SET    raw_score  = COALESCE((
           SELECT sce.initial_score + COALESCE(SUM(bpt.points_delta), 0)
           FROM   public.student_class_enrollments    sce
           LEFT JOIN public.behavior_point_transactions bpt
                  ON bpt.enrollment_id = sce.id
                 AND bpt.deleted_at   IS NULL
           WHERE  sce.id = sbs.enrollment_id
           GROUP  BY sce.id, sce.initial_score
         ), 75),
         updated_at = NOW()
  WHERE EXISTS (
    SELECT 1
    FROM   public.student_class_enrollments sce
    JOIN   public.class_period_assignments  cpa
           ON cpa.id = sce.class_period_assignment_id
    WHERE  cpa.period_id = v_period_id
    AND    sce.id        = sbs.enrollment_id
  );
  GET DIAGNOSTICS n_sbs = ROW_COUNT;

  -- ── 5. Hapus absensi bulanan tahun 2026 ──────────────────
  DELETE FROM public.monthly_attendance ma
  WHERE  ma.year = 2026
  AND EXISTS (
    SELECT 1
    FROM   public.student_class_enrollments sce
    JOIN   public.class_period_assignments  cpa
           ON cpa.id = sce.class_period_assignment_id
    WHERE  cpa.period_id = v_period_id
    AND    sce.id        = ma.enrollment_id
  );
  GET DIAGNOSTICS n_att = ROW_COUNT;

  -- ── Ringkasan ─────────────────────────────────────────────
  RAISE NOTICE '=================================================';
  RAISE NOTICE 'RESET SELESAI';
  RAISE NOTICE '  behavior_final_scores dihapus     : %', n_scores;
  RAISE NOTICE '  peer_review_sessions dihapus      : % (cascade sub+x3+progress)', n_sessions;
  RAISE NOTICE '  behavior_point_transactions dihapus: %', n_tx;
  RAISE NOTICE '  student_behavior_scores direset   : % siswa', n_sbs;
  RAISE NOTICE '  monthly_attendance dihapus        : % baris', n_att;
  RAISE NOTICE '=================================================';
END $$;

COMMIT;

-- ────────────────────────────────────────────────────────────────────────────
-- VERIFIKASI (opsional)
-- ────────────────────────────────────────────────────────────────────────────
/*
-- Pastikan semua tabel bersih
SELECT 'behavior_final_scores' AS tabel, COUNT(*) AS sisa
FROM public.behavior_final_scores bfs
JOIN public.student_class_enrollments sce ON sce.id = bfs.enrollment_id
JOIN public.class_period_assignments cpa  ON cpa.id = sce.class_period_assignment_id
WHERE cpa.period_id = (SELECT id FROM public.academic_periods WHERE status = 'active')
UNION ALL
SELECT 'peer_review_sessions', COUNT(*)
FROM public.peer_review_sessions prs
JOIN public.class_period_assignments cpa ON cpa.id = prs.class_period_assignment_id
WHERE cpa.period_id = (SELECT id FROM public.academic_periods WHERE status = 'active')
UNION ALL
SELECT 'behavior_point_transactions (dummy)', COUNT(*)
FROM public.behavior_point_transactions bpt
JOIN public.student_class_enrollments sce ON sce.id = bpt.enrollment_id
JOIN public.class_period_assignments cpa  ON cpa.id = sce.class_period_assignment_id
WHERE cpa.period_id = (SELECT id FROM public.academic_periods WHERE status = 'active')
AND   bpt.notes = 'Data dummy semester genap 2025/2026'
UNION ALL
SELECT 'monthly_attendance (2026)', COUNT(*)
FROM public.monthly_attendance ma
JOIN public.student_class_enrollments sce ON sce.id = ma.enrollment_id
JOIN public.class_period_assignments cpa  ON cpa.id = sce.class_period_assignment_id
WHERE cpa.period_id = (SELECT id FROM public.academic_periods WHERE status = 'active')
AND   ma.year = 2026;
-- Semua kolom "sisa" harus bernilai 0
*/
