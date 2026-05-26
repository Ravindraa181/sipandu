/**
 * @file lib/actions/student.ts
 * @description Server Actions untuk role Siswa SiPandu.
 *
 *  Patch 7.7.3 sudah diterapkan — nama kolom DB yang benar:
 *   - peer_review_sessions      → class_period_assignment_id (bukan class_period_assignment_id)
 *   - student_class_enrollments → class_period_assignment_id
 *
 *  Opsi A untuk savePeerReviewDraft (rekomendasi panduan):
 *   Fungsi ini TIDAK diimplementasikan — draft dipertahankan di state
 *   browser (Zustand / useState) saja, sehingga tidak perlu kolom
 *   draft_data di DB.
 */

'use server';

import { z } from 'zod';

import { createClient, createServiceRoleClient } from '@/lib/supabase/server';
import { getStudentContext } from '@/lib/student/getStudentContext';

/* ─────────────────────────────────────────────────────────────────────
 *  Tipe kembalian standar
 * ───────────────────────────────────────────────────────────────────── */

type ActionResult<T = undefined> =
  | { ok: true; data?: T }
  | { ok: false; error: string };

/* ═══════════════════════════════════════════════════════════════════
 *  PEER REVIEW — Submit Rating
 * ═══════════════════════════════════════════════════════════════════ */

const aspectScale = z.number().int().min(1).max(5);

const submitRatingSchema = z.object({
  sessionId: z.string().uuid(),
  revieweeId: z.string().uuid(),
  scores: z.object({
    courtesy: aspectScale,
    cooperation: aspectScale,
    empathy: aspectScale,
    honesty: aspectScale,
    responsibility: aspectScale,
  }),
});

/**
 * Submit atau perbarui penilaian peer review satu siswa.
 *
 * Alur:
 *  1. Validasi sesi aktif & deadline.
 *  2. Validasi reviewer & reviewee sekelas (via class_period_assignment_id).
 *  3. Cek apakah sudah pernah submit:
 *     - Belum → INSERT baru + increment progress.
 *     - Sudah  → UPDATE skor (service role) + jangan ubah progress.
 *  4. INSERT/UPDATE ke peer_review_submissions.
 *  5. UPSERT peer_review_progress reviewer.
 *
 * Patch: gunakan `class_period_assignment_id` (bukan `class_period_assignment_id`)
 *        saat join student_class_enrollments → peer_review_sessions.
 */
