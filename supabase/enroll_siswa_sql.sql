-- ============================================================
-- ENROLL SISWA KE KELAS (student_class_enrollments)
-- SiPandu - SMAN 13 Bandung
-- Prasyarat: import_siswa_sql.sql sudah dijalankan
-- Script ini otomatis pakai periode AKTIF yang ada
-- ============================================================

-- Cek periode aktif dulu:
-- SELECT id, name FROM public.academic_periods WHERE status = 'active';

DO $$
DECLARE
  v_period_id        UUID;
  v_class_id         UUID;
  v_cpa_id           UUID;
  v_student_id       UUID;
BEGIN

  -- Ambil ID periode aktif
  SELECT id INTO v_period_id FROM public.academic_periods WHERE status = 'active' LIMIT 1;

  IF v_period_id IS NULL THEN
    RAISE EXCEPTION 'Tidak ada periode aktif. Aktifkan periode terlebih dahulu.';
  END IF;

  RAISE NOTICE 'Menggunakan periode: %', v_period_id;

  -- ── Kelas X-6 (38 siswa) ──
  SELECT id INTO v_class_id FROM public.classes WHERE name = 'X-6';
  IF v_class_id IS NULL THEN
    RAISE WARNING 'Kelas X-6 tidak ditemukan, dilewati.';
  ELSE
    -- Buat class_period_assignment jika belum ada
    INSERT INTO public.class_period_assignments (id, class_id, period_id, created_at, updated_at)
    VALUES (gen_random_uuid(), v_class_id, v_period_id, now(), now())
    ON CONFLICT (class_id, period_id) DO NOTHING;

    SELECT id INTO v_cpa_id FROM public.class_period_assignments
    WHERE class_id = v_class_id AND period_id = v_period_id;

    -- NISN 0095604838
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095604838' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 3092316727
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '3092316727' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093768354
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093768354' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0082831378
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0082831378' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0104785424
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0104785424' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0102219828
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0102219828' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098490905
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098490905' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092208878
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092208878' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0102282661
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0102282661' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0105246639
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0105246639' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0109203574
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0109203574' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098050618
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098050618' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081426498
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081426498' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0103733132
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0103733132' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0107135466
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0107135466' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0109394649
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0109394649' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0071150194
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0071150194' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096500319
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096500319' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0074487210
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0074487210' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0106947287
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0106947287' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094498606
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094498606' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095594049
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095594049' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096412687
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096412687' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0107461443
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0107461443' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095450176
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095450176' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0103428856
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0103428856' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097305509
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097305509' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089837636
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089837636' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0102622876
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0102622876' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096034527
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096034527' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087486130
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087486130' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093111936
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093111936' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095414630
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095414630' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0109580059
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0109580059' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092637850
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092637850' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081043957
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081043957' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0107018021
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0107018021' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094072893
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094072893' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
  END IF;

  -- ── Kelas X-7 (38 siswa) ──
  SELECT id INTO v_class_id FROM public.classes WHERE name = 'X-7';
  IF v_class_id IS NULL THEN
    RAISE WARNING 'Kelas X-7 tidak ditemukan, dilewati.';
  ELSE
    -- Buat class_period_assignment jika belum ada
    INSERT INTO public.class_period_assignments (id, class_id, period_id, created_at, updated_at)
    VALUES (gen_random_uuid(), v_class_id, v_period_id, now(), now())
    ON CONFLICT (class_id, period_id) DO NOTHING;

    SELECT id INTO v_cpa_id FROM public.class_period_assignments
    WHERE class_id = v_class_id AND period_id = v_period_id;

    -- NISN 0107342384
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0107342384' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0104353946
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0104353946' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0107508754
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0107508754' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0107879456
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0107879456' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0101416691
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0101416691' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0105830077
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0105830077' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0099034730
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099034730' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091797532
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091797532' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0104900137
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0104900137' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095243902
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095243902' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 3105561311
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '3105561311' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091441601
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091441601' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093412518
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093412518' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094984856
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094984856' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0107734460
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0107734460' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095471649
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095471649' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0105500052
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0105500052' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094109928
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094109928' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093104616
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093104616' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0107605799
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0107605799' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087715936
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087715936' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096183682
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096183682' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091862168
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091862168' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092886161
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092886161' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097438074
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097438074' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0106098648
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0106098648' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0108315381
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0108315381' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0103427060
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0103427060' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 3100249836
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '3100249836' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096311667
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096311667' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0107746241
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0107746241' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091861104
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091861104' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0104781395
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0104781395' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096345742
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096345742' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0105984687
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0105984687' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095793403
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095793403' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095466195
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095466195' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098054349
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098054349' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
  END IF;

  -- ── Kelas X-8 (37 siswa) ──
  SELECT id INTO v_class_id FROM public.classes WHERE name = 'X-8';
  IF v_class_id IS NULL THEN
    RAISE WARNING 'Kelas X-8 tidak ditemukan, dilewati.';
  ELSE
    -- Buat class_period_assignment jika belum ada
    INSERT INTO public.class_period_assignments (id, class_id, period_id, created_at, updated_at)
    VALUES (gen_random_uuid(), v_class_id, v_period_id, now(), now())
    ON CONFLICT (class_id, period_id) DO NOTHING;

    SELECT id INTO v_cpa_id FROM public.class_period_assignments
    WHERE class_id = v_class_id AND period_id = v_period_id;

    -- NISN 0096195462
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096195462' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0107377371
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0107377371' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097729040
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097729040' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095362397
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095362397' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087674596
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087674596' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092822640
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092822640' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0108697945
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0108697945' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0105076009
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0105076009' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096567415
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096567415' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091662024
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091662024' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0106213839
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0106213839' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095784306
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095784306' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0108228227
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0108228227' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094960250
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094960250' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091989335
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091989335' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0108727752
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0108727752' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0099348350
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099348350' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097838322
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097838322' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096762939
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096762939' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095204935
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095204935' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094328461
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094328461' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0108992042
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0108992042' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095866149
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095866149' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091330181
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091330181' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0109041768
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0109041768' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0108252299
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0108252299' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098994143
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098994143' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096457879
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096457879' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0101023182
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0101023182' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093554154
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093554154' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0108931373
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0108931373' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091511337
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091511337' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092074545
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092074545' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 3090553801
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '3090553801' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0101962357
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0101962357' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0107068635
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0107068635' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092829290
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092829290' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
  END IF;

  -- ── Kelas X-9 (37 siswa) ──
  SELECT id INTO v_class_id FROM public.classes WHERE name = 'X-9';
  IF v_class_id IS NULL THEN
    RAISE WARNING 'Kelas X-9 tidak ditemukan, dilewati.';
  ELSE
    -- Buat class_period_assignment jika belum ada
    INSERT INTO public.class_period_assignments (id, class_id, period_id, created_at, updated_at)
    VALUES (gen_random_uuid(), v_class_id, v_period_id, now(), now())
    ON CONFLICT (class_id, period_id) DO NOTHING;

    SELECT id INTO v_cpa_id FROM public.class_period_assignments
    WHERE class_id = v_class_id AND period_id = v_period_id;

    -- NISN 0096291379
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096291379' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093934354
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093934354' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0161668911
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0161668911' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0106784033
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0106784033' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095157862
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095157862' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092200006
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092200006' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0104635846
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0104635846' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095079812
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095079812' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0108938832
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0108938832' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0103312549
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0103312549' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097501581
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097501581' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096639515
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096639515' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0101383600
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0101383600' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0108571974
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0108571974' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 3086040492
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '3086040492' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098552776
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098552776' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094532712
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094532712' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095167542
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095167542' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0107601232
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0107601232' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094927362
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094927362' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097026853
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097026853' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098898235
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098898235' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096556998
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096556998' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0101175088
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0101175088' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094169569
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094169569' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092869659
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092869659' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094566388
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094566388' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0108510740
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0108510740' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0108626732
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0108626732' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091718847
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091718847' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093665552
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093665552' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098378016
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098378016' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0104052508
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0104052508' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092885404
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092885404' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0102105094
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0102105094' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096849967
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096849967' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0109972200
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0109972200' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
  END IF;

  -- ── Kelas X-10 (37 siswa) ──
  SELECT id INTO v_class_id FROM public.classes WHERE name = 'X-10';
  IF v_class_id IS NULL THEN
    RAISE WARNING 'Kelas X-10 tidak ditemukan, dilewati.';
  ELSE
    -- Buat class_period_assignment jika belum ada
    INSERT INTO public.class_period_assignments (id, class_id, period_id, created_at, updated_at)
    VALUES (gen_random_uuid(), v_class_id, v_period_id, now(), now())
    ON CONFLICT (class_id, period_id) DO NOTHING;

    SELECT id INTO v_cpa_id FROM public.class_period_assignments
    WHERE class_id = v_class_id AND period_id = v_period_id;

    -- NISN 0087041228
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087041228' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097794426
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097794426' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095429863
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095429863' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0106574495
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0106574495' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094181704
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094181704' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 3104121883
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '3104121883' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0103953371
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0103953371' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0102406899
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0102406899' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096149291
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096149291' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0103817954
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0103817954' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096601746
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096601746' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0107076441
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0107076441' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0101304912
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0101304912' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096820499
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096820499' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094521011
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094521011' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092564861
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092564861' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091989992
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091989992' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0104001079
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0104001079' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0104681060
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0104681060' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091479386
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091479386' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098781868
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098781868' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0101809477
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0101809477' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097396815
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097396815' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0099406234
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099406234' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093563069
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093563069' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0107065679
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0107065679' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096979789
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096979789' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093438227
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093438227' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098562310
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098562310' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094576386
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094576386' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0099284140
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099284140' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0099619974
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099619974' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0105480689
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0105480689' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0099872250
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099872250' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095396321
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095396321' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098892540
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098892540' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0106261335
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0106261335' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
  END IF;

  -- ── Kelas XI-1 (36 siswa) ──
  SELECT id INTO v_class_id FROM public.classes WHERE name = 'XI-1';
  IF v_class_id IS NULL THEN
    RAISE WARNING 'Kelas XI-1 tidak ditemukan, dilewati.';
  ELSE
    -- Buat class_period_assignment jika belum ada
    INSERT INTO public.class_period_assignments (id, class_id, period_id, created_at, updated_at)
    VALUES (gen_random_uuid(), v_class_id, v_period_id, now(), now())
    ON CONFLICT (class_id, period_id) DO NOTHING;

    SELECT id INTO v_cpa_id FROM public.class_period_assignments
    WHERE class_id = v_class_id AND period_id = v_period_id;

    -- NISN 0099901151
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099901151' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096804251
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096804251' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0082983720
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0082983720' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0085393853
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0085393853' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094811754
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094811754' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091719309
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091719309' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092822214
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092822214' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0099275201
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099275201' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095846136
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095846136' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096331666
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096331666' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081608744
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081608744' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088874777
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088874777' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 3081418068
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '3081418068' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094312919
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094312919' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093589653
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093589653' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096120705
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096120705' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088385451
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088385451' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093324527
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093324527' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088101359
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088101359' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091348168
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091348168' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0084632088
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0084632088' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088196042
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088196042' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088486173
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088486173' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095880099
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095880099' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0084888666
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0084888666' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0082101385
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0082101385' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088633637
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088633637' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095229833
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095229833' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083493640
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083493640' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097159532
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097159532' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 3077332510
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '3077332510' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092400779
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092400779' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0084018415
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0084018415' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0085694828
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0085694828' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088999079
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088999079' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094897585
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094897585' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
  END IF;

  -- ── Kelas XI-2 (36 siswa) ──
  SELECT id INTO v_class_id FROM public.classes WHERE name = 'XI-2';
  IF v_class_id IS NULL THEN
    RAISE WARNING 'Kelas XI-2 tidak ditemukan, dilewati.';
  ELSE
    -- Buat class_period_assignment jika belum ada
    INSERT INTO public.class_period_assignments (id, class_id, period_id, created_at, updated_at)
    VALUES (gen_random_uuid(), v_class_id, v_period_id, now(), now())
    ON CONFLICT (class_id, period_id) DO NOTHING;

    SELECT id INTO v_cpa_id FROM public.class_period_assignments
    WHERE class_id = v_class_id AND period_id = v_period_id;

    -- NISN 0084267116
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0084267116' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096922170
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096922170' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083519030
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083519030' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0099610459
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099610459' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083812668
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083812668' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087349094
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087349094' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 3083961072
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '3083961072' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088030509
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088030509' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0071211737
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0071211737' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087172775
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087172775' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0082390369
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0082390369' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088914676
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088914676' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087400639
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087400639' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089563673
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089563673' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0074399124
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0074399124' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095866549
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095866549' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0086014300
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0086014300' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0084692875
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0084692875' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083466112
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083466112' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093870606
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093870606' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083662112
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083662112' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088919921
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088919921' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 3088906437
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '3088906437' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0084760521
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0084760521' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0084189826
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0084189826' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097180658
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097180658' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0084658950
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0084658950' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0084124145
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0084124145' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094409861
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094409861' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092775233
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092775233' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0099062653
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099062653' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0082051697
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0082051697' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092203398
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092203398' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0082127083
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0082127083' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093120886
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093120886' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094528638
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094528638' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
  END IF;

  -- ── Kelas XI-3 (36 siswa) ──
  SELECT id INTO v_class_id FROM public.classes WHERE name = 'XI-3';
  IF v_class_id IS NULL THEN
    RAISE WARNING 'Kelas XI-3 tidak ditemukan, dilewati.';
  ELSE
    -- Buat class_period_assignment jika belum ada
    INSERT INTO public.class_period_assignments (id, class_id, period_id, created_at, updated_at)
    VALUES (gen_random_uuid(), v_class_id, v_period_id, now(), now())
    ON CONFLICT (class_id, period_id) DO NOTHING;

    SELECT id INTO v_cpa_id FROM public.class_period_assignments
    WHERE class_id = v_class_id AND period_id = v_period_id;

    -- NISN 0085186808
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0085186808' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0082882344
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0082882344' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087749173
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087749173' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0086273312
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0086273312' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097760504
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097760504' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0079438506
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0079438506' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094258212
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094258212' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0085766136
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0085766136' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 3097917547
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '3097917547' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0078476568
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0078476568' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087520296
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087520296' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087344570
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087344570' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0085868151
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0085868151' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081006479
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081006479' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094862116
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094862116' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094024681
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094024681' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097909539
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097909539' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089524404
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089524404' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0082102643
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0082102643' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083167167
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083167167' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0086479416
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0086479416' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0085202930
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0085202930' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095189763
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095189763' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0086162370
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0086162370' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087758194
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087758194' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094343231
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094343231' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089305913
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089305913' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083917203
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083917203' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0099498534
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099498534' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083310765
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083310765' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093280589
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093280589' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095919175
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095919175' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083302553
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083302553' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098361753
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098361753' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089512584
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089512584' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081832386
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081832386' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
  END IF;

  -- ── Kelas XI-4 (35 siswa) ──
  SELECT id INTO v_class_id FROM public.classes WHERE name = 'XI-4';
  IF v_class_id IS NULL THEN
    RAISE WARNING 'Kelas XI-4 tidak ditemukan, dilewati.';
  ELSE
    -- Buat class_period_assignment jika belum ada
    INSERT INTO public.class_period_assignments (id, class_id, period_id, created_at, updated_at)
    VALUES (gen_random_uuid(), v_class_id, v_period_id, now(), now())
    ON CONFLICT (class_id, period_id) DO NOTHING;

    SELECT id INTO v_cpa_id FROM public.class_period_assignments
    WHERE class_id = v_class_id AND period_id = v_period_id;

    -- NISN 0099109050
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099109050' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 3095675991
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '3095675991' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0084401100
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0084401100' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098532515
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098532515' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087256983
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087256983' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087801517
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087801517' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097420667
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097420667' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088966018
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088966018' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0068613702
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0068613702' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094083454
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094083454' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091300126
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091300126' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0085167950
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0085167950' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081818425
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081818425' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089099537
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089099537' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089795936
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089795936' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089758640
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089758640' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0085462671
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0085462671' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094806151
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094806151' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095131265
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095131265' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0084926284
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0084926284' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081217796
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081217796' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098807327
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098807327' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092798482
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092798482' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0082658726
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0082658726' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088880777
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088880777' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0084105497
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0084105497' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095459106
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095459106' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088083126
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088083126' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097282071
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097282071' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083406312
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083406312' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092122625
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092122625' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0156921258
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0156921258' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089979511
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089979511' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 3088141841
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '3088141841' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087530985
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087530985' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
  END IF;

  -- ── Kelas XI-5 (36 siswa) ──
  SELECT id INTO v_class_id FROM public.classes WHERE name = 'XI-5';
  IF v_class_id IS NULL THEN
    RAISE WARNING 'Kelas XI-5 tidak ditemukan, dilewati.';
  ELSE
    -- Buat class_period_assignment jika belum ada
    INSERT INTO public.class_period_assignments (id, class_id, period_id, created_at, updated_at)
    VALUES (gen_random_uuid(), v_class_id, v_period_id, now(), now())
    ON CONFLICT (class_id, period_id) DO NOTHING;

    SELECT id INTO v_cpa_id FROM public.class_period_assignments
    WHERE class_id = v_class_id AND period_id = v_period_id;

    -- NISN 0093113126
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093113126' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083177174
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083177174' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088299667
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088299667' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0099636755
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099636755' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0085700136
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0085700136' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095383586
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095383586' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097451551
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097451551' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096975922
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096975922' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091464866
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091464866' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081479561
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081479561' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098714420
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098714420' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091317479
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091317479' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094014357
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094014357' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091357338
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091357338' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098033018
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098033018' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094623385
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094623385' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094553536
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094553536' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097054255
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097054255' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096669011
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096669011' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083196924
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083196924' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087470024
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087470024' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096696904
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096696904' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095918749
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095918749' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083049231
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083049231' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089224605
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089224605' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091680711
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091680711' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098352610
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098352610' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096824108
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096824108' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087384082
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087384082' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087085579
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087085579' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0085598942
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0085598942' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091008138
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091008138' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0086340312
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0086340312' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098488996
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098488996' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094592131
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094592131' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096627108
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096627108' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
  END IF;

  -- ── Kelas XI-6 (35 siswa) ──
  SELECT id INTO v_class_id FROM public.classes WHERE name = 'XI-6';
  IF v_class_id IS NULL THEN
    RAISE WARNING 'Kelas XI-6 tidak ditemukan, dilewati.';
  ELSE
    -- Buat class_period_assignment jika belum ada
    INSERT INTO public.class_period_assignments (id, class_id, period_id, created_at, updated_at)
    VALUES (gen_random_uuid(), v_class_id, v_period_id, now(), now())
    ON CONFLICT (class_id, period_id) DO NOTHING;

    SELECT id INTO v_cpa_id FROM public.class_period_assignments
    WHERE class_id = v_class_id AND period_id = v_period_id;

    -- NISN 0081186409
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081186409' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0086932588
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0086932588' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0099878708
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099878708' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0099961265
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099961265' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087358290
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087358290' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0082183005
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0082183005' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097926587
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097926587' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0082783372
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0082783372' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0084332997
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0084332997' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088623278
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088623278' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0084050958
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0084050958' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096231111
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096231111' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087910499
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087910499' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 3096360862
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '3096360862' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098806088
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098806088' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087484824
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087484824' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095846898
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095846898' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081353285
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081353285' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0099681137
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099681137' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0084154165
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0084154165' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092882100
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092882100' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087733731
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087733731' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0099566260
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099566260' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089250553
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089250553' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093390563
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093390563' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0085486373
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0085486373' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0086949825
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0086949825' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089384410
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089384410' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 3085831558
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '3085831558' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088718613
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088718613' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0085904568
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0085904568' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0084094873
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0084094873' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081619218
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081619218' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081906630
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081906630' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093309233
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093309233' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
  END IF;

  -- ── Kelas XI-7 (36 siswa) ──
  SELECT id INTO v_class_id FROM public.classes WHERE name = 'XI-7';
  IF v_class_id IS NULL THEN
    RAISE WARNING 'Kelas XI-7 tidak ditemukan, dilewati.';
  ELSE
    -- Buat class_period_assignment jika belum ada
    INSERT INTO public.class_period_assignments (id, class_id, period_id, created_at, updated_at)
    VALUES (gen_random_uuid(), v_class_id, v_period_id, now(), now())
    ON CONFLICT (class_id, period_id) DO NOTHING;

    SELECT id INTO v_cpa_id FROM public.class_period_assignments
    WHERE class_id = v_class_id AND period_id = v_period_id;

    -- NISN 0078679565
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0078679565' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088840375
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088840375' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098763089
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098763089' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0085275159
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0085275159' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095150920
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095150920' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0079792230
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0079792230' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 3086152544
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '3086152544' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089652132
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089652132' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092244478
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092244478' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0082170305
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0082170305' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0085846297
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0085846297' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091299273
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091299273' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095803546
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095803546' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088953741
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088953741' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0086527715
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0086527715' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091710805
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091710805' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0075460992
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0075460992' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093045596
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093045596' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089698113
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089698113' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092801863
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092801863' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091308780
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091308780' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093713254
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093713254' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083951115
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083951115' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081426575
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081426575' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088582784
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088582784' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089733050
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089733050' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0077300922
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0077300922' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0102190790
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0102190790' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0099139467
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099139467' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0076737356
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0076737356' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087887967
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087887967' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095401427
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095401427' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081764532
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081764532' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087150130
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087150130' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083057535
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083057535' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096077767
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096077767' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
  END IF;

  -- ── Kelas XI-8 (37 siswa) ──
  SELECT id INTO v_class_id FROM public.classes WHERE name = 'XI-8';
  IF v_class_id IS NULL THEN
    RAISE WARNING 'Kelas XI-8 tidak ditemukan, dilewati.';
  ELSE
    -- Buat class_period_assignment jika belum ada
    INSERT INTO public.class_period_assignments (id, class_id, period_id, created_at, updated_at)
    VALUES (gen_random_uuid(), v_class_id, v_period_id, now(), now())
    ON CONFLICT (class_id, period_id) DO NOTHING;

    SELECT id INTO v_cpa_id FROM public.class_period_assignments
    WHERE class_id = v_class_id AND period_id = v_period_id;

    -- NISN 0079009586
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0079009586' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091472126
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091472126' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088791278
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088791278' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 3098844606
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '3098844606' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096013145
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096013145' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095863072
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095863072' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089476991
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089476991' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097451916
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097451916' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081073412
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081073412' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087080377
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087080377' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093385349
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093385349' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087836967
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087836967' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093610867
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093610867' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093506466
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093506466' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0086851375
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0086851375' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093573164
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093573164' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083280515
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083280515' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087798887
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087798887' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092475850
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092475850' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081255077
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081255077' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087494331
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087494331' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0099440010
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099440010' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0107605799
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0107605799' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087715936
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087715936' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083189007
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083189007' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096005890
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096005890' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0073781464
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0073781464' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097585814
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097585814' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083566428
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083566428' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0086336864
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0086336864' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083761151
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083761151' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093794534
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093794534' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0078594113
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0078594113' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098666683
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098666683' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096801429
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096801429' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093300779
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093300779' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0099549401
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099549401' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
  END IF;

  -- ── Kelas XI-9 (36 siswa) ──
  SELECT id INTO v_class_id FROM public.classes WHERE name = 'XI-9';
  IF v_class_id IS NULL THEN
    RAISE WARNING 'Kelas XI-9 tidak ditemukan, dilewati.';
  ELSE
    -- Buat class_period_assignment jika belum ada
    INSERT INTO public.class_period_assignments (id, class_id, period_id, created_at, updated_at)
    VALUES (gen_random_uuid(), v_class_id, v_period_id, now(), now())
    ON CONFLICT (class_id, period_id) DO NOTHING;

    SELECT id INTO v_cpa_id FROM public.class_period_assignments
    WHERE class_id = v_class_id AND period_id = v_period_id;

    -- NISN 0099007202
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099007202' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081069514
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081069514' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096503148
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096503148' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0084124676
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0084124676' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098286909
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098286909' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083605206
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083605206' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0099407261
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0099407261' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0086062975
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0086062975' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081642905
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081642905' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083202241
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083202241' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094592651
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094592651' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092153536
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092153536' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097243803
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097243803' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098657251
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098657251' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091949915
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091949915' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097326410
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097326410' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0084647919
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0084647919' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097930344
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097930344' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098557325
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098557325' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095433212
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095433212' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0086286412
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0086286412' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081725195
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081725195' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092968686
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092968686' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093458006
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093458006' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0082078809
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0082078809' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091729412
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091729412' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087370376
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087370376' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088365307
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088365307' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0082804480
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0082804480' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088833446
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088833446' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0086653085
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0086653085' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081295064
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081295064' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096366586
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096366586' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0085072517
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0085072517' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0093598610
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0093598610' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097063142
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097063142' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
  END IF;

  -- ── Kelas XI-10 (36 siswa) ──
  SELECT id INTO v_class_id FROM public.classes WHERE name = 'XI-10';
  IF v_class_id IS NULL THEN
    RAISE WARNING 'Kelas XI-10 tidak ditemukan, dilewati.';
  ELSE
    -- Buat class_period_assignment jika belum ada
    INSERT INTO public.class_period_assignments (id, class_id, period_id, created_at, updated_at)
    VALUES (gen_random_uuid(), v_class_id, v_period_id, now(), now())
    ON CONFLICT (class_id, period_id) DO NOTHING;

    SELECT id INTO v_cpa_id FROM public.class_period_assignments
    WHERE class_id = v_class_id AND period_id = v_period_id;

    -- NISN 0088468705
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088468705' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0084362721
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0084362721' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089374484
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089374484' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089370910
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089370910' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087459845
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087459845' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0084247091
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0084247091' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 3098048730
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '3098048730' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 3098048730
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '3098048730' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0086930027
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0086930027' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098126640
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098126640' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0094458582
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0094458582' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089273796
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089273796' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098617909
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098617909' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087406621
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087406621' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081757505
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081757505' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0088194704
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0088194704' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0083458341
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0083458341' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081739092
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081739092' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0081607959
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0081607959' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089548215
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089548215' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0095095375
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0095095375' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087141409
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087141409' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0091238541
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0091238541' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0096169234
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0096169234' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0089690282
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0089690282' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0085251664
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0085251664' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 3096257488
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '3096257488' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0082613544
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0082613544' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0085259009
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0085259009' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098034055
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098034055' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0087150577
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0087150577' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097911684
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097911684' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0086191320
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0086191320' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0092605743
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0092605743' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0098625717
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0098625717' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
    -- NISN 0097858366
    SELECT id INTO v_student_id FROM public.profiles WHERE nisn = '0097858366' AND role = 'student';
    IF v_student_id IS NOT NULL THEN
      INSERT INTO public.student_class_enrollments
        (id, student_id, class_period_assignment_id, initial_score, status, created_at, updated_at)
      VALUES
        (gen_random_uuid(), v_student_id, v_cpa_id, 75, 'active', now(), now())
      ON CONFLICT (student_id, class_period_assignment_id) DO NOTHING;
    END IF;
  END IF;

  RAISE NOTICE 'Enroll selesai.';
END $$;

-- ============================================================
-- Verifikasi per kelas:
-- SELECT c.name, COUNT(sce.id) as total_siswa
-- FROM public.classes c
-- JOIN public.class_period_assignments cpa ON c.id = cpa.class_id
-- JOIN public.student_class_enrollments sce ON cpa.id = sce.class_period_assignment_id
-- GROUP BY c.name ORDER BY c.name;
-- ============================================================