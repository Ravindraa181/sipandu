-- ═══════════════════════════════════════════════════════════════════════════
--  SiPandu — Sistem Penilaian Terpadu (SMAN 13 Bandung)
--  File          : 01_migration.sql
--  Tujuan        : Schema awal lengkap (DDL + RLS + Seed) untuk Supabase
--  Mengikuti     : SYSTEM_CONTEXT.md & DATABASE_ENTITIES.md (revisi nama EN)
--  Cara pakai    : Buka Supabase → SQL Editor → New Query → Paste → Run
--  Idempotency   : DROP IF EXISTS di awal untuk re-run aman saat dev.
--                  HAPUS bagian DROP saat deploy production untuk menghindari
--                  data loss tak disengaja.
-- ═══════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════
-- BAGIAN 0 — EXTENSIONS & DEV CLEANUP (opsional saat re-run)
-- ═══════════════════════════════════════════════════════════════════════════

-- pgcrypto untuk gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ⚠ DEV ONLY: hapus seluruh objek lama agar bisa re-run.
--    HAPUS BLOCK INI DI PRODUCTION!
DO $$
BEGIN
  -- drop tables (urutan terbalik dari dependency)
  DROP TABLE IF EXISTS public.teacher_narrative_notes CASCADE;
  DROP TABLE IF EXISTS public.behavior_final_scores CASCADE;
  DROP TABLE IF EXISTS public.fuzzy_rules CASCADE;
  DROP TABLE IF EXISTS public.fuzzy_configurations CASCADE;
  DROP TABLE IF EXISTS public.peer_review_aspects CASCADE;
  DROP TABLE IF EXISTS public.student_x3_scores CASCADE;
  DROP TABLE IF EXISTS public.peer_review_progress CASCADE;
  DROP TABLE IF EXISTS public.peer_review_submissions CASCADE;
  DROP TABLE IF EXISTS public.peer_review_sessions CASCADE;
  DROP TABLE IF EXISTS public.student_behavior_scores CASCADE;
  DROP TABLE IF EXISTS public.behavior_point_transactions CASCADE;
  DROP TABLE IF EXISTS public.monthly_attendance CASCADE;
  DROP TABLE IF EXISTS public.reward_categories CASCADE;
  DROP TABLE IF EXISTS public.violation_categories CASCADE;
  DROP TABLE IF EXISTS public.student_class_enrollments CASCADE;
  DROP TABLE IF EXISTS public.class_period_assignments CASCADE;
  DROP TABLE IF EXISTS public.classes CASCADE;
  DROP TABLE IF EXISTS public.period_monthly_days CASCADE;
  DROP TABLE IF EXISTS public.academic_periods CASCADE;
  DROP TABLE IF EXISTS public.profiles CASCADE;

  -- drop enums
  DROP TYPE IF EXISTS public.user_role CASCADE;
  DROP TYPE IF EXISTS public.semester_type CASCADE;
  DROP TYPE IF EXISTS public.period_status CASCADE;
  DROP TYPE IF EXISTS public.peer_review_status CASCADE;
  DROP TYPE IF EXISTS public.transaction_type CASCADE;
  DROP TYPE IF EXISTS public.fuzzy_set_name CASCADE;
  DROP TYPE IF EXISTS public.behavior_category CASCADE;
  DROP TYPE IF EXISTS public.membership_function_type CASCADE;
  DROP TYPE IF EXISTS public.gender_type CASCADE;
  DROP TYPE IF EXISTS public.grade_level_type CASCADE;
  DROP TYPE IF EXISTS public.enrollment_status CASCADE;

  -- drop helper functions
  DROP FUNCTION IF EXISTS public.set_updated_at() CASCADE;
  DROP FUNCTION IF EXISTS public.is_admin() CASCADE;
  DROP FUNCTION IF EXISTS public.is_teacher() CASCADE;
  DROP FUNCTION IF EXISTS public.is_student() CASCADE;
  DROP FUNCTION IF EXISTS public.is_homeroom_teacher_of_enrollment(uuid) CASCADE;
  DROP FUNCTION IF EXISTS public.is_homeroom_teacher_of_class_period(uuid) CASCADE;
  DROP FUNCTION IF EXISTS public.update_raw_score_after_transaction() CASCADE;
  DROP FUNCTION IF EXISTS public.calculate_x3_on_session_close() CASCADE;
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'Cleanup skip: %', SQLERRM;
END $$;


-- ═══════════════════════════════════════════════════════════════════════════
-- BAGIAN 1 — ENUM TYPES
-- ═══════════════════════════════════════════════════════════════════════════

-- Peran pengguna sistem
CREATE TYPE public.user_role AS ENUM ('admin', 'teacher', 'student');

-- Semester
CREATE TYPE public.semester_type AS ENUM ('ganjil', 'genap');

-- Status periode akademik (hanya 1 yang 'active')
CREATE TYPE public.period_status AS ENUM ('active', 'closed', 'archived');

-- Status sesi peer review per kelas-periode
CREATE TYPE public.peer_review_status AS ENUM ('not_started', 'active', 'closed');

-- Jenis transaksi poin
CREATE TYPE public.transaction_type AS ENUM ('violation', 'reward');

-- Nama himpunan fuzzy (input + output)
CREATE TYPE public.fuzzy_set_name AS ENUM (
  'rendah',
  'sedang',
  'tinggi',
  'perlu_pembinaan',
  'cukup',
  'baik',
  'sangat_baik'
);

-- Kategori akhir Z* (subset dari output)
CREATE TYPE public.behavior_category AS ENUM (
  'perlu_pembinaan',
  'cukup',
  'baik',
  'sangat_baik'
);

-- Tipe fungsi keanggotaan
CREATE TYPE public.membership_function_type AS ENUM (
  'triangle',
  'trapezoid_left',
  'trapezoid_right'
);

-- Penunjang
CREATE TYPE public.gender_type AS ENUM ('L', 'P');
CREATE TYPE public.grade_level_type AS ENUM ('X', 'XI', 'XII');
CREATE TYPE public.enrollment_status AS ENUM ('active', 'transferred', 'left');


-- ═══════════════════════════════════════════════════════════════════════════
-- BAGIAN 2 — TABEL (urut dari yang tidak punya FK dulu)
-- ═══════════════════════════════════════════════════════════════════════════

-- ────────────────────────────────────────────────────────────────────────
-- 2.1 profiles  — terhubung 1:1 dengan auth.users (Supabase Auth)
-- ────────────────────────────────────────────────────────────────────────
CREATE TABLE public.profiles (
  id              UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  role            public.user_role        NOT NULL,
  email           VARCHAR(150)            NOT NULL UNIQUE,
  full_name       VARCHAR(150)            NOT NULL,
  -- atribut spesifik (NULL bila tidak relevan dengan role)
  nip             VARCHAR(18)             NULL UNIQUE,           -- guru
  nisn            VARCHAR(10)             NULL UNIQUE,           -- siswa (Nomor Induk Siswa Nasional, 10 digit)
  gender          public.gender_type      NULL,                  -- siswa
  date_of_birth   DATE                    NULL,                  -- siswa
  is_active       BOOLEAN                 NOT NULL DEFAULT TRUE,
  created_at      TIMESTAMPTZ             NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ             NOT NULL DEFAULT now(),

  -- konsistensi role ↔ atribut
  CONSTRAINT chk_teacher_has_nip CHECK (role <> 'teacher' OR nip IS NOT NULL),
  CONSTRAINT chk_student_has_nisn CHECK (role <> 'student' OR nisn IS NOT NULL)
);

