-- ============================================================
-- SIPANDU — SEED DATA NILAI DUMMY
-- Semester Genap 2025/2026 | SMAN 13 Bandung
-- ============================================================
-- CARA PAKAI:
--   Jalankan di Supabase SQL Editor (Settings → SQL Editor)
--   sebagai postgres / service role.
--
--   Jika timeout, jalankan per BLOK secara berurutan:
--     Blok 1 (fungsi fuzzy)
--     Blok 2 (tabel tier sementara)
--     Blok 3 (absensi + poin perilaku)
--     Blok 4 (buat sesi peer review)
--     Blok 5 (bulk insert submisi peer review)
--     Blok 6 (tutup sesi → trigger hitung X3 otomatis)
--     Blok 7 (hitung & simpan nilai fuzzy Z*)
--     Blok 8 (bersihkan fungsi sementara)
--
-- PRASYARAT:
--   1. Periode aktif sudah ada di academic_periods (status = 'active')
--   2. Siswa sudah di-enroll ke kelas (student_class_enrollments)
--   3. Setiap class_period_assignment sudah ada homeroom_teacher_id
--      (jika belum, script memakai fallback ke admin pertama)
--   4. Kategori pelanggaran & reward sudah diinput (is_active = true)
--   5. Migration 04_fix_cascade_delete.sql sudah dijalankan
--
-- DISTRIBUSI TIER:
--   PP  (Perlu Pembinaan) : 10%
--   C   (Cukup)           : 10%
--   B   (Baik)            : 35%
--   SB  (Sangat Baik)     : 45%
--
-- KALENDER ABSENSI 2026:
--   Jan(23) Feb(17) Mar(6) Apr(25) Mei(14) Jun(10) = 95 hari
-- ============================================================

BEGIN;

-- ────────────────────────────────────────────────────────────────────────────
-- BLOK 1: Fungsi bantu fuzzy Mamdani
-- Parameter default konfigurasi fuzzy SiPandu:
--   X1: rendah=TL[60,75]  sedang=TRI[60,75,90]  tinggi=TR[85,95]
--   X2: rendah=TL[40,60]  sedang=TRI[40,60,80]  tinggi=TR[60,85]
--   X3: rendah=TL[50,70]  sedang=TRI[50,75,90]  tinggi=TR[80,95]
--   Z : PP=TL[40,50]  C=TRI[40,55,70]  B=TRI[65,80,90]  SB=TR[85,95]
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
  a_pp NUMERIC := 0;
  a_c  NUMERIC := 0;
  a_b  NUMERIC := 0;
  a_sb NUMERIC := 0;
  al   NUMERIC;
  z    NUMERIC;
  mu   NUMERIC;
  num  NUMERIC := 0;
  den  NUMERIC := 0;
  k    INT;
