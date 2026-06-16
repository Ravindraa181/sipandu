-- ============================================================
-- SIPANDU — SEED DATA NILAI DUMMY
-- Semester Genap 2025/2026 | SMAN 13 Bandung
-- ============================================================
-- CARA PAKAI:
--   Jalankan di Supabase SQL Editor (Settings → SQL Editor)
--   sebagai postgres / service role. Pilih "Run without RLS".
--
--   Jika timeout, jalankan per BLOK secara berurutan.
--
-- PRASYARAT:
--   1. Periode aktif sudah ada (status = 'active')
--   2. Siswa sudah di-enroll ke kelas (student_class_enrollments)
--   3. Kategori pelanggaran & reward sudah diinput (is_active = true)
--
-- DISTRIBUSI TIER:
--   PP  (Perlu Pembinaan) :  5%  — kehadiran sangat rendah (45-62%)
--   C   (Cukup)           : 10%  — kehadiran rendah (65-79%)
--   B   (Baik)            : 25%  — kehadiran sedang (80-92%)
--   SB  (Sangat Baik)     : 60%  — kehadiran tinggi (88-100%)
--
-- CATATAN PENTING:
--   - Poin Perilaku TIDAK PERNAH 0. Minimum 50 untuk semua siswa.
--   - Hanya pelanggaran kecil (≤ 15 poin) yang digunakan.
--   - Kategori PP disebabkan kehadiran rendah, bukan nilai perilaku 0.
-- ============================================================

BEGIN;

-- ────────────────────────────────────────────────────────────────────────────
-- BLOK 1: Fungsi bantu fuzzy Mamdani
-- ────────────────────────────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION _sp_tl(x NUMERIC, a NUMERIC, b NUMERIC)
RETURNS NUMERIC LANGUAGE sql IMMUTABLE STRICT AS $$
  SELECT CASE WHEN x <= a THEN 1.0
              WHEN x >= b THEN 0.0
              ELSE (b - x) / (b - a) END;
$$;

CREATE OR REPLACE FUNCTION _sp_tri(x NUMERIC, a NUMERIC, b NUMERIC, c NUMERIC)
RETURNS NUMERIC LANGUAGE sql IMMUTABLE STRICT AS $$
  SELECT CASE WHEN x <= a OR x >= c THEN 0.0
              WHEN x <= b THEN (x - a) / (b - a)
              ELSE (c - x) / (c - b) END;
$$;

CREATE OR REPLACE FUNCTION _sp_tr(x NUMERIC, a NUMERIC, b NUMERIC)
RETURNS NUMERIC LANGUAGE sql IMMUTABLE STRICT AS $$
  SELECT CASE WHEN x <= a THEN 0.0
              WHEN x >= b THEN 1.0
              ELSE (x - a) / (b - a) END;
$$;

CREATE OR REPLACE FUNCTION _sp_zstar(x1 NUMERIC, x2 NUMERIC, x3 NUMERIC)
RETURNS NUMERIC LANGUAGE plpgsql IMMUTABLE STRICT AS $$
DECLARE
  x1l NUMERIC; x1m NUMERIC; x1h NUMERIC;
  x2l NUMERIC; x2m NUMERIC; x2h NUMERIC;
  x3l NUMERIC; x3m NUMERIC; x3h NUMERIC;
  a_pp NUMERIC := 0; a_c  NUMERIC := 0;
  a_b  NUMERIC := 0; a_sb NUMERIC := 0;
  al NUMERIC; z NUMERIC; mu NUMERIC;
  num NUMERIC := 0; den NUMERIC := 0; k INT;