COMMENT ON TABLE public.profiles IS 'Profil pengguna; PK = auth.users.id (Supabase Auth)';

-- ────────────────────────────────────────────────────────────────────────
-- 2.2 academic_periods
-- ────────────────────────────────────────────────────────────────────────
CREATE TABLE public.academic_periods (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name            VARCHAR(50)             NOT NULL,                 -- "Ganjil 2024/2025"
  academic_year   VARCHAR(9)              NOT NULL,                 -- "2024/2025"
  semester        public.semester_type    NOT NULL,
  start_date      DATE                    NOT NULL,
  end_date        DATE                    NOT NULL,
  status          public.period_status    NOT NULL DEFAULT 'closed',
  created_at      TIMESTAMPTZ             NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ             NOT NULL DEFAULT now(),

  CONSTRAINT chk_period_dates CHECK (end_date > start_date),
  CONSTRAINT uq_period_year_semester UNIQUE (academic_year, semester)
);

-- Hanya 1 periode boleh berstatus 'active'
CREATE UNIQUE INDEX uq_one_active_period
  ON public.academic_periods (status)
  WHERE status = 'active';

-- ────────────────────────────────────────────────────────────────────────
-- 2.3 period_monthly_days  — hari efektif per bulan dalam periode
-- ────────────────────────────────────────────────────────────────────────
CREATE TABLE public.period_monthly_days (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  period_id       UUID                    NOT NULL REFERENCES public.academic_periods(id) ON DELETE CASCADE,
  month           SMALLINT                NOT NULL CHECK (month BETWEEN 1 AND 12),
  year            SMALLINT                NOT NULL CHECK (year BETWEEN 2020 AND 2100),
  effective_days  SMALLINT                NOT NULL CHECK (effective_days BETWEEN 0 AND 31),
  created_at      TIMESTAMPTZ             NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ             NOT NULL DEFAULT now(),

  CONSTRAINT uq_period_month_year UNIQUE (period_id, month, year)
);

-- ────────────────────────────────────────────────────────────────────────
-- 2.4 classes
-- ────────────────────────────────────────────────────────────────────────
CREATE TABLE public.classes (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name            VARCHAR(10)             NOT NULL UNIQUE,              -- "X-A", "XI-A"
  grade_level     public.grade_level_type NOT NULL,
  created_at      TIMESTAMPTZ             NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ             NOT NULL DEFAULT now()
);

-- ────────────────────────────────────────────────────────────────────────
-- 2.5 class_period_assignments  — wali kelas per kelas+periode
-- ────────────────────────────────────────────────────────────────────────
CREATE TABLE public.class_period_assignments (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  class_id              UUID NOT NULL REFERENCES public.classes(id) ON DELETE RESTRICT,
  period_id             UUID NOT NULL REFERENCES public.academic_periods(id) ON DELETE RESTRICT,
  homeroom_teacher_id   UUID NULL REFERENCES public.profiles(id) ON DELETE SET NULL,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_class_period UNIQUE (class_id, period_id)
);

-- 1 guru = max 1 kelas per periode
CREATE UNIQUE INDEX uq_homeroom_per_period
  ON public.class_period_assignments (homeroom_teacher_id, period_id)
  WHERE homeroom_teacher_id IS NOT NULL;

-- ────────────────────────────────────────────────────────────────────────
-- 2.6 student_class_enrollments  — siswa ↔ kelas-periode
-- ────────────────────────────────────────────────────────────────────────
CREATE TABLE public.student_class_enrollments (
  id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id                  UUID NOT NULL REFERENCES public.profiles(id) ON DELETE RESTRICT,
  class_period_assignment_id  UUID NOT NULL REFERENCES public.class_period_assignments(id) ON DELETE RESTRICT,
  initial_score               SMALLINT NOT NULL DEFAULT 75 CHECK (initial_score BETWEEN 0 AND 100),
  status                      public.enrollment_status NOT NULL DEFAULT 'active',
  created_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_student_class_period UNIQUE (student_id, class_period_assignment_id)
);