BEGIN
  -- Fuzzifikasi input
  x1l := _sp_tl(x1, 60, 75);   x1m := _sp_tri(x1, 60, 75, 90);  x1h := _sp_tr(x1, 85, 95);
  x2l := _sp_tl(x2, 40, 60);   x2m := _sp_tri(x2, 40, 60, 80);  x2h := _sp_tr(x2, 60, 85);
  x3l := _sp_tl(x3, 50, 70);   x3m := _sp_tri(x3, 50, 75, 90);  x3h := _sp_tr(x3, 80, 95);

  -- 27 aturan IF-THEN (AND = MIN, OR = MAX)
  -- X1 = Tinggi
  al := LEAST(x1h, x2h, x3h); IF al > a_sb THEN a_sb := al; END IF;
  al := LEAST(x1h, x2h, x3m); IF al > a_sb THEN a_sb := al; END IF;
  al := LEAST(x1h, x2h, x3l); IF al > a_b  THEN a_b  := al; END IF;
  al := LEAST(x1h, x2m, x3h); IF al > a_sb THEN a_sb := al; END IF;
  al := LEAST(x1h, x2m, x3m); IF al > a_b  THEN a_b  := al; END IF;
  al := LEAST(x1h, x2m, x3l); IF al > a_c  THEN a_c  := al; END IF;
  al := LEAST(x1h, x2l, x3h); IF al > a_b  THEN a_b  := al; END IF;
  al := LEAST(x1h, x2l, x3m); IF al > a_c  THEN a_c  := al; END IF;
  al := LEAST(x1h, x2l, x3l); IF al > a_pp THEN a_pp := al; END IF;
  -- X1 = Sedang
  al := LEAST(x1m, x2h, x3h); IF al > a_sb THEN a_sb := al; END IF;
  al := LEAST(x1m, x2h, x3m); IF al > a_b  THEN a_b  := al; END IF;
  al := LEAST(x1m, x2h, x3l); IF al > a_c  THEN a_c  := al; END IF;
  al := LEAST(x1m, x2m, x3h); IF al > a_b  THEN a_b  := al; END IF;
  al := LEAST(x1m, x2m, x3m); IF al > a_c  THEN a_c  := al; END IF;
  al := LEAST(x1m, x2m, x3l); IF al > a_pp THEN a_pp := al; END IF;
  al := LEAST(x1m, x2l, x3h); IF al > a_c  THEN a_c  := al; END IF;
  al := LEAST(x1m, x2l, x3m); IF al > a_pp THEN a_pp := al; END IF;
  al := LEAST(x1m, x2l, x3l); IF al > a_pp THEN a_pp := al; END IF;
  -- X1 = Rendah
  al := LEAST(x1l, x2h, x3h); IF al > a_b  THEN a_b  := al; END IF;
  al := LEAST(x1l, x2h, x3m); IF al > a_c  THEN a_c  := al; END IF;
  al := LEAST(x1l, x2h, x3l); IF al > a_pp THEN a_pp := al; END IF;
  al := LEAST(x1l, x2m, x3h); IF al > a_c  THEN a_c  := al; END IF;
  al := LEAST(x1l, x2m, x3m); IF al > a_pp THEN a_pp := al; END IF;
  al := LEAST(x1l, x2m, x3l); IF al > a_pp THEN a_pp := al; END IF;
  al := LEAST(x1l, x2l, x3h); IF al > a_pp THEN a_pp := al; END IF;
  al := LEAST(x1l, x2l, x3m); IF al > a_pp THEN a_pp := al; END IF;
  al := LEAST(x1l, x2l, x3l); IF al > a_pp THEN a_pp := al; END IF;

  IF a_pp = 0 AND a_c = 0 AND a_b = 0 AND a_sb = 0 THEN
    RETURN 0.0;
  END IF;

  -- Defuzzifikasi centroid: 200 titik sampel pada [0, 100]
  FOR k IN 0..199 LOOP
    z  := k * 100.0 / 199.0;
    mu := GREATEST(
      CASE WHEN a_pp > 0 THEN LEAST(a_pp, _sp_tl(z,  40, 50))    ELSE 0.0 END,
      CASE WHEN a_c  > 0 THEN LEAST(a_c,  _sp_tri(z, 40, 55, 70)) ELSE 0.0 END,
      CASE WHEN a_b  > 0 THEN LEAST(a_b,  _sp_tri(z, 65, 80, 90)) ELSE 0.0 END,
      CASE WHEN a_sb > 0 THEN LEAST(a_sb, _sp_tr(z,  85, 95))     ELSE 0.0 END
    );
    num := num + z  * mu;
    den := den + mu;
  END LOOP;

  RETURN CASE WHEN den <= 0 THEN 0.0
              ELSE ROUND((num / den)::NUMERIC, 2)
         END;
END;
$$;


-- ────────────────────────────────────────────────────────────────────────────
-- BLOK 2: Tabel sementara untuk menyimpan tier setiap siswa
-- (Dipakai oleh Blok 3, 5, dan 7. Otomatis dihapus saat COMMIT.)
-- ────────────────────────────────────────────────────────────────────────────

CREATE TEMP TABLE IF NOT EXISTS _sp_tiers (
  enrollment_id   UUID      PRIMARY KEY,
  student_id      UUID      NOT NULL,
  assignment_id   UUID      NOT NULL,
  tier            SMALLINT  NOT NULL CHECK (tier BETWEEN 1 AND 4)
) ON COMMIT DROP;


