-- ═══════════════════════════════════════════════════════════════════════════
--  SiPandu — Migrasi 03: Tabel konfigurasi aspek Peer Assessment
--  Tujuan : Memindahkan LABEL & DESKRIPSI 5 aspek peer review dari hardcode
--           (konstanta) ke database, agar bisa dikelola admin lewat UI.
--
--  PENTING: Ini HANYA mengatur label & deskripsi yang ditampilkan ke siswa.
--           Jumlah aspek TETAP 5 dan kunci (aspect_key) TETAP, karena terikat
--           ke 5 kolom skor di peer_review_submissions dan trigger X3.
--           Perhitungan X3 (rata-rata 5 aspek × 20) TIDAK berubah.
--
--  Cara pakai : Buka Supabase → SQL Editor → New Query → Paste → Run.
--  Idempotent : Aman dijalankan ulang (CREATE IF NOT EXISTS + ON CONFLICT).
-- ═══════════════════════════════════════════════════════════════════════════

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ── 1. Tabel ────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.peer_review_aspects (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  aspect_key    VARCHAR(20)  NOT NULL UNIQUE,
  label         VARCHAR(100) NOT NULL,
  description   TEXT         NOT NULL,
  display_order SMALLINT     NOT NULL,
  updated_at    TIMESTAMPTZ  NOT NULL DEFAULT now(),
  updated_by    UUID         NULL REFERENCES public.profiles(id) ON DELETE SET NULL,

  -- Kunci aspek dikunci ke 5 nilai yang sama dengan kolom skor di
  -- peer_review_submissions — admin TIDAK boleh menambah/menghapus aspek.
  CONSTRAINT chk_aspect_key CHECK (
    aspect_key IN ('courtesy','cooperation','empathy','honesty','responsibility')
  )
);

COMMENT ON TABLE public.peer_review_aspects IS
  'Label & deskripsi 5 aspek peer assessment (dapat diedit admin). Kunci & jumlah tetap.';

-- ── 2. Trigger updated_at (pakai fungsi yang sudah ada dari migrasi 01) ──────
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'set_updated_at')
     AND NOT EXISTS (
       SELECT 1 FROM pg_trigger WHERE tgname = 'trg_peer_review_aspects_updated_at'
     ) THEN
    CREATE TRIGGER trg_peer_review_aspects_updated_at
      BEFORE UPDATE ON public.peer_review_aspects
      FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
  END IF;
END $$;

-- ── 3. Row Level Security ────────────────────────────────────────────────────
ALTER TABLE public.peer_review_aspects ENABLE ROW LEVEL SECURITY;

-- Semua pengguna terautentikasi boleh membaca (siswa butuh untuk render form).
DROP POLICY IF EXISTS aspects_select_authenticated ON public.peer_review_aspects;
CREATE POLICY aspects_select_authenticated ON public.peer_review_aspects
  FOR SELECT USING (auth.uid() IS NOT NULL);

-- Hanya admin yang boleh mengubah.
DROP POLICY IF EXISTS aspects_admin_write ON public.peer_review_aspects;
CREATE POLICY aspects_admin_write ON public.peer_review_aspects
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── 4. Seed 5 aspek default (sama dengan konstanta PEER_REVIEW_ASPECTS) ──────
INSERT INTO public.peer_review_aspects (aspect_key, label, description, display_order) VALUES
  ('courtesy',       'Kesantunan & Sopan Santun',
   'Seberapa sopan siswa ini dalam berbicara dan bersikap kepada guru dan teman-teman?', 1),
  ('cooperation',    'Gotong Royong & Kerja Sama',
   'Seberapa aktif siswa ini dalam kerja kelompok dan membantu teman yang kesulitan?', 2),
  ('empathy',        'Empati & Kepedulian',
   'Seberapa peka siswa ini terhadap perasaan dan kondisi teman di sekitarnya?', 3),
  ('honesty',        'Kejujuran',
   'Seberapa jujur siswa ini dalam kegiatan belajar sehari-hari?', 4),
  ('responsibility', 'Tanggung Jawab',
   'Seberapa bertanggung jawab siswa ini dengan tugas, kewajiban, dan janjinya?', 5)
ON CONFLICT (aspect_key) DO NOTHING;  -- jangan timpa edit admin saat re-run

-- ── Verifikasi ───────────────────────────────────────────────────────────────
DO $$
BEGIN
  RAISE NOTICE 'Jumlah aspek peer review: %', (SELECT count(*) FROM public.peer_review_aspects);
END $$;