-- ────────────────────────────────────────────────────────────────────────
-- 2.7 violation_categories
-- ────────────────────────────────────────────────────────────────────────
CREATE TABLE public.violation_categories (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name              VARCHAR(150) NOT NULL UNIQUE,
  point_deduction   SMALLINT     NOT NULL CHECK (point_deduction > 0),    -- nilai absolut
  sop_reference     VARCHAR(100) NULL,
  description       TEXT         NULL,
  is_active         BOOLEAN      NOT NULL DEFAULT TRUE,
  created_at        TIMESTAMPTZ  NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- ────────────────────────────────────────────────────────────────────────
-- 2.8 reward_categories
-- ────────────────────────────────────────────────────────────────────────
CREATE TABLE public.reward_categories (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name              VARCHAR(150) NOT NULL UNIQUE,
  point_addition    SMALLINT     NOT NULL CHECK (point_addition > 0),
  category_label    VARCHAR(50)  NULL,                                    -- mis. "Akademik", "Religius"
  description       TEXT         NULL,
  is_active         BOOLEAN      NOT NULL DEFAULT TRUE,
  created_at        TIMESTAMPTZ  NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- ────────────────────────────────────────────────────────────────────────
-- 2.9 monthly_attendance  — sumber X1
-- ────────────────────────────────────────────────────────────────────────
CREATE TABLE public.monthly_attendance (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  enrollment_id   UUID NOT NULL REFERENCES public.student_class_enrollments(id) ON DELETE CASCADE,
  month           SMALLINT NOT NULL CHECK (month BETWEEN 1 AND 12),
  year            SMALLINT NOT NULL CHECK (year BETWEEN 2020 AND 2100),
  present_days    SMALLINT NOT NULL DEFAULT 0 CHECK (present_days >= 0),
  sick_days       SMALLINT NOT NULL DEFAULT 0 CHECK (sick_days >= 0),
  permit_days     SMALLINT NOT NULL DEFAULT 0 CHECK (permit_days >= 0),
  absent_days     SMALLINT NOT NULL DEFAULT 0 CHECK (absent_days >= 0),
  effective_days  SMALLINT NOT NULL CHECK (effective_days BETWEEN 0 AND 31),
  is_locked       BOOLEAN  NOT NULL DEFAULT FALSE,
  locked_at       TIMESTAMPTZ NULL,
  locked_by       UUID NULL REFERENCES public.profiles(id) ON DELETE SET NULL,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_attendance_enrollment_month UNIQUE (enrollment_id, month, year),
  CONSTRAINT chk_attendance_total CHECK (present_days + sick_days + permit_days + absent_days <= effective_days)
);

-- ────────────────────────────────────────────────────────────────────────
-- 2.10 behavior_point_transactions  — append-only, sumber X2
-- ────────────────────────────────────────────────────────────────────────
CREATE TABLE public.behavior_point_transactions (
  id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  enrollment_id           UUID NOT NULL REFERENCES public.student_class_enrollments(id) ON DELETE CASCADE,
  transaction_type        public.transaction_type NOT NULL,
  violation_category_id   UUID NULL REFERENCES public.violation_categories(id) ON DELETE RESTRICT,
  reward_category_id      UUID NULL REFERENCES public.reward_categories(id) ON DELETE RESTRICT,
  points_delta            SMALLINT NOT NULL,                               -- + reward, - violation
  transaction_date        DATE NOT NULL DEFAULT CURRENT_DATE,
  raw_score_after         SMALLINT NOT NULL,                               -- snapshot running total
  notes                   TEXT NULL,
  recorded_by             UUID NOT NULL REFERENCES public.profiles(id) ON DELETE RESTRICT,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at              TIMESTAMPTZ NULL,                                -- soft delete

  CONSTRAINT chk_points_nonzero CHECK (points_delta <> 0),
  CONSTRAINT chk_violation_sign CHECK (transaction_type <> 'violation' OR points_delta < 0),
  CONSTRAINT chk_reward_sign    CHECK (transaction_type <> 'reward'    OR points_delta > 0),
  CONSTRAINT chk_category_match CHECK (
    (transaction_type = 'violation' AND violation_category_id IS NOT NULL AND reward_category_id IS NULL) OR
    (transaction_type = 'reward'    AND reward_category_id    IS NOT NULL AND violation_category_id IS NULL)
  )
);

-- ────────────────────────────────────────────────────────────────────────
-- 2.11 student_behavior_scores  — running total raw_score per enrollment
-- ────────────────────────────────────────────────────────────────────────
CREATE TABLE public.student_behavior_scores (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  enrollment_id   UUID NOT NULL UNIQUE REFERENCES public.student_class_enrollments(id) ON DELETE CASCADE,
  raw_score       SMALLINT NOT NULL DEFAULT 75,                          -- bisa > 100 (buffer X2)
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.student_behavior_scores IS 'Running total raw_score; X2 = LEAST(raw_score, 100) di app.';

-- ────────────────────────────────────────────────────────────────────────
-- 2.12 peer_review_sessions  — sesi per kelas-periode
-- ────────────────────────────────────────────────────────────────────────
CREATE TABLE public.peer_review_sessions (
  id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  class_period_assignment_id  UUID NOT NULL UNIQUE REFERENCES public.class_period_assignments(id) ON DELETE CASCADE,
  status                      public.peer_review_status NOT NULL DEFAULT 'not_started',
  deadline                    DATE NULL,
  opened_at                   TIMESTAMPTZ NULL,
  opened_by                   UUID NULL REFERENCES public.profiles(id) ON DELETE SET NULL,
  closed_at                   TIMESTAMPTZ NULL,
  closed_by                   UUID NULL REFERENCES public.profiles(id) ON DELETE SET NULL,
  auto_closed                 BOOLEAN NOT NULL DEFAULT FALSE,
  created_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at                  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ────────────────────────────────────────────────────────────────────────
-- 2.13 peer_review_submissions  — penilaian individu (ANONYMOUS)
-- ────────────────────────────────────────────────────────────────────────
CREATE TABLE public.peer_review_submissions (
  id                       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id               UUID NOT NULL REFERENCES public.peer_review_sessions(id) ON DELETE CASCADE,
  reviewer_id              UUID NOT NULL REFERENCES public.profiles(id) ON DELETE RESTRICT,   -- RAHASIA
  reviewee_id              UUID NOT NULL REFERENCES public.profiles(id) ON DELETE RESTRICT,
  score_courtesy           SMALLINT NOT NULL CHECK (score_courtesy        BETWEEN 1 AND 5),
  score_cooperation        SMALLINT NOT NULL CHECK (score_cooperation     BETWEEN 1 AND 5),
  score_empathy            SMALLINT NOT NULL CHECK (score_empathy         BETWEEN 1 AND 5),
  score_honesty            SMALLINT NOT NULL CHECK (score_honesty         BETWEEN 1 AND 5),
  score_responsibility     SMALLINT NOT NULL CHECK (score_responsibility  BETWEEN 1 AND 5),
  submitted_at             TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at               TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_session_reviewer_reviewee UNIQUE (session_id, reviewer_id, reviewee_id),
  CONSTRAINT chk_no_self_review CHECK (reviewer_id <> reviewee_id)
);

COMMENT ON TABLE public.peer_review_submissions IS 'KRITIS: kolom reviewer_id WAJIB anonim — RLS memblokir SELECT untuk siswa.';

-- ────────────────────────────────────────────────────────────────────────
-- 2.14 peer_review_progress  — progres pengisian per reviewer
-- ────────────────────────────────────────────────────────────────────────
CREATE TABLE public.peer_review_progress (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id        UUID NOT NULL REFERENCES public.peer_review_sessions(id) ON DELETE CASCADE,
  student_id        UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,    -- reviewer
  completed_count   SMALLINT NOT NULL DEFAULT 0 CHECK (completed_count >= 0),
  total_count       SMALLINT NOT NULL CHECK (total_count >= 0),
  last_updated      TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_progress_session_student UNIQUE (session_id, student_id),
  CONSTRAINT chk_progress_within_total CHECK (completed_count <= total_count)
);

-- ────────────────────────────────────────────────────────────────────────
-- 2.15 student_x3_scores  — agregat X3 per reviewee, dihitung saat sesi ditutup
-- ────────────────────────────────────────────────────────────────────────
CREATE TABLE public.student_x3_scores (
  id                       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id               UUID NOT NULL REFERENCES public.peer_review_sessions(id) ON DELETE CASCADE,
  student_id               UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,   -- reviewee
  x3_score                 NUMERIC(5,2) NULL CHECK (x3_score IS NULL OR x3_score BETWEEN 0 AND 100),
  avg_courtesy             NUMERIC(3,2) NULL,
  avg_cooperation          NUMERIC(3,2) NULL,
  avg_empathy              NUMERIC(3,2) NULL,
  avg_honesty              NUMERIC(3,2) NULL,
  avg_responsibility       NUMERIC(3,2) NULL,
  reviewer_count           SMALLINT NOT NULL DEFAULT 0,
  computed_at              TIMESTAMPTZ NULL,
  created_at               TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at               TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_x3_session_student UNIQUE (session_id, student_id)
);

-- ────────────────────────────────────────────────────────────────────────
-- 2.15b peer_review_aspects  — label & deskripsi 5 aspek (dikelola admin)
--   Kunci & jumlah aspek TETAP (terikat ke 5 kolom skor + trigger X3).
-- ────────────────────────────────────────────────────────────────────────
CREATE TABLE public.peer_review_aspects (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  aspect_key    VARCHAR(20)  NOT NULL UNIQUE,
  label         VARCHAR(100) NOT NULL,
  description   TEXT         NOT NULL,
  display_order SMALLINT     NOT NULL,
  updated_at    TIMESTAMPTZ  NOT NULL DEFAULT now(),
  updated_by    UUID         NULL REFERENCES public.profiles(id) ON DELETE SET NULL,

  CONSTRAINT chk_aspect_key CHECK (
    aspect_key IN ('courtesy','cooperation','empathy','honesty','responsibility')
  )
);

-- ────────────────────────────────────────────────────────────────────────
-- 2.16 fuzzy_configurations  — parameter himpunan fuzzy (X1/X2/X3/Z)
-- ────────────────────────────────────────────────────────────────────────
CREATE TABLE public.fuzzy_configurations (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  variable_name   VARCHAR(5)                       NOT NULL,         -- 'x1' | 'x2' | 'x3' | 'z'
  set_name        public.fuzzy_set_name            NOT NULL,
  function_type   public.membership_function_type  NOT NULL,
  parameters      NUMERIC[]                        NOT NULL,         -- {a,b} atau {a,b,c} atau {a,b,c,d}
  updated_at      TIMESTAMPTZ                      NOT NULL DEFAULT now(),
  updated_by      UUID                             NULL REFERENCES public.profiles(id) ON DELETE SET NULL,

  CONSTRAINT uq_fuzzy_var_set UNIQUE (variable_name, set_name),
  CONSTRAINT chk_variable_name CHECK (variable_name IN ('x1','x2','x3','z')),
  CONSTRAINT chk_parameters_length CHECK (array_length(parameters, 1) BETWEEN 2 AND 4)
);

-- ────────────────────────────────────────────────────────────────────────
-- 2.17 fuzzy_rules  — 27 aturan IF-THEN
-- ────────────────────────────────────────────────────────────────────────
CREATE TABLE public.fuzzy_rules (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  rule_number   SMALLINT NOT NULL UNIQUE CHECK (rule_number BETWEEN 1 AND 27),
  x1_set        public.fuzzy_set_name NOT NULL,
  x2_set        public.fuzzy_set_name NOT NULL,
  x3_set        public.fuzzy_set_name NOT NULL,
  output_set    public.fuzzy_set_name NOT NULL,
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_by    UUID NULL REFERENCES public.profiles(id) ON DELETE SET NULL,

  CONSTRAINT uq_rule_combination UNIQUE (x1_set, x2_set, x3_set),
  CONSTRAINT chk_rule_input_sets CHECK (
    x1_set IN ('rendah','sedang','tinggi') AND
    x2_set IN ('rendah','sedang','tinggi') AND
    x3_set IN ('rendah','sedang','tinggi')
  ),
  CONSTRAINT chk_rule_output_set CHECK (
    output_set IN ('perlu_pembinaan','cukup','baik','sangat_baik')
  )
);

-- ────────────────────────────────────────────────────────────────────────
-- 2.18 behavior_final_scores  — snapshot Z* hasil fuzzy
-- ────────────────────────────────────────────────────────────────────────
CREATE TABLE public.behavior_final_scores (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  enrollment_id   UUID NOT NULL UNIQUE REFERENCES public.student_class_enrollments(id) ON DELETE CASCADE,
  x1              NUMERIC(5,2) NULL CHECK (x1 IS NULL OR x1 BETWEEN 0 AND 100),
  x2              NUMERIC(5,2) NULL CHECK (x2 IS NULL OR x2 BETWEEN 0 AND 100),
  raw_x2          SMALLINT     NULL,
  x3              NUMERIC(5,2) NULL CHECK (x3 IS NULL OR x3 BETWEEN 0 AND 100),
  z_star          NUMERIC(5,2) NULL CHECK (z_star IS NULL OR z_star BETWEEN 0 AND 100),
  category        public.behavior_category NULL,
  alpha_pp        NUMERIC(5,4) NULL CHECK (alpha_pp IS NULL OR alpha_pp BETWEEN 0 AND 1),
  alpha_c         NUMERIC(5,4) NULL CHECK (alpha_c  IS NULL OR alpha_c  BETWEEN 0 AND 1),
  alpha_b         NUMERIC(5,4) NULL CHECK (alpha_b  IS NULL OR alpha_b  BETWEEN 0 AND 1),
  alpha_sb        NUMERIC(5,4) NULL CHECK (alpha_sb IS NULL OR alpha_sb BETWEEN 0 AND 1),
  active_rules    JSONB        NULL,                              -- [{rule_no, alpha, output}, ...]
  computed_at     TIMESTAMPTZ  NULL,
  created_at      TIMESTAMPTZ  NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- ────────────────────────────────────────────────────────────────────────
-- 2.19 teacher_narrative_notes  — catatan wali kelas per siswa
-- ────────────────────────────────────────────────────────────────────────
CREATE TABLE public.teacher_narrative_notes (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  enrollment_id   UUID NOT NULL UNIQUE REFERENCES public.student_class_enrollments(id) ON DELETE CASCADE,
  note_text       TEXT NOT NULL,
  written_by      UUID NOT NULL REFERENCES public.profiles(id) ON DELETE RESTRICT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- ═══════════════════════════════════════════════════════════════════════════
-- BAGIAN 3 — TRIGGERS & FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

-- ────────────────────────────────────────────────────────────────────────
-- 3.1 Auto-update updated_at
-- ────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Pasang trigger ke semua tabel yang punya kolom updated_at
DO $$
DECLARE
  tbl TEXT;
  tables TEXT[] := ARRAY[
    'profiles','academic_periods','period_monthly_days','classes',
    'class_period_assignments','student_class_enrollments',
    'violation_categories','reward_categories',
    'monthly_attendance','student_behavior_scores',
    'peer_review_sessions','peer_review_progress','student_x3_scores',
    'peer_review_aspects',
    'behavior_final_scores','teacher_narrative_notes'
  ];
BEGIN
  FOREACH tbl IN ARRAY tables LOOP
    EXECUTE format(
      'CREATE TRIGGER trg_%I_updated_at
         BEFORE UPDATE ON public.%I
         FOR EACH ROW EXECUTE FUNCTION public.set_updated_at()', tbl, tbl);
  END LOOP;
END $$;

-- ────────────────────────────────────────────────────────────────────────
-- 3.2 Update raw_score saat ada transaksi poin
--     - INSERT  : tambahkan delta
--     - UPDATE  : hanya tangani perubahan deleted_at (soft delete/restore)
--     - upsert  : pastikan baris student_behavior_scores ada
-- ────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.update_raw_score_after_transaction()
RETURNS TRIGGER AS $$
DECLARE
  v_delta SMALLINT;
  v_initial SMALLINT;
BEGIN
  IF TG_OP = 'INSERT' THEN
    v_delta := NEW.points_delta;

    -- Pastikan baris student_behavior_scores ada (initial dari enrollment)
    INSERT INTO public.student_behavior_scores (enrollment_id, raw_score)
    SELECT NEW.enrollment_id, e.initial_score
    FROM public.student_class_enrollments e
    WHERE e.id = NEW.enrollment_id
    ON CONFLICT (enrollment_id) DO NOTHING;

    UPDATE public.student_behavior_scores
       SET raw_score = raw_score + v_delta,
           updated_at = now()
     WHERE enrollment_id = NEW.enrollment_id;

    -- Snapshot raw_score_after agar UI bisa rekonstruksi cepat
    UPDATE public.behavior_point_transactions
       SET raw_score_after = (
         SELECT raw_score FROM public.student_behavior_scores
         WHERE enrollment_id = NEW.enrollment_id
       )
     WHERE id = NEW.id;

    RETURN NEW;
  END IF;

  IF TG_OP = 'UPDATE' THEN
    -- Soft delete: kurangi delta dari running total
    IF OLD.deleted_at IS NULL AND NEW.deleted_at IS NOT NULL THEN
      UPDATE public.student_behavior_scores
         SET raw_score = raw_score - OLD.points_delta,
             updated_at = now()
       WHERE enrollment_id = OLD.enrollment_id;
    END IF;
    -- Restore: tambahkan delta kembali
    IF OLD.deleted_at IS NOT NULL AND NEW.deleted_at IS NULL THEN
      UPDATE public.student_behavior_scores
         SET raw_score = raw_score + NEW.points_delta,
             updated_at = now()
       WHERE enrollment_id = NEW.enrollment_id;
    END IF;
    RETURN NEW;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_point_transaction_update_score
  AFTER INSERT OR UPDATE ON public.behavior_point_transactions
  FOR EACH ROW EXECUTE FUNCTION public.update_raw_score_after_transaction();

-- ────────────────────────────────────────────────────────────────────────
-- 3.3 Hitung agregat X3 saat sesi peer review ditutup
--     Saat status berubah → 'closed': hitung rata-rata per reviewee.
-- ────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.calculate_x3_on_session_close()
RETURNS TRIGGER AS $$
BEGIN
  -- hanya jalan saat status BERUBAH menjadi 'closed'
  IF NEW.status = 'closed' AND (OLD.status IS DISTINCT FROM NEW.status) THEN

    -- upsert agregat per reviewee
    INSERT INTO public.student_x3_scores (
      session_id, student_id, x3_score,
      avg_courtesy, avg_cooperation, avg_empathy, avg_honesty, avg_responsibility,
      reviewer_count, computed_at
    )
    SELECT
      NEW.id AS session_id,
      s.reviewee_id AS student_id,
      ROUND( AVG( (s.score_courtesy + s.score_cooperation + s.score_empathy
                 + s.score_honesty + s.score_responsibility)::numeric / 5.0 * 20.0 )::numeric, 2) AS x3_score,
      ROUND(AVG(s.score_courtesy)::numeric, 2),
      ROUND(AVG(s.score_cooperation)::numeric, 2),
      ROUND(AVG(s.score_empathy)::numeric, 2),
      ROUND(AVG(s.score_honesty)::numeric, 2),
      ROUND(AVG(s.score_responsibility)::numeric, 2),
      COUNT(*)::smallint,
      now()
    FROM public.peer_review_submissions s
    WHERE s.session_id = NEW.id
    GROUP BY s.reviewee_id
    ON CONFLICT (session_id, student_id) DO UPDATE
      SET x3_score              = EXCLUDED.x3_score,
          avg_courtesy          = EXCLUDED.avg_courtesy,
          avg_cooperation       = EXCLUDED.avg_cooperation,
          avg_empathy           = EXCLUDED.avg_empathy,
          avg_honesty           = EXCLUDED.avg_honesty,
          avg_responsibility    = EXCLUDED.avg_responsibility,
          reviewer_count        = EXCLUDED.reviewer_count,
          computed_at           = EXCLUDED.computed_at,
          updated_at            = now();

    -- Stempel waktu tutup
    NEW.closed_at := COALESCE(NEW.closed_at, now());
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_peer_session_close_calc_x3
  BEFORE UPDATE ON public.peer_review_sessions
  FOR EACH ROW EXECUTE FUNCTION public.calculate_x3_on_session_close();


-- ═══════════════════════════════════════════════════════════════════════════
-- BAGIAN 4 — ROW LEVEL SECURITY (RLS)
-- ═══════════════════════════════════════════════════════════════════════════

-- ────────────────────────────────────────────────────────────────────────
-- 4.1 Helper functions (SECURITY DEFINER agar tidak rekursif RLS)
-- ────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role = 'admin' AND is_active
  );
$$;

CREATE OR REPLACE FUNCTION public.is_teacher()
RETURNS BOOLEAN
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role = 'teacher' AND is_active
  );
$$;

CREATE OR REPLACE FUNCTION public.is_student()
RETURNS BOOLEAN
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role = 'student' AND is_active
  );
$$;

-- Apakah user saat ini wali kelas dari kelas-periode tertentu?
CREATE OR REPLACE FUNCTION public.is_homeroom_teacher_of_class_period(p_class_period_id UUID)
RETURNS BOOLEAN
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.class_period_assignments cpa
    WHERE cpa.id = p_class_period_id
      AND cpa.homeroom_teacher_id = auth.uid()
  );
$$;

-- Apakah user saat ini wali kelas dari enrollment tertentu?
CREATE OR REPLACE FUNCTION public.is_homeroom_teacher_of_enrollment(p_enrollment_id UUID)
RETURNS BOOLEAN
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.student_class_enrollments e
    JOIN public.class_period_assignments cpa ON cpa.id = e.class_period_assignment_id
    WHERE e.id = p_enrollment_id
      AND cpa.homeroom_teacher_id = auth.uid()
  );
$$;

-- ────────────────────────────────────────────────────────────────────────
-- 4.2 Enable RLS untuk semua tabel
-- ────────────────────────────────────────────────────────────────────────
ALTER TABLE public.profiles                     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.academic_periods             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.period_monthly_days          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.classes                      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.class_period_assignments     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_class_enrollments    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.violation_categories         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reward_categories            ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.monthly_attendance           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.behavior_point_transactions  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_behavior_scores      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.peer_review_sessions         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.peer_review_submissions      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.peer_review_progress         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_x3_scores            ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.peer_review_aspects          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fuzzy_configurations         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fuzzy_rules                  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.behavior_final_scores        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.teacher_narrative_notes      ENABLE ROW LEVEL SECURITY;

-- ────────────────────────────────────────────────────────────────────────
-- 4.3 Policy patterns
--     SELECT/INSERT/UPDATE/DELETE dipisah agar kontrol ketat.
--     Admin: full access (USING true & WITH CHECK true) ditangani per-table.
-- ────────────────────────────────────────────────────────────────────────

-- ── profiles ─────────────────────────────────────────────────────────────
CREATE POLICY profiles_select_self_or_admin ON public.profiles
  FOR SELECT USING (
    id = auth.uid()
    OR public.is_admin()
    OR public.is_teacher()    -- guru perlu lihat data siswanya (terbatas via app)
  );
CREATE POLICY profiles_admin_all ON public.profiles
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY profiles_self_update ON public.profiles
  FOR UPDATE USING (id = auth.uid()) WITH CHECK (id = auth.uid());

-- ── academic_periods ────────────────────────────────────────────────────
CREATE POLICY periods_select_authenticated ON public.academic_periods
  FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY periods_admin_write ON public.academic_periods
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── period_monthly_days ──────────────────────────────────────────────────
CREATE POLICY period_days_select_authenticated ON public.period_monthly_days
  FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY period_days_admin_write ON public.period_monthly_days
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── classes ──────────────────────────────────────────────────────────────
CREATE POLICY classes_select_authenticated ON public.classes
  FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY classes_admin_write ON public.classes
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── class_period_assignments ─────────────────────────────────────────────
CREATE POLICY cpa_select_authenticated ON public.class_period_assignments
  FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY cpa_admin_write ON public.class_period_assignments
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── student_class_enrollments ────────────────────────────────────────────
CREATE POLICY enroll_select_self_teacher_admin ON public.student_class_enrollments
  FOR SELECT USING (
    student_id = auth.uid()
    OR public.is_admin()
    OR public.is_homeroom_teacher_of_class_period(class_period_assignment_id)
  );
CREATE POLICY enroll_admin_write ON public.student_class_enrollments
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── violation_categories ─────────────────────────────────────────────────
CREATE POLICY violation_select_authenticated ON public.violation_categories
  FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY violation_admin_write ON public.violation_categories
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── reward_categories ────────────────────────────────────────────────────
CREATE POLICY reward_select_authenticated ON public.reward_categories
  FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY reward_admin_write ON public.reward_categories
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── monthly_attendance ───────────────────────────────────────────────────
CREATE POLICY attendance_select ON public.monthly_attendance
  FOR SELECT USING (
    public.is_admin()
    OR public.is_homeroom_teacher_of_enrollment(enrollment_id)
    OR EXISTS (SELECT 1 FROM public.student_class_enrollments e
               WHERE e.id = enrollment_id AND e.student_id = auth.uid())
  );
CREATE POLICY attendance_teacher_write ON public.monthly_attendance
  FOR INSERT WITH CHECK (
    public.is_homeroom_teacher_of_enrollment(enrollment_id)
  );
CREATE POLICY attendance_teacher_update ON public.monthly_attendance
  FOR UPDATE USING (
    public.is_homeroom_teacher_of_enrollment(enrollment_id) AND is_locked = FALSE
  ) WITH CHECK (
    public.is_homeroom_teacher_of_enrollment(enrollment_id)
  );
CREATE POLICY attendance_admin_all ON public.monthly_attendance
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── behavior_point_transactions ──────────────────────────────────────────
CREATE POLICY tx_select ON public.behavior_point_transactions
  FOR SELECT USING (
    public.is_admin()
    OR public.is_homeroom_teacher_of_enrollment(enrollment_id)
    OR EXISTS (SELECT 1 FROM public.student_class_enrollments e
               WHERE e.id = enrollment_id AND e.student_id = auth.uid())
  );
CREATE POLICY tx_teacher_insert ON public.behavior_point_transactions
  FOR INSERT WITH CHECK (
    public.is_homeroom_teacher_of_enrollment(enrollment_id) AND recorded_by = auth.uid()
  );
CREATE POLICY tx_teacher_update ON public.behavior_point_transactions
  FOR UPDATE USING (
    public.is_homeroom_teacher_of_enrollment(enrollment_id)
  ) WITH CHECK (
    public.is_homeroom_teacher_of_enrollment(enrollment_id)
  );
CREATE POLICY tx_admin_all ON public.behavior_point_transactions
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── student_behavior_scores ──────────────────────────────────────────────
CREATE POLICY score_select ON public.student_behavior_scores
  FOR SELECT USING (
    public.is_admin()
    OR public.is_homeroom_teacher_of_enrollment(enrollment_id)
    OR EXISTS (SELECT 1 FROM public.student_class_enrollments e
               WHERE e.id = enrollment_id AND e.student_id = auth.uid())
  );
CREATE POLICY score_admin_all ON public.student_behavior_scores
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());
-- INSERT/UPDATE oleh trigger (SECURITY DEFINER), tidak butuh policy user.

-- ── peer_review_sessions ─────────────────────────────────────────────────
CREATE POLICY session_select ON public.peer_review_sessions
  FOR SELECT USING (
    public.is_admin()
    OR public.is_homeroom_teacher_of_class_period(class_period_assignment_id)
    OR EXISTS (
      SELECT 1
      FROM public.student_class_enrollments e
      WHERE e.class_period_assignment_id = peer_review_sessions.class_period_assignment_id
        AND e.student_id = auth.uid()
    )
  );
CREATE POLICY session_teacher_write ON public.peer_review_sessions
  FOR INSERT WITH CHECK (
    public.is_homeroom_teacher_of_class_period(class_period_assignment_id)
  );
CREATE POLICY session_teacher_update ON public.peer_review_sessions
  FOR UPDATE USING (
    public.is_homeroom_teacher_of_class_period(class_period_assignment_id)
  ) WITH CHECK (
    public.is_homeroom_teacher_of_class_period(class_period_assignment_id)
  );
CREATE POLICY session_admin_all ON public.peer_review_sessions
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── peer_review_submissions  (KRITIS: anonimitas) ────────────────────────
-- SELECT diblok untuk semua siswa & reviewee. Hanya admin & wali kelas
-- (untuk agregasi) yang boleh SELECT. Reviewer sendiri TIDAK boleh SELECT
-- baris yang sudah submitted (immutable + privacy).
CREATE POLICY submission_select_admin_or_teacher_only ON public.peer_review_submissions
  FOR SELECT USING (
    public.is_admin()
    OR EXISTS (
      SELECT 1 FROM public.peer_review_sessions s
      JOIN public.class_period_assignments cpa ON cpa.id = s.class_period_assignment_id
      WHERE s.id = peer_review_submissions.session_id
        AND cpa.homeroom_teacher_id = auth.uid()
    )
  );
CREATE POLICY submission_student_insert ON public.peer_review_submissions
  FOR INSERT WITH CHECK (
    reviewer_id = auth.uid()
    AND public.is_student()
    AND EXISTS (
      SELECT 1 FROM public.peer_review_sessions s
      WHERE s.id = peer_review_submissions.session_id
        AND s.status = 'active'
    )
  );
-- Tidak ada UPDATE/DELETE policy → submission immutable.
CREATE POLICY submission_admin_all ON public.peer_review_submissions
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── peer_review_progress ─────────────────────────────────────────────────
-- Siswa hanya boleh INSERT/UPDATE progres dirinya sendiri.
CREATE POLICY progress_select_self_teacher_admin ON public.peer_review_progress
  FOR SELECT USING (
    student_id = auth.uid()
    OR public.is_admin()
    OR EXISTS (
      SELECT 1 FROM public.peer_review_sessions s
      JOIN public.class_period_assignments cpa ON cpa.id = s.class_period_assignment_id
      WHERE s.id = peer_review_progress.session_id
        AND cpa.homeroom_teacher_id = auth.uid()
    )
  );
CREATE POLICY progress_student_insert ON public.peer_review_progress
  FOR INSERT WITH CHECK (
    student_id = auth.uid() AND public.is_student()
  );
CREATE POLICY progress_student_update ON public.peer_review_progress
  FOR UPDATE USING (
    student_id = auth.uid() AND public.is_student()
  ) WITH CHECK (
    student_id = auth.uid()
  );
CREATE POLICY progress_admin_all ON public.peer_review_progress
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── student_x3_scores ────────────────────────────────────────────────────
CREATE POLICY x3_select ON public.student_x3_scores
  FOR SELECT USING (
    public.is_admin()
    OR student_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM public.peer_review_sessions s
      JOIN public.class_period_assignments cpa ON cpa.id = s.class_period_assignment_id
      WHERE s.id = student_x3_scores.session_id
        AND cpa.homeroom_teacher_id = auth.uid()
    )
  );