-- ────────────────────────────────────────────────────────────────────────────
-- BLOK 3: Absensi bulanan (6 bulan, dikunci) + transaksi poin perilaku
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

  v_viol_ids        UUID[];
  v_viol_pts        SMALLINT[];
  v_reward_ids      UUID[];
  v_reward_pts      SMALLINT[];

  v_rnd             NUMERIC;
  v_tier            SMALLINT;
  v_rate            NUMERIC;
  v_present         SMALLINT;
  v_absent          SMALLINT;
  v_sd              SMALLINT;

  v_n_viol          INT;
  v_n_reward        INT;
  v_cat_idx         INT;
  v_tx_date         DATE;

  i                 INT;
  j                 INT;
  v_total           INT := 0;
BEGIN
  -- Periode aktif
  SELECT id INTO v_period_id FROM public.academic_periods WHERE status = 'active' LIMIT 1;
  IF v_period_id IS NULL THEN
    RAISE EXCEPTION 'Tidak ada periode aktif. Aktifkan satu periode terlebih dahulu.';
  END IF;

  -- Fallback teacher jika kelas belum punya homeroom_teacher_id
  SELECT id INTO v_fallback_uid FROM public.profiles
  WHERE role = 'admin' LIMIT 1;
  IF v_fallback_uid IS NULL THEN
    SELECT id INTO v_fallback_uid FROM public.profiles
    WHERE role = 'teacher' LIMIT 1;
  END IF;
  IF v_fallback_uid IS NULL THEN
    RAISE EXCEPTION 'Tidak ditemukan admin/teacher. Pastikan minimal satu akun admin sudah ada.';
  END IF;

  -- Muat kategori pelanggaran
  SELECT ARRAY_AGG(id ORDER BY id),
         ARRAY_AGG(point_deduction::SMALLINT ORDER BY id)
  INTO v_viol_ids, v_viol_pts
  FROM public.violation_categories WHERE is_active = TRUE;

  IF v_viol_ids IS NULL THEN
    RAISE EXCEPTION 'Tidak ada violation_categories aktif. Tambahkan terlebih dahulu.';
  END IF;

  -- Muat kategori reward
  SELECT ARRAY_AGG(id ORDER BY id),
         ARRAY_AGG(point_addition::SMALLINT ORDER BY id)
  INTO v_reward_ids, v_reward_pts
  FROM public.reward_categories WHERE is_active = TRUE;

  IF v_reward_ids IS NULL THEN
    RAISE EXCEPTION 'Tidak ada reward_categories aktif. Tambahkan terlebih dahulu.';
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

    -- ── Loop per siswa ───────────────────────────────────────
    FOR v_enr IN
      SELECT sce.id AS enrollment_id, sce.student_id
      FROM   public.student_class_enrollments sce
      WHERE  sce.class_period_assignment_id = v_assignment.id
      AND    sce.status = 'active'
    LOOP
      -- ── Tetapkan tier ─────────────────────────────────────
      v_rnd := random();
      IF    v_rnd < 0.10 THEN v_tier := 1;   -- PP  10 %
      ELSIF v_rnd < 0.20 THEN v_tier := 2;   -- C   10 %
      ELSIF v_rnd < 0.55 THEN v_tier := 3;   -- B   35 %
      ELSE                    v_tier := 4;   -- SB  45 %
      END IF;

      INSERT INTO _sp_tiers (enrollment_id, student_id, assignment_id, tier)
      VALUES (v_enr.enrollment_id, v_enr.student_id, v_assignment.id, v_tier);

      -- ── Target kehadiran per tier ─────────────────────────
      CASE v_tier
        WHEN 1 THEN v_rate := 0.45 + random() * 0.22;  -- 45 – 67 %
        WHEN 2 THEN v_rate := 0.65 + random() * 0.17;  -- 65 – 82 %
        WHEN 3 THEN v_rate := 0.82 + random() * 0.11;  -- 82 – 93 %
        ELSE        v_rate := 0.90 + random() * 0.10;  -- 90 – 100 %
      END CASE;

      -- ── Absensi 6 bulan ───────────────────────────────────
      FOR j IN 1..6 LOOP
        v_sd := v_school_days[j];
        -- Hadir = proporsi + variasi ±1 hari
        v_present := GREATEST(
          0::SMALLINT,
          LEAST(v_sd,
            (ROUND(v_rate * v_sd) + (FLOOR(random() * 3))::INT - 1)::SMALLINT
          )
        );
        v_absent := v_sd - v_present;

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

      -- ── Inisialisasi skor perilaku ────────────────────────
      INSERT INTO public.student_behavior_scores (enrollment_id, raw_score)
      VALUES (v_enr.enrollment_id, 75)
      ON CONFLICT (enrollment_id) DO NOTHING;

      -- ── Jumlah transaksi per tier ─────────────────────────
      CASE v_tier
        WHEN 1 THEN
          v_n_viol   := 3 + (FLOOR(random() * 3))::INT;  -- 3–5 pelanggaran
          v_n_reward := 0;
        WHEN 2 THEN
          v_n_viol   := 2 + (FLOOR(random() * 2))::INT;  -- 2–3 pelanggaran
          v_n_reward := (FLOOR(random() * 2))::INT;       -- 0–1 reward
        WHEN 3 THEN
          v_n_viol   := (FLOOR(random() * 3))::INT;       -- 0–2 pelanggaran
          v_n_reward := (FLOOR(random() * 3))::INT;       -- 0–2 reward
        ELSE
          v_n_viol   := (FLOOR(random() * 2))::INT;       -- 0–1 pelanggaran
          v_n_reward := 1 + (FLOOR(random() * 3))::INT;  -- 1–3 reward
      END CASE;

      -- ── Insert pelanggaran ────────────────────────────────
      FOR j IN 1..v_n_viol LOOP
        v_cat_idx := 1 + (FLOOR(random() * array_length(v_viol_ids, 1)))::INT;
        v_cat_idx := LEAST(v_cat_idx, array_length(v_viol_ids, 1));
        -- Tanggal acak dalam semester (15 Jan – 3 Jun 2026)
        v_tx_date := DATE '2026-01-15' + (FLOOR(random() * 139))::INT;

        INSERT INTO public.behavior_point_transactions
          (enrollment_id, transaction_type,
           violation_category_id, reward_category_id,
           points_delta, transaction_date, raw_score_after,
           recorded_by, notes)
        VALUES
          (v_enr.enrollment_id, 'violation'::public.transaction_type,
           v_viol_ids[v_cat_idx], NULL,
           -(v_viol_pts[v_cat_idx]),
           v_tx_date, 75,
           v_teacher_id, 'Data dummy semester genap 2025/2026');
      END LOOP;

      -- ── Insert reward ─────────────────────────────────────
      FOR j IN 1..v_n_reward LOOP
        v_cat_idx := 1 + (FLOOR(random() * array_length(v_reward_ids, 1)))::INT;
        v_cat_idx := LEAST(v_cat_idx, array_length(v_reward_ids, 1));
        v_tx_date := DATE '2026-01-15' + (FLOOR(random() * 139))::INT;

        INSERT INTO public.behavior_point_transactions
          (enrollment_id, transaction_type,
           violation_category_id, reward_category_id,
           points_delta, transaction_date, raw_score_after,
           recorded_by, notes)
        VALUES
          (v_enr.enrollment_id, 'reward'::public.transaction_type,
           NULL, v_reward_ids[v_cat_idx],
           v_reward_pts[v_cat_idx],
           v_tx_date, 75,
           v_teacher_id, 'Data dummy semester genap 2025/2026');
      END LOOP;

      v_total := v_total + 1;
    END LOOP; -- end loop siswa

  END LOOP; -- end loop kelas

  RAISE NOTICE '✓ Blok 3 selesai: % siswa diproses (absensi + poin perilaku)', v_total;
