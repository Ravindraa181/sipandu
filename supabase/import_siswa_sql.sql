-- ============================================================
-- IMPORT SISWA KELAS X (6-10) dan XI (1-10)
-- SiPandu - SMAN 13 Bandung
-- Total: 546 siswa | Password awal: SiPandu123!
-- FIX: skip jika email ATAU nisn sudah ada
-- ============================================================

-- LANGKAH 1: Cek kelas yang sudah ada
-- SELECT name FROM public.classes ORDER BY name;

-- LANGKAH 2: Insert kelas jika belum ada
INSERT INTO public.classes (id, name, grade_level, created_at, updated_at) VALUES
  (gen_random_uuid(), 'X-6', 'X', now(), now()),
  (gen_random_uuid(), 'X-7', 'X', now(), now()),
  (gen_random_uuid(), 'X-8', 'X', now(), now()),
  (gen_random_uuid(), 'X-9', 'X', now(), now()),
  (gen_random_uuid(), 'X-10', 'X', now(), now()),
  (gen_random_uuid(), 'XI-1', 'XI', now(), now()),
  (gen_random_uuid(), 'XI-2', 'XI', now(), now()),
  (gen_random_uuid(), 'XI-3', 'XI', now(), now()),
  (gen_random_uuid(), 'XI-4', 'XI', now(), now()),
  (gen_random_uuid(), 'XI-5', 'XI', now(), now()),
  (gen_random_uuid(), 'XI-6', 'XI', now(), now()),
  (gen_random_uuid(), 'XI-7', 'XI', now(), now()),
  (gen_random_uuid(), 'XI-8', 'XI', now(), now()),
  (gen_random_uuid(), 'XI-9', 'XI', now(), now()),
  (gen_random_uuid(), 'XI-10', 'XI', now(), now())
ON CONFLICT (name) DO NOTHING;

-- LANGKAH 3: Insert auth users + profiles (skip jika email atau nisn sudah ada)

DO $$
DECLARE
  v_uid UUID;