CREATE POLICY x3_admin_all ON public.student_x3_scores
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── peer_review_aspects ──────────────────────────────────────────────────
CREATE POLICY aspects_select_authenticated ON public.peer_review_aspects
  FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY aspects_admin_write ON public.peer_review_aspects
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── fuzzy_configurations & fuzzy_rules ───────────────────────────────────
CREATE POLICY fuzzy_cfg_select ON public.fuzzy_configurations
  FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY fuzzy_cfg_admin ON public.fuzzy_configurations
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

CREATE POLICY fuzzy_rules_select ON public.fuzzy_rules
  FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY fuzzy_rules_admin ON public.fuzzy_rules
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── behavior_final_scores ────────────────────────────────────────────────
CREATE POLICY final_select ON public.behavior_final_scores
  FOR SELECT USING (
    public.is_admin()
    OR public.is_homeroom_teacher_of_enrollment(enrollment_id)
    OR EXISTS (SELECT 1 FROM public.student_class_enrollments e
               WHERE e.id = enrollment_id AND e.student_id = auth.uid())
  );
CREATE POLICY final_admin_all ON public.behavior_final_scores
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── teacher_narrative_notes ──────────────────────────────────────────────
CREATE POLICY note_select ON public.teacher_narrative_notes
  FOR SELECT USING (
    public.is_admin()
    OR public.is_homeroom_teacher_of_enrollment(enrollment_id)
    OR EXISTS (SELECT 1 FROM public.student_class_enrollments e
               WHERE e.id = enrollment_id AND e.student_id = auth.uid())
  );