export async function submitPeerReviewRating(
  input: z.infer<typeof submitRatingSchema>,
): Promise<ActionResult<{ nextRevieweeId: string | null; isEdit: boolean }>> {
  try {
    const parsed = submitRatingSchema.parse(input);
    const supabase = await createClient();
    const admin = await createServiceRoleClient();

    // Ambil student context (reviewer)
    const ctx = await getStudentContext();
    if (!ctx) return { ok: false, error: 'Sesi siswa tidak ditemukan, silakan login ulang' };

    const reviewerId = ctx.studentId;

    if (reviewerId === parsed.revieweeId) {
      return { ok: false, error: 'Tidak boleh menilai diri sendiri' };
    }

    // 1. Validasi sesi: aktif & deadline belum lewat
    const { data: session, error: sErr } = await supabase
      .from('peer_review_sessions')
      .select('id, status, deadline, class_period_assignment_id')  // PATCH
      .eq('id', parsed.sessionId)
      .maybeSingle();

    if (sErr || !session) {
      return { ok: false, error: 'Sesi peer review tidak ditemukan' };
    }
    if (session.status !== 'active') {
      return { ok: false, error: 'Sesi peer review tidak sedang aktif' };
    }
    if (session.deadline) {
      const deadlineDate = new Date(`${session.deadline}T23:59:59`);
      if (deadlineDate.getTime() < Date.now()) {
        return { ok: false, error: 'Deadline peer review sudah lewat' };
      }
    }

    const assignmentId = session.class_period_assignment_id as string;  // PATCH

    // 2. Validasi reviewer & reviewee sekelas
    const { data: enrolls, error: eErr } = await admin
      .from('student_class_enrollments')
      .select('student_id')
      .eq('class_period_assignment_id', assignmentId)               // PATCH
      .eq('status', 'active')
      .in('student_id', [reviewerId, parsed.revieweeId]);

    if (eErr) {
      return { ok: false, error: `Gagal validasi keanggotaan kelas: ${eErr.message}` };
    }

    const memberIds = new Set(
      (enrolls ?? []).map((e) => (e as { student_id: string }).student_id),
    );
    if (!memberIds.has(reviewerId) || !memberIds.has(parsed.revieweeId)) {
      return { ok: false, error: 'Reviewer dan reviewee harus berada di kelas yang sama' };
    }

    // 3. Cek apakah sudah pernah submit untuk reviewee ini
    // ALASAN: service role wajib — RLS memblokir SELECT peer_review_submissions untuk siswa
    const { data: existing } = await admin
      .from('peer_review_submissions')
      .select('id')
      .eq('session_id', parsed.sessionId)
      .eq('reviewer_id', reviewerId)
      .eq('reviewee_id', parsed.revieweeId)
      .maybeSingle();

    const isEdit = Boolean(existing);
    const scorePayload = {
      score_courtesy: parsed.scores.courtesy,
      score_cooperation: parsed.scores.cooperation,
      score_empathy: parsed.scores.empathy,
      score_honesty: parsed.scores.honesty,
      score_responsibility: parsed.scores.responsibility,
    };

    if (isEdit) {
      // 4a. UPDATE submission yang sudah ada (koreksi nilai)
      // ALASAN: siswa tidak punya UPDATE policy → service role wajib
      const { error: uErr } = await admin
        .from('peer_review_submissions')
        .update({ ...scorePayload, submitted_at: new Date().toISOString() })
        .eq('id', (existing as { id: string }).id);

      if (uErr) {
        return { ok: false, error: `Gagal memperbarui penilaian: ${uErr.message}` };
      }
    } else {
      // 4b. INSERT submission baru
      const { error: iErr } = await admin.from('peer_review_submissions').insert({
        session_id: parsed.sessionId,
        reviewer_id: reviewerId,
        reviewee_id: parsed.revieweeId,
        ...scorePayload,
      });

      if (iErr) {
        return { ok: false, error: `Gagal menyimpan penilaian: ${iErr.message}` };
      }
    }

    // 5. Update progress reviewer (hanya untuk submit baru, bukan edit)
    // ALASAN: progress sudah dihitung saat submit pertama — jangan increment dua kali
    const totalCount = Math.max(memberIds.size - 1, 0);
    if (!isEdit) {
      const { data: progress } = await admin
        .from('peer_review_progress')
        .select('id, completed_count')
        .eq('session_id', parsed.sessionId)
        .eq('student_id', reviewerId)
        .maybeSingle();

      if (progress) {
        const completedCount = (progress.completed_count as number | undefined) ?? 0;
        await admin
          .from('peer_review_progress')
          .update({
            completed_count: Math.min(completedCount + 1, totalCount),
            last_updated: new Date().toISOString(),
          })
          .eq('id', progress.id as string);
      } else {
        await admin.from('peer_review_progress').insert({
          session_id: parsed.sessionId,
          student_id: reviewerId,
          completed_count: 1,
          total_count: totalCount,
        });
      }
    }

    // 6. Hitung X3 parsial untuk reviewee
    await recomputePartialX3(admin, parsed.sessionId, parsed.revieweeId);

    // 7. Tentukan reviewee berikutnya (hanya relevan saat submit baru, bukan edit)
    const allCandidates = Array.from(memberIds).filter((id) => id !== reviewerId);
    const nextRevieweeId = isEdit
      ? null  // Saat edit: tetap di reviewee yang sama, tidak maju
      : await pickNextReviewee(admin, parsed.sessionId, reviewerId, allCandidates);

    return { ok: true, data: { nextRevieweeId, isEdit } };
  } catch (err) {
    return { ok: false, error: err instanceof Error ? err.message : 'Error tidak diketahui' };
  }
}

/* ═══════════════════════════════════════════════════════════════════
 *  GET sesi peer review aktif untuk siswa
 * ═══════════════════════════════════════════════════════════════════ */

/**
 * Ambil sesi peer review aktif untuk kelas siswa.
 * Patch: join lewat `class_period_assignment_id` (bukan `class_period_assignment_id`).
 */
export async function getActivePeerSession(): Promise<
  ActionResult<{
    sessionId: string;
    deadline: string | null;
    classmates: Array<{ id: string; fullName: string }>;
    submittedIds: string[];
    progress: { completed: number; total: number };
  }>
