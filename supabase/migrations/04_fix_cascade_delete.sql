-- ============================================================
-- Migration 04: Fix FK ON DELETE untuk mendukung penghapusan siswa
-- ============================================================
-- Masalah: Beberapa FK constraint menggunakan ON DELETE RESTRICT
-- sehingga siswa yang memiliki data (enrollment, peer review, dll)
-- tidak bisa dihapus via auth.admin.deleteUser().
--
-- Perubahan:
--   1. student_class_enrollments.student_id     RESTRICT → CASCADE
--      (hapus siswa = hapus semua data enrollment & turunannya)
--   2. peer_review_submissions.reviewer_id      RESTRICT → CASCADE
--      (hapus siswa = hapus data peer review yang dia berikan)
--   3. peer_review_submissions.reviewee_id      RESTRICT → CASCADE
--      (hapus siswa = hapus data peer review yang dia terima)
--   4. student_narrative_notes.written_by       RESTRICT → SET NULL
--      (catatan tetap ada tapi pencatat jadi NULL)
-- ============================================================

BEGIN;

-- 1. student_class_enrollments.student_id: RESTRICT → CASCADE
ALTER TABLE public.student_class_enrollments
  DROP CONSTRAINT IF EXISTS student_class_enrollments_student_id_fkey;

ALTER TABLE public.student_class_enrollments
  ADD CONSTRAINT student_class_enrollments_student_id_fkey
  FOREIGN KEY (student_id)
  REFERENCES public.profiles(id)
  ON DELETE CASCADE;

-- 2. peer_review_submissions.reviewer_id: RESTRICT → CASCADE
ALTER TABLE public.peer_review_submissions
  DROP CONSTRAINT IF EXISTS peer_review_submissions_reviewer_id_fkey;

ALTER TABLE public.peer_review_submissions
  ADD CONSTRAINT peer_review_submissions_reviewer_id_fkey
  FOREIGN KEY (reviewer_id)
  REFERENCES public.profiles(id)
  ON DELETE CASCADE;

-- 3. peer_review_submissions.reviewee_id: RESTRICT → CASCADE
ALTER TABLE public.peer_review_submissions
  DROP CONSTRAINT IF EXISTS peer_review_submissions_reviewee_id_fkey;

ALTER TABLE public.peer_review_submissions
  ADD CONSTRAINT peer_review_submissions_reviewee_id_fkey
  FOREIGN KEY (reviewee_id)
  REFERENCES public.profiles(id)
  ON DELETE CASCADE;

-- 4. student_narrative_notes.written_by: RESTRICT → SET NULL
ALTER TABLE public.student_narrative_notes
  DROP CONSTRAINT IF EXISTS student_narrative_notes_written_by_fkey;

ALTER TABLE public.student_narrative_notes
  ADD CONSTRAINT student_narrative_notes_written_by_fkey
  FOREIGN KEY (written_by)
  REFERENCES public.profiles(id)
  ON DELETE SET NULL;

COMMIT;