CREATE POLICY note_teacher_write ON public.teacher_narrative_notes
  FOR INSERT WITH CHECK (
    public.is_homeroom_teacher_of_enrollment(enrollment_id) AND written_by = auth.uid()
  );
CREATE POLICY note_teacher_update ON public.teacher_narrative_notes
  FOR UPDATE USING (
    public.is_homeroom_teacher_of_enrollment(enrollment_id)
  ) WITH CHECK (
    public.is_homeroom_teacher_of_enrollment(enrollment_id)
  );
CREATE POLICY note_admin_all ON public.teacher_narrative_notes
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());


-- ═══════════════════════════════════════════════════════════════════════════
-- BAGIAN 5 — INDEXES (untuk query yang sering)
-- ═══════════════════════════════════════════════════════════════════════════

-- profiles
CREATE INDEX idx_profiles_role         ON public.profiles (role) WHERE is_active;
CREATE INDEX idx_profiles_email        ON public.profiles (lower(email));

-- academic_periods
CREATE INDEX idx_periods_status        ON public.academic_periods (status);

-- period_monthly_days
CREATE INDEX idx_period_days_period    ON public.period_monthly_days (period_id);
CREATE INDEX idx_period_days_my        ON public.period_monthly_days (month, year);

-- class_period_assignments
CREATE INDEX idx_cpa_class             ON public.class_period_assignments (class_id);
CREATE INDEX idx_cpa_period            ON public.class_period_assignments (period_id);
CREATE INDEX idx_cpa_teacher           ON public.class_period_assignments (homeroom_teacher_id) WHERE homeroom_teacher_id IS NOT NULL;