> {
  try {
    const ctx = await getStudentContext();
    if (!ctx) return { ok: false, error: 'Konteks siswa tidak ditemukan' };

    const supabase = await createClient();
    const admin = await createServiceRoleClient();

    // Cari sesi aktif di assignment kelas siswa
    const { data: session } = await supabase
      .from('peer_review_sessions')
      .select('id, status, deadline, class_period_assignment_id')  // PATCH
      .eq('class_period_assignment_id', ctx.assignmentId)          // PATCH
      .eq('status', 'active')
      .maybeSingle();

    if (!session) return { ok: false, error: 'Tidak ada sesi peer review aktif' };

    // Ambil daftar teman sekelas
    const { data: enrolls } = await admin
      .from('student_class_enrollments')
      .select('student_id, profiles!inner(full_name)')
      .eq('class_period_assignment_id', ctx.assignmentId)          // PATCH
      .eq('status', 'active')
      .neq('student_id', ctx.studentId);

    type EnrollRow = { student_id: string; profiles: { full_name: string } };
    const classmates = (enrolls ?? []).map((e) => {
      const row = e as unknown as EnrollRow;
      return {
        id: row.student_id,
        fullName: row.profiles.full_name,
      };
    });

    // Ambil submission yang sudah dilakukan
    const { data: submitted } = await admin
      .from('peer_review_submissions')
      .select('reviewee_id')
      .eq('session_id', session.id as string)
      .eq('reviewer_id', ctx.studentId);

    const submittedIds = (submitted ?? []).map(
      (s) => (s as { reviewee_id: string }).reviewee_id,
    );

    // Progress
    const { data: prog } = await admin
      .from('peer_review_progress')
      .select('completed_count, total_count')
      .eq('session_id', session.id as string)
      .eq('student_id', ctx.studentId)
      .maybeSingle();

    return {
      ok: true,
      data: {
        sessionId: session.id as string,
        deadline: session.deadline as string | null,
        classmates,
        submittedIds,
        progress: {
          completed: (prog?.completed_count as number | undefined) ?? 0,
          total: (prog?.total_count as number | undefined) ?? classmates.length,
        },
      },
    };
  } catch (err) {
    return { ok: false, error: err instanceof Error ? err.message : 'Error tidak diketahui' };
  }
}

/* ─────────────────────────────────────────────────────────────────────
 *  Helper: hitung ulang X3 parsial untuk satu reviewee
 * ───────────────────────────────────────────────────────────────────── */

async function recomputePartialX3(
  admin: Awaited<ReturnType<typeof createServiceRoleClient>>,
  sessionId: string,
  revieweeId: string,
): Promise<void> {
  const { data: subs } = await admin
    .from('peer_review_submissions')
    .select(
      'score_courtesy, score_cooperation, score_empathy, score_honesty, score_responsibility',
    )
    .eq('session_id', sessionId)
    .eq('reviewee_id', revieweeId);

  type SubRow = {
    score_courtesy: number;
    score_cooperation: number;
    score_empathy: number;
    score_honesty: number;
    score_responsibility: number;
  };
  const rows = (subs ?? []) as SubRow[];
  if (rows.length === 0) return;

  const n = rows.length;
  const sum = rows.reduce(
    (acc, r) => ({
      c: acc.c + r.score_courtesy,
      coop: acc.coop + r.score_cooperation,
      e: acc.e + r.score_empathy,
      h: acc.h + r.score_honesty,
      r: acc.r + r.score_responsibility,
    }),
    { c: 0, coop: 0, e: 0, h: 0, r: 0 },
  );

  const x3 = (((sum.c + sum.coop + sum.e + sum.h + sum.r) / n) / 5) * 20;

  await admin.from('student_x3_scores').upsert(
    {
      session_id: sessionId,
      student_id: revieweeId,
      x3_score: Number(x3.toFixed(2)),
      avg_courtesy: Number((sum.c / n).toFixed(2)),
      avg_cooperation: Number((sum.coop / n).toFixed(2)),
      avg_empathy: Number((sum.e / n).toFixed(2)),
      avg_honesty: Number((sum.h / n).toFixed(2)),
      avg_responsibility: Number((sum.r / n).toFixed(2)),
      reviewer_count: n,
      computed_at: null,
    },
    { onConflict: 'session_id,student_id' },
  );
}

/* ─────────────────────────────────────────────────────────────────────
 *  Helper: pilih reviewee berikutnya
 * ───────────────────────────────────────────────────────────────────── */

async function pickNextReviewee(
  admin: Awaited<ReturnType<typeof createServiceRoleClient>>,
  sessionId: string,
  reviewerId: string,
  candidateIds: string[],
): Promise<string | null> {
  if (candidateIds.length === 0) return null;

  const { data: done } = await admin
    .from('peer_review_submissions')
    .select('reviewee_id')
    .eq('session_id', sessionId)
    .eq('reviewer_id', reviewerId);

  const doneSet = new Set(
    (done ?? []).map((d) => (d as { reviewee_id: string }).reviewee_id),
  );

  const remaining = candidateIds.filter((id) => !doneSet.has(id));
  if (remaining.length === 0) return null;
  remaining.sort();
  return remaining[0] ?? null;
}