END $$;


-- ────────────────────────────────────────────────────────────────────────────
-- BLOK 4: Buat sesi peer review (status = in_progress)
-- ────────────────────────────────────────────────────────────────────────────

INSERT INTO public.peer_review_sessions
  (class_period_assignment_id, status, opened_at, opened_by)
SELECT
  cpa.id,
  'in_progress'::public.peer_review_status,
  '2026-04-01 08:00:00+07'::TIMESTAMPTZ,
  COALESCE(cpa.homeroom_teacher_id,
    (SELECT id FROM public.profiles WHERE role = 'admin' LIMIT 1))
FROM public.class_period_assignments cpa
WHERE cpa.period_id = (SELECT id FROM public.academic_periods WHERE status = 'active')
ON CONFLICT (class_period_assignment_id) DO UPDATE
  SET status    = 'in_progress',
      opened_at = EXCLUDED.opened_at,
      opened_by = EXCLUDED.opened_by,
      closed_at = NULL,
      closed_by = NULL;


-- ────────────────────────────────────────────────────────────────────────────
-- BLOK 5: Bulk insert submisi peer review
-- Setiap siswa menilai semua teman sekelasnya.
-- Skor per aspek didasarkan pada tier reviewee (siswa yang dinilai).
--   Tier 1 (PP) : skor 1–3
--   Tier 2 (C)  : skor 2–4
--   Tier 3 (B)  : skor 3–5
--   Tier 4 (SB) : skor 4–5
-- ────────────────────────────────────────────────────────────────────────────