BEGIN
  x1l := _sp_tl(x1,60,75);   x1m := _sp_tri(x1,60,75,90);  x1h := _sp_tr(x1,85,95);
  x2l := _sp_tl(x2,40,60);   x2m := _sp_tri(x2,40,60,80);  x2h := _sp_tr(x2,60,85);
  x3l := _sp_tl(x3,50,70);   x3m := _sp_tri(x3,50,75,90);  x3h := _sp_tr(x3,80,95);

  al:=LEAST(x1h,x2h,x3h); IF al>a_sb THEN a_sb:=al; END IF;
  al:=LEAST(x1h,x2h,x3m); IF al>a_sb THEN a_sb:=al; END IF;
  al:=LEAST(x1h,x2h,x3l); IF al>a_b  THEN a_b:=al;  END IF;
  al:=LEAST(x1h,x2m,x3h); IF al>a_sb THEN a_sb:=al; END IF;
  al:=LEAST(x1h,x2m,x3m); IF al>a_b  THEN a_b:=al;  END IF;
  al:=LEAST(x1h,x2m,x3l); IF al>a_c  THEN a_c:=al;  END IF;
  al:=LEAST(x1h,x2l,x3h); IF al>a_b  THEN a_b:=al;  END IF;
  al:=LEAST(x1h,x2l,x3m); IF al>a_c  THEN a_c:=al;  END IF;
  al:=LEAST(x1h,x2l,x3l); IF al>a_pp THEN a_pp:=al; END IF;
  al:=LEAST(x1m,x2h,x3h); IF al>a_sb THEN a_sb:=al; END IF;
  al:=LEAST(x1m,x2h,x3m); IF al>a_b  THEN a_b:=al;  END IF;
  al:=LEAST(x1m,x2h,x3l); IF al>a_c  THEN a_c:=al;  END IF;
  al:=LEAST(x1m,x2m,x3h); IF al>a_b  THEN a_b:=al;  END IF;
  al:=LEAST(x1m,x2m,x3m); IF al>a_c  THEN a_c:=al;  END IF;
  al:=LEAST(x1m,x2m,x3l); IF al>a_pp THEN a_pp:=al; END IF;
  al:=LEAST(x1m,x2l,x3h); IF al>a_c  THEN a_c:=al;  END IF;
  al:=LEAST(x1m,x2l,x3m); IF al>a_pp THEN a_pp:=al; END IF;
  al:=LEAST(x1m,x2l,x3l); IF al>a_pp THEN a_pp:=al; END IF;
  al:=LEAST(x1l,x2h,x3h); IF al>a_b  THEN a_b:=al;  END IF;
  al:=LEAST(x1l,x2h,x3m); IF al>a_c  THEN a_c:=al;  END IF;
  al:=LEAST(x1l,x2h,x3l); IF al>a_pp THEN a_pp:=al; END IF;
  al:=LEAST(x1l,x2m,x3h); IF al>a_c  THEN a_c:=al;  END IF;
  al:=LEAST(x1l,x2m,x3m); IF al>a_pp THEN a_pp:=al; END IF;
  al:=LEAST(x1l,x2m,x3l); IF al>a_pp THEN a_pp:=al; END IF;
  al:=LEAST(x1l,x2l,x3h); IF al>a_pp THEN a_pp:=al; END IF;
  al:=LEAST(x1l,x2l,x3m); IF al>a_pp THEN a_pp:=al; END IF;
  al:=LEAST(x1l,x2l,x3l); IF al>a_pp THEN a_pp:=al; END IF;

  IF a_pp=0 AND a_c=0 AND a_b=0 AND a_sb=0 THEN RETURN 0.0; END IF;

  FOR k IN 0..199 LOOP
    z  := k * 100.0 / 199.0;
    mu := GREATEST(
      CASE WHEN a_pp>0 THEN LEAST(a_pp, _sp_tl(z,  40,50))     ELSE 0.0 END,
      CASE WHEN a_c >0 THEN LEAST(a_c,  _sp_tri(z, 40,55,70))  ELSE 0.0 END,
      CASE WHEN a_b >0 THEN LEAST(a_b,  _sp_tri(z, 65,80,90))  ELSE 0.0 END,
      CASE WHEN a_sb>0 THEN LEAST(a_sb, _sp_tr(z,  85,95))     ELSE 0.0 END
    );
    num := num + z * mu;
    den := den + mu;
  END LOOP;

  RETURN CASE WHEN den <= 0 THEN 0.0
              ELSE ROUND((num / den)::NUMERIC, 2) END;
END;
$$;


