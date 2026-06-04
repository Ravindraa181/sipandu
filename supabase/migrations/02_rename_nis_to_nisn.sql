-- ═══════════════════════════════════════════════════════════════════════════
--  SiPandu — Migrasi 02: Rename kolom NIS → NISN
--  Tujuan : Mengganti identifier siswa dari NIS (Nomor Induk Siswa internal
--           sekolah) menjadi NISN (Nomor Induk Siswa Nasional, 10 digit).
--  Cara pakai : Buka Supabase → SQL Editor → New Query → Paste → Run.
--  Idempotent : Aman dijalankan ulang (cek keberadaan kolom dulu).
--
--  CATATAN: Jalankan migrasi ini HANYA untuk database yang sudah terlanjur
--           dibuat dengan skema lama (kolom `nis`). Untuk instalasi baru,
--           01_migration.sql sudah memakai kolom `nisn` langsung.
-- ═══════════════════════════════════════════════════════════════════════════

DO $$
BEGIN
  -- Hanya rename bila kolom lama `nis` masih ada dan `nisn` belum ada
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'profiles' AND column_name = 'nis'
  ) AND NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'profiles' AND column_name = 'nisn'
  ) THEN

    -- 1. Rename kolom nis → nisn (data lama tetap terbawa)
    ALTER TABLE public.profiles RENAME COLUMN nis TO nisn;

    -- 2. Perbarui constraint CHECK (nama lama → nama baru)
    ALTER TABLE public.profiles DROP CONSTRAINT IF EXISTS chk_student_has_nis;
    ALTER TABLE public.profiles
      ADD CONSTRAINT chk_student_has_nisn CHECK (role <> 'student' OR nisn IS NOT NULL);

    RAISE NOTICE '✓ Kolom nis berhasil di-rename menjadi nisn.';
  ELSE
    RAISE NOTICE '⚠ Skip: kolom nis tidak ditemukan atau nisn sudah ada.';
  END IF;
END $$;

-- 3. (Opsional) Perketat panjang menjadi 10 digit khas NISN.
--    Dijalankan terpisah agar tidak gagal bila ada data lama >10 karakter.
--    Hapus komentar baris di bawah HANYA setelah memastikan semua data
--    siswa sudah berformat 10 digit.
-- ALTER TABLE public.profiles ALTER COLUMN nisn TYPE VARCHAR(10);

-- ═══════════════════════════════════════════════════════════════════════════
-- Verifikasi cepat
-- ═══════════════════════════════════════════════════════════════════════════
DO $$
BEGIN
  RAISE NOTICE 'Kolom NISN ada : %', (
    SELECT EXISTS (
      SELECT 1 FROM information_schema.columns
      WHERE table_schema = 'public' AND table_name = 'profiles' AND column_name = 'nisn'
    )
  );
END $$;