INSERT INTO public.peer_review_submissions
  (session_id, reviewer_id, reviewee_id,
   score_courtesy, score_cooperation, score_empathy,
   score_honesty, score_responsibility, submitted_at)
SELECT
  prs.id                           AS session_id,
  reviewer.student_id              AS reviewer_id,
  reviewee.student_id              AS reviewee_id,
  -- 5 skor independen berdasarkan tier reviewee
  GREATEST(1, LEAST(5,
    (CASE t.tier
       WHEN 1 THEN 1 + (FLOOR(random() * 3))::INT
       WHEN 2 THEN 2 + (FLOOR(random() * 3))::INT
       WHEN 3 THEN 3 + (FLOOR(random() * 3))::INT
       ELSE       4 + (FLOOR(random() * 2))::INT
     END)::SMALLINT))              AS score_courtesy,
  GREATEST(1, LEAST(5,
    (CASE t.tier
       WHEN 1 THEN 1 + (FLOOR(random() * 3))::INT
       WHEN 2 THEN 2 + (FLOOR(random() * 3))::INT
       WHEN 3 THEN 3 + (FLOOR(random() * 3))::INT
       ELSE       4 + (FLOOR(random() * 2))::INT
     END)::SMALLINT))              AS score_cooperation,
  GREATEST(1, LEAST(5,
    (CASE t.tier
       WHEN 1 THEN 1 + (FLOOR(random() * 3))::INT
       WHEN 2 THEN 2 + (FLOOR(random() * 3))::INT
       WHEN 3 THEN 3 + (FLOOR(random() * 3))::INT
       ELSE       4 + (FLOOR(random() * 2))::INT
     END)::SMALLINT))              AS score_empathy,
  GREATEST(1, LEAST(5,
    (CASE t.tier
       WHEN 1 THEN 1 + (FLOOR(random() * 3))::INT
       WHEN 2 THEN 2 + (FLOOR(random() * 3))::INT
       WHEN 3 THEN 3 + (FLOOR(random() * 3))::INT
       ELSE       4 + (FLOOR(random() * 2))::INT
     END)::SMALLINT))              AS score_honesty,
  GREATEST(1, LEAST(5,
    (CASE t.tier
       WHEN 1 THEN 1 + (FLOOR(random() * 3))::INT
       WHEN 2 THEN 2 + (FLOOR(random() * 3))::INT
       WHEN 3 THEN 3 + (FLOOR(random() * 3))::INT
       ELSE       4 + (FLOOR(random() * 2))::INT
     END)::SMALLINT))              AS score_responsibility,
  '2026-05-15 09:00:00+07'::TIMESTAMPTZ AS submitted_at
FROM       _sp_tiers reviewee
JOIN       _sp_tiers reviewer
        ON reviewer.assignment_id = reviewee.assignment_id
       AND reviewer.student_id   <> reviewee.student_id