-- ────────────────────────────────────────────────────────────────────────────
-- BLOK 2: Tabel sementara tier siswa
-- ────────────────────────────────────────────────────────────────────────────

CREATE TEMP TABLE IF NOT EXISTS _sp_tiers (
  enrollment_id   UUID     PRIMARY KEY,
  student_id      UUID     NOT NULL,
  assignment_id   UUID     NOT NULL,
  tier            SMALLINT NOT NULL CHECK (tier BETWEEN 1 AND 4)
) ON COMMIT DROP;


-- ────────────────────────────────────────────────────────────────────────────
-- BLOK 3: Absensi bulanan + poin perilaku
--
-- Strategi skor perilaku per tier (raw_score setelah transaksi):
--   PP  (tier 1): raw_score 50–64  — kehadiran 45-62% yang menyebabkan PP
--   C   (tier 2): raw_score 64–74  — kehadiran 65-79%
--   B   (tier 3): raw_score 75–90  — kehadiran 80-92%
--   SB  (tier 4): raw_score 87–105 — kehadiran 88-100%
--
-- Pelanggaran: HANYA kategori dengan point_deduction ≤ 15.
-- Tidak ada siswa dengan Poin Perilaku = 0.
-- ────────────────────────────────────────────────────────────────────────────

DO $$
DECLARE
  v_period_id       UUID;
  v_fallback_uid    UUID;
  v_year            SMALLINT   := 2026;
  v_school_days     SMALLINT[] := ARRAY[23, 17, 6, 25, 14, 10]::SMALLINT[];
  v_months          SMALLINT[] := ARRAY[1,  2,  3,  4,  5,  6]::SMALLINT[];

  v_assignment      RECORD;
  v_enr             RECORD;
  v_teacher_id      UUID;

  -- Semua kategori (untuk reward)
  v_reward_ids      UUID[];
  v_reward_pts      SMALLINT[];

  -- Hanya pelanggaran KECIL ≤ 15 poin (agar skor tidak jatuh ke 0)
  v_viol_ids        UUID[];
  v_viol_pts        SMALLINT[];

  v_rnd             NUMERIC;
  v_tier            SMALLINT;
  v_rate            NUMERIC;
  v_present         SMALLINT;
  v_absent          SMALLINT;
  v_sd              SMALLINT;

  -- Target skor perilaku
  v_target_score    SMALLINT;
  v_total_delta     INT;       -- positif = butuh reward, negatif = butuh pelanggaran
  v_remaining       INT;       -- sisa delta yang perlu dibuat
  v_cat_idx         INT;
  v_pts             SMALLINT;
  v_tx_date         DATE;

  i                 INT;
  j                 INT;
  v_total           INT := 0;
