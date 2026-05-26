-- ============================================================
-- Migration 02 — school_settings
-- Tabel key-value untuk konfigurasi sekolah (nama kepala sekolah, NIP, dll.)
-- Jalankan di Supabase SQL Editor setelah 01_migration.sql.
-- ============================================================

CREATE TABLE IF NOT EXISTS public.school_settings (
  key   TEXT PRIMARY KEY,
  value TEXT NOT NULL DEFAULT ''
);

-- Nilai default (boleh diubah via halaman Konfigurasi Fuzzy → Pengaturan Sekolah)
INSERT INTO public.school_settings (key, value)
VALUES
  ('principal_name', ''),
  ('principal_nip',  '')
ON CONFLICT (key) DO NOTHING;

-- RLS: semua user login bisa SELECT, hanya admin yang bisa ubah
ALTER TABLE public.school_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY school_settings_read ON public.school_settings
  FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY school_settings_admin ON public.school_settings
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());