JOIN       public.peer_review_sessions prs
        ON prs.class_period_assignment_id = reviewee.assignment_id
-- join kembali untuk skor: gunakan tier reviewee
JOIN       _sp_tiers t
        ON t.enrollment_id = reviewee.enrollment_id
ON CONFLICT (session_id, reviewer_id, reviewee_id) DO NOTHING;


-- ────────────────────────────────────────────────────────────────────────────
-- BLOK 6: Tutup semua sesi peer review
-- Trigger trg_peer_session_close_calc_x3 otomatis menghitung X3
-- untuk setiap siswa berdasarkan submisi yang sudah masuk.
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
AND    prs.status    = 'in_progress';


-- ────────────────────────────────────────────────────────────────────────────
-- BLOK 7: Hitung nilai fuzzy Mamdani Z* dan simpan ke behavior_final_scores
-- ────────────────────────────────────────────────────────────────────────────

WITH inputs AS (
  SELECT
    sce.id AS enrollment_id,
    -- X1 = persentase kehadiran (0–100)
    ROUND(
      COALESCE(SUM(ma.present_days), 0)::NUMERIC
      / NULLIF(SUM(ma.effective_days), 0) * 100.0,
      2
    )                                                         AS x1,
    -- X2 = skor perilaku dikap 100
    LEAST(COALESCE(MAX(sbs.raw_score), 75), 100)::NUMERIC     AS x2,
    -- raw_x2 tanpa cap
    COALESCE(MAX(sbs.raw_score), 75)::SMALLINT                AS raw_x2,
    -- X3 = nilai peer review (0–100), 0 jika belum ada
    COALESCE(MAX(x3s.x3_score), 0)::NUMERIC                   AS x3
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
  SELECT
    enrollment_id,
    x1, x2, raw_x2, x3,
    _sp_zstar(x1, x2, x3) AS z_star
  FROM inputs
)
INSERT INTO public.behavior_final_scores
  (enrollment_id, x1, x2, raw_x2, x3, z_star, category, computed_at)
SELECT
  enrollment_id,
  x1, x2, raw_x2, x3, z_star,
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
-- BLOK 8: Bersihkan fungsi bantu sementara
-- ────────────────────────────────────────────────────────────────────────────

DROP FUNCTION IF EXISTS _sp_zstar(NUMERIC, NUMERIC, NUMERIC);
DROP FUNCTION IF EXISTS _sp_tri(NUMERIC, NUMERIC, NUMERIC, NUMERIC);
DROP FUNCTION IF EXISTS _sp_tl(NUMERIC, NUMERIC, NUMERIC);
DROP FUNCTION IF EXISTS _sp_tr(NUMERIC, NUMERIC, NUMERIC);

COMMIT;

-- ────────────────────────────────────────────────────────────────────────────
-- VERIFIKASI (opsional, jalankan setelah commit)
-- ────────────────────────────────────────────────────────────────────────────
/*
SELECT
  bfs.category,
  COUNT(*) AS jumlah,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS persen
FROM public.behavior_final_scores bfs
JOIN public.student_class_enrollments sce ON sce.id = bfs.enrollment_id
JOIN public.class_period_assignments cpa  ON cpa.id = sce.class_period_assignment_id
WHERE cpa.period_id = (SELECT id FROM public.academic_periods WHERE status = 'active')
GROUP BY bfs.category
ORDER BY bfs.category;

SELECT
  ROUND(AVG(x1), 1) AS avg_x1,
  ROUND(AVG(x2), 1) AS avg_x2,
  ROUND(AVG(x3), 1) AS avg_x3,
  ROUND(AVG(z_star), 1) AS avg_zstar,
  COUNT(*) AS total_siswa
FROM public.behavior_final_scores bfs
JOIN public.student_class_enrollments sce ON sce.id = bfs.enrollment_id
JOIN public.class_period_assignments cpa  ON cpa.id = sce.class_period_assignment_id
WHERE cpa.period_id = (SELECT id FROM public.academic_periods WHERE status = 'active');
*/