BEGIN
  SELECT id INTO v_period_id FROM public.academic_periods WHERE status='active' LIMIT 1;
  IF v_period_id IS NULL THEN
    RAISE EXCEPTION 'Tidak ada periode aktif.';
  END IF;

  SELECT id INTO v_fallback_uid FROM public.profiles WHERE role='admin' LIMIT 1;
  IF v_fallback_uid IS NULL THEN
    SELECT id INTO v_fallback_uid FROM public.profiles WHERE role='teacher' LIMIT 1;
  END IF;
  IF v_fallback_uid IS NULL THEN
    RAISE EXCEPTION 'Tidak ada admin/teacher sebagai fallback.';
  END IF;

  -- Muat reward (semua kategori)
  SELECT ARRAY_AGG(id ORDER BY point_addition),
         ARRAY_AGG(point_addition::SMALLINT ORDER BY point_addition)
  INTO v_reward_ids, v_reward_pts
  FROM public.reward_categories WHERE is_active = TRUE;

  IF v_reward_ids IS NULL THEN
    RAISE EXCEPTION 'Tidak ada reward_categories aktif.';
  END IF;

  -- Muat HANYA pelanggaran kecil (≤ 15 poin) untuk keamanan skor
  SELECT ARRAY_AGG(id ORDER BY point_deduction),
         ARRAY_AGG(point_deduction::SMALLINT ORDER BY point_deduction)
  INTO v_viol_ids, v_viol_pts
  FROM public.violation_categories
  WHERE is_active = TRUE AND point_deduction <= 15;

  -- Fallback: jika semua pelanggaran > 15, pakai yang paling kecil saja
  IF v_viol_ids IS NULL THEN
    SELECT ARRAY_AGG(id ORDER BY point_deduction),
           ARRAY_AGG(point_deduction::SMALLINT ORDER BY point_deduction)
    INTO v_viol_ids, v_viol_pts
    FROM (
      SELECT id, point_deduction FROM public.violation_categories
      WHERE is_active = TRUE ORDER BY point_deduction LIMIT 3
    ) t;
  END IF;

  IF v_viol_ids IS NULL THEN
    RAISE EXCEPTION 'Tidak ada violation_categories aktif.';
  END IF;

  -- ── Loop per kelas ──────────────────────────────────────────
  FOR v_assignment IN
    SELECT cpa.id,
           COALESCE(cpa.homeroom_teacher_id, v_fallback_uid) AS homeroom_teacher_id
    FROM   public.class_period_assignments cpa
    WHERE  cpa.period_id = v_period_id
    ORDER  BY cpa.id
  LOOP
    v_teacher_id := v_assignment.homeroom_teacher_id;

    FOR v_enr IN
      SELECT sce.id AS enrollment_id, sce.student_id
      FROM   public.student_class_enrollments sce
      WHERE  sce.class_period_assignment_id = v_assignment.id
      AND    sce.status = 'active'
    LOOP
      -- ── Tetapkan tier ───────────────────────────────────────
      v_rnd := random();
      IF    v_rnd < 0.05 THEN v_tier := 1;   -- PP   5 %
      ELSIF v_rnd < 0.15 THEN v_tier := 2;   -- C   10 %
      ELSIF v_rnd < 0.40 THEN v_tier := 3;   -- B   25 %
      ELSE                    v_tier := 4;   -- SB  60 %
      END IF;

      INSERT INTO _sp_tiers (enrollment_id, student_id, assignment_id, tier)
      VALUES (v_enr.enrollment_id, v_enr.student_id, v_assignment.id, v_tier);

      -- ── Kehadiran per tier ──────────────────────────────────
      -- PP: kehadiran sangat rendah → penyebab klasifikasi PP (bukan skor 0)
      CASE v_tier
        WHEN 1 THEN v_rate := 0.45 + random() * 0.17;  -- 45–62 %
        WHEN 2 THEN v_rate := 0.65 + random() * 0.14;  -- 65–79 %
        WHEN 3 THEN v_rate := 0.80 + random() * 0.12;  -- 80–92 %
        ELSE        v_rate := 0.88 + random() * 0.12;  -- 88–100 %
      END CASE;

      FOR j IN 1..6 LOOP
        v_sd      := v_school_days[j];
        v_present := GREATEST(0::SMALLINT, LEAST(v_sd,
          (ROUND(v_rate * v_sd) + (FLOOR(random()*3))::INT - 1)::SMALLINT
        ));
        v_absent  := v_sd - v_present;

        INSERT INTO public.monthly_attendance
          (enrollment_id, month, year,
           present_days, sick_days, permit_days, absent_days, effective_days,
           is_locked, locked_at, locked_by)
        VALUES
          (v_enr.enrollment_id, v_months[j], v_year,
           v_present, 0, 0, v_absent, v_sd,
           TRUE, NOW(), v_teacher_id)
        ON CONFLICT (enrollment_id, month, year) DO NOTHING;
      END LOOP;

      -- ── Inisialisasi skor perilaku (initial = 75) ───────────
      INSERT INTO public.student_behavior_scores (enrollment_id, raw_score)
      VALUES (v_enr.enrollment_id, 75)
      ON CONFLICT (enrollment_id) DO NOTHING;

      -- ── Target skor perilaku per tier ───────────────────────
      -- Minimum 50 untuk semua tier (tidak ada Poin Perilaku 0)
      CASE v_tier
        WHEN 1 THEN v_target_score := (50 + (FLOOR(random()*14))::INT)::SMALLINT; -- 50–63
        WHEN 2 THEN v_target_score := (64 + (FLOOR(random()*11))::INT)::SMALLINT; -- 64–74
        WHEN 3 THEN v_target_score := (75 + (FLOOR(random()*16))::INT)::SMALLINT; -- 75–90
        ELSE        v_target_score := (87 + (FLOOR(random()*18))::INT)::SMALLINT; -- 87–104
      END CASE;

      v_total_delta := v_target_score - 75;  -- bisa negatif atau positif

      -- ── Generate transaksi pelanggaran (delta negatif) ──────
      IF v_total_delta < 0 THEN
        v_remaining := -v_total_delta;  -- jumlah poin yang perlu dikurangi

        -- Buat 1-3 transaksi pelanggaran, tiap kali ambil kategori acak
        i := 0;
        WHILE v_remaining > 0 AND i < 3 LOOP
          i := i + 1;
          v_cat_idx := 1 + (FLOOR(random() * array_length(v_viol_ids,1)))::INT;
          v_cat_idx := LEAST(v_cat_idx, array_length(v_viol_ids,1));
          v_pts     := v_viol_pts[v_cat_idx];

          -- Jika poin kategori melebihi sisa yang dibutuhkan, gunakan yang terkecil
          IF v_pts > v_remaining THEN
            v_cat_idx := 1;  -- kategori terkecil
            v_pts     := v_viol_pts[1];
          END IF;

          v_tx_date := DATE '2026-01-15' + (FLOOR(random()*139))::INT;

          INSERT INTO public.behavior_point_transactions
            (enrollment_id, transaction_type,
             violation_category_id, reward_category_id,
             points_delta, transaction_date, raw_score_after,
             recorded_by, notes)
          VALUES
            (v_enr.enrollment_id, 'violation'::public.transaction_type,
             v_viol_ids[v_cat_idx], NULL,
             -(v_pts), v_tx_date, 75,
             v_teacher_id, 'Data dummy semester genap 2025/2026');

          v_remaining := v_remaining - v_pts;
        END LOOP;

      -- ── Generate transaksi reward (delta positif) ────────────
      ELSIF v_total_delta > 0 THEN
        v_remaining := v_total_delta;

        i := 0;
        WHILE v_remaining > 0 AND i < 3 LOOP
          i := i + 1;
          v_cat_idx := 1 + (FLOOR(random() * array_length(v_reward_ids,1)))::INT;
          v_cat_idx := LEAST(v_cat_idx, array_length(v_reward_ids,1));
          v_pts     := v_reward_pts[v_cat_idx];

          IF v_pts > v_remaining THEN
            v_cat_idx := 1;
            v_pts     := v_reward_pts[1];
          END IF;

          v_tx_date := DATE '2026-01-15' + (FLOOR(random()*139))::INT;

          INSERT INTO public.behavior_point_transactions
            (enrollment_id, transaction_type,
             violation_category_id, reward_category_id,
             points_delta, transaction_date, raw_score_after,
             recorded_by, notes)
          VALUES
            (v_enr.enrollment_id, 'reward'::public.transaction_type,
             NULL, v_reward_ids[v_cat_idx],
             v_pts, v_tx_date, 75,
             v_teacher_id, 'Data dummy semester genap 2025/2026');

          v_remaining := v_remaining - v_pts;
        END LOOP;
      END IF;
      -- Jika v_total_delta = 0: tidak ada transaksi → skor tetap 75

      v_total := v_total + 1;
    END LOOP;
  END LOOP;

  RAISE NOTICE '✓ Blok 3 selesai: % siswa diproses', v_total;