BEGIN
  -- Aatifah Tsabita Zuhroh Sutarya (0095604838) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aatifahtsabita@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095604838') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aatifahtsabita@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aatifahtsabita@sman13bdg.sch.id', 'Aatifah Tsabita Zuhroh Sutarya', '0095604838', 'P', true, now(), now());
  END IF;

  -- Abdi Muhammad Saleh (3092316727) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'itzabdiajlah@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '3092316727') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'itzabdiajlah@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'itzabdiajlah@sman13bdg.sch.id', 'Abdi Muhammad Saleh', '3092316727', 'L', true, now(), now());
  END IF;

  -- Anabella Raina Rahayu (0093768354) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'anabellaraina882@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093768354') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'anabellaraina882@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'anabellaraina882@sman13bdg.sch.id', 'Anabella Raina Rahayu', '0093768354', 'P', true, now(), now());
  END IF;

  -- Aninda Sekar Auranty (0082831378) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'anindasekay25@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0082831378') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'anindasekay25@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'anindasekay25@sman13bdg.sch.id', 'Aninda Sekar Auranty', '0082831378', 'P', true, now(), now());
  END IF;

  -- Anisha Meilani Putri (0104785424) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'anishasaa7@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0104785424') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'anishasaa7@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'anishasaa7@sman13bdg.sch.id', 'Anisha Meilani Putri', '0104785424', 'P', true, now(), now());
  END IF;

  -- Annatasya (0102219828) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'annatasya.ssya@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0102219828') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'annatasya.ssya@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'annatasya.ssya@sman13bdg.sch.id', 'Annatasya', '0102219828', 'P', true, now(), now());
  END IF;

  -- Aurelia Bunga Azzahra (0098490905) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aureliabungaazzahra@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098490905') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aureliabungaazzahra@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aureliabungaazzahra@sman13bdg.sch.id', 'Aurelia Bunga Azzahra', '0098490905', 'P', true, now(), now());
  END IF;

  -- Bhunga Ardiani Budianto (0092208878) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'bhunga.ardiani2309@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092208878') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'bhunga.ardiani2309@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'bhunga.ardiani2309@sman13bdg.sch.id', 'Bhunga Ardiani Budianto', '0092208878', 'P', true, now(), now());
  END IF;

  -- Bintang Nuralam (0102282661) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'bintangnuralam723@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0102282661') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'bintangnuralam723@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'bintangnuralam723@sman13bdg.sch.id', 'Bintang Nuralam', '0102282661', 'L', true, now(), now());
  END IF;

  -- Candy Puspa Wangun (0105246639) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'candypuspawangun@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0105246639') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'candypuspawangun@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'candypuspawangun@sman13bdg.sch.id', 'Candy Puspa Wangun', '0105246639', 'P', true, now(), now());
  END IF;

  -- Cika Rianti (0109203574) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'cikarianty3@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0109203574') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'cikarianty3@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'cikarianty3@sman13bdg.sch.id', 'Cika Rianti', '0109203574', 'P', true, now(), now());
  END IF;

  -- Defrissa Nazurul Pasha (0098050618) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'defrissafasha@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098050618') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'defrissafasha@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'defrissafasha@sman13bdg.sch.id', 'Defrissa Nazurul Pasha', '0098050618', 'P', true, now(), now());
  END IF;

  -- Desi Asmara (0081426498) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'desiasmara308@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081426498') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'desiasmara308@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'desiasmara308@sman13bdg.sch.id', 'Desi Asmara', '0081426498', 'P', true, now(), now());
  END IF;

  -- Elpan Aditya (0103733132) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'elpanaditya6@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0103733132') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'elpanaditya6@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'elpanaditya6@sman13bdg.sch.id', 'Elpan Aditya', '0103733132', 'L', true, now(), now());
  END IF;

  -- Fachri N. M. Ibrahim Yunan (0107135466) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'fay051611@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0107135466') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'fay051611@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'fay051611@sman13bdg.sch.id', 'Fachri N. M. Ibrahim Yunan', '0107135466', 'L', true, now(), now());
  END IF;

  -- Handayani Putri (0109394649) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'handayaniputri2ndn@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0109394649') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'handayaniputri2ndn@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'handayaniputri2ndn@sman13bdg.sch.id', 'Handayani Putri', '0109394649', 'P', true, now(), now());
  END IF;

  -- Ibnu Fauzan (0071150194) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ombadut.yt@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0071150194') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ombadut.yt@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ombadut.yt@sman13bdg.sch.id', 'Ibnu Fauzan', '0071150194', 'L', true, now(), now());
  END IF;

  -- Idhar Pratama (0096500319) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'idarderdor22@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096500319') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'idarderdor22@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'idarderdor22@sman13bdg.sch.id', 'Idhar Pratama', '0096500319', 'L', true, now(), now());
  END IF;

  -- Idris Maulana (0074487210) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'idrisidris81551@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0074487210') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'idrisidris81551@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'idrisidris81551@sman13bdg.sch.id', 'Idris Maulana', '0074487210', 'L', true, now(), now());
  END IF;

  -- Illah Nurfadillah (0106947287) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'illahnur@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0106947287') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'illahnur@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'illahnur@sman13bdg.sch.id', 'Illah Nurfadillah', '0106947287', 'P', true, now(), now());
  END IF;

  -- Khalysta Alviena Savaly (0094498606) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'alvienakhalys@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094498606') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'alvienakhalys@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'alvienakhalys@sman13bdg.sch.id', 'Khalysta Alviena Savaly', '0094498606', 'P', true, now(), now());
  END IF;

  -- Khumaira Khosyi Ayuri (0095594049) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'khumairaayuri14@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095594049') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'khumairaayuri14@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'khumairaayuri14@sman13bdg.sch.id', 'Khumaira Khosyi Ayuri', '0095594049', 'P', true, now(), now());
  END IF;

  -- Marcha Loka Aliyu (0096412687) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'marchaloka@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096412687') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'marchaloka@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'marchaloka@sman13bdg.sch.id', 'Marcha Loka Aliyu', '0096412687', 'P', true, now(), now());
  END IF;

  -- Michelle Setyaningtias (0107461443) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'michellesetyaningtias@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0107461443') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'michellesetyaningtias@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'michellesetyaningtias@sman13bdg.sch.id', 'Michelle Setyaningtias', '0107461443', 'P', true, now(), now());
  END IF;

  -- Mochammad Rafi Adicandra (0095450176) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'apiww05@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095450176') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'apiww05@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'apiww05@sman13bdg.sch.id', 'Mochammad Rafi Adicandra', '0095450176', 'L', true, now(), now());
  END IF;

  -- Muhammad Adhya Azhna Wiharja (0103428856) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'adhyawiharja@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0103428856') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'adhyawiharja@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'adhyawiharja@sman13bdg.sch.id', 'Muhammad Adhya Azhna Wiharja', '0103428856', 'L', true, now(), now());
  END IF;

  -- Muhammad Daanish Satriamas Nurcahyo (0097305509) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'mdaanish587@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097305509') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'mdaanish587@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'mdaanish587@sman13bdg.sch.id', 'Muhammad Daanish Satriamas Nurcahyo', '0097305509', 'L', true, now(), now());
  END IF;

  -- Muhammad Dzaki Prasetyo (0089837636) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'dzakiwel0@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089837636') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'dzakiwel0@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'dzakiwel0@sman13bdg.sch.id', 'Muhammad Dzaki Prasetyo', '0089837636', 'L', true, now(), now());
  END IF;

  -- Muhammad Rafli Ardiansyah (0102622876) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rafliarsyh04@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0102622876') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rafliarsyh04@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rafliarsyh04@sman13bdg.sch.id', 'Muhammad Rafli Ardiansyah', '0102622876', 'L', true, now(), now());
  END IF;

  -- Muhammad Reiza Al Hafi (0096034527) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'reizaalhafi31@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096034527') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'reizaalhafi31@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'reizaalhafi31@sman13bdg.sch.id', 'Muhammad Reiza Al Hafi', '0096034527', 'L', true, now(), now());
  END IF;

  -- Nabila Ramadhani (0087486130) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'lalapooh184@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087486130') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'lalapooh184@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'lalapooh184@sman13bdg.sch.id', 'Nabila Ramadhani', '0087486130', 'P', true, now(), now());
  END IF;

  -- Queena Lattifa Elviana (0093111936) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'queena.elviana22@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093111936') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'queena.elviana22@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'queena.elviana22@sman13bdg.sch.id', 'Queena Lattifa Elviana', '0093111936', 'P', true, now(), now());
  END IF;

  -- Rahma Rizqia Hilman (0095414630) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'raidrustandi@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095414630') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'raidrustandi@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'raidrustandi@sman13bdg.sch.id', 'Rahma Rizqia Hilman', '0095414630', 'P', true, now(), now());
  END IF;

  -- Reyna Chia Cahyadhika (0109580059) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'reynachiacahyadhika@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0109580059') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'reynachiacahyadhika@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'reynachiacahyadhika@sman13bdg.sch.id', 'Reyna Chia Cahyadhika', '0109580059', 'P', true, now(), now());
  END IF;

  -- Reza Dian Pratama (0092637850) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rezadwi996@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092637850') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rezadwi996@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rezadwi996@sman13bdg.sch.id', 'Reza Dian Pratama', '0092637850', 'L', true, now(), now());
  END IF;

  -- Selin Ardilla (0081043957) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ardillaselin@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081043957') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ardillaselin@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ardillaselin@sman13bdg.sch.id', 'Selin Ardilla', '0081043957', 'P', true, now(), now());
  END IF;

  -- Surya Tanaka Sianturi (0107018021) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'suryatanaka75@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0107018021') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'suryatanaka75@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'suryatanaka75@sman13bdg.sch.id', 'Surya Tanaka Sianturi', '0107018021', 'L', true, now(), now());
  END IF;

  -- Tirani Irawan (0094072893) [X-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'tiraniirawan07@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094072893') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'tiraniirawan07@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'tiraniirawan07@sman13bdg.sch.id', 'Tirani Irawan', '0094072893', 'P', true, now(), now());
  END IF;

  -- Adelia Herdines (0107342384) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'adelia11012010@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0107342384') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'adelia11012010@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'adelia11012010@sman13bdg.sch.id', 'Adelia Herdines', '0107342384', 'P', true, now(), now());
  END IF;

  -- Adriene Adelia (0104353946) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'adeliaadriene@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0104353946') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'adeliaadriene@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'adeliaadriene@sman13bdg.sch.id', 'Adriene Adelia', '0104353946', 'P', true, now(), now());
  END IF;

  -- Amelia Rozatun Aisyah (0107508754) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ameliarozatun0@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0107508754') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ameliarozatun0@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ameliarozatun0@sman13bdg.sch.id', 'Amelia Rozatun Aisyah', '0107508754', 'P', true, now(), now());
  END IF;

  -- Ayu Sri Lestari (0107879456) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ayustari10@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0107879456') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ayustari10@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ayustari10@sman13bdg.sch.id', 'Ayu Sri Lestari', '0107879456', 'P', true, now(), now());
  END IF;

  -- Bangkit Syahrul Hermansyah (0101416691) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'bangkitsyahrulsh@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0101416691') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'bangkitsyahrulsh@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'bangkitsyahrulsh@sman13bdg.sch.id', 'Bangkit Syahrul Hermansyah', '0101416691', 'L', true, now(), now());
  END IF;

  -- Cindy Almira (0105830077) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'almiracindy81@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0105830077') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'almiracindy81@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'almiracindy81@sman13bdg.sch.id', 'Cindy Almira', '0105830077', 'P', true, now(), now());
  END IF;

  -- Cintiani Malika (0099034730) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'emasitirohmah80@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099034730') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'emasitirohmah80@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'emasitirohmah80@sman13bdg.sch.id', 'Cintiani Malika', '0099034730', 'P', true, now(), now());
  END IF;

  -- Deden Mulyana (0091797532) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'villaintoku@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091797532') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'villaintoku@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'villaintoku@sman13bdg.sch.id', 'Deden Mulyana', '0091797532', 'L', true, now(), now());
  END IF;

  -- Elvia Nurul Husna (0104900137) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'elvianurul98@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0104900137') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'elvianurul98@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'elvianurul98@sman13bdg.sch.id', 'Elvia Nurul Husna', '0104900137', 'P', true, now(), now());
  END IF;

  -- Esya Alfina Hadian (0095243902) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'esyahadian@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095243902') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'esyahadian@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'esyahadian@sman13bdg.sch.id', 'Esya Alfina Hadian', '0095243902', 'P', true, now(), now());
  END IF;

  -- Gema Muhamad Maulana Asyari (3105561311) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'tkun664@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '3105561311') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'tkun664@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'tkun664@sman13bdg.sch.id', 'Gema Muhamad Maulana Asyari', '3105561311', 'L', true, now(), now());
  END IF;

  -- Isabella Avriliyani Pratami (0091441601) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'isabellaavriliyani@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091441601') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'isabellaavriliyani@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'isabellaavriliyani@sman13bdg.sch.id', 'Isabella Avriliyani Pratami', '0091441601', 'P', true, now(), now());
  END IF;

  -- Kania Putri Sulastri (0093412518) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'kaniasulastri17@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093412518') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'kaniasulastri17@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'kaniasulastri17@sman13bdg.sch.id', 'Kania Putri Sulastri', '0093412518', 'P', true, now(), now());
  END IF;

  -- Larasati Dewi Setyorini (0094984856) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'larasdewisetyorini@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094984856') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'larasdewisetyorini@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'larasdewisetyorini@sman13bdg.sch.id', 'Larasati Dewi Setyorini', '0094984856', 'P', true, now(), now());
  END IF;

  -- Malikha Naora Savana (0107734460) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'naoramalikha@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0107734460') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'naoramalikha@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'naoramalikha@sman13bdg.sch.id', 'Malikha Naora Savana', '0107734460', 'P', true, now(), now());
  END IF;

  -- Marshal Abdurrohman Fauzi (0095471649) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'marshalfauzi54@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095471649') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'marshalfauzi54@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'marshalfauzi54@sman13bdg.sch.id', 'Marshal Abdurrohman Fauzi', '0095471649', 'L', true, now(), now());
  END IF;

  -- Mohammad Arya (0105500052) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'vivobdg62@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0105500052') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'vivobdg62@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'vivobdg62@sman13bdg.sch.id', 'Mohammad Arya', '0105500052', 'L', true, now(), now());
  END IF;

  -- Muhamad Rafif Prayata (0094109928) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rafifprayata42@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094109928') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rafifprayata42@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rafifprayata42@sman13bdg.sch.id', 'Muhamad Rafif Prayata', '0094109928', 'L', true, now(), now());
  END IF;

  -- Muhammad Ghazanfar La''ogi (0093104616) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ghazanfarlaogi@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093104616') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ghazanfarlaogi@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ghazanfarlaogi@sman13bdg.sch.id', 'Muhammad Ghazanfar La''ogi', '0093104616', 'L', true, now(), now());
  END IF;

  -- Muhammad Nazril Ilham (0107605799) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nazuuuid893@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0107605799') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nazuuuid893@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nazuuuid893@sman13bdg.sch.id', 'Muhammad Nazril Ilham', '0107605799', 'L', true, now(), now());
  END IF;

  -- Muhammad Nazril Ilham (0087715936) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nazuuuid893@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087715936') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nazuuuid893@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nazuuuid893@sman13bdg.sch.id', 'Muhammad Nazril Ilham', '0087715936', 'L', true, now(), now());
  END IF;

  -- Muhammad Yusuf Asy Syaamil (0096183682) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'myusufasyamil@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096183682') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'myusufasyamil@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'myusufasyamil@sman13bdg.sch.id', 'Muhammad Yusuf Asy Syaamil', '0096183682', 'L', true, now(), now());
  END IF;

  -- Nabila Nafisah Budiman (0091862168) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'kusumawatiai09@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091862168') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'kusumawatiai09@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'kusumawatiai09@sman13bdg.sch.id', 'Nabila Nafisah Budiman', '0091862168', 'P', true, now(), now());
  END IF;

  -- Nadia Balqies Batrisyia (0092886161) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nadiabalqies@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092886161') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nadiabalqies@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nadiabalqies@sman13bdg.sch.id', 'Nadia Balqies Batrisyia', '0092886161', 'P', true, now(), now());
  END IF;

  -- Nadiva Khansa Kamela (0097438074) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nadivakhansa01@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097438074') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nadivakhansa01@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nadivakhansa01@sman13bdg.sch.id', 'Nadiva Khansa Kamela', '0097438074', 'P', true, now(), now());
  END IF;

  -- Naila Ramadhani (0106098648) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'kenzhinayla3636@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0106098648') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'kenzhinayla3636@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'kenzhinayla3636@sman13bdg.sch.id', 'Naila Ramadhani', '0106098648', 'P', true, now(), now());
  END IF;

  -- Najwa Carissa Angga Perbata (0108315381) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'carissanap4@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0108315381') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'carissanap4@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'carissanap4@sman13bdg.sch.id', 'Najwa Carissa Angga Perbata', '0108315381', 'P', true, now(), now());
  END IF;

  -- Nayzarin Jusieyra Maulidya (0103427060) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nayzarin19@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0103427060') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nayzarin19@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nayzarin19@sman13bdg.sch.id', 'Nayzarin Jusieyra Maulidya', '0103427060', 'P', true, now(), now());
  END IF;

  -- Rachman (3100249836) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'fadlirachman592@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '3100249836') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'fadlirachman592@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'fadlirachman592@sman13bdg.sch.id', 'Rachman', '3100249836', 'L', true, now(), now());
  END IF;

  -- Raisya Ayunindya Putri (0096311667) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'raisyaayunindya0809@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096311667') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'raisyaayunindya0809@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'raisyaayunindya0809@sman13bdg.sch.id', 'Raisya Ayunindya Putri', '0096311667', 'P', true, now(), now());
  END IF;

  -- Rizki Maulana (0107746241) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'maulanarizky3331100@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0107746241') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'maulanarizky3331100@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'maulanarizky3331100@sman13bdg.sch.id', 'Rizki Maulana', '0107746241', 'L', true, now(), now());
  END IF;

  -- Septiani (0091861104) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'stia13950@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091861104') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'stia13950@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'stia13950@sman13bdg.sch.id', 'Septiani', '0091861104', 'P', true, now(), now());
  END IF;

  -- Sheila Nur Meilani Putri (0104781395) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nilaherawati402@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0104781395') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nilaherawati402@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nilaherawati402@sman13bdg.sch.id', 'Sheila Nur Meilani Putri', '0104781395', 'P', true, now(), now());
  END IF;

  -- Sindy Septiani (0096345742) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'sisindyseptiaa@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096345742') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'sisindyseptiaa@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'sisindyseptiaa@sman13bdg.sch.id', 'Sindy Septiani', '0096345742', 'P', true, now(), now());
  END IF;

  -- Windie Maulida Rohimah (0105984687) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'windiemaulida@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0105984687') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'windiemaulida@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'windiemaulida@sman13bdg.sch.id', 'Windie Maulida Rohimah', '0105984687', 'P', true, now(), now());
  END IF;

  -- Yoga Zudistian (0095793403) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'oggacom4@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095793403') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'oggacom4@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'oggacom4@sman13bdg.sch.id', 'Yoga Zudistian', '0095793403', 'L', true, now(), now());
  END IF;

  -- Zasqia Oudri Divani (0095466195) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'audreyaudreydivani076@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095466195') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'audreyaudreydivani076@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'audreyaudreydivani076@sman13bdg.sch.id', 'Zasqia Oudri Divani', '0095466195', 'P', true, now(), now());
  END IF;

  -- Zidan Lutfhi Sanusi (0098054349) [X-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'zidanlutfhi88@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098054349') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'zidanlutfhi88@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'zidanlutfhi88@sman13bdg.sch.id', 'Zidan Lutfhi Sanusi', '0098054349', 'L', true, now(), now());
  END IF;

  -- Aditya Pratama (0096195462) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'bayupurwanto110@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096195462') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'bayupurwanto110@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'bayupurwanto110@sman13bdg.sch.id', 'Aditya Pratama', '0096195462', 'L', true, now(), now());
  END IF;

  -- Afifah Qanita Zain (0107377371) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'inasarie2@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0107377371') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'inasarie2@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'inasarie2@sman13bdg.sch.id', 'Afifah Qanita Zain', '0107377371', 'L', true, now(), now());
  END IF;

  -- Al Fathir Abdi Negara Sutrianto (0097729040) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'alfathirabdinegaras@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097729040') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'alfathirabdinegaras@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'alfathirabdinegaras@sman13bdg.sch.id', 'Al Fathir Abdi Negara Sutrianto', '0097729040', 'L', true, now(), now());
  END IF;

  -- Arby Ibnu Hasan (0095362397) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'arbyibnuh@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095362397') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'arbyibnuh@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'arbyibnuh@sman13bdg.sch.id', 'Arby Ibnu Hasan', '0095362397', 'L', true, now(), now());
  END IF;

  -- Citra Lestari (0087674596) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'citralestari1630@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087674596') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'citralestari1630@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'citralestari1630@sman13bdg.sch.id', 'Citra Lestari', '0087674596', 'P', true, now(), now());
  END IF;

  -- Elsa Aida (0092822640) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'elsaaida1111@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092822640') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'elsaaida1111@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'elsaaida1111@sman13bdg.sch.id', 'Elsa Aida', '0092822640', 'P', true, now(), now());
  END IF;

  -- Freya Ghoitsa Arsyilia (0108697945) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'arsyliafreya5@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0108697945') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'arsyliafreya5@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'arsyliafreya5@sman13bdg.sch.id', 'Freya Ghoitsa Arsyilia', '0108697945', 'P', true, now(), now());
  END IF;

  -- Humam Athifudzakwan Nurjamil (0105076009) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'humamnurjamil2@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0105076009') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'humamnurjamil2@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'humamnurjamil2@sman13bdg.sch.id', 'Humam Athifudzakwan Nurjamil', '0105076009', 'L', true, now(), now());
  END IF;

  -- Irma Rohaeni (0096567415) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'antonaripin62@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096567415') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'antonaripin62@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'antonaripin62@sman13bdg.sch.id', 'Irma Rohaeni', '0096567415', 'P', true, now(), now());
  END IF;

  -- Jesica Imel Oktaputri (0091662024) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'imelllljsc@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091662024') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'imelllljsc@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'imelllljsc@sman13bdg.sch.id', 'Jesica Imel Oktaputri', '0091662024', 'P', true, now(), now());
  END IF;

  -- Juwita Delfi Maulani (0106213839) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'juwitadelfi252@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0106213839') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'juwitadelfi252@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'juwitadelfi252@sman13bdg.sch.id', 'Juwita Delfi Maulani', '0106213839', 'P', true, now(), now());
  END IF;

  -- Keyla Putri Salsabila (0095784306) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'putrikyla160@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095784306') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'putrikyla160@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'putrikyla160@sman13bdg.sch.id', 'Keyla Putri Salsabila', '0095784306', 'P', true, now(), now());
  END IF;

  -- Keysa Putri Nabila (0108228227) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'keysaputrinabila55@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0108228227') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'keysaputrinabila55@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'keysaputrinabila55@sman13bdg.sch.id', 'Keysa Putri Nabila', '0108228227', 'P', true, now(), now());
  END IF;

  -- Kiki Kirani Nanda (0094960250) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'kikikirani80@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094960250') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'kikikirani80@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'kikikirani80@sman13bdg.sch.id', 'Kiki Kirani Nanda', '0094960250', 'P', true, now(), now());
  END IF;

  -- Linda Agustina (0091989335) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'lindaagustin855@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091989335') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'lindaagustin855@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'lindaagustin855@sman13bdg.sch.id', 'Linda Agustina', '0091989335', 'P', true, now(), now());
  END IF;

  -- Livia Putri Kirani (0108727752) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'makacin1000@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0108727752') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'makacin1000@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'makacin1000@sman13bdg.sch.id', 'Livia Putri Kirani', '0108727752', 'P', true, now(), now());
  END IF;

  -- Muhammad Fairuz Dwi Kurniawan (0099348350) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'muhammadfairuz538@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099348350') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'muhammadfairuz538@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'muhammadfairuz538@sman13bdg.sch.id', 'Muhammad Fairuz Dwi Kurniawan', '0099348350', 'L', true, now(), now());
  END IF;

  -- Mulyandra Putra Kusmawan (0097838322) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'mulyandrakusmwan@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097838322') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'mulyandrakusmwan@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'mulyandrakusmwan@sman13bdg.sch.id', 'Mulyandra Putra Kusmawan', '0097838322', 'L', true, now(), now());
  END IF;

  -- Nabila Khairunisa (0096762939) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nabilaagniap@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096762939') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nabilaagniap@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nabilaagniap@sman13bdg.sch.id', 'Nabila Khairunisa', '0096762939', 'P', true, now(), now());
  END IF;

  -- Nadya Farida Tunnisa (0095204935) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'wantinenti@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095204935') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'wantinenti@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'wantinenti@sman13bdg.sch.id', 'Nadya Farida Tunnisa', '0095204935', 'P', true, now(), now());
  END IF;

  -- Niomi Khoirunnisa Athaya Safitri (0094328461) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'athayaniomi@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094328461') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'athayaniomi@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'athayaniomi@sman13bdg.sch.id', 'Niomi Khoirunnisa Athaya Safitri', '0094328461', 'P', true, now(), now());
  END IF;

  -- Nisrina Kirei Fitriyani (0108992042) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nisrinakirei@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0108992042') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nisrinakirei@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nisrinakirei@sman13bdg.sch.id', 'Nisrina Kirei Fitriyani', '0108992042', 'P', true, now(), now());
  END IF;

  -- Putri Rizkia Wulandari (0095866149) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'pwulandari@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095866149') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'pwulandari@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'pwulandari@sman13bdg.sch.id', 'Putri Rizkia Wulandari', '0095866149', 'P', true, now(), now());
  END IF;

  -- Raffy Rizky Firdaus (0091330181) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'raffyjtc@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091330181') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'raffyjtc@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'raffyjtc@sman13bdg.sch.id', 'Raffy Rizky Firdaus', '0091330181', 'L', true, now(), now());
  END IF;

  -- Raiva Putri Nurshaliha (0109041768) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'raivaputrinurshaliha@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0109041768') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'raivaputrinurshaliha@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'raivaputrinurshaliha@sman13bdg.sch.id', 'Raiva Putri Nurshaliha', '0109041768', 'P', true, now(), now());
  END IF;

  -- Raken Maulana (0108252299) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'maulanaraken@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0108252299') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'maulanaraken@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'maulanaraken@sman13bdg.sch.id', 'Raken Maulana', '0108252299', 'L', true, now(), now());
  END IF;

  -- Rianita Sitohang (0098994143) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rianitasitohang10@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098994143') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rianitasitohang10@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rianitasitohang10@sman13bdg.sch.id', 'Rianita Sitohang', '0098994143', 'P', true, now(), now());
  END IF;

  -- Ricky Triantoro (0096457879) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rickytriantoro02@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096457879') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rickytriantoro02@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rickytriantoro02@sman13bdg.sch.id', 'Ricky Triantoro', '0096457879', 'L', true, now(), now());
  END IF;

  -- Safina Aulia Andhita (0101023182) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'bayuandh05@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0101023182') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'bayuandh05@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'bayuandh05@sman13bdg.sch.id', 'Safina Aulia Andhita', '0101023182', 'P', true, now(), now());
  END IF;

  -- Sarifatul Syifa Fauziah (0093554154) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'sarifatulsyifafauziah@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093554154') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'sarifatulsyifafauziah@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'sarifatulsyifafauziah@sman13bdg.sch.id', 'Sarifatul Syifa Fauziah', '0093554154', 'P', true, now(), now());
  END IF;

  -- Shelomita Indira Putri (0108931373) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'zerobase2708@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0108931373') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'zerobase2708@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'zerobase2708@sman13bdg.sch.id', 'Shelomita Indira Putri', '0108931373', 'P', true, now(), now());
  END IF;

  -- Shifa Nuraeni (0091511337) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'shifanuraeni62@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091511337') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'shifanuraeni62@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'shifanuraeni62@sman13bdg.sch.id', 'Shifa Nuraeni', '0091511337', 'P', true, now(), now());
  END IF;

  -- Sulis Susilawati (0092074545) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'sulissusilawati191@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092074545') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'sulissusilawati191@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'sulissusilawati191@sman13bdg.sch.id', 'Sulis Susilawati', '0092074545', 'P', true, now(), now());
  END IF;

  -- Surya Dewi Permana (3090553801) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'suryadewipermana@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '3090553801') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'suryadewipermana@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'suryadewipermana@sman13bdg.sch.id', 'Surya Dewi Permana', '3090553801', 'L', true, now(), now());
  END IF;

  -- Syatria Nur Pratama (0101962357) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'syatrianurpratama@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0101962357') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'syatrianurpratama@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'syatrianurpratama@sman13bdg.sch.id', 'Syatria Nur Pratama', '0101962357', 'L', true, now(), now());
  END IF;

  -- Vinna Anis Alfiani (0107068635) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'vinaan32@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0107068635') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'vinaan32@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'vinaan32@sman13bdg.sch.id', 'Vinna Anis Alfiani', '0107068635', 'P', true, now(), now());
  END IF;

  -- Zaskia Nur Alviah (0092829290) [X-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'zskianuralviah@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092829290') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'zskianuralviah@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'zskianuralviah@sman13bdg.sch.id', 'Zaskia Nur Alviah', '0092829290', 'P', true, now(), now());
  END IF;

  -- Anandava Putra Pamungkas (0096291379) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'anandavaputra@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096291379') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'anandavaputra@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'anandavaputra@sman13bdg.sch.id', 'Anandava Putra Pamungkas', '0096291379', 'L', true, now(), now());
  END IF;

  -- Arliansyah Al''aziz (0093934354) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'arlyliy204@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093934354') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'arlyliy204@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'arlyliy204@sman13bdg.sch.id', 'Arliansyah Al''aziz', '0093934354', 'L', true, now(), now());
  END IF;

  -- Azhar Dzovaruloh (0161668911) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'azhar46dz@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0161668911') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'azhar46dz@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'azhar46dz@sman13bdg.sch.id', 'Azhar Dzovaruloh', '0161668911', 'L', true, now(), now());
  END IF;

  -- Azkha Putra (0106784033) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'azkhaputraa2@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0106784033') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'azkhaputraa2@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'azkhaputraa2@sman13bdg.sch.id', 'Azkha Putra', '0106784033', 'L', true, now(), now());
  END IF;

  -- Balqis Adzra Zakiyya (0095157862) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'balqisadzra234@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095157862') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'balqisadzra234@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'balqisadzra234@sman13bdg.sch.id', 'Balqis Adzra Zakiyya', '0095157862', 'P', true, now(), now());
  END IF;

  -- Dinda Kienaya (0092200006) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'dkienayadinda23@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092200006') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'dkienayadinda23@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'dkienayadinda23@sman13bdg.sch.id', 'Dinda Kienaya', '0092200006', 'P', true, now(), now());
  END IF;

  -- Erika Dwi Pratiwi (0104635846) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'erikadwipratiwi59@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0104635846') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'erikadwipratiwi59@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'erikadwipratiwi59@sman13bdg.sch.id', 'Erika Dwi Pratiwi', '0104635846', 'P', true, now(), now());
  END IF;

  -- Falhi Zenil Alam (0095079812) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'falam@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095079812') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'falam@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'falam@sman13bdg.sch.id', 'Falhi Zenil Alam', '0095079812', 'L', true, now(), now());
  END IF;

  -- Farras Muhammad Iqbal (0108938832) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'farrasmuhamadiqbal20@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0108938832') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'farrasmuhamadiqbal20@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'farrasmuhamadiqbal20@sman13bdg.sch.id', 'Farras Muhammad Iqbal', '0108938832', 'L', true, now(), now());
  END IF;

  -- Fathya Queennisa Azzahra Mutiara Hati (0103312549) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'qzahra1202@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0103312549') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'qzahra1202@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'qzahra1202@sman13bdg.sch.id', 'Fathya Queennisa Azzahra Mutiara Hati', '0103312549', 'P', true, now(), now());
  END IF;

  -- Ghiyats Abdul Malik (0097501581) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'malikghiyats@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097501581') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'malikghiyats@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'malikghiyats@sman13bdg.sch.id', 'Ghiyats Abdul Malik', '0097501581', 'L', true, now(), now());
  END IF;

  -- Hilal Alfian Maulana (0096639515) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'hilalalfian58@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096639515') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'hilalalfian58@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'hilalalfian58@sman13bdg.sch.id', 'Hilal Alfian Maulana', '0096639515', 'L', true, now(), now());
  END IF;

  -- Indah Ayu Rahmadhani (0101383600) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ayurahmadhaniindah@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0101383600') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ayurahmadhaniindah@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ayurahmadhaniindah@sman13bdg.sch.id', 'Indah Ayu Rahmadhani', '0101383600', 'P', true, now(), now());
  END IF;

  -- Keira Alya Suryaputri (0108571974) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'keiraalyasp@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0108571974') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'keiraalyasp@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'keiraalyasp@sman13bdg.sch.id', 'Keira Alya Suryaputri', '0108571974', 'P', true, now(), now());
  END IF;

  -- Martalia (3086040492) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'destykizz111@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '3086040492') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'destykizz111@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'destykizz111@sman13bdg.sch.id', 'Martalia', '3086040492', 'P', true, now(), now());
  END IF;

  -- Maulida Khoirunisa (0098552776) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'mkhoirunisa452@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098552776') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'mkhoirunisa452@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'mkhoirunisa452@sman13bdg.sch.id', 'Maulida Khoirunisa', '0098552776', 'P', true, now(), now());
  END IF;

  -- Maylani Masya Dwirani (0094532712) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'hollanana03@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094532712') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'hollanana03@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'hollanana03@sman13bdg.sch.id', 'Maylani Masya Dwirani', '0094532712', 'P', true, now(), now());
  END IF;

  -- Muhamad Nugraha Ramdhani (0095167542) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'muhamadramdhani499@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095167542') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'muhamadramdhani499@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'muhamadramdhani499@sman13bdg.sch.id', 'Muhamad Nugraha Ramdhani', '0095167542', 'L', true, now(), now());
  END IF;

  -- Muhamad Ribakh Nahrudin (0107601232) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'paluper6@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0107601232') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'paluper6@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'paluper6@sman13bdg.sch.id', 'Muhamad Ribakh Nahrudin', '0107601232', 'L', true, now(), now());
  END IF;

  -- Muhammad Fauzan Hakim Kamil (0094927362) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'fauzanhakimpaw@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094927362') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'fauzanhakimpaw@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'fauzanhakimpaw@sman13bdg.sch.id', 'Muhammad Fauzan Hakim Kamil', '0094927362', 'L', true, now(), now());
  END IF;

  -- Musha Sawaludin (0097026853) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'mushasawal@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097026853') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'mushasawal@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'mushasawal@sman13bdg.sch.id', 'Musha Sawaludin', '0097026853', 'L', true, now(), now());
  END IF;

  -- Nabila Khoirun Nisa (0098898235) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ielaangels04@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098898235') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ielaangels04@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ielaangels04@sman13bdg.sch.id', 'Nabila Khoirun Nisa', '0098898235', 'P', true, now(), now());
  END IF;

  -- Nanda Bustami (0096556998) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nandabustami04@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096556998') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nandabustami04@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nandabustami04@sman13bdg.sch.id', 'Nanda Bustami', '0096556998', 'P', true, now(), now());
  END IF;

  -- Rafka Akmal Alviansyah (0101175088) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rafkaakmal43@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0101175088') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rafkaakmal43@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rafkaakmal43@sman13bdg.sch.id', 'Rafka Akmal Alviansyah', '0101175088', 'L', true, now(), now());
  END IF;

  -- Rakha Ayodhya Prawira (0094169569) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rakhaprawira21@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094169569') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rakhaprawira21@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rakhaprawira21@sman13bdg.sch.id', 'Rakha Ayodhya Prawira', '0094169569', 'L', true, now(), now());
  END IF;

  -- Randi Alviansyah (0092869659) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'randialvi@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092869659') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'randialvi@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'randialvi@sman13bdg.sch.id', 'Randi Alviansyah', '0092869659', 'L', true, now(), now());
  END IF;

  -- Randika Gustiandira Putra (0094566388) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'gprandika21@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094566388') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'gprandika21@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'gprandika21@sman13bdg.sch.id', 'Randika Gustiandira Putra', '0094566388', 'L', true, now(), now());
  END IF;

  -- Rega Fabian Zidane (0108510740) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'regafabian261@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0108510740') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'regafabian261@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'regafabian261@sman13bdg.sch.id', 'Rega Fabian Zidane', '0108510740', 'L', true, now(), now());
  END IF;

  -- Reisha Azqia Arsya (0108626732) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'iisinar199@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0108626732') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'iisinar199@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'iisinar199@sman13bdg.sch.id', 'Reisha Azqia Arsya', '0108626732', 'P', true, now(), now());
  END IF;

  -- Rifa Azka Zafirah (0091718847) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'azkarifa85@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091718847') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'azkarifa85@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'azkarifa85@sman13bdg.sch.id', 'Rifa Azka Zafirah', '0091718847', 'P', true, now(), now());
  END IF;

  -- Rifqi Cahyana Arif Putra (0093665552) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rifqicap123@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093665552') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rifqicap123@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rifqicap123@sman13bdg.sch.id', 'Rifqi Cahyana Arif Putra', '0093665552', 'L', true, now(), now());
  END IF;

  -- Riska Risvani (0098378016) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'riskarisvani28@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098378016') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'riskarisvani28@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'riskarisvani28@sman13bdg.sch.id', 'Riska Risvani', '0098378016', 'P', true, now(), now());
  END IF;

  -- Salsabila Dwi Fatimah (0104052508) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'salsabiladwifatimah579@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0104052508') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'salsabiladwifatimah579@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'salsabiladwifatimah579@sman13bdg.sch.id', 'Salsabila Dwi Fatimah', '0104052508', 'P', true, now(), now());
  END IF;

  -- Sarif Hidayat (0092885404) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'sh.30062009@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092885404') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'sh.30062009@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'sh.30062009@sman13bdg.sch.id', 'Sarif Hidayat', '0092885404', 'L', true, now(), now());
  END IF;

  -- Selvi Regiani (0102105094) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'regianiselvi@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0102105094') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'regianiselvi@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'regianiselvi@sman13bdg.sch.id', 'Selvi Regiani', '0102105094', 'P', true, now(), now());
  END IF;

  -- Sely Lestari (0096849967) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'lestarisl23738@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096849967') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'lestarisl23738@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'lestarisl23738@sman13bdg.sch.id', 'Sely Lestari', '0096849967', 'P', true, now(), now());
  END IF;

  -- Senza Fahreza (0109972200) [X-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'senjafahreza9@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0109972200') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'senjafahreza9@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'senjafahreza9@sman13bdg.sch.id', 'Senza Fahreza', '0109972200', 'L', true, now(), now());
  END IF;

  -- Aditya Permana (0087041228) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aditya@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087041228') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aditya@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aditya@sman13bdg.sch.id', 'Aditya Permana', '0087041228', 'L', true, now(), now());
  END IF;

  -- Anandhita Rezky Apsari Rachmayadi (0097794426) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nanda.arar0779@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097794426') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nanda.arar0779@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nanda.arar0779@sman13bdg.sch.id', 'Anandhita Rezky Apsari Rachmayadi', '0097794426', 'P', true, now(), now());
  END IF;

  -- Andini Nabila Putri (0095429863) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'andinii0109@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095429863') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'andinii0109@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'andinii0109@sman13bdg.sch.id', 'Andini Nabila Putri', '0095429863', 'P', true, now(), now());
  END IF;

  -- Aprilia Khoirun Nisa (0106574495) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aprilia.nisa2010@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0106574495') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aprilia.nisa2010@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aprilia.nisa2010@sman13bdg.sch.id', 'Aprilia Khoirun Nisa', '0106574495', 'P', true, now(), now());
  END IF;

  -- Arini Arifatunnisa (0094181704) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ns8798086@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094181704') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ns8798086@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ns8798086@sman13bdg.sch.id', 'Arini Arifatunnisa', '0094181704', 'P', true, now(), now());
  END IF;

  -- Assyfa Zahra Aulia (3104121883) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aslyaza261@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '3104121883') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aslyaza261@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aslyaza261@sman13bdg.sch.id', 'Assyfa Zahra Aulia', '3104121883', 'P', true, now(), now());
  END IF;

  -- Ayu Dwi Aryani (0103953371) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ayuaryani605@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0103953371') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ayuaryani605@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ayuaryani605@sman13bdg.sch.id', 'Ayu Dwi Aryani', '0103953371', 'P', true, now(), now());
  END IF;

  -- Evryl Alodya Al Queensha (0102406899) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'evrylalqueensha@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0102406899') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'evrylalqueensha@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'evrylalqueensha@sman13bdg.sch.id', 'Evryl Alodya Al Queensha', '0102406899', 'P', true, now(), now());
  END IF;

  -- Fadli Alif Maulana (0096149291) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'fadlialifmaulanamaulana@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096149291') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'fadlialifmaulanamaulana@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'fadlialifmaulanamaulana@sman13bdg.sch.id', 'Fadli Alif Maulana', '0096149291', 'L', true, now(), now());
  END IF;

  -- Frandhy Ezhy Artha Pratama (0103817954) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'frandhypratama@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0103817954') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'frandhypratama@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'frandhypratama@sman13bdg.sch.id', 'Frandhy Ezhy Artha Pratama', '0103817954', 'L', true, now(), now());
  END IF;

  -- Juanito Zeke Sigalingging (0096601746) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'juanitozeke1169@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096601746') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'juanitozeke1169@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'juanitozeke1169@sman13bdg.sch.id', 'Juanito Zeke Sigalingging', '0096601746', 'L', true, now(), now());
  END IF;

  -- Khaizura Syauqi (0107076441) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'patlabor0104@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0107076441') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'patlabor0104@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'patlabor0104@sman13bdg.sch.id', 'Khaizura Syauqi', '0107076441', 'P', true, now(), now());
  END IF;

  -- Kharisma Aini (0101304912) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'kharismaaaini@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0101304912') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'kharismaaaini@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'kharismaaaini@sman13bdg.sch.id', 'Kharisma Aini', '0101304912', 'P', true, now(), now());
  END IF;

  -- Luqman Hakim Sarifudin (0096820499) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'luqmanhakimsarifudin291@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096820499') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'luqmanhakimsarifudin291@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'luqmanhakimsarifudin291@sman13bdg.sch.id', 'Luqman Hakim Sarifudin', '0096820499', 'L', true, now(), now());
  END IF;

  -- Lutfyana Nurwijaya (0094521011) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'lutfyananur@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094521011') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'lutfyananur@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'lutfyananur@sman13bdg.sch.id', 'Lutfyana Nurwijaya', '0094521011', 'P', true, now(), now());
  END IF;

  -- Muhamad Rafka Rizky Pratama (0092564861) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'mr12afka@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092564861') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'mr12afka@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'mr12afka@sman13bdg.sch.id', 'Muhamad Rafka Rizky Pratama', '0092564861', 'L', true, now(), now());
  END IF;

  -- Muhammad Fadil Rahman (0091989992) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'fadilrizky0212@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091989992') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'fadilrizky0212@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'fadilrizky0212@sman13bdg.sch.id', 'Muhammad Fadil Rahman', '0091989992', 'L', true, now(), now());
  END IF;

  -- Muhammad Rakha Arrizky (0104001079) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'marrizky@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0104001079') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'marrizky@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'marrizky@sman13bdg.sch.id', 'Muhammad Rakha Arrizky', '0104001079', 'L', true, now(), now());
  END IF;

  -- Muhammad Yusuf Fachri Al-ghazali (0104681060) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'myfalgh4zali@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0104681060') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'myfalgh4zali@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'myfalgh4zali@sman13bdg.sch.id', 'Muhammad Yusuf Fachri Al-ghazali', '0104681060', 'L', true, now(), now());
  END IF;

  -- Muthia Tsani (0091479386) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'muthiatsani834@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091479386') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'muthiatsani834@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'muthiatsani834@sman13bdg.sch.id', 'Muthia Tsani', '0091479386', 'P', true, now(), now());
  END IF;

  -- Nazwa Aulia Syawal (0098781868) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nazw052@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098781868') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nazw052@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nazw052@sman13bdg.sch.id', 'Nazwa Aulia Syawal', '0098781868', 'P', true, now(), now());
  END IF;

  -- Nisa Aulia Ghassani (0101809477) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nisauliaghassani@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0101809477') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nisauliaghassani@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nisauliaghassani@sman13bdg.sch.id', 'Nisa Aulia Ghassani', '0101809477', 'P', true, now(), now());
  END IF;

  -- Nufail Firas Budiman (0097396815) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nufailfarisbudiman@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097396815') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nufailfarisbudiman@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nufailfarisbudiman@sman13bdg.sch.id', 'Nufail Firas Budiman', '0097396815', 'L', true, now(), now());
  END IF;

  -- Rangga Wisnu Satriani (0099406234) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ranggawisnusatriani@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099406234') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ranggawisnusatriani@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ranggawisnusatriani@sman13bdg.sch.id', 'Rangga Wisnu Satriani', '0099406234', 'L', true, now(), now());
  END IF;

  -- Raya Abdillah Permana (0093563069) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rayapermana19@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093563069') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rayapermana19@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rayapermana19@sman13bdg.sch.id', 'Raya Abdillah Permana', '0093563069', 'L', true, now(), now());
  END IF;

  -- Rezki Alif Fadhillah (0107065679) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rfadhillah@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0107065679') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rfadhillah@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rfadhillah@sman13bdg.sch.id', 'Rezki Alif Fadhillah', '0107065679', 'L', true, now(), now());
  END IF;

  -- Ririn Anggraeni (0096979789) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ririnanggraeni0001@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096979789') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ririnanggraeni0001@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ririnanggraeni0001@sman13bdg.sch.id', 'Ririn Anggraeni', '0096979789', 'P', true, now(), now());
  END IF;

  -- Rusdi Viera Sobari (0093438227) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'dyyqwerty6@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093438227') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'dyyqwerty6@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'dyyqwerty6@sman13bdg.sch.id', 'Rusdi Viera Sobari', '0093438227', 'L', true, now(), now());
  END IF;

  -- Salsabila Zulfa (0098562310) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'szulfa089@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098562310') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'szulfa089@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'szulfa089@sman13bdg.sch.id', 'Salsabila Zulfa', '0098562310', 'P', true, now(), now());
  END IF;

  -- Salwa Lathiifatul Fitriya (0094576386) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'salwalathifatulfitriya@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094576386') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'salwalathifatulfitriya@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'salwalathifatulfitriya@sman13bdg.sch.id', 'Salwa Lathiifatul Fitriya', '0094576386', 'P', true, now(), now());
  END IF;

  -- Sultan Sya''ban Nataprawira (0099284140) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'sultansyaban2009@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099284140') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'sultansyaban2009@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'sultansyaban2009@sman13bdg.sch.id', 'Sultan Sya''ban Nataprawira', '0099284140', 'L', true, now(), now());
  END IF;

  -- Syahrando Bestian Raspati (0099619974) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'syahrandobraspati11@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099619974') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'syahrandobraspati11@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'syahrandobraspati11@sman13bdg.sch.id', 'Syahrando Bestian Raspati', '0099619974', 'L', true, now(), now());
  END IF;

  -- Syifa Nayla Alifa (0105480689) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'syifanaylaaliffa@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0105480689') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'syifanaylaaliffa@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'syifanaylaaliffa@sman13bdg.sch.id', 'Syifa Nayla Alifa', '0105480689', 'P', true, now(), now());
  END IF;

  -- Syifa Putri (0099872250) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'danisipayyau776@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099872250') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'danisipayyau776@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'danisipayyau776@sman13bdg.sch.id', 'Syifa Putri', '0099872250', 'P', true, now(), now());
  END IF;

  -- Tiara Tri Yani (0095396321) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ty3401938@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095396321') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ty3401938@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ty3401938@sman13bdg.sch.id', 'Tiara Tri Yani', '0095396321', 'P', true, now(), now());
  END IF;

  -- Widiya Ayu Maharani (0098892540) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'widiyaayumaharani01@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098892540') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'widiyaayumaharani01@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'widiyaayumaharani01@sman13bdg.sch.id', 'Widiya Ayu Maharani', '0098892540', 'P', true, now(), now());
  END IF;

  -- Zacka Suhendar Saputra (0106261335) [X-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'zackasuhendar760@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0106261335') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'zackasuhendar760@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'zackasuhendar760@sman13bdg.sch.id', 'Zacka Suhendar Saputra', '0106261335', 'L', true, now(), now());
  END IF;

  -- Afzaal Restu Putra Sepdrian (0099901151) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'afzaalrestu@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099901151') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'afzaalrestu@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'afzaalrestu@sman13bdg.sch.id', 'Afzaal Restu Putra Sepdrian', '0099901151', 'L', true, now(), now());
  END IF;

  -- Aghnisya Yasyfa Adilah (0096804251) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aghniyayasyfa@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096804251') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aghniyayasyfa@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aghniyayasyfa@sman13bdg.sch.id', 'Aghnisya Yasyfa Adilah', '0096804251', 'P', true, now(), now());
  END IF;

  -- Aliifah Aura Al-tasbih (0082983720) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aliifahaura@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0082983720') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aliifahaura@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aliifahaura@sman13bdg.sch.id', 'Aliifah Aura Al-tasbih', '0082983720', 'P', true, now(), now());
  END IF;

  -- Alisyah Nararya Salmih Simbolon (0085393853) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'salmihnararya@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0085393853') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'salmihnararya@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'salmihnararya@sman13bdg.sch.id', 'Alisyah Nararya Salmih Simbolon', '0085393853', 'P', true, now(), now());
  END IF;

  -- Aura Callysta (0094811754) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'auracally@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094811754') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'auracally@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'auracally@sman13bdg.sch.id', 'Aura Callysta', '0094811754', 'P', true, now(), now());
  END IF;

  -- Bagas Aditama Yudha (0091719309) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'adytamayudha17@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091719309') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'adytamayudha17@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'adytamayudha17@sman13bdg.sch.id', 'Bagas Aditama Yudha', '0091719309', 'L', true, now(), now());
  END IF;

  -- Briana Adelyn Amaris Tris Agatha (0092822214) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'brianaadelyn20@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092822214') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'brianaadelyn20@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'brianaadelyn20@sman13bdg.sch.id', 'Briana Adelyn Amaris Tris Agatha', '0092822214', 'P', true, now(), now());
  END IF;

  -- Dinda Bilqis Dinara (0099275201) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'donabilqies@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099275201') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'donabilqies@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'donabilqies@sman13bdg.sch.id', 'Dinda Bilqis Dinara', '0099275201', 'P', true, now(), now());
  END IF;

  -- Dineu Hillary Kusumawardhani (0095846136) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'dineuhk@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095846136') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'dineuhk@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'dineuhk@sman13bdg.sch.id', 'Dineu Hillary Kusumawardhani', '0095846136', 'P', true, now(), now());
  END IF;

  -- Fadli Surya Dwitama (0096331666) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'fadlisuryadwitama29@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096331666') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'fadlisuryadwitama29@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'fadlisuryadwitama29@sman13bdg.sch.id', 'Fadli Surya Dwitama', '0096331666', 'L', true, now(), now());
  END IF;

  -- Farsal Herdiansyah (0081608744) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'farsalherdiansyah88@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081608744') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'farsalherdiansyah88@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'farsalherdiansyah88@sman13bdg.sch.id', 'Farsal Herdiansyah', '0081608744', 'L', true, now(), now());
  END IF;

  -- Fazri Bilal Alhaq (0088874777) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'fazri1990bdg@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088874777') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'fazri1990bdg@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'fazri1990bdg@sman13bdg.sch.id', 'Fazri Bilal Alhaq', '0088874777', 'L', true, now(), now());
  END IF;

  -- Haifa Nurusshafa (3081418068) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nurusshafahaifa@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '3081418068') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nurusshafahaifa@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nurusshafahaifa@sman13bdg.sch.id', 'Haifa Nurusshafa', '3081418068', 'P', true, now(), now());
  END IF;

  -- Jusuf Christofer Priadi Putra (0094312919) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'jusufchristofer@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094312919') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'jusufchristofer@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'jusufchristofer@sman13bdg.sch.id', 'Jusuf Christofer Priadi Putra', '0094312919', 'L', true, now(), now());
  END IF;

  -- Kamila Putri Meiliana (0093589653) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'kamilaaputri21@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093589653') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'kamilaaputri21@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'kamilaaputri21@sman13bdg.sch.id', 'Kamila Putri Meiliana', '0093589653', 'P', true, now(), now());
  END IF;

  -- Khairya Adzra Tsabitha (0096120705) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'khairyaadzratsabitha@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096120705') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'khairyaadzratsabitha@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'khairyaadzratsabitha@sman13bdg.sch.id', 'Khairya Adzra Tsabitha', '0096120705', 'P', true, now(), now());
  END IF;

  -- Lisnawati (0088385451) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'lisnaw2008@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088385451') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'lisnaw2008@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'lisnaw2008@sman13bdg.sch.id', 'Lisnawati', '0088385451', 'P', true, now(), now());
  END IF;

  -- Mita Setyawati (0093324527) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'mitasetyawati26@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093324527') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'mitasetyawati26@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'mitasetyawati26@sman13bdg.sch.id', 'Mita Setyawati', '0093324527', 'P', true, now(), now());
  END IF;

  -- Mohammad Lutfi Pratama (0088101359) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'mohammadlutfipratama58@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088101359') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'mohammadlutfipratama58@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'mohammadlutfipratama58@sman13bdg.sch.id', 'Mohammad Lutfi Pratama', '0088101359', 'L', true, now(), now());
  END IF;

  -- Mughni Rahmawan (0091348168) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rahmawanmughni@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091348168') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rahmawanmughni@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rahmawanmughni@sman13bdg.sch.id', 'Mughni Rahmawan', '0091348168', 'L', true, now(), now());
  END IF;

  -- Muhammad Agil Prakoso (0084632088) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'sitiwangsih1505@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0084632088') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'sitiwangsih1505@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'sitiwangsih1505@sman13bdg.sch.id', 'Muhammad Agil Prakoso', '0084632088', 'L', true, now(), now());
  END IF;

  -- Nadira Aura Fadlina (0088196042) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'fadlinalira@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088196042') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'fadlinalira@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'fadlinalira@sman13bdg.sch.id', 'Nadira Aura Fadlina', '0088196042', 'P', true, now(), now());
  END IF;

  -- Nayla Ratifah Zahra (0088486173) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ratifahzahranayla123@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088486173') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ratifahzahranayla123@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ratifahzahranayla123@sman13bdg.sch.id', 'Nayla Ratifah Zahra', '0088486173', 'P', true, now(), now());
  END IF;

  -- Nazwa Aurellia Nathaniela (0095880099) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aurelnazwa14@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095880099') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aurelnazwa14@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aurelnazwa14@sman13bdg.sch.id', 'Nazwa Aurellia Nathaniela', '0095880099', 'P', true, now(), now());
  END IF;

  -- Novia Handayani (0084888666) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'noviaahandayani986@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0084888666') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'noviaahandayani986@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'noviaahandayani986@sman13bdg.sch.id', 'Novia Handayani', '0084888666', 'P', true, now(), now());
  END IF;

  -- Putri Deca Oktaviani (0082101385) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'putrideca@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0082101385') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'putrideca@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'putrideca@sman13bdg.sch.id', 'Putri Deca Oktaviani', '0082101385', 'P', true, now(), now());
  END IF;

  -- Qayla Azra Mysha (0088633637) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'qaylaazra06@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088633637') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'qaylaazra06@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'qaylaazra06@sman13bdg.sch.id', 'Qayla Azra Mysha', '0088633637', 'P', true, now(), now());
  END IF;

  -- Raditya Dhimas Nuggraha (0095229833) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'radityadhimas21@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095229833') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'radityadhimas21@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'radityadhimas21@sman13bdg.sch.id', 'Raditya Dhimas Nuggraha', '0095229833', 'L', true, now(), now());
  END IF;

  -- Rahmy Afipah (0083493640) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rahmyafifah32@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083493640') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rahmyafifah32@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rahmyafifah32@sman13bdg.sch.id', 'Rahmy Afipah', '0083493640', 'P', true, now(), now());
  END IF;

  -- Regalia Candranaran Arief Nadea (0097159532) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'regaliaarief@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097159532') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'regaliaarief@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'regaliaarief@sman13bdg.sch.id', 'Regalia Candranaran Arief Nadea', '0097159532', 'L', true, now(), now());
  END IF;

  -- Salma Oktaviani (3077332510) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'oktavianisalma41@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '3077332510') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'oktavianisalma41@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'oktavianisalma41@sman13bdg.sch.id', 'Salma Oktaviani', '3077332510', 'P', true, now(), now());
  END IF;

  -- Salwa Salsabila (0092400779) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'salwatermeloon@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092400779') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'salwatermeloon@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'salwatermeloon@sman13bdg.sch.id', 'Salwa Salsabila', '0092400779', 'P', true, now(), now());
  END IF;

  -- Seffany Aulia Putri Maheswari (0084018415) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'seffanyauliaputrimaheswari@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0084018415') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'seffanyauliaputrimaheswari@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'seffanyauliaputrimaheswari@sman13bdg.sch.id', 'Seffany Aulia Putri Maheswari', '0084018415', 'P', true, now(), now());
  END IF;

  -- Virgita Imtiaz (0085694828) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'virgitaimtiaz@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0085694828') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'virgitaimtiaz@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'virgitaimtiaz@sman13bdg.sch.id', 'Virgita Imtiaz', '0085694828', 'P', true, now(), now());
  END IF;

  -- Wina Nadila (0088999079) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nadilawina4@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088999079') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nadilawina4@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nadilawina4@sman13bdg.sch.id', 'Wina Nadila', '0088999079', 'P', true, now(), now());
  END IF;

  -- Zulfa Baida Alhadi (0094897585) [XI-1]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'zulfabaidaalhadi09@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094897585') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'zulfabaidaalhadi09@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'zulfabaidaalhadi09@sman13bdg.sch.id', 'Zulfa Baida Alhadi', '0094897585', 'P', true, now(), now());
  END IF;

  -- Adham Al Afgani (0084267116) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'alafghaniadham@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0084267116') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'alafghaniadham@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'alafghaniadham@sman13bdg.sch.id', 'Adham Al Afgani', '0084267116', 'L', true, now(), now());
  END IF;

  -- Affan Marcel Bastian (0096922170) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'bbastian681@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096922170') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'bbastian681@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'bbastian681@sman13bdg.sch.id', 'Affan Marcel Bastian', '0096922170', 'L', true, now(), now());
  END IF;

  -- Agung Pirmansyah (0083519030) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'agungfirmansyah2463@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083519030') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'agungfirmansyah2463@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'agungfirmansyah2463@sman13bdg.sch.id', 'Agung Pirmansyah', '0083519030', 'L', true, now(), now());
  END IF;

  -- Akmal Nurdiansyah (0099610459) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'akmaln1809@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099610459') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'akmaln1809@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'akmaln1809@sman13bdg.sch.id', 'Akmal Nurdiansyah', '0099610459', 'L', true, now(), now());
  END IF;

  -- Andien Dwi Oktamal (0083812668) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aoktamal@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083812668') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aoktamal@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aoktamal@sman13bdg.sch.id', 'Andien Dwi Oktamal', '0083812668', 'P', true, now(), now());
  END IF;

  -- Andra Najwan Fadhilah (0087349094) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'juan.andra23@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087349094') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'juan.andra23@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'juan.andra23@sman13bdg.sch.id', 'Andra Najwan Fadhilah', '0087349094', 'P', true, now(), now());
  END IF;

  -- Arga Sofyan (3083961072) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'argaasofyan2@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '3083961072') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'argaasofyan2@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'argaasofyan2@sman13bdg.sch.id', 'Arga Sofyan', '3083961072', 'L', true, now(), now());
  END IF;

  -- Aulia Nur Fadilah (0088030509) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aulianurfadilah0815@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088030509') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aulianurfadilah0815@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aulianurfadilah0815@sman13bdg.sch.id', 'Aulia Nur Fadilah', '0088030509', 'P', true, now(), now());
  END IF;

  -- Bilqis Serin Nafisah (0071211737) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'bilqiserin@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0071211737') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'bilqiserin@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'bilqiserin@sman13bdg.sch.id', 'Bilqis Serin Nafisah', '0071211737', 'P', true, now(), now());
  END IF;

  -- Daviansyah Rizqy Ramadhan (0087172775) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'daviramadhan96@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087172775') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'daviramadhan96@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'daviramadhan96@sman13bdg.sch.id', 'Daviansyah Rizqy Ramadhan', '0087172775', 'L', true, now(), now());
  END IF;

  -- Dewira Angkasa Syaputra (0082390369) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'www.syaputra20@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0082390369') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'www.syaputra20@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'www.syaputra20@sman13bdg.sch.id', 'Dewira Angkasa Syaputra', '0082390369', 'P', true, now(), now());
  END IF;

  -- Dezan Azka Mulyana (0088914676) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'dezanazka@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088914676') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'dezanazka@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'dezanazka@sman13bdg.sch.id', 'Dezan Azka Mulyana', '0088914676', 'P', true, now(), now());
  END IF;

  -- Dini Sifana Rahayu (0087400639) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'sifanadini30@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087400639') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'sifanadini30@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'sifanadini30@sman13bdg.sch.id', 'Dini Sifana Rahayu', '0087400639', 'P', true, now(), now());
  END IF;

  -- Fauzia Rahma Jaya (0089563673) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'fauziarahmajaya23@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089563673') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'fauziarahmajaya23@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'fauziarahmajaya23@sman13bdg.sch.id', 'Fauzia Rahma Jaya', '0089563673', 'P', true, now(), now());
  END IF;

  -- Ibel Vilissiano (0074399124) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ibelvilissiano07@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0074399124') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ibelvilissiano07@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ibelvilissiano07@sman13bdg.sch.id', 'Ibel Vilissiano', '0074399124', 'P', true, now(), now());
  END IF;

  -- Insania Tazkia Anshory (0095866549) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'azalucent@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095866549') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'azalucent@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'azalucent@sman13bdg.sch.id', 'Insania Tazkia Anshory', '0095866549', 'P', true, now(), now());
  END IF;

  -- Iqbal Ramdhan (0086014300) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ramdhann067@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0086014300') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ramdhann067@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ramdhann067@sman13bdg.sch.id', 'Iqbal Ramdhan', '0086014300', 'L', true, now(), now());
  END IF;

  -- Irwan Ramdani (0084692875) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'irwanramdani0724@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0084692875') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'irwanramdani0724@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'irwanramdani0724@sman13bdg.sch.id', 'Irwan Ramdani', '0084692875', 'L', true, now(), now());
  END IF;

  -- Kelvin Rezal Aprilyoga (0083466112) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'kelvinrezalaprilyoga@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083466112') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'kelvinrezalaprilyoga@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'kelvinrezalaprilyoga@sman13bdg.sch.id', 'Kelvin Rezal Aprilyoga', '0083466112', 'L', true, now(), now());
  END IF;

  -- Khalisha Jannatul Anwari (0093870606) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'khalishajannatulanwari15@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093870606') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'khalishajannatulanwari15@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'khalishajannatulanwari15@sman13bdg.sch.id', 'Khalisha Jannatul Anwari', '0093870606', 'P', true, now(), now());
  END IF;

  -- Khusnussyifa Salsabila (0083662112) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'syifa6141@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083662112') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'syifa6141@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'syifa6141@sman13bdg.sch.id', 'Khusnussyifa Salsabila', '0083662112', 'P', true, now(), now());
  END IF;

  -- Kurniawati (0088919921) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'kurniawati@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088919921') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'kurniawati@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'kurniawati@sman13bdg.sch.id', 'Kurniawati', '0088919921', 'P', true, now(), now());
  END IF;

  -- Muhamad Haza Sulhaq (3088906437) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'muhamadhazas@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '3088906437') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'muhamadhazas@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'muhamadhazas@sman13bdg.sch.id', 'Muhamad Haza Sulhaq', '3088906437', 'L', true, now(), now());
  END IF;

  -- Muhamad Raka Adiputra (0084760521) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'muhammadrakaadiputra14@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0084760521') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'muhammadrakaadiputra14@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'muhammadrakaadiputra14@sman13bdg.sch.id', 'Muhamad Raka Adiputra', '0084760521', 'L', true, now(), now());
  END IF;

  -- Muhamad Rido (0084189826) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'www.rido@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0084189826') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'www.rido@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'www.rido@sman13bdg.sch.id', 'Muhamad Rido', '0084189826', 'L', true, now(), now());
  END IF;

  -- Mutia Farramitha (0097180658) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'muthiafar@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097180658') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'muthiafar@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'muthiafar@sman13bdg.sch.id', 'Mutia Farramitha', '0097180658', 'P', true, now(), now());
  END IF;

  -- Mutia Putri (0084658950) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'mutiaputri@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0084658950') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'mutiaputri@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'mutiaputri@sman13bdg.sch.id', 'Mutia Putri', '0084658950', 'P', true, now(), now());
  END IF;

  -- Nazwa Nuri Afwa (0084124145) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'enungapo63@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0084124145') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'enungapo63@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'enungapo63@sman13bdg.sch.id', 'Nazwa Nuri Afwa', '0084124145', 'P', true, now(), now());
  END IF;

  -- Reikhal Byan Alfajari (0094409861) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'elreye077@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094409861') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'elreye077@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'elreye077@sman13bdg.sch.id', 'Reikhal Byan Alfajari', '0094409861', 'L', true, now(), now());
  END IF;

  -- Riadi Septiansyah (0092775233) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'riadiseptian5555@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092775233') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'riadiseptian5555@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'riadiseptian5555@sman13bdg.sch.id', 'Riadi Septiansyah', '0092775233', 'L', true, now(), now());
  END IF;

  -- Rigam Radya Putra (0099062653) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rigam@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099062653') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rigam@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rigam@sman13bdg.sch.id', 'Rigam Radya Putra', '0099062653', 'L', true, now(), now());
  END IF;

  -- Salman Mujahid Al Fadhil (0082051697) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'manzzaldill@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0082051697') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'manzzaldill@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'manzzaldill@sman13bdg.sch.id', 'Salman Mujahid Al Fadhil', '0082051697', 'L', true, now(), now());
  END IF;

  -- Shiekha Mozza (0092203398) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'mozamoza3010@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092203398') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'mozamoza3010@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'mozamoza3010@sman13bdg.sch.id', 'Shiekha Mozza', '0092203398', 'L', true, now(), now());
  END IF;

  -- Syahrani Nur Khodizah (0082127083) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'syahraninur2410@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0082127083') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'syahraninur2410@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'syahraninur2410@sman13bdg.sch.id', 'Syahrani Nur Khodizah', '0082127083', 'P', true, now(), now());
  END IF;

  -- Syifa Apriliani (0093120886) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'syifapril@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093120886') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'syifapril@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'syifapril@sman13bdg.sch.id', 'Syifa Apriliani', '0093120886', 'P', true, now(), now());
  END IF;

  -- Wildan Januar Muharam (0094528638) [XI-2]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'wildanjanuar@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094528638') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'wildanjanuar@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'wildanjanuar@sman13bdg.sch.id', 'Wildan Januar Muharam', '0094528638', 'L', true, now(), now());
  END IF;

  -- Ajeng Dwi Rahardjo (0085186808) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ajengdwi@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0085186808') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ajengdwi@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ajengdwi@sman13bdg.sch.id', 'Ajeng Dwi Rahardjo', '0085186808', 'P', true, now(), now());
  END IF;

  -- Anisa Nur Seyla (0082882344) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'anisanurseyla96@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0082882344') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'anisanurseyla96@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'anisanurseyla96@sman13bdg.sch.id', 'Anisa Nur Seyla', '0082882344', 'P', true, now(), now());
  END IF;

  -- Azkia Humaira Ramadhanty (0087749173) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'azkiakia591@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087749173') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'azkiakia591@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'azkiakia591@sman13bdg.sch.id', 'Azkia Humaira Ramadhanty', '0087749173', 'P', true, now(), now());
  END IF;

  -- Balqis Naura Sabila (0086273312) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'balqisnaurasabila24@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0086273312') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'balqisnaurasabila24@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'balqisnaurasabila24@sman13bdg.sch.id', 'Balqis Naura Sabila', '0086273312', 'P', true, now(), now());
  END IF;

  -- Barlie Putri Bilbina (0097760504) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'barlieputri@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097760504') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'barlieputri@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'barlieputri@sman13bdg.sch.id', 'Barlie Putri Bilbina', '0097760504', 'P', true, now(), now());
  END IF;

  -- Bentar Ananda Pramudita (0079438506) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'b441205@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0079438506') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'b441205@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'b441205@sman13bdg.sch.id', 'Bentar Ananda Pramudita', '0079438506', 'P', true, now(), now());
  END IF;

  -- Dafin Navid Alkhairan (0094258212) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'dafinnavidalkhairan@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094258212') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'dafinnavidalkhairan@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'dafinnavidalkhairan@sman13bdg.sch.id', 'Dafin Navid Alkhairan', '0094258212', 'L', true, now(), now());
  END IF;

  -- Devan Trian Yaris Gunawan (0085766136) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'devanngunawan@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0085766136') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'devanngunawan@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'devanngunawan@sman13bdg.sch.id', 'Devan Trian Yaris Gunawan', '0085766136', 'L', true, now(), now());
  END IF;

  -- Dinda Fazila Putri (3097917547) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'dputri@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '3097917547') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'dputri@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'dputri@sman13bdg.sch.id', 'Dinda Fazila Putri', '3097917547', 'P', true, now(), now());
  END IF;

  -- Dino Septiano Ramadhan (0078476568) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'teadino4@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0078476568') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'teadino4@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'teadino4@sman13bdg.sch.id', 'Dino Septiano Ramadhan', '0078476568', 'L', true, now(), now());
  END IF;

  -- Eddytha Triestha Keisha Kendra (0087520296) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'kendrakeisha29@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087520296') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'kendrakeisha29@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'kendrakeisha29@sman13bdg.sch.id', 'Eddytha Triestha Keisha Kendra', '0087520296', 'P', true, now(), now());
  END IF;

  -- Falisha Putri Ramdhan (0087344570) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'framdhan@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087344570') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'framdhan@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'framdhan@sman13bdg.sch.id', 'Falisha Putri Ramdhan', '0087344570', 'P', true, now(), now());
  END IF;

  -- Fitria Lestari Sitanggang (0085868151) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'fsitanggang@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0085868151') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'fsitanggang@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'fsitanggang@sman13bdg.sch.id', 'Fitria Lestari Sitanggang', '0085868151', 'P', true, now(), now());
  END IF;

  -- Hanifa Ramadhani (0081006479) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'hanifaramadhani2008@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081006479') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'hanifaramadhani2008@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'hanifaramadhani2008@sman13bdg.sch.id', 'Hanifa Ramadhani', '0081006479', 'P', true, now(), now());
  END IF;

  -- Haura Atthiya Rahmania (0094862116) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'atthiyahaura99@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094862116') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'atthiyahaura99@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'atthiyahaura99@sman13bdg.sch.id', 'Haura Atthiya Rahmania', '0094862116', 'P', true, now(), now());
  END IF;

  -- Havilah Kayana Fausta (0094024681) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'hfausta@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094024681') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'hfausta@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'hfausta@sman13bdg.sch.id', 'Havilah Kayana Fausta', '0094024681', 'P', true, now(), now());
  END IF;

  -- Juneeta Talita Sakhi Hermawan (0097909539) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'juneetatalita918@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097909539') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'juneetatalita918@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'juneetatalita918@sman13bdg.sch.id', 'Juneeta Talita Sakhi Hermawan', '0097909539', 'P', true, now(), now());
  END IF;

  -- Kafa Billahi Syahida Artha (0089524404) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'kafaartha@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089524404') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'kafaartha@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'kafaartha@sman13bdg.sch.id', 'Kafa Billahi Syahida Artha', '0089524404', 'L', true, now(), now());
  END IF;

  -- Keyla Shita Nur Rizqia (0082102643) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'kylashta@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0082102643') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'kylashta@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'kylashta@sman13bdg.sch.id', 'Keyla Shita Nur Rizqia', '0082102643', 'P', true, now(), now());
  END IF;

  -- Mochammad Yoggy Firdhaus (0083167167) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'yogifirdaus292@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083167167') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'yogifirdaus292@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'yogifirdaus292@sman13bdg.sch.id', 'Mochammad Yoggy Firdhaus', '0083167167', 'L', true, now(), now());
  END IF;

  -- Monica Putri Octavia (0086479416) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'mnicaputriictv@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0086479416') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'mnicaputriictv@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'mnicaputriictv@sman13bdg.sch.id', 'Monica Putri Octavia', '0086479416', 'P', true, now(), now());
  END IF;

  -- Muhamad Alfarizi (0085202930) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'alfa200813@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0085202930') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'alfa200813@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'alfa200813@sman13bdg.sch.id', 'Muhamad Alfarizi', '0085202930', 'L', true, now(), now());
  END IF;

  -- Muhamad Dhimas Arizky (0095189763) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'dhimasarizky5@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095189763') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'dhimasarizky5@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'dhimasarizky5@sman13bdg.sch.id', 'Muhamad Dhimas Arizky', '0095189763', 'L', true, now(), now());
  END IF;

  -- Muhammad Faisal (0086162370) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'muhammadfaisal@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0086162370') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'muhammadfaisal@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'muhammadfaisal@sman13bdg.sch.id', 'Muhammad Faisal', '0086162370', 'L', true, now(), now());
  END IF;

  -- Nazara Aqilashakil Tauladan (0087758194) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nazaratauladan04@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087758194') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nazaratauladan04@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nazaratauladan04@sman13bdg.sch.id', 'Nazara Aqilashakil Tauladan', '0087758194', 'P', true, now(), now());
  END IF;

  -- Pahry Janwar Setiawan (0094343231) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'pahryjanuar2009@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094343231') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'pahryjanuar2009@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'pahryjanuar2009@sman13bdg.sch.id', 'Pahry Janwar Setiawan', '0094343231', 'L', true, now(), now());
  END IF;

  -- Qeila Sagiara (0089305913) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'qeilasagiara@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089305913') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'qeilasagiara@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'qeilasagiara@sman13bdg.sch.id', 'Qeila Sagiara', '0089305913', 'P', true, now(), now());
  END IF;

  -- Raka Akbar Ramadhan (0083917203) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rakaakbarramadhan4@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083917203') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rakaakbarramadhan4@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rakaakbarramadhan4@sman13bdg.sch.id', 'Raka Akbar Ramadhan', '0083917203', 'L', true, now(), now());
  END IF;

  -- Regita Alfrina Balqis Fauziah Tuasikal (0099498534) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'regitaafrina@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099498534') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'regitaafrina@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'regitaafrina@sman13bdg.sch.id', 'Regita Alfrina Balqis Fauziah Tuasikal', '0099498534', 'P', true, now(), now());
  END IF;

  -- Revan Surya Noviansyah (0083310765) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'yeyenhagi21@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083310765') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'yeyenhagi21@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'yeyenhagi21@sman13bdg.sch.id', 'Revan Surya Noviansyah', '0083310765', 'L', true, now(), now());
  END IF;

  -- Sintya Agustin (0093280589) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'sintyaagus@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093280589') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'sintyaagus@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'sintyaagus@sman13bdg.sch.id', 'Sintya Agustin', '0093280589', 'P', true, now(), now());
  END IF;

  -- Sucita Sintia Sari (0095919175) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ssintiasari2@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095919175') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ssintiasari2@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ssintiasari2@sman13bdg.sch.id', 'Sucita Sintia Sari', '0095919175', 'P', true, now(), now());
  END IF;

  -- Tiara Almaya Esa (0083302553) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'tiaraaesaa@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083302553') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'tiaraaesaa@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'tiaraaesaa@sman13bdg.sch.id', 'Tiara Almaya Esa', '0083302553', 'P', true, now(), now());
  END IF;

  -- Viola Ivana (0098361753) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'viola13@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098361753') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'viola13@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'viola13@sman13bdg.sch.id', 'Viola Ivana', '0098361753', 'P', true, now(), now());
  END IF;

  -- Yunita Nur Azahra (0089512584) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'yunitanurazahra@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089512584') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'yunitanurazahra@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'yunitanurazahra@sman13bdg.sch.id', 'Yunita Nur Azahra', '0089512584', 'P', true, now(), now());
  END IF;

  -- Zahra Anugrah Oktavia (0081832386) [XI-3]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'zahraoktavia2310@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081832386') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'zahraoktavia2310@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'zahraoktavia2310@sman13bdg.sch.id', 'Zahra Anugrah Oktavia', '0081832386', 'P', true, now(), now());
  END IF;

  -- Aditiya Riski (0099109050) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'adityariz121h@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099109050') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'adityariz121h@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'adityariz121h@sman13bdg.sch.id', 'Aditiya Riski', '0099109050', 'L', true, now(), now());
  END IF;

  -- Andini Atriani Febrianti (3095675991) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'deden4774@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '3095675991') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'deden4774@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'deden4774@sman13bdg.sch.id', 'Andini Atriani Febrianti', '3095675991', 'P', true, now(), now());
  END IF;

  -- Aqbil Fathan Sayidan (0084401100) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aqbilfathansayidan@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0084401100') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aqbilfathansayidan@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aqbilfathansayidan@sman13bdg.sch.id', 'Aqbil Fathan Sayidan', '0084401100', 'L', true, now(), now());
  END IF;

  -- Audi Ayu Hermawan (0098532515) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ahermawan@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098532515') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ahermawan@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ahermawan@sman13bdg.sch.id', 'Audi Ayu Hermawan', '0098532515', 'P', true, now(), now());
  END IF;

  -- Auliya Azahra Rezhiana (0087256983) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aulzhayara08@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087256983') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aulzhayara08@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aulzhayara08@sman13bdg.sch.id', 'Auliya Azahra Rezhiana', '0087256983', 'P', true, now(), now());
  END IF;

  -- Azhahra Anggun Lestari (0087801517) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'lindalindiana48@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087801517') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'lindalindiana48@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'lindalindiana48@sman13bdg.sch.id', 'Azhahra Anggun Lestari', '0087801517', 'P', true, now(), now());
  END IF;

  -- Azkia Aulia Khairunnisa (0097420667) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aazkia390@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097420667') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aazkia390@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aazkia390@sman13bdg.sch.id', 'Azkia Aulia Khairunnisa', '0097420667', 'P', true, now(), now());
  END IF;

  -- Ellisya Harta Sundapa (0088966018) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ellisyasundapa11@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088966018') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ellisyasundapa11@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ellisyasundapa11@sman13bdg.sch.id', 'Ellisya Harta Sundapa', '0088966018', 'P', true, now(), now());
  END IF;

  -- Elsa Dewanti (0068613702) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'elsadeswanti200@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0068613702') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'elsadeswanti200@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'elsadeswanti200@sman13bdg.sch.id', 'Elsa Dewanti', '0068613702', 'P', true, now(), now());
  END IF;

  -- Galuh Restia Nindy (0094083454) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'gnindy@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094083454') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'gnindy@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'gnindy@sman13bdg.sch.id', 'Galuh Restia Nindy', '0094083454', 'L', true, now(), now());
  END IF;

  -- Gisela Nurfadilah Pratiwi (0091300126) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'gpratiwi@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091300126') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'gpratiwi@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'gpratiwi@sman13bdg.sch.id', 'Gisela Nurfadilah Pratiwi', '0091300126', 'P', true, now(), now());
  END IF;

  -- Jibril Cisse Gurnito (0085167950) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'jibrilcissegurnito85587@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0085167950') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'jibrilcissegurnito85587@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'jibrilcissegurnito85587@sman13bdg.sch.id', 'Jibril Cisse Gurnito', '0085167950', 'L', true, now(), now());
  END IF;

  -- Jimi Samuel Tambunan (0081818425) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'jimisamuel@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081818425') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'jimisamuel@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'jimisamuel@sman13bdg.sch.id', 'Jimi Samuel Tambunan', '0081818425', 'L', true, now(), now());
  END IF;

  -- Julva Widiyansah (0089099537) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'julva@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089099537') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'julva@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'julva@sman13bdg.sch.id', 'Julva Widiyansah', '0089099537', 'P', true, now(), now());
  END IF;

  -- Keyla Fazza Ayriya (0089795936) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'keylafazzaayriya462@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089795936') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'keylafazzaayriya462@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'keylafazzaayriya462@sman13bdg.sch.id', 'Keyla Fazza Ayriya', '0089795936', 'P', true, now(), now());
  END IF;

  -- Mahsa Chaliesta Al Azura (0089758640) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'mahsachaliesta@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089758640') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'mahsachaliesta@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'mahsachaliesta@sman13bdg.sch.id', 'Mahsa Chaliesta Al Azura', '0089758640', 'P', true, now(), now());
  END IF;

  -- Muhamad Raihan (0085462671) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'muhamadraihan@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0085462671') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'muhamadraihan@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'muhamadraihan@sman13bdg.sch.id', 'Muhamad Raihan', '0085462671', 'L', true, now(), now());
  END IF;

  -- Muhammad Galih Purnama (0094806151) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'purnamagalih735@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094806151') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'purnamagalih735@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'purnamagalih735@sman13bdg.sch.id', 'Muhammad Galih Purnama', '0094806151', 'L', true, now(), now());
  END IF;

  -- Nenden Anggraeni (0095131265) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'anenden889@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095131265') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'anenden889@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'anenden889@sman13bdg.sch.id', 'Nenden Anggraeni', '0095131265', 'P', true, now(), now());
  END IF;

  -- Nur Aprianti (0084926284) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nurapri@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0084926284') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nurapri@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nurapri@sman13bdg.sch.id', 'Nur Aprianti', '0084926284', 'P', true, now(), now());
  END IF;

  -- Rafa Sabiya (0081217796) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rafa@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081217796') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rafa@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rafa@sman13bdg.sch.id', 'Rafa Sabiya', '0081217796', 'L', true, now(), now());
  END IF;

  -- Rafi Apriansyah (0098807327) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'apriansyahrafi0@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098807327') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'apriansyahrafi0@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'apriansyahrafi0@sman13bdg.sch.id', 'Rafi Apriansyah', '0098807327', 'L', true, now(), now());
  END IF;

  -- Reno Cahya Gumelar (0092798482) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'renocahya57@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092798482') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'renocahya57@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'renocahya57@sman13bdg.sch.id', 'Reno Cahya Gumelar', '0092798482', 'L', true, now(), now());
  END IF;

  -- Riska Triani (0082658726) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'juniartir066@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0082658726') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'juniartir066@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'juniartir066@sman13bdg.sch.id', 'Riska Triani', '0082658726', 'P', true, now(), now());
  END IF;

  -- Salina Azin Aqilah Solihin (0088880777) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'salina450009@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088880777') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'salina450009@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'salina450009@sman13bdg.sch.id', 'Salina Azin Aqilah Solihin', '0088880777', 'L', true, now(), now());
  END IF;

  -- Sandhi Yudha Wastu Kencana (0084105497) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'sandhiyudha@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0084105497') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'sandhiyudha@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'sandhiyudha@sman13bdg.sch.id', 'Sandhi Yudha Wastu Kencana', '0084105497', 'L', true, now(), now());
  END IF;

  -- Santi Setiawati (0095459106) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'santisetiawati318@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095459106') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'santisetiawati318@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'santisetiawati318@sman13bdg.sch.id', 'Santi Setiawati', '0095459106', 'P', true, now(), now());
  END IF;

  -- Silva Naila Shofiana (0088083126) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'silvashofiana@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088083126') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'silvashofiana@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'silvashofiana@sman13bdg.sch.id', 'Silva Naila Shofiana', '0088083126', 'P', true, now(), now());
  END IF;

  -- Silvia Pramesti (0097282071) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'silviapramesti123@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097282071') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'silviapramesti123@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'silviapramesti123@sman13bdg.sch.id', 'Silvia Pramesti', '0097282071', 'P', true, now(), now());
  END IF;

  -- Supriansah (0083406312) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'priansyah688@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083406312') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'priansyah688@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'priansyah688@sman13bdg.sch.id', 'Supriansah', '0083406312', 'L', true, now(), now());
  END IF;

  -- Tarmidzi Aldy Yudhoyono (0092122625) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'tarmidzialdy@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092122625') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'tarmidzialdy@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'tarmidzialdy@sman13bdg.sch.id', 'Tarmidzi Aldy Yudhoyono', '0092122625', 'L', true, now(), now());
  END IF;

  -- Tengku Andra Rezky Putra (0156921258) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'tengkuandra@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0156921258') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'tengkuandra@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'tengkuandra@sman13bdg.sch.id', 'Tengku Andra Rezky Putra', '0156921258', 'L', true, now(), now());
  END IF;

  -- Virni Aprilianti (0089979511) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'virniapril86@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089979511') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'virniapril86@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'virniapril86@sman13bdg.sch.id', 'Virni Aprilianti', '0089979511', 'P', true, now(), now());
  END IF;

  -- Wulandari Nur Oktapiani (3088141841) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'wulandarinuroktapiani@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '3088141841') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'wulandarinuroktapiani@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'wulandarinuroktapiani@sman13bdg.sch.id', 'Wulandari Nur Oktapiani', '3088141841', 'P', true, now(), now());
  END IF;

  -- Zahra Humaira (0087530985) [XI-4]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'zayu290109@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087530985') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'zayu290109@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'zayu290109@sman13bdg.sch.id', 'Zahra Humaira', '0087530985', 'P', true, now(), now());
  END IF;

  -- Almaira Gladys Adhiswara (0093113126) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'kerinalxnder@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093113126') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'kerinalxnder@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'kerinalxnder@sman13bdg.sch.id', 'Almaira Gladys Adhiswara', '0093113126', 'P', true, now(), now());
  END IF;

  -- Alqina Silvi Syara (0083177174) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'silviir44@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083177174') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'silviir44@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'silviir44@sman13bdg.sch.id', 'Alqina Silvi Syara', '0083177174', 'P', true, now(), now());
  END IF;

  -- Aurora Nur Tsaniyyah (0088299667) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aurorant10@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088299667') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aurorant10@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aurorant10@sman13bdg.sch.id', 'Aurora Nur Tsaniyyah', '0088299667', 'P', true, now(), now());
  END IF;

  -- Azka Mayza Pratama Fidastafo (0099636755) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'azkampf33@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099636755') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'azkampf33@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'azkampf33@sman13bdg.sch.id', 'Azka Mayza Pratama Fidastafo', '0099636755', 'L', true, now(), now());
  END IF;

  -- Charisya Dinda Nur Syafira (0085700136) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'charisyadinda@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0085700136') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'charisyadinda@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'charisyadinda@sman13bdg.sch.id', 'Charisya Dinda Nur Syafira', '0085700136', 'P', true, now(), now());
  END IF;

  -- Daffa Hylmi Adlitareeq (0095383586) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'daffahylmi.net@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095383586') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'daffahylmi.net@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'daffahylmi.net@sman13bdg.sch.id', 'Daffa Hylmi Adlitareeq', '0095383586', 'L', true, now(), now());
  END IF;

  -- Eqila Qaida Alima (0097451551) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'eqilaqaidaa5@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097451551') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'eqilaqaidaa5@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'eqilaqaidaa5@sman13bdg.sch.id', 'Eqila Qaida Alima', '0097451551', 'P', true, now(), now());
  END IF;

  -- Fiqri Naufal Darussalam (0096975922) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'fiqri.naufal2021@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096975922') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'fiqri.naufal2021@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'fiqri.naufal2021@sman13bdg.sch.id', 'Fiqri Naufal Darussalam', '0096975922', 'L', true, now(), now());
  END IF;

  -- Khanza Tabina Puteri Mulyana (0091464866) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'khanzatabina30721@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091464866') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'khanzatabina30721@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'khanzatabina30721@sman13bdg.sch.id', 'Khanza Tabina Puteri Mulyana', '0091464866', 'P', true, now(), now());
  END IF;

  -- Kiagus Muhammad Hannan Baasith (0081479561) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'kiagushannan6b16@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081479561') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'kiagushannan6b16@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'kiagushannan6b16@sman13bdg.sch.id', 'Kiagus Muhammad Hannan Baasith', '0081479561', 'L', true, now(), now());
  END IF;

  -- Kirana Anditha Adzka Suryanie (0098714420) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'suryaniekirana@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098714420') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'suryaniekirana@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'suryaniekirana@sman13bdg.sch.id', 'Kirana Anditha Adzka Suryanie', '0098714420', 'P', true, now(), now());
  END IF;

  -- Marsila Rima Anggraeni (0091317479) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'marsilaanggraeni@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091317479') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'marsilaanggraeni@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'marsilaanggraeni@sman13bdg.sch.id', 'Marsila Rima Anggraeni', '0091317479', 'P', true, now(), now());
  END IF;

  -- Mercya Tirza Estefania (0094014357) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'mestefania@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094014357') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'mestefania@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'mestefania@sman13bdg.sch.id', 'Mercya Tirza Estefania', '0094014357', 'P', true, now(), now());
  END IF;

  -- Mochammad Galan Mirza Ukail (0091357338) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'dedegalsuryadi@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091357338') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'dedegalsuryadi@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'dedegalsuryadi@sman13bdg.sch.id', 'Mochammad Galan Mirza Ukail', '0091357338', 'L', true, now(), now());
  END IF;

  -- Muhammad Aflah Abidin (0098033018) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aflahabidin.cimahi@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098033018') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aflahabidin.cimahi@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aflahabidin.cimahi@sman13bdg.sch.id', 'Muhammad Aflah Abidin', '0098033018', 'L', true, now(), now());
  END IF;

  -- Muhammad Falachy Manirvaita (0094623385) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'mmanirvaita@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094623385') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'mmanirvaita@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'mmanirvaita@sman13bdg.sch.id', 'Muhammad Falachy Manirvaita', '0094623385', 'L', true, now(), now());
  END IF;

  -- Muhammad Fauzan Rahman (0094553536) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'mfauzanrahman25@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094553536') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'mfauzanrahman25@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'mfauzanrahman25@sman13bdg.sch.id', 'Muhammad Fauzan Rahman', '0094553536', 'L', true, now(), now());
  END IF;

  -- Nabil Febriansyah (0097054255) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nabilfebriansyah@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097054255') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nabilfebriansyah@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nabilfebriansyah@sman13bdg.sch.id', 'Nabil Febriansyah', '0097054255', 'L', true, now(), now());
  END IF;

  -- Nafeeza Ayu Azzahra (0096669011) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'napisbaik@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096669011') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'napisbaik@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'napisbaik@sman13bdg.sch.id', 'Nafeeza Ayu Azzahra', '0096669011', 'P', true, now(), now());
  END IF;

  -- Najla Alya (0083196924) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'alyanajla304@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083196924') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'alyanajla304@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'alyanajla304@sman13bdg.sch.id', 'Najla Alya', '0083196924', 'P', true, now(), now());
  END IF;

  -- Nazwa Amaliah Rasa (0087470024) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'amaliahrasa01@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087470024') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'amaliahrasa01@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'amaliahrasa01@sman13bdg.sch.id', 'Nazwa Amaliah Rasa', '0087470024', 'P', true, now(), now());
  END IF;

  -- Nazwa Nur Fitri Salbila (0096696904) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nazwanur@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096696904') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nazwanur@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nazwanur@sman13bdg.sch.id', 'Nazwa Nur Fitri Salbila', '0096696904', 'P', true, now(), now());
  END IF;

  -- Neysha Rabbilia Nurul Ain (0095918749) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'neysharabbilia@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095918749') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'neysharabbilia@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'neysharabbilia@sman13bdg.sch.id', 'Neysha Rabbilia Nurul Ain', '0095918749', 'P', true, now(), now());
  END IF;

  -- Nurul Fitri Ramadani (0083049231) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'anisuryani050578@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083049231') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'anisuryani050578@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'anisuryani050578@sman13bdg.sch.id', 'Nurul Fitri Ramadani', '0083049231', 'P', true, now(), now());
  END IF;

  -- Pandu Langit Prabasa (0089224605) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'pandulangit@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089224605') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'pandulangit@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'pandulangit@sman13bdg.sch.id', 'Pandu Langit Prabasa', '0089224605', 'L', true, now(), now());
  END IF;

  -- Qian Zasfa Alghifari (0091680711) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'qianzasfa0@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091680711') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'qianzasfa0@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'qianzasfa0@sman13bdg.sch.id', 'Qian Zasfa Alghifari', '0091680711', 'L', true, now(), now());
  END IF;

  -- Rabiatul Addawiyah (0098352610) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rabiatuladda@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098352610') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rabiatuladda@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rabiatuladda@sman13bdg.sch.id', 'Rabiatul Addawiyah', '0098352610', 'P', true, now(), now());
  END IF;

  -- Rafka Emirza Tazkiatul Haq (0096824108) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rafkaemirza888@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096824108') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rafkaemirza888@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rafkaemirza888@sman13bdg.sch.id', 'Rafka Emirza Tazkiatul Haq', '0096824108', 'L', true, now(), now());
  END IF;

  -- Reissyha Putri Ardhianty Ghozali (0087384082) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'reissyhap@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087384082') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'reissyhap@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'reissyhap@sman13bdg.sch.id', 'Reissyha Putri Ardhianty Ghozali', '0087384082', 'P', true, now(), now());
  END IF;

  -- Restu Gustiana Syaban (0087085579) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'restusyaban25@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087085579') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'restusyaban25@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'restusyaban25@sman13bdg.sch.id', 'Restu Gustiana Syaban', '0087085579', 'L', true, now(), now());
  END IF;

  -- Riva Suci Ramadani (0085598942) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rivasuci02@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0085598942') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rivasuci02@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rivasuci02@sman13bdg.sch.id', 'Riva Suci Ramadani', '0085598942', 'P', true, now(), now());
  END IF;

  -- Salwa Aulia (0091008138) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'auliasalwa800@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091008138') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'auliasalwa800@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'auliasalwa800@sman13bdg.sch.id', 'Salwa Aulia', '0091008138', 'P', true, now(), now());
  END IF;

  -- Siti Sarifa Nadia Salsabila (0086340312) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nadiasalsabilaa21@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0086340312') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nadiasalsabilaa21@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nadiasalsabilaa21@sman13bdg.sch.id', 'Siti Sarifa Nadia Salsabila', '0086340312', 'P', true, now(), now());
  END IF;

  -- Tia Syafitri (0098488996) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'tiasyftrr@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098488996') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'tiasyftrr@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'tiasyftrr@sman13bdg.sch.id', 'Tia Syafitri', '0098488996', 'P', true, now(), now());
  END IF;

  -- Virginia Maranata Sitorus (0094592131) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'virginiaaamaranataaa@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094592131') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'virginiaaamaranataaa@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'virginiaaamaranataaa@sman13bdg.sch.id', 'Virginia Maranata Sitorus', '0094592131', 'P', true, now(), now());
  END IF;

  -- Zahira Anaya Putri Setiadi (0096627108) [XI-5]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'anayazahira17@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096627108') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'anayazahira17@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'anayazahira17@sman13bdg.sch.id', 'Zahira Anaya Putri Setiadi', '0096627108', 'P', true, now(), now());
  END IF;

  -- Adliy Rifqi Fadhilah (0081186409) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'adlyrifki064@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081186409') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'adlyrifki064@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'adlyrifki064@sman13bdg.sch.id', 'Adliy Rifqi Fadhilah', '0081186409', 'P', true, now(), now());
  END IF;

  -- Adly Hisyam Khairullah (0086932588) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'adlyhisyam7@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0086932588') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'adlyhisyam7@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'adlyhisyam7@sman13bdg.sch.id', 'Adly Hisyam Khairullah', '0086932588', 'L', true, now(), now());
  END IF;

  -- Almira Raisa Sahira (0099878708) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'arsmira02@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099878708') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'arsmira02@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'arsmira02@sman13bdg.sch.id', 'Almira Raisa Sahira', '0099878708', 'P', true, now(), now());
  END IF;

  -- Anindita Adhya Latifa (0099961265) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aninditaadhyalatifa@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099961265') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aninditaadhyalatifa@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aninditaadhyalatifa@sman13bdg.sch.id', 'Anindita Adhya Latifa', '0099961265', 'P', true, now(), now());
  END IF;

  -- Asfia Nurfadilah (0087358290) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'asfianurfadila@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087358290') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'asfianurfadila@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'asfianurfadila@sman13bdg.sch.id', 'Asfia Nurfadilah', '0087358290', 'P', true, now(), now());
  END IF;

  -- Bayu Lintang Ababiel Cahyadi (0082183005) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'bayucahyadi1308@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0082183005') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'bayucahyadi1308@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'bayucahyadi1308@sman13bdg.sch.id', 'Bayu Lintang Ababiel Cahyadi', '0082183005', 'L', true, now(), now());
  END IF;

  -- Bianca Salma (0097926587) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'bianca@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097926587') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'bianca@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'bianca@sman13bdg.sch.id', 'Bianca Salma', '0097926587', 'P', true, now(), now());
  END IF;

  -- Davin Raisa Ahsyanny (0082783372) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'davinraisa18@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0082783372') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'davinraisa18@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'davinraisa18@sman13bdg.sch.id', 'Davin Raisa Ahsyanny', '0082783372', 'L', true, now(), now());
  END IF;

  -- Desyiffa Salsabila (0084332997) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'desyiffasalsabilla@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0084332997') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'desyiffasalsabilla@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'desyiffasalsabilla@sman13bdg.sch.id', 'Desyiffa Salsabila', '0084332997', 'P', true, now(), now());
  END IF;

  -- Diaz Fitri Azimah (0088623278) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'fitriazimah15@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088623278') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'fitriazimah15@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'fitriazimah15@sman13bdg.sch.id', 'Diaz Fitri Azimah', '0088623278', 'P', true, now(), now());
  END IF;

  -- Elin Herlina Ramadani (0084050958) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'elinherlinaana@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0084050958') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'elinherlinaana@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'elinherlinaana@sman13bdg.sch.id', 'Elin Herlina Ramadani', '0084050958', 'P', true, now(), now());
  END IF;

  -- Febiano (0096231111) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'febianoajah@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096231111') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'febianoajah@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'febianoajah@sman13bdg.sch.id', 'Febiano', '0096231111', 'L', true, now(), now());
  END IF;

  -- Haura Ainun Mahya (0087910499) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'mahyahaura06@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087910499') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'mahyahaura06@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'mahyahaura06@sman13bdg.sch.id', 'Haura Ainun Mahya', '0087910499', 'P', true, now(), now());
  END IF;

  -- Janitra Maha Dewi (3096360862) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'janitradewi@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '3096360862') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'janitradewi@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'janitradewi@sman13bdg.sch.id', 'Janitra Maha Dewi', '3096360862', 'P', true, now(), now());
  END IF;

  -- Kamila Avrilianingtyas (0098806088) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'kamilaavrilianingtyas@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098806088') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'kamilaavrilianingtyas@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'kamilaavrilianingtyas@sman13bdg.sch.id', 'Kamila Avrilianingtyas', '0098806088', 'P', true, now(), now());
  END IF;

  -- Kania Bunga Pertiwi (0087484824) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'kania.bp888@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087484824') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'kania.bp888@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'kania.bp888@sman13bdg.sch.id', 'Kania Bunga Pertiwi', '0087484824', 'P', true, now(), now());
  END IF;

  -- Muhamad Caesar Abimanyu (0095846898) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'muhamadcaesar09@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095846898') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'muhamadcaesar09@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'muhamadcaesar09@sman13bdg.sch.id', 'Muhamad Caesar Abimanyu', '0095846898', 'L', true, now(), now());
  END IF;

  -- Muhammad Ascha Razanatha Dhurandarra Edward (0081353285) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ascharazanatha08@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081353285') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ascharazanatha08@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ascharazanatha08@sman13bdg.sch.id', 'Muhammad Ascha Razanatha Dhurandarra Edward', '0081353285', 'L', true, now(), now());
  END IF;

  -- Muhammad Fahri Alfarizi (0099681137) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'fahrialfa999@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099681137') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'fahrialfa999@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'fahrialfa999@sman13bdg.sch.id', 'Muhammad Fahri Alfarizi', '0099681137', 'L', true, now(), now());
  END IF;

  -- Muhammad Ichsan Ramadhan (0084154165) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'm.ikhsanramadhan1990@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0084154165') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'm.ikhsanramadhan1990@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'm.ikhsanramadhan1990@sman13bdg.sch.id', 'Muhammad Ichsan Ramadhan', '0084154165', 'L', true, now(), now());
  END IF;

  -- Muhammad Luffianda Ferdinand (0092882100) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'luffiandaf@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092882100') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'luffiandaf@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'luffiandaf@sman13bdg.sch.id', 'Muhammad Luffianda Ferdinand', '0092882100', 'L', true, now(), now());
  END IF;

  -- Muhammad Rakha Athaya Rahmandhiya (0087733731) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rakhaathaya465@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087733731') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rakhaathaya465@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rakhaathaya465@sman13bdg.sch.id', 'Muhammad Rakha Athaya Rahmandhiya', '0087733731', 'L', true, now(), now());
  END IF;

  -- Muhammad Reyhan Putra Zulkarnain (0099566260) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'mreyhanp@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099566260') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'mreyhanp@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'mreyhanp@sman13bdg.sch.id', 'Muhammad Reyhan Putra Zulkarnain', '0099566260', 'L', true, now(), now());
  END IF;

  -- Nadia Sri Nuraisah (0089250553) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'srinuraisahnadia@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089250553') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'srinuraisahnadia@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'srinuraisahnadia@sman13bdg.sch.id', 'Nadia Sri Nuraisah', '0089250553', 'P', true, now(), now());
  END IF;

  -- Naila Ro''uf Nur Zakiya (0093390563) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nailarouf65@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093390563') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nailarouf65@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nailarouf65@sman13bdg.sch.id', 'Naila Ro''uf Nur Zakiya', '0093390563', 'P', true, now(), now());
  END IF;

  -- Rafa Fauziah (0085486373) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rafafauziah400@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0085486373') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rafafauziah400@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rafafauziah400@sman13bdg.sch.id', 'Rafa Fauziah', '0085486373', 'P', true, now(), now());
  END IF;

  -- Rahmi Sulaeman (0086949825) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rahmisulaeman052@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0086949825') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rahmisulaeman052@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rahmisulaeman052@sman13bdg.sch.id', 'Rahmi Sulaeman', '0086949825', 'P', true, now(), now());
  END IF;

  -- Rasya Ramadhan Pratama M. (0089384410) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'abangrasya2000@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089384410') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'abangrasya2000@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'abangrasya2000@sman13bdg.sch.id', 'Rasya Ramadhan Pratama M.', '0089384410', 'L', true, now(), now());
  END IF;

  -- Renan Adhisa Hafiz (3085831558) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'renannanas69@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '3085831558') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'renannanas69@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'renannanas69@sman13bdg.sch.id', 'Renan Adhisa Hafiz', '3085831558', 'L', true, now(), now());
  END IF;

  -- Rifki Ari Ramdani (0088718613) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rramdani@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088718613') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rramdani@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rramdani@sman13bdg.sch.id', 'Rifki Ari Ramdani', '0088718613', 'L', true, now(), now());
  END IF;

  -- Rineza Fazyahumaira Amshal (0085904568) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ramshal@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0085904568') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ramshal@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ramshal@sman13bdg.sch.id', 'Rineza Fazyahumaira Amshal', '0085904568', 'P', true, now(), now());
  END IF;

  -- Sabrina Khaira Putri (0084094873) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'sabrinakhaira08@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0084094873') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'sabrinakhaira08@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'sabrinakhaira08@sman13bdg.sch.id', 'Sabrina Khaira Putri', '0084094873', 'P', true, now(), now());
  END IF;

  -- Sule Sulaeman (0081619218) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'sulesulaeman1611@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081619218') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'sulesulaeman1611@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'sulesulaeman1611@sman13bdg.sch.id', 'Sule Sulaeman', '0081619218', 'L', true, now(), now());
  END IF;

  -- Syandria Revani Syahbania Anansyah (0081906630) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'syandriarevani23@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081906630') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'syandriarevani23@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'syandriarevani23@sman13bdg.sch.id', 'Syandria Revani Syahbania Anansyah', '0081906630', 'P', true, now(), now());
  END IF;

  -- Windy Korli (0093309233) [XI-6]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'febriyantiwindyayu@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093309233') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'febriyantiwindyayu@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'febriyantiwindyayu@sman13bdg.sch.id', 'Windy Korli', '0093309233', 'P', true, now(), now());
  END IF;

  -- Adrian Mahlon Tua Pardomuan (0078679565) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'asitanggang@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0078679565') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'asitanggang@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'asitanggang@sman13bdg.sch.id', 'Adrian Mahlon Tua Pardomuan', '0078679565', 'L', true, now(), now());
  END IF;

  -- Ahmad Ariz Zakariya (0088840375) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ahmadarizz346@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088840375') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ahmadarizz346@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ahmadarizz346@sman13bdg.sch.id', 'Ahmad Ariz Zakariya', '0088840375', 'L', true, now(), now());
  END IF;

  -- Alfin Darmawan (0098763089) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'alfindarma@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098763089') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'alfindarma@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'alfindarma@sman13bdg.sch.id', 'Alfin Darmawan', '0098763089', 'L', true, now(), now());
  END IF;

  -- Ananda Saputri (0085275159) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'saputriananda796@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0085275159') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'saputriananda796@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'saputriananda796@sman13bdg.sch.id', 'Ananda Saputri', '0085275159', 'P', true, now(), now());
  END IF;

  -- Annisa Fahira Maharani (0095150920) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'amaharani@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095150920') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'amaharani@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'amaharani@sman13bdg.sch.id', 'Annisa Fahira Maharani', '0095150920', 'P', true, now(), now());
  END IF;

  -- Ardiansyah (0079792230) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ardiansyah@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0079792230') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ardiansyah@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ardiansyah@sman13bdg.sch.id', 'Ardiansyah', '0079792230', 'L', true, now(), now());
  END IF;

  -- Athaar Qadharullah Nasruddin (3086152544) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'athaarq1@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '3086152544') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'athaarq1@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'athaarq1@sman13bdg.sch.id', 'Athaar Qadharullah Nasruddin', '3086152544', 'L', true, now(), now());
  END IF;

  -- Aulia Fanni Syafitri (0089652132) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'auliafanni2008@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089652132') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'auliafanni2008@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'auliafanni2008@sman13bdg.sch.id', 'Aulia Fanni Syafitri', '0089652132', 'P', true, now(), now());
  END IF;

  -- Azka Ghaisani Ahmad Putri (0092244478) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'vedderdoea@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092244478') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'vedderdoea@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'vedderdoea@sman13bdg.sch.id', 'Azka Ghaisani Ahmad Putri', '0092244478', 'L', true, now(), now());
  END IF;

  -- Berliana Novianti (0082170305) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'berliananovi@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0082170305') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'berliananovi@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'berliananovi@sman13bdg.sch.id', 'Berliana Novianti', '0082170305', 'P', true, now(), now());
  END IF;

  -- Butsainah Salma (0085846297) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'butsainahsalmaa@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0085846297') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'butsainahsalmaa@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'butsainahsalmaa@sman13bdg.sch.id', 'Butsainah Salma', '0085846297', 'P', true, now(), now());
  END IF;

  -- Calista Amira Yusuf (0091299273) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'calistaamira23@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091299273') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'calistaamira23@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'calistaamira23@sman13bdg.sch.id', 'Calista Amira Yusuf', '0091299273', 'P', true, now(), now());
  END IF;

  -- Celsy Putria Yustiani (0095803546) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'celsyputria@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095803546') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'celsyputria@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'celsyputria@sman13bdg.sch.id', 'Celsy Putria Yustiani', '0095803546', 'P', true, now(), now());
  END IF;

  -- Cindy Aulia Putri (0088953741) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'cputri@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088953741') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'cputri@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'cputri@sman13bdg.sch.id', 'Cindy Aulia Putri', '0088953741', 'P', true, now(), now());
  END IF;

  -- Dimas Cetta Aryasatya Wastu Ilham (0086527715) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'dimasaryasatya15@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0086527715') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'dimasaryasatya15@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'dimasaryasatya15@sman13bdg.sch.id', 'Dimas Cetta Aryasatya Wastu Ilham', '0086527715', 'L', true, now(), now());
  END IF;

  -- Dirana Kei Aqueena (0091710805) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'daqueena@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091710805') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'daqueena@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'daqueena@sman13bdg.sch.id', 'Dirana Kei Aqueena', '0091710805', 'P', true, now(), now());
  END IF;

  -- Elia Priadi Putra (0075460992) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'eliapriadiputra1@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0075460992') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'eliapriadiputra1@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'eliapriadiputra1@sman13bdg.sch.id', 'Elia Priadi Putra', '0075460992', 'L', true, now(), now());
  END IF;

  -- Elvaretta Lintya Zahirah (0093045596) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'elvarettaaa30@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093045596') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'elvarettaaa30@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'elvarettaaa30@sman13bdg.sch.id', 'Elvaretta Lintya Zahirah', '0093045596', 'P', true, now(), now());
  END IF;

  -- Gian Fajar Ramadhan (0089698113) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'gramadhan@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089698113') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'gramadhan@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'gramadhan@sman13bdg.sch.id', 'Gian Fajar Ramadhan', '0089698113', 'L', true, now(), now());
  END IF;

  -- Juli Cinta Fauzia (0092801863) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'julicinta@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092801863') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'julicinta@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'julicinta@sman13bdg.sch.id', 'Juli Cinta Fauzia', '0092801863', 'P', true, now(), now());
  END IF;

  -- Keisha Nadhira Suherly (0091308780) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'keishanadhira@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091308780') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'keishanadhira@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'keishanadhira@sman13bdg.sch.id', 'Keisha Nadhira Suherly', '0091308780', 'P', true, now(), now());
  END IF;

  -- Muhamad Arvisyah Pratama Putra (0093713254) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'arvipratama6@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093713254') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'arvipratama6@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'arvipratama6@sman13bdg.sch.id', 'Muhamad Arvisyah Pratama Putra', '0093713254', 'L', true, now(), now());
  END IF;

  -- Muhamad Yoga Pratama (0083951115) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'myogapratama@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083951115') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'myogapratama@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'myogapratama@sman13bdg.sch.id', 'Muhamad Yoga Pratama', '0083951115', 'L', true, now(), now());
  END IF;

  -- Muhamad Yogi Pradita (0081426575) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'yogimuhamad979@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081426575') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'yogimuhamad979@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'yogimuhamad979@sman13bdg.sch.id', 'Muhamad Yogi Pradita', '0081426575', 'L', true, now(), now());
  END IF;

  -- Muhammad Azzarel Bintang Setiadi (0088582784) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'mazzarel@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088582784') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'mazzarel@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'mazzarel@sman13bdg.sch.id', 'Muhammad Azzarel Bintang Setiadi', '0088582784', 'L', true, now(), now());
  END IF;

  -- Muhammad Nabil Aryapraja (0089733050) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nabilaryapraja@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089733050') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nabilaryapraja@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nabilaryapraja@sman13bdg.sch.id', 'Muhammad Nabil Aryapraja', '0089733050', 'L', true, now(), now());
  END IF;

  -- Muhammad Rizki Nur Ilham (0077300922) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rizkinurilham306@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0077300922') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rizkinurilham306@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rizkinurilham306@sman13bdg.sch.id', 'Muhammad Rizki Nur Ilham', '0077300922', 'L', true, now(), now());
  END IF;

  -- Nabila Agnia Putri (0102190790) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nabila@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0102190790') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nabila@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nabila@sman13bdg.sch.id', 'Nabila Agnia Putri', '0102190790', 'P', true, now(), now());
  END IF;

  -- Rafid Adhipramana Aryaguna (0099139467) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'radhipramana9@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099139467') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'radhipramana9@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'radhipramana9@sman13bdg.sch.id', 'Rafid Adhipramana Aryaguna', '0099139467', 'L', true, now(), now());
  END IF;

  -- Raysha Ramadhan Muliawan (0076737356) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rmadhansyhaa@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0076737356') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rmadhansyhaa@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rmadhansyhaa@sman13bdg.sch.id', 'Raysha Ramadhan Muliawan', '0076737356', 'L', true, now(), now());
  END IF;

  -- Renaldini Kwini (0087887967) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'renaldinikwini@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087887967') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'renaldinikwini@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'renaldinikwini@sman13bdg.sch.id', 'Renaldini Kwini', '0087887967', 'L', true, now(), now());
  END IF;

  -- Rianri Dwi Rahima (0095401427) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'dwirahimariri@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095401427') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'dwirahimariri@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'dwirahimariri@sman13bdg.sch.id', 'Rianri Dwi Rahima', '0095401427', 'P', true, now(), now());
  END IF;

  -- Seruni Hasna Fitriyani (0081764532) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'serunihasna@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081764532') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'serunihasna@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'serunihasna@sman13bdg.sch.id', 'Seruni Hasna Fitriyani', '0081764532', 'P', true, now(), now());
  END IF;

  -- Stevannie Aprillia Putri (0087150130) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'sputri@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087150130') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'sputri@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'sputri@sman13bdg.sch.id', 'Stevannie Aprillia Putri', '0087150130', 'P', true, now(), now());
  END IF;

  -- Sultan Fallah Saeeduzzaman (0083057535) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'sultanflh44@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083057535') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'sultanflh44@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'sultanflh44@sman13bdg.sch.id', 'Sultan Fallah Saeeduzzaman', '0083057535', 'L', true, now(), now());
  END IF;

  -- Windy Ayu Febriyanti (0096077767) [XI-7]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'krlwindy789@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096077767') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'krlwindy789@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'krlwindy789@sman13bdg.sch.id', 'Windy Ayu Febriyanti', '0096077767', 'P', true, now(), now());
  END IF;

  -- Aba Shalmahat (0079009586) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ashalamahat@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0079009586') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ashalamahat@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ashalamahat@sman13bdg.sch.id', 'Aba Shalmahat', '0079009586', 'L', true, now(), now());
  END IF;

  -- Ailsya Kirania Yusral (0091472126) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ailsyaky23@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091472126') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ailsyaky23@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ailsyaky23@sman13bdg.sch.id', 'Ailsya Kirania Yusral', '0091472126', 'P', true, now(), now());
  END IF;

  -- Anggi Khaerunisa Adhasari (0088791278) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'khaerunisaanggi@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088791278') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'khaerunisaanggi@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'khaerunisaanggi@sman13bdg.sch.id', 'Anggi Khaerunisa Adhasari', '0088791278', 'P', true, now(), now());
  END IF;

  -- Aquila Megumi Kurniawan (3098844606) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aquilamegumi99@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '3098844606') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aquilamegumi99@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aquilamegumi99@sman13bdg.sch.id', 'Aquila Megumi Kurniawan', '3098844606', 'P', true, now(), now());
  END IF;

  -- Azalia Putri Yasmin (0096013145) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'azaliaputriyasminn@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096013145') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'azaliaputriyasminn@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'azaliaputriyasminn@sman13bdg.sch.id', 'Azalia Putri Yasmin', '0096013145', 'P', true, now(), now());
  END IF;

  -- Azwa Zahira Hermawan (0095863072) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'azhraazwa@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095863072') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'azhraazwa@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'azhraazwa@sman13bdg.sch.id', 'Azwa Zahira Hermawan', '0095863072', 'P', true, now(), now());
  END IF;

  -- Chery Raida Hasya (0089476991) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'chasya@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089476991') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'chasya@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'chasya@sman13bdg.sch.id', 'Chery Raida Hasya', '0089476991', 'P', true, now(), now());
  END IF;

  -- Daffina Aufa Azalia (0097451916) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'daffina280109@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097451916') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'daffina280109@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'daffina280109@sman13bdg.sch.id', 'Daffina Aufa Azalia', '0097451916', 'P', true, now(), now());
  END IF;

  -- Devita Oktaviani (0081073412) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'devitaoktaviani36@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081073412') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'devitaoktaviani36@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'devitaoktaviani36@sman13bdg.sch.id', 'Devita Oktaviani', '0081073412', 'P', true, now(), now());
  END IF;

  -- Fairuz Putria Irawan (0087080377) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'fairuzputria021@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087080377') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'fairuzputria021@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'fairuzputria021@sman13bdg.sch.id', 'Fairuz Putria Irawan', '0087080377', 'L', true, now(), now());
  END IF;

  -- Farel Novandika (0093385349) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'farelakbar@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093385349') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'farelakbar@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'farelakbar@sman13bdg.sch.id', 'Farel Novandika', '0093385349', 'L', true, now(), now());
  END IF;

  -- Firjatulloh Ibnu Trianggoro (0087836967) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ibnuthohir8@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087836967') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ibnuthohir8@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ibnuthohir8@sman13bdg.sch.id', 'Firjatulloh Ibnu Trianggoro', '0087836967', 'L', true, now(), now());
  END IF;

  -- Hadi Baihaqi Ibrahim (0093610867) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'hadi.baihaqiibra@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093610867') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'hadi.baihaqiibra@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'hadi.baihaqiibra@sman13bdg.sch.id', 'Hadi Baihaqi Ibrahim', '0093610867', 'L', true, now(), now());
  END IF;

  -- Hasna Tsania Ramadhani (0093506466) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ramadhanihasna336@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093506466') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ramadhanihasna336@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ramadhanihasna336@sman13bdg.sch.id', 'Hasna Tsania Ramadhani', '0093506466', 'P', true, now(), now());
  END IF;

  -- Karina Agustin Daniah (0086851375) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'karinaagustin239@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0086851375') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'karinaagustin239@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'karinaagustin239@sman13bdg.sch.id', 'Karina Agustin Daniah', '0086851375', 'P', true, now(), now());
  END IF;

  -- Karissa Putri Damayanti (0093573164) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'putridamayantikarissa@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093573164') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'putridamayantikarissa@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'putridamayantikarissa@sman13bdg.sch.id', 'Karissa Putri Damayanti', '0093573164', 'P', true, now(), now());
  END IF;

  -- Kesha Nur Aprilia (0083280515) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'kaprilia@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083280515') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'kaprilia@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'kaprilia@sman13bdg.sch.id', 'Kesha Nur Aprilia', '0083280515', 'P', true, now(), now());
  END IF;

  -- Keysha Ayudiafajr (0087798887) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'kayudiafajr@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087798887') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'kayudiafajr@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'kayudiafajr@sman13bdg.sch.id', 'Keysha Ayudiafajr', '0087798887', 'P', true, now(), now());
  END IF;

  -- Khairunisa Dayana Latifah (0092475850) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'khairunisadayana67@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092475850') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'khairunisadayana67@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'khairunisadayana67@sman13bdg.sch.id', 'Khairunisa Dayana Latifah', '0092475850', 'P', true, now(), now());
  END IF;

  -- Khalisya Queena Sampurno (0081255077) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ksampurno@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081255077') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ksampurno@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ksampurno@sman13bdg.sch.id', 'Khalisya Queena Sampurno', '0081255077', 'P', true, now(), now());
  END IF;

  -- Marcell Arij Wahibathuf (0087494331) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'marcellstranger@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087494331') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'marcellstranger@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'marcellstranger@sman13bdg.sch.id', 'Marcell Arij Wahibathuf', '0087494331', 'L', true, now(), now());
  END IF;

  -- Muhamad Fariz Syahreza (0099440010) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'farizsyahrezasururi@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099440010') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'farizsyahrezasururi@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'farizsyahrezasururi@sman13bdg.sch.id', 'Muhamad Fariz Syahreza', '0099440010', 'L', true, now(), now());
  END IF;

  -- Muhammad Nazril Ilham (0107605799) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'muhammadnazril824@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0107605799') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'muhammadnazril824@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'muhammadnazril824@sman13bdg.sch.id', 'Muhammad Nazril Ilham', '0107605799', 'L', true, now(), now());
  END IF;

  -- Muhammad Nazril Ilham (0087715936) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'muhammadnazril824@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087715936') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'muhammadnazril824@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'muhammadnazril824@sman13bdg.sch.id', 'Muhammad Nazril Ilham', '0087715936', 'L', true, now(), now());
  END IF;

  -- Muhammad Rafi Hakim (0083189007) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'mhakim@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083189007') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'mhakim@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'mhakim@sman13bdg.sch.id', 'Muhammad Rafi Hakim', '0083189007', 'L', true, now(), now());
  END IF;

  -- Nazwa Meilani (0096005890) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nazwameilani@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096005890') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nazwameilani@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nazwameilani@sman13bdg.sch.id', 'Nazwa Meilani', '0096005890', 'P', true, now(), now());
  END IF;

  -- Nisrina Naila (0073781464) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nisrinanayla64@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0073781464') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nisrinanayla64@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nisrinanayla64@sman13bdg.sch.id', 'Nisrina Naila', '0073781464', 'P', true, now(), now());
  END IF;

  -- Nur Suci Atma (0097585814) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'sucinuratma@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097585814') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'sucinuratma@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'sucinuratma@sman13bdg.sch.id', 'Nur Suci Atma', '0097585814', 'P', true, now(), now());
  END IF;

  -- Risya Siti Barokah (0083566428) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'risyas071@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083566428') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'risyas071@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'risyas071@sman13bdg.sch.id', 'Risya Siti Barokah', '0083566428', 'P', true, now(), now());
  END IF;

  -- Roofi Nurazizah (0086336864) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'roofinurazizah08@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0086336864') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'roofinurazizah08@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'roofinurazizah08@sman13bdg.sch.id', 'Roofi Nurazizah', '0086336864', 'P', true, now(), now());
  END IF;

  -- Sabina Ghaliya (0083761151) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'sabinaghal@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083761151') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'sabinaghal@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'sabinaghal@sman13bdg.sch.id', 'Sabina Ghaliya', '0083761151', 'P', true, now(), now());
  END IF;

  -- Siti Mar''atussalama (0093794534) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'maratussalamasiti@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093794534') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'maratussalamasiti@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'maratussalamasiti@sman13bdg.sch.id', 'Siti Mar''atussalama', '0093794534', 'P', true, now(), now());
  END IF;

  -- Syifa Salsabila (0078594113) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'khairunnisyahsyifa@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0078594113') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'khairunnisyahsyifa@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'khairunnisyahsyifa@sman13bdg.sch.id', 'Syifa Salsabila', '0078594113', 'P', true, now(), now());
  END IF;

  -- Tazkiya Nafs Gardeani (0098666683) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'tazkiyanafs712@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098666683') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'tazkiyanafs712@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'tazkiyanafs712@sman13bdg.sch.id', 'Tazkiya Nafs Gardeani', '0098666683', 'P', true, now(), now());
  END IF;

  -- Theresia Debora Simbolon (0096801429) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'tsimbolon@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096801429') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'tsimbolon@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'tsimbolon@sman13bdg.sch.id', 'Theresia Debora Simbolon', '0096801429', 'P', true, now(), now());
  END IF;

  -- Zaidan Maulana Adhiswara (0093300779) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'zaidanmaul@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093300779') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'zaidanmaul@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'zaidanmaul@sman13bdg.sch.id', 'Zaidan Maulana Adhiswara', '0093300779', 'L', true, now(), now());
  END IF;

  -- Zhesicha Freinceast Darmawan (0099549401) [XI-8]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'kyeshanoura@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099549401') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'kyeshanoura@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'kyeshanoura@sman13bdg.sch.id', 'Zhesicha Freinceast Darmawan', '0099549401', 'L', true, now(), now());
  END IF;

  -- Agnia Isfiraini (0099007202) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'agniisfi21@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099007202') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'agniisfi21@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'agniisfi21@sman13bdg.sch.id', 'Agnia Isfiraini', '0099007202', 'P', true, now(), now());
  END IF;

  -- Alisa Mounira (0081069514) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'alisamounira573@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081069514') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'alisamounira573@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'alisamounira573@sman13bdg.sch.id', 'Alisa Mounira', '0081069514', 'P', true, now(), now());
  END IF;

  -- Alya Izzah Amany (0096503148) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'alyaizzah@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096503148') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'alyaizzah@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'alyaizzah@sman13bdg.sch.id', 'Alya Izzah Amany', '0096503148', 'P', true, now(), now());
  END IF;

  -- Angel Carolina Chandra (0084124676) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'angelcarolina702@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0084124676') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'angelcarolina702@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'angelcarolina702@sman13bdg.sch.id', 'Angel Carolina Chandra', '0084124676', 'P', true, now(), now());
  END IF;

  -- Azka Syadza Nur Hanifah (0098286909) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'azkasyadza@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098286909') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'azkasyadza@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'azkasyadza@sman13bdg.sch.id', 'Azka Syadza Nur Hanifah', '0098286909', 'P', true, now(), now());
  END IF;

  -- Besta Novitasari (0083605206) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'besta13@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083605206') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'besta13@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'besta13@sman13bdg.sch.id', 'Besta Novitasari', '0083605206', 'P', true, now(), now());
  END IF;

  -- Cheisya Putri Apriliyani (0099407261) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'cheisyaputri756@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0099407261') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'cheisyaputri756@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'cheisyaputri756@sman13bdg.sch.id', 'Cheisya Putri Apriliyani', '0099407261', 'P', true, now(), now());
  END IF;

  -- Elfariani Putri Amelia (0086062975) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'elfariani116@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0086062975') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'elfariani116@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'elfariani116@sman13bdg.sch.id', 'Elfariani Putri Amelia', '0086062975', 'P', true, now(), now());
  END IF;

  -- Fillia Lestary (0081642905) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'fillialestary@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081642905') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'fillialestary@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'fillialestary@sman13bdg.sch.id', 'Fillia Lestary', '0081642905', 'P', true, now(), now());
  END IF;

  -- Genia Putri Pratama (0083202241) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'pratamagenia@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083202241') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'pratamagenia@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'pratamagenia@sman13bdg.sch.id', 'Genia Putri Pratama', '0083202241', 'L', true, now(), now());
  END IF;

  -- Ibrahim Vesile Budiman (0094592651) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ibra.vesile060299@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094592651') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'ibra.vesile060299@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'ibra.vesile060299@sman13bdg.sch.id', 'Ibrahim Vesile Budiman', '0094592651', 'L', true, now(), now());
  END IF;

  -- Jihan Nur Maulidya (0092153536) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'jihannurmaulidya33@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092153536') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'jihannurmaulidya33@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'jihannurmaulidya33@sman13bdg.sch.id', 'Jihan Nur Maulidya', '0092153536', 'L', true, now(), now());
  END IF;

  -- Kaila Iliyinisa (0097243803) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'kailailiyin@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097243803') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'kailailiyin@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'kailailiyin@sman13bdg.sch.id', 'Kaila Iliyinisa', '0097243803', 'P', true, now(), now());
  END IF;

  -- Khansa Nazhirah (0098657251) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'khansanazirahh@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098657251') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'khansanazirahh@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'khansanazirahh@sman13bdg.sch.id', 'Khansa Nazhirah', '0098657251', 'P', true, now(), now());
  END IF;

  -- Lathifah Zahra (0091949915) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'lathifazahra56@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091949915') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'lathifazahra56@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'lathifazahra56@sman13bdg.sch.id', 'Lathifah Zahra', '0091949915', 'P', true, now(), now());
  END IF;

  -- Melati Fauzah Lestari (0097326410) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'fauzahlestarimelati@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097326410') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'fauzahlestarimelati@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'fauzahlestarimelati@sman13bdg.sch.id', 'Melati Fauzah Lestari', '0097326410', 'P', true, now(), now());
  END IF;

  -- Melvin Hylmi Naufalianto (0084647919) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'kuya54970@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0084647919') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'kuya54970@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'kuya54970@sman13bdg.sch.id', 'Melvin Hylmi Naufalianto', '0084647919', 'L', true, now(), now());
  END IF;

  -- Muhammad Razaan Rialdy Iskandar (0097930344) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'razaanrialdy@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097930344') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'razaanrialdy@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'razaanrialdy@sman13bdg.sch.id', 'Muhammad Razaan Rialdy Iskandar', '0097930344', 'L', true, now(), now());
  END IF;

  -- Nanda Keisha Nur Aini (0098557325) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nandaakeishanurr28@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098557325') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nandaakeishanurr28@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nandaakeishanurr28@sman13bdg.sch.id', 'Nanda Keisha Nur Aini', '0098557325', 'P', true, now(), now());
  END IF;

  -- Naufal Dzaky Darmanshah (0095433212) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'naufaldzaky@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095433212') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'naufaldzaky@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'naufaldzaky@sman13bdg.sch.id', 'Naufal Dzaky Darmanshah', '0095433212', 'L', true, now(), now());
  END IF;

  -- Nesa Laelatul Kodriyah (0086286412) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nesanisa819@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0086286412') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nesanisa819@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nesanisa819@sman13bdg.sch.id', 'Nesa Laelatul Kodriyah', '0086286412', 'P', true, now(), now());
  END IF;

  -- Noval Ferdian Ilhami (0081725195) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nopalgabisamain23@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081725195') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nopalgabisamain23@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nopalgabisamain23@sman13bdg.sch.id', 'Noval Ferdian Ilhami', '0081725195', 'L', true, now(), now());
  END IF;

  -- Raden Balqies Alya Raihanna Al Bakkar (0092968686) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rdbalqies@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092968686') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rdbalqies@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rdbalqies@sman13bdg.sch.id', 'Raden Balqies Alya Raihanna Al Bakkar', '0092968686', 'P', true, now(), now());
  END IF;

  -- Rafi Yudistira Menjerang (0093458006) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rafiyudistira409@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093458006') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rafiyudistira409@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rafiyudistira409@sman13bdg.sch.id', 'Rafi Yudistira Menjerang', '0093458006', 'L', true, now(), now());
  END IF;

  -- Rahma Sulaeman (0082078809) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rahmasulaeman078@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0082078809') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rahmasulaeman078@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rahmasulaeman078@sman13bdg.sch.id', 'Rahma Sulaeman', '0082078809', 'P', true, now(), now());
  END IF;

  -- Raisya Aslianda Parmana (0091729412) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'raisyaaslianda95@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091729412') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'raisyaaslianda95@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'raisyaaslianda95@sman13bdg.sch.id', 'Raisya Aslianda Parmana', '0091729412', 'P', true, now(), now());
  END IF;

  -- Rheva Dea Syafira (0087370376) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rdea969@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087370376') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rdea969@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rdea969@sman13bdg.sch.id', 'Rheva Dea Syafira', '0087370376', 'P', true, now(), now());
  END IF;

  -- Rizval Ramdandi Sentosa (0088365307) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rizvalramdandi63@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088365307') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rizvalramdandi63@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rizvalramdandi63@sman13bdg.sch.id', 'Rizval Ramdandi Sentosa', '0088365307', 'L', true, now(), now());
  END IF;

  -- Salman Dafani Ramadhan (0082804480) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'salmandavani@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0082804480') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'salmandavani@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'salmandavani@sman13bdg.sch.id', 'Salman Dafani Ramadhan', '0082804480', 'L', true, now(), now());
  END IF;

  -- Satria Adi Wibowo Sakrianto (0088833446) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'satria.adi@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088833446') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'satria.adi@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'satria.adi@sman13bdg.sch.id', 'Satria Adi Wibowo Sakrianto', '0088833446', 'L', true, now(), now());
  END IF;

  -- Talitha Nur Kholidah (0086653085) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'thalitanur01@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0086653085') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'thalitanur01@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'thalitanur01@sman13bdg.sch.id', 'Talitha Nur Kholidah', '0086653085', 'P', true, now(), now());
  END IF;

  -- Tubagus Rexan Putra Ayla (0081295064) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'sanzemong@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081295064') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'sanzemong@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'sanzemong@sman13bdg.sch.id', 'Tubagus Rexan Putra Ayla', '0081295064', 'L', true, now(), now());
  END IF;

  -- Wishnu Dwitama (0096366586) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'dwitamawishnu@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096366586') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'dwitamawishnu@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'dwitamawishnu@sman13bdg.sch.id', 'Wishnu Dwitama', '0096366586', 'L', true, now(), now());
  END IF;

  -- Yulia Astila Putri Fuadi (0085072517) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'yuliaastila25@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0085072517') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'yuliaastila25@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'yuliaastila25@sman13bdg.sch.id', 'Yulia Astila Putri Fuadi', '0085072517', 'P', true, now(), now());
  END IF;

  -- Zahra Ayu Lestari (0093598610) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'zahraaul@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0093598610') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'zahraaul@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'zahraaul@sman13bdg.sch.id', 'Zahra Ayu Lestari', '0093598610', 'P', true, now(), now());
  END IF;

  -- Zulviana Eka Putri (0097063142) [XI-9]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'zulvianaputri351@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097063142') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'zulvianaputri351@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'zulvianaputri351@sman13bdg.sch.id', 'Zulviana Eka Putri', '0097063142', 'P', true, now(), now());
  END IF;

  -- Algian Syukuridwan (0088468705) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'algiansyukuridwan123@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088468705') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'algiansyukuridwan123@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'algiansyukuridwan123@sman13bdg.sch.id', 'Algian Syukuridwan', '0088468705', 'L', true, now(), now());
  END IF;

  -- Alifa Aghnia Qolbi (0084362721) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'alifaaghniaqolbi@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0084362721') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'alifaaghniaqolbi@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'alifaaghniaqolbi@sman13bdg.sch.id', 'Alifa Aghnia Qolbi', '0084362721', 'P', true, now(), now());
  END IF;

  -- Amiera Verrisha Utamy (0089374484) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'amieraverrisha@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089374484') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'amieraverrisha@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'amieraverrisha@sman13bdg.sch.id', 'Amiera Verrisha Utamy', '0089374484', 'P', true, now(), now());
  END IF;

  -- Andre Agustian Firdaus (0089370910) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'afa071866@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089370910') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'afa071866@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'afa071866@sman13bdg.sch.id', 'Andre Agustian Firdaus', '0089370910', 'L', true, now(), now());
  END IF;

  -- Anisa Siti Saidah (0087459845) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'anisasitisaidah@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087459845') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'anisasitisaidah@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'anisasitisaidah@sman13bdg.sch.id', 'Anisa Siti Saidah', '0087459845', 'P', true, now(), now());
  END IF;

  -- Aqila Arkana (0084247091) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aqilaarkana07@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0084247091') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aqilaarkana07@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aqilaarkana07@sman13bdg.sch.id', 'Aqila Arkana', '0084247091', 'P', true, now(), now());
  END IF;

  -- Asyiffa Putri Gunawan (3098048730) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'agunawan@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '3098048730') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'agunawan@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'agunawan@sman13bdg.sch.id', 'Asyiffa Putri Gunawan', '3098048730', 'L', true, now(), now());
  END IF;

  -- Asyiffa Putri Gunawan (3098048730) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'asyiffaputri@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '3098048730') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'asyiffaputri@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'asyiffaputri@sman13bdg.sch.id', 'Asyiffa Putri Gunawan', '3098048730', 'L', true, now(), now());
  END IF;

  -- Asyyfa Alya Ramadhany (0086930027) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'asyf.alyr@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0086930027') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'asyf.alyr@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'asyf.alyr@sman13bdg.sch.id', 'Asyyfa Alya Ramadhany', '0086930027', 'P', true, now(), now());
  END IF;

  -- Aurel Salsabilah Putri (0098126640) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aurelsalsabilah@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098126640') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aurelsalsabilah@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aurelsalsabilah@sman13bdg.sch.id', 'Aurel Salsabilah Putri', '0098126640', 'P', true, now(), now());
  END IF;

  -- Aurellia Putri Permatasari (0094458582) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aurelliaputripermatasari0506@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0094458582') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aurelliaputripermatasari0506@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aurelliaputripermatasari0506@sman13bdg.sch.id', 'Aurellia Putri Permatasari', '0094458582', 'P', true, now(), now());
  END IF;

  -- Aysa Rifha Amalyah (0089273796) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aamalyah@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089273796') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aamalyah@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aamalyah@sman13bdg.sch.id', 'Aysa Rifha Amalyah', '0089273796', 'P', true, now(), now());
  END IF;

  -- Deliya Fauziyyah (0098617909) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'fauziyyah@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098617909') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'fauziyyah@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'fauziyyah@sman13bdg.sch.id', 'Deliya Fauziyyah', '0098617909', 'P', true, now(), now());
  END IF;

  -- Davilo Ockan Andrea (0087406621) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'dandrea@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087406621') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'dandrea@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'dandrea@sman13bdg.sch.id', 'Davilo Ockan Andrea', '0087406621', 'L', true, now(), now());
  END IF;

  -- Davina Oktaviana (0081757505) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'davinaokta@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081757505') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'davinaokta@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'davinaokta@sman13bdg.sch.id', 'Davina Oktaviana', '0081757505', 'L', true, now(), now());
  END IF;

  -- Dedi Surjana (0088194704) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'dedzbang3@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0088194704') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'dedzbang3@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'dedzbang3@sman13bdg.sch.id', 'Dedi Surjana', '0088194704', 'L', true, now(), now());
  END IF;

  -- Dimas Satria Pratama (0083458341) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'satriapratamadimas9@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0083458341') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'satriapratamadimas9@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'satriapratamadimas9@sman13bdg.sch.id', 'Dimas Satria Pratama', '0083458341', 'L', true, now(), now());
  END IF;

  -- Dini Apriyani (0081739092) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'diniapriyani@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081739092') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'diniapriyani@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'diniapriyani@sman13bdg.sch.id', 'Dini Apriyani', '0081739092', 'P', true, now(), now());
  END IF;

  -- Firdan Ramadan (0081607959) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'firdanramadan21@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0081607959') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'firdanramadan21@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'firdanramadan21@sman13bdg.sch.id', 'Firdan Ramadan', '0081607959', 'L', true, now(), now());
  END IF;

  -- Hanan Rumi (0089548215) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'hananrumi13@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089548215') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'hananrumi13@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'hananrumi13@sman13bdg.sch.id', 'Hanan Rumi', '0089548215', 'P', true, now(), now());
  END IF;

  -- Inayah Mustafidah Nur Aulia (0095095375) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'inayahmustafidah70@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0095095375') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'inayahmustafidah70@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'inayahmustafidah70@sman13bdg.sch.id', 'Inayah Mustafidah Nur Aulia', '0095095375', 'P', true, now(), now());
  END IF;

  -- Irens Indah Dewi (0087141409) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'irensindah@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087141409') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'irensindah@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'irensindah@sman13bdg.sch.id', 'Irens Indah Dewi', '0087141409', 'P', true, now(), now());
  END IF;

  -- Karissa Lieza Putri (0091238541) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'karissaliezaputri@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0091238541') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'karissaliezaputri@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'karissaliezaputri@sman13bdg.sch.id', 'Karissa Lieza Putri', '0091238541', 'P', true, now(), now());
  END IF;

  -- Keila Kama Jaya (0096169234) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'keilakamajay@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0096169234') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'keilakamajay@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'keilakamajay@sman13bdg.sch.id', 'Keila Kama Jaya', '0096169234', 'P', true, now(), now());
  END IF;

  -- Maya Meijesta (0089690282) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'meijestamaya@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0089690282') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'meijestamaya@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'meijestamaya@sman13bdg.sch.id', 'Maya Meijesta', '0089690282', 'P', true, now(), now());
  END IF;

  -- Meiliza Kusnaidi (0085251664) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'meilizakusnaidi@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0085251664') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'meilizakusnaidi@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'meilizakusnaidi@sman13bdg.sch.id', 'Meiliza Kusnaidi', '0085251664', 'P', true, now(), now());
  END IF;

  -- Mochamad Calvin Alfiansah (3096257488) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'malfiansyah@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '3096257488') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'malfiansyah@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'malfiansyah@sman13bdg.sch.id', 'Mochamad Calvin Alfiansah', '3096257488', 'L', true, now(), now());
  END IF;

  -- Nazwa Devi Sulistiawan (0082613544) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'nazwadevi04@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0082613544') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'nazwadevi04@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'nazwadevi04@sman13bdg.sch.id', 'Nazwa Devi Sulistiawan', '0082613544', 'P', true, now(), now());
  END IF;

  -- Nazwa Nayra Putri Machda (0085259009) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'putrinadzwa779@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0085259009') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'putrinadzwa779@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'putrinadzwa779@sman13bdg.sch.id', 'Nazwa Nayra Putri Machda', '0085259009', 'P', true, now(), now());
  END IF;

  -- Neng Aisyah (0098034055) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'aisyahneng007@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098034055') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'aisyahneng007@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'aisyahneng007@sman13bdg.sch.id', 'Neng Aisyah', '0098034055', 'P', true, now(), now());
  END IF;

  -- Rasya Alfiansyah (0087150577) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rasyaravikal7@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0087150577') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rasyaravikal7@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rasyaravikal7@sman13bdg.sch.id', 'Rasya Alfiansyah', '0087150577', 'L', true, now(), now());
  END IF;

  -- Riska Juniarti (0097911684) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'trianir450@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097911684') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'trianir450@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'trianir450@sman13bdg.sch.id', 'Riska Juniarti', '0097911684', 'P', true, now(), now());
  END IF;

  -- Riski (0086191320) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'rizkyy28100@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0086191320') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'rizkyy28100@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'rizkyy28100@sman13bdg.sch.id', 'Riski', '0086191320', 'L', true, now(), now());
  END IF;

  -- Ruzaina Lathifah Huwaida (0092605743) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'na.rzna18@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0092605743') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'na.rzna18@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'na.rzna18@sman13bdg.sch.id', 'Ruzaina Lathifah Huwaida', '0092605743', 'P', true, now(), now());
  END IF;

  -- Sazkya Reskya Danadi (0098625717) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'sdanadi@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0098625717') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'sdanadi@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'sdanadi@sman13bdg.sch.id', 'Sazkya Reskya Danadi', '0098625717', 'P', true, now(), now());
  END IF;

  -- Wina Febrianti (0097858366) [XI-10]
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'febriantiwina29@sman13bdg.sch.id')
     AND NOT EXISTS (SELECT 1 FROM public.profiles WHERE nisn = '0097858366') THEN
    v_uid := gen_random_uuid();
    INSERT INTO auth.users (
      id, instance_id, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      is_super_admin, role, aud
    ) VALUES (
      v_uid, '00000000-0000-0000-0000-000000000000',
      'febriantiwina29@sman13bdg.sch.id',
      crypt('SiPandu123!', gen_salt('bf')),
      now(), now(), now(),
      jsonb_build_object('provider','email','providers',array['email']),
      jsonb_build_object('role','student'),
      false, 'authenticated', 'authenticated'
    );
    INSERT INTO public.profiles (id, role, email, full_name, nisn, gender, is_active, created_at, updated_at)
    VALUES (v_uid, 'student', 'febriantiwina29@sman13bdg.sch.id', 'Wina Febrianti', '0097858366', 'P', true, now(), now());
  END IF;

END $$;

-- ============================================================
-- SELESAI. Verifikasi:
-- SELECT COUNT(*) FROM public.profiles WHERE role = 'student';
-- ============================================================