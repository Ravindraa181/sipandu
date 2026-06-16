-- ═══════════════════════════════════════════════════════════════════════════
--  SiPandu — Migration 05
--  Tujuan : Tambah tabel peer_review_assignments untuk mekanisme
--           random subset (setiap siswa menilai tepat 5 teman acak).
--  Cara   : Supabase → SQL Editor → Run
-- ═══════════════════════════════════════════════════════════════════════════

-- ── Tabel peer_review_assignments ────────────────────────────────────────
-- Menyimpan pasangan (reviewer → reviewee) yang ditugaskan sistem saat
-- guru membuka sesi. Setiap reviewer mendapat tepat PEER_REVIEW_SUBSET_SIZE
-- reviewee yang dipilih secara acak dari anggota kelas.

CREATE TABLE IF NOT EXISTS public.peer_review_assignments (
  id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id    UUID        NOT NULL REFERENCES public.peer_review_sessions(id) ON DELETE CASCADE,
  reviewer_id   UUID        NOT NULL REFERENCES public.profiles(id)             ON DELETE CASCADE,
  reviewee_id   UUID        NOT NULL REFERENCES public.profiles(id)             ON DELETE CASCADE,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_peer_assign       UNIQUE  (session_id, reviewer_id, reviewee_id),
  CONSTRAINT chk_no_self_assign   CHECK   (reviewer_id <> reviewee_id)
);

COMMENT ON TABLE public.peer_review_assignments IS
  'Pasangan reviewer→reviewee yang ditugaskan sistem (random subset 5 teman).';

-- Index untuk lookup cepat (siapa saja yang harus dinilai seorang reviewer)
CREATE INDEX IF NOT EXISTS idx_pra_session_reviewer
  ON public.peer_review_assignments (session_id, reviewer_id);

-- Index untuk lookup sebaliknya (siapa saja yang akan menilai seorang reviewee)
CREATE INDEX IF NOT EXISTS idx_pra_session_reviewee
  ON public.peer_review_assignments (session_id, reviewee_id);

-- ── RLS ──────────────────────────────────────────────────────────────────
ALTER TABLE public.peer_review_assignments ENABLE ROW LEVEL SECURITY;

-- Siswa hanya boleh lihat assignment milik dirinya sendiri (sebagai reviewer)
CREATE POLICY "pra_student_select_own"
  ON public.peer_review_assignments FOR SELECT
  USING (
    reviewer_id = auth.uid()
    AND public.is_student()
  );

-- Guru & admin boleh lihat semua assignment di kelas mereka
CREATE POLICY "pra_teacher_admin_select"
  ON public.peer_review_assignments FOR SELECT
  USING (
    public.is_admin()
    OR public.is_teacher()
  );

-- INSERT hanya boleh via service role (dilakukan saat openPeerSession)
-- Tidak ada policy INSERT untuk user biasa — service role bypass RLS.