END $$;


-- ────────────────────────────────────────────────────────────────────────────
-- BLOK 3b: Jaminan keamanan — pastikan tidak ada skor di bawah 50
-- Trigger tidak update skor saat DELETE, jadi ada kemungkinan skor
-- tidak sesuai target jika kategori tidak cukup granular.
-- ────────────────────────────────────────────────────────────────────────────

DO $$
DECLARE
  v_period_id  UUID;
  v_reward_id  UUID;
  v_fallback   UUID;
  v_enr        RECORD;
  v_gap        SMALLINT;
  v_fixed      INT := 0;
BEGIN
  SELECT id INTO v_period_id FROM public.academic_periods WHERE status='active' LIMIT 1;

  SELECT id INTO v_fallback FROM public.profiles WHERE role='admin' LIMIT 1;
  IF v_fallback IS NULL THEN
    SELECT id INTO v_fallback FROM public.profiles WHERE role='teacher' LIMIT 1;
  END IF;

  -- Gunakan reward kategori terkecil untuk koreksi
  SELECT id INTO v_reward_id FROM public.reward_categories
  WHERE is_active = TRUE ORDER BY point_addition LIMIT 1;

  FOR v_enr IN
    SELECT sbs.enrollment_id,
           sbs.raw_score,
           COALESCE(cpa.homeroom_teacher_id, v_fallback) AS teacher_id
    FROM   public.student_behavior_scores sbs
    JOIN   public.student_class_enrollments sce
           ON sce.id = sbs.enrollment_id
    JOIN   public.class_period_assignments cpa
           ON cpa.id = sce.class_period_assignment_id
    WHERE  cpa.period_id = v_period_id
    AND    sbs.raw_score < 50
  LOOP
    v_gap := (50 - v_enr.raw_score)::SMALLINT;

    -- Satu transaksi reward untuk mendorong skor ke 50
    INSERT INTO public.behavior_point_transactions
      (enrollment_id, transaction_type,
       violation_category_id, reward_category_id,
       points_delta, transaction_date, raw_score_after,
       recorded_by, notes)
    VALUES
      (v_enr.enrollment_id, 'reward'::public.transaction_type,
       NULL, v_reward_id,
       v_gap, DATE '2026-03-01', 50,
       v_enr.teacher_id, 'Data dummy semester genap 2025/2026');

    v_fixed := v_fixed + 1;
  END LOOP;

  IF v_fixed > 0 THEN
    RAISE NOTICE '✓ Blok 3b: % siswa skor-nya dikoreksi ke minimum 50', v_fixed;
  ELSE
    RAISE NOTICE '✓ Blok 3b: tidak ada skor di bawah 50, semua aman';
  END IF;