-- student_class_enrollments
CREATE INDEX idx_enroll_student        ON public.student_class_enrollments (student_id);
CREATE INDEX idx_enroll_cpa            ON public.student_class_enrollments (class_period_assignment_id);
CREATE INDEX idx_enroll_status         ON public.student_class_enrollments (status);

-- monthly_attendance
CREATE INDEX idx_attendance_enrollment   ON public.monthly_attendance (enrollment_id);
CREATE INDEX idx_attendance_my           ON public.monthly_attendance (year, month);
CREATE INDEX idx_attendance_locked       ON public.monthly_attendance (is_locked);

-- behavior_point_transactions
CREATE INDEX idx_tx_enrollment           ON public.behavior_point_transactions (enrollment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_tx_date                 ON public.behavior_point_transactions (transaction_date);
CREATE INDEX idx_tx_recorded_by          ON public.behavior_point_transactions (recorded_by);
CREATE INDEX idx_tx_violation_cat        ON public.behavior_point_transactions (violation_category_id) WHERE violation_category_id IS NOT NULL;
CREATE INDEX idx_tx_reward_cat           ON public.behavior_point_transactions (reward_category_id) WHERE reward_category_id IS NOT NULL;

-- peer_review
CREATE INDEX idx_session_cpa             ON public.peer_review_sessions (class_period_assignment_id);
CREATE INDEX idx_session_status          ON public.peer_review_sessions (status);
CREATE INDEX idx_submission_session      ON public.peer_review_submissions (session_id);
CREATE INDEX idx_submission_reviewee     ON public.peer_review_submissions (session_id, reviewee_id);
CREATE INDEX idx_submission_reviewer     ON public.peer_review_submissions (session_id, reviewer_id);
CREATE INDEX idx_progress_session        ON public.peer_review_progress (session_id);
CREATE INDEX idx_progress_student        ON public.peer_review_progress (student_id);
CREATE INDEX idx_x3_session              ON public.student_x3_scores (session_id);
CREATE INDEX idx_x3_student              ON public.student_x3_scores (student_id);

-- behavior_final_scores
CREATE INDEX idx_final_enrollment        ON public.behavior_final_scores (enrollment_id);
CREATE INDEX idx_final_category          ON public.behavior_final_scores (category) WHERE category IS NOT NULL;

-- teacher_narrative_notes
CREATE INDEX idx_note_enrollment         ON public.teacher_narrative_notes (enrollment_id);
CREATE INDEX idx_note_writer             ON public.teacher_narrative_notes (written_by);


-- ═══════════════════════════════════════════════════════════════════════════
-- BAGIAN 6 — SEED DATA
-- ═══════════════════════════════════════════════════════════════════════════

-- ────────────────────────────────────────────────────────────────────────
-- 6.1 Admin user
--
-- ⚠ CARA YANG BENAR (SUPABASE):
--   1. Buka Dashboard Supabase → Authentication → Users → "Add user"
--   2. Email: admin@sman13bdg.sch.id   Password: (set sendiri)
--   3. Salin UUID user yang baru dibuat
--   4. Ganti '00000000-0000-0000-0000-000000000001' di bawah dengan UUID itu
--   5. Jalankan ulang block ini saja, atau jalankan setelah migrasi.
--
-- Block ini hanya akan menyisipkan profile bila auth.users memang punya
-- baris dengan UUID tsb. Bila tidak ada, INSERT di-skip dengan NOTICE.
-- ────────────────────────────────────────────────────────────────────────
DO $$
DECLARE
  v_admin_id UUID := '00000000-0000-0000-0000-000000000001';
BEGIN
  IF EXISTS (SELECT 1 FROM auth.users WHERE id = v_admin_id) THEN
    INSERT INTO public.profiles (id, role, email, full_name, is_active)
    VALUES (v_admin_id, 'admin', 'admin@sman13bdg.sch.id', 'Administrator SiPandu', TRUE)
    ON CONFLICT (id) DO UPDATE
      SET role = 'admin', is_active = TRUE;
    RAISE NOTICE '✓ Admin profile siap.';
  ELSE
    RAISE NOTICE '⚠ Admin auth user belum ada. Buat dulu via Dashboard, lalu jalankan block ini ulang.';
  END IF;
END $$;

-- ────────────────────────────────────────────────────────────────────────
-- 6.2 fuzzy_configurations  — sesuai SYSTEM_CONTEXT.md §3
--   X1 (Kehadiran):
--     Rendah  : trapezoid_left  [60, 75]
--     Sedang  : triangle        [60, 75, 90]
--     Tinggi  : trapezoid_right [85, 95]
--   X2 (Poin Perilaku):
--     Rendah  : trapezoid_left  [40, 60]
--     Sedang  : triangle        [40, 60, 80]
--     Tinggi  : trapezoid_right [60, 85]
--   X3 (Nilai Teman):
--     Rendah  : trapezoid_left  [50, 70]
--     Sedang  : triangle        [50, 75, 90]
--     Tinggi  : trapezoid_right [80, 95]
--   Z* (Output):
--     Perlu Pembinaan : trapezoid_left  [40, 50]
--     Cukup           : triangle        [40, 55, 70]
--     Baik            : triangle        [65, 80, 90]
--     Sangat Baik     : trapezoid_right [85, 95]
-- ────────────────────────────────────────────────────────────────────────
INSERT INTO public.fuzzy_configurations (variable_name, set_name, function_type, parameters) VALUES
  ('x1', 'rendah', 'trapezoid_left',  ARRAY[60,75]::numeric[]),
  ('x1', 'sedang', 'triangle',        ARRAY[60,75,90]::numeric[]),
  ('x1', 'tinggi', 'trapezoid_right', ARRAY[85,95]::numeric[]),

  ('x2', 'rendah', 'trapezoid_left',  ARRAY[40,60]::numeric[]),
  ('x2', 'sedang', 'triangle',        ARRAY[40,60,80]::numeric[]),
  ('x2', 'tinggi', 'trapezoid_right', ARRAY[60,85]::numeric[]),

  ('x3', 'rendah', 'trapezoid_left',  ARRAY[50,70]::numeric[]),
  ('x3', 'sedang', 'triangle',        ARRAY[50,75,90]::numeric[]),
  ('x3', 'tinggi', 'trapezoid_right', ARRAY[80,95]::numeric[]),

  ('z',  'perlu_pembinaan', 'trapezoid_left',  ARRAY[40,50]::numeric[]),
  ('z',  'cukup',           'triangle',        ARRAY[40,55,70]::numeric[]),
  ('z',  'baik',            'triangle',        ARRAY[65,80,90]::numeric[]),
  ('z',  'sangat_baik',     'trapezoid_right', ARRAY[85,95]::numeric[])
ON CONFLICT (variable_name, set_name) DO UPDATE
  SET function_type = EXCLUDED.function_type,
      parameters    = EXCLUDED.parameters,
      updated_at    = now();

-- ────────────────────────────────────────────────────────────────────────
-- 6.3 fuzzy_rules — 27 aturan IF-THEN sesuai Tabel 4.3 PDF skripsi
-- ────────────────────────────────────────────────────────────────────────
INSERT INTO public.fuzzy_rules (rule_number, x1_set, x2_set, x3_set, output_set) VALUES
  ( 1, 'tinggi', 'tinggi', 'tinggi', 'sangat_baik'),
  ( 2, 'tinggi', 'tinggi', 'sedang', 'sangat_baik'),
  ( 3, 'tinggi', 'tinggi', 'rendah', 'baik'),
  ( 4, 'tinggi', 'sedang', 'tinggi', 'sangat_baik'),
  ( 5, 'tinggi', 'sedang', 'sedang', 'baik'),
  ( 6, 'tinggi', 'sedang', 'rendah', 'cukup'),
  ( 7, 'tinggi', 'rendah', 'tinggi', 'baik'),
  ( 8, 'tinggi', 'rendah', 'sedang', 'cukup'),
  ( 9, 'tinggi', 'rendah', 'rendah', 'perlu_pembinaan'),
  (10, 'sedang', 'tinggi', 'tinggi', 'sangat_baik'),
  (11, 'sedang', 'tinggi', 'sedang', 'baik'),
  (12, 'sedang', 'tinggi', 'rendah', 'cukup'),
  (13, 'sedang', 'sedang', 'tinggi', 'baik'),
  (14, 'sedang', 'sedang', 'sedang', 'cukup'),
  (15, 'sedang', 'sedang', 'rendah', 'perlu_pembinaan'),
  (16, 'sedang', 'rendah', 'tinggi', 'cukup'),
  (17, 'sedang', 'rendah', 'sedang', 'perlu_pembinaan'),
  (18, 'sedang', 'rendah', 'rendah', 'perlu_pembinaan'),
  (19, 'rendah', 'tinggi', 'tinggi', 'baik'),
  (20, 'rendah', 'tinggi', 'sedang', 'cukup'),
  (21, 'rendah', 'tinggi', 'rendah', 'perlu_pembinaan'),
  (22, 'rendah', 'sedang', 'tinggi', 'cukup'),
  (23, 'rendah', 'sedang', 'sedang', 'perlu_pembinaan'),
  (24, 'rendah', 'sedang', 'rendah', 'perlu_pembinaan'),
  (25, 'rendah', 'rendah', 'tinggi', 'perlu_pembinaan'),
  (26, 'rendah', 'rendah', 'sedang', 'perlu_pembinaan'),
  (27, 'rendah', 'rendah', 'rendah', 'perlu_pembinaan')
ON CONFLICT (rule_number) DO UPDATE
  SET x1_set     = EXCLUDED.x1_set,
      x2_set     = EXCLUDED.x2_set,
      x3_set     = EXCLUDED.x3_set,
      output_set = EXCLUDED.output_set,
      updated_at = now();

-- ────────────────────────────────────────────────────────────────────────
-- 6.4 violation_categories — 6 contoh realistis (poin sesuai mockup admin)
-- ────────────────────────────────────────────────────────────────────────
INSERT INTO public.violation_categories (name, point_deduction, sop_reference, description) VALUES
  ('Bolos tanpa keterangan',         15, 'Pasal 3 ayat 1', 'Tidak hadir tanpa surat izin'),
  ('Terlambat masuk kelas',           5, 'Pasal 2 ayat 3', 'Datang terlambat lebih dari 10 menit'),
  ('Tidak mengerjakan PR',           10, 'Pasal 4 ayat 2', 'Tidak menyelesaikan tugas rumah'),
  ('Membuat keributan di kelas',      8, 'Pasal 3 ayat 4', 'Mengganggu konsentrasi belajar'),
  ('Perkelahian',                    50, 'Pasal 6 ayat 1', 'Adu fisik dengan siswa lain'),
  ('Merokok di lingkungan sekolah',  40, 'Pasal 7 ayat 2', 'Pelanggaran berat tata tertib')
ON CONFLICT (name) DO NOTHING;

-- ────────────────────────────────────────────────────────────────────────
-- 6.5 reward_categories — 4 contoh
-- ────────────────────────────────────────────────────────────────────────
INSERT INTO public.reward_categories (name, point_addition, category_label, description) VALUES
  ('Juara olimpiade tingkat kota',     15, 'Akademik',     'Meraih juara olimpiade kota/kabupaten'),
  ('Ketua OSIS',                       10, 'Organisasi',   'Aktif sebagai ketua OSIS'),
  ('Hadir 100% sebulan penuh',          5, 'Kedisiplinan', 'Tidak ada absensi dalam satu bulan penuh'),
  ('Mewakili sekolah lomba provinsi',  12, 'Prestasi',     'Mewakili sekolah dalam lomba tingkat provinsi')
ON CONFLICT (name) DO NOTHING;

-- ────────────────────────────────────────────────────────────────────────
-- 6.6 peer_review_aspects — 5 aspek default (label & deskripsi)
-- ────────────────────────────────────────────────────────────────────────
-- Dimensi Profil Lulusan — Permendikdasmen No. 10 Tahun 2025 (SKL).
INSERT INTO public.peer_review_aspects (aspect_key, label, description, display_order) VALUES
  ('courtesy',       'Akhlak Mulia',
   'Seberapa jujur dan baik sikap siswa ini dalam berkata dan bertindak kepada guru maupun teman-teman?', 1),
  ('cooperation',    'Kewargaan',
   'Seberapa taat siswa ini terhadap aturan sekolah dan bertanggung jawab menjaga nama baik kelas maupun sekolah?', 2),
  ('empathy',        'Kolaborasi',
   'Seberapa aktif siswa ini peduli, berbagi, dan bekerja sama dengan teman-teman dalam kegiatan bersama?', 3),
  ('honesty',        'Kemandirian',
   'Seberapa bertanggung jawab dan berinisiatif siswa ini dalam menyelesaikan tugas dan kewajibannya sendiri?', 4),
  ('responsibility', 'Komunikasi',
   'Seberapa sopan siswa ini saat berbicara atau menyampaikan pendapat kepada teman-teman?', 5)
ON CONFLICT (aspect_key) DO NOTHING;


-- ═══════════════════════════════════════════════════════════════════════════
-- SELESAI — Verifikasi cepat
-- ═══════════════════════════════════════════════════════════════════════════
DO $$
BEGIN
  RAISE NOTICE '════════════════════════════════════════════════════════════';
  RAISE NOTICE 'SiPandu migration selesai.';
  RAISE NOTICE 'Tabel        : %', (SELECT count(*) FROM information_schema.tables WHERE table_schema='public');
  RAISE NOTICE 'Fuzzy config : %', (SELECT count(*) FROM public.fuzzy_configurations);
  RAISE NOTICE 'Fuzzy rules  : %', (SELECT count(*) FROM public.fuzzy_rules);
  RAISE NOTICE 'Violations   : %', (SELECT count(*) FROM public.violation_categories);
  RAISE NOTICE 'Rewards      : %', (SELECT count(*) FROM public.reward_categories);
  RAISE NOTICE '════════════════════════════════════════════════════════════';
END $$;