END $$;


-- ────────────────────────────────────────────────────────────────────────────
-- BLOK 4: Buat sesi peer review (status = active)
-- ────────────────────────────────────────────────────────────────────────────

INSERT INTO public.peer_review_sessions
  (class_period_assignment_id, status, opened_at, opened_by)
SELECT
  cpa.id,
  'active'::public.peer_review_status,
  '2026-04-01 08:00:00+07'::TIMESTAMPTZ,
  COALESCE(cpa.homeroom_teacher_id,
    (SELECT id FROM public.profiles WHERE role = 'admin' LIMIT 1))
FROM public.class_period_assignments cpa
WHERE cpa.period_id = (SELECT id FROM public.academic_periods WHERE status = 'active')
ON CONFLICT (class_period_assignment_id) DO UPDATE
  SET status    = 'active',
      opened_at = EXCLUDED.opened_at,
      opened_by = EXCLUDED.opened_by,
      closed_at = NULL,
      closed_by = NULL;


-- ────────────────────────────────────────────────────────────────────────────
-- BLOK 5: Bulk insert submisi peer review
-- Skor per aspek berdasarkan tier reviewee:
--   PP  (tier 1): 1–2  → X3 ≈ 20–40  (rendah, mendukung klasifikasi PP)
--   C   (tier 2): 2–4  → X3 ≈ 40–80
--   B   (tier 3): 3–5  → X3 ≈ 60–100
--   SB  (tier 4): 4–5  → X3 ≈ 80–100
-- ────────────────────────────────────────────────────────────────────────────

INSERT INTO public.peer_review_submissions
  (session_id, reviewer_id, reviewee_id,
   score_courtesy, score_cooperation, score_empathy,
   score_honesty, score_responsibility, submitted_at)
SELECT
  prs.id                                               AS session_id,
  reviewer.student_id                                  AS reviewer_id,
  reviewee.student_id                                  AS reviewee_id,
  GREATEST(1, LEAST(5, (CASE t.tier
    WHEN 1 THEN 1 + (FLOOR(random()*2))::INT   -- 1–2
    WHEN 2 THEN 2 + (FLOOR(random()*3))::INT   -- 2–4
    WHEN 3 THEN 3 + (FLOOR(random()*3))::INT   -- 3–5
    ELSE       4 + (FLOOR(random()*2))::INT    -- 4–5
  END)::SMALLINT)) AS score_courtesy,
  GREATEST(1, LEAST(5, (CASE t.tier
    WHEN 1 THEN 1 + (FLOOR(random()*2))::INT
    WHEN 2 THEN 2 + (FLOOR(random()*3))::INT
    WHEN 3 THEN 3 + (FLOOR(random()*3))::INT
    ELSE       4 + (FLOOR(random()*2))::INT
  END)::SMALLINT)) AS score_cooperation,
  GREATEST(1, LEAST(5, (CASE t.tier
    WHEN 1 THEN 1 + (FLOOR(random()*2))::INT
    WHEN 2 THEN 2 + (FLOOR(random()*3))::INT
    WHEN 3 THEN 3 + (FLOOR(random()*3))::INT
    ELSE       4 + (FLOOR(random()*2))::INT
  END)::SMALLINT)) AS score_empathy,
  GREATEST(1, LEAST(5, (CASE t.tier
    WHEN 1 THEN 1 + (FLOOR(random()*2))::INT
    WHEN 2 THEN 2 + (FLOOR(random()*3))::INT
    WHEN 3 THEN 3 + (FLOOR(random()*3))::INT
    ELSE       4 + (FLOOR(random()*2))::INT
  END)::SMALLINT)) AS score_honesty,
  GREATEST(1, LEAST(5, (CASE t.tier
    WHEN 1 THEN 1 + (FLOOR(random()*2))::INT
    WHEN 2 THEN 2 + (FLOOR(random()*3))::INT
    WHEN 3 THEN 3 + (FLOOR(random()*3))::INT
    ELSE       4 + (FLOOR(random()*2))::INT
  END)::SMALLINT)) AS score_responsibility,
  '2026-05-15 09:00:00+07'::TIMESTAMPTZ AS submitted_at
FROM       _sp_tiers reviewee
JOIN       _sp_tiers reviewer
        ON reviewer.assignment_id = reviewee.assignment_id
       AND reviewer.student_id   <> reviewee.student_id
JOIN       public.peer_review_sessions prs
        ON prs.class_period_assignment_id = reviewee.assignment_id
JOIN       _sp_tiers t
        ON t.enrollment_id = reviewee.enrollment_id
ON CONFLICT (session_id, reviewer_id, reviewee_id) DO NOTHING;


-- ────────────────────────────────────────────────────────────────────────────
-- BLOK 6: Tutup sesi → trigger hitung X3 otomatis
-- ────────────────────────────────────────────────────────────────────────────

UPDATE public.peer_review_sessions prs
SET    status    = 'closed',
       closed_at = '2026-05-31 15:00:00+07',
       closed_by = COALESCE(
                     cpa.homeroom_teacher_id,
                     (SELECT id FROM public.profiles WHERE role = 'admin' LIMIT 1)
                   )
FROM   public.class_period_assignments cpa
WHERE  cpa.id        = prs.class_period_assignment_id
AND    cpa.period_id = (SELECT id FROM public.academic_periods WHERE status = 'active')
AND    prs.status    = 'active';


-- ────────────────────────────────────────────────────────────────────────────
-- BLOK 7: Hitung nilai fuzzy Z* → behavior_final_scores
-- ────────────────────────────────────────────────────────────────────────────

WITH inputs AS (
  SELECT
    sce.id AS enrollment_id,
    ROUND(
      COALESCE(SUM(ma.present_days), 0)::NUMERIC
      / NULLIF(SUM(ma.effective_days), 0) * 100.0, 2
    )                                                          AS x1,
    GREATEST(0, LEAST(COALESCE(MAX(sbs.raw_score), 75), 100))::NUMERIC AS x2,
    COALESCE(MAX(sbs.raw_score), 75)::SMALLINT                 AS raw_x2,
    COALESCE(MAX(x3s.x3_score), 0)::NUMERIC                    AS x3
  FROM       public.student_class_enrollments   sce
  JOIN       public.class_period_assignments    cpa
          ON cpa.id = sce.class_period_assignment_id
  LEFT JOIN  public.monthly_attendance          ma
          ON ma.enrollment_id = sce.id AND ma.year = 2026
  LEFT JOIN  public.student_behavior_scores     sbs
          ON sbs.enrollment_id = sce.id
  LEFT JOIN  public.peer_review_sessions        prs
          ON prs.class_period_assignment_id = cpa.id
  LEFT JOIN  public.student_x3_scores           x3s
          ON x3s.session_id = prs.id AND x3s.student_id = sce.student_id
  WHERE  cpa.period_id = (SELECT id FROM public.academic_periods WHERE status = 'active')
  AND    sce.status    = 'active'
  GROUP  BY sce.id
),
scored AS (
  SELECT enrollment_id, x1, x2, raw_x2, x3,
         _sp_zstar(x1, x2, x3) AS z_star
  FROM   inputs
)
INSERT INTO public.behavior_final_scores
  (enrollment_id, x1, x2, raw_x2, x3, z_star, category, computed_at)
SELECT
  enrollment_id, x1, x2, raw_x2, x3, z_star,
  CASE WHEN z_star >= 85 THEN 'sangat_baik'
       WHEN z_star >= 70 THEN 'baik'
       WHEN z_star >= 55 THEN 'cukup'
       ELSE                   'perlu_pembinaan'
  END::public.behavior_category,
  NOW()
FROM scored
ON CONFLICT (enrollment_id) DO UPDATE SET
  x1          = EXCLUDED.x1,
  x2          = EXCLUDED.x2,
  raw_x2      = EXCLUDED.raw_x2,
  x3          = EXCLUDED.x3,
  z_star      = EXCLUDED.z_star,
  category    = EXCLUDED.category,
  computed_at = EXCLUDED.computed_at,
  updated_at  = NOW();


-- ────────────────────────────────────────────────────────────────────────────
-- BLOK 8: Bersihkan fungsi bantu
-- ────────────────────────────────────────────────────────────────────────────

DROP FUNCTION IF EXISTS _sp_zstar(NUMERIC, NUMERIC, NUMERIC);
DROP FUNCTION IF EXISTS _sp_tri(NUMERIC, NUMERIC, NUMERIC, NUMERIC);
DROP FUNCTION IF EXISTS _sp_tl(NUMERIC, NUMERIC, NUMERIC);
DROP FUNCTION IF EXISTS _sp_tr(NUMERIC, NUMERIC, NUMERIC);

COMMIT;

-- ────────────────────────────────────────────────────────────────────────────
-- VERIFIKASI (jalankan setelah commit)
-- ────────────────────────────────────────────────────────────────────────────
/*
SELECT category,
       COUNT(*) AS jumlah,
       ROUND(COUNT(*)*100.0 / SUM(COUNT(*)) OVER(), 1) AS persen
FROM public.behavior_final_scores bfs
JOIN public.student_class_enrollments sce ON sce.id = bfs.enrollment_id
JOIN public.class_period_assignments  cpa ON cpa.id = sce.class_period_assignment_id
WHERE cpa.period_id = (SELECT id FROM public.academic_periods WHERE status='active')
GROUP BY category ORDER BY category;

-- Cek tidak ada x2 = 0
SELECT COUNT(*) AS siswa_x2_nol
FROM public.behavior_final_scores bfs
JOIN public.student_class_enrollments sce ON sce.id = bfs.enrollment_id
JOIN public.class_period_assignments  cpa ON cpa.id = sce.class_period_assignment_id
WHERE cpa.period_id = (SELECT id FROM public.academic_periods WHERE status='active')
AND   bfs.x2 = 0;
-- Harus 0
*/
