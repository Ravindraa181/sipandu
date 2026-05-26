/**
 * @file app/api/peer-review/submit/route.ts
 * @description Endpoint submit peer review oleh siswa.
 *
 *  Auth: hanya student (caller = reviewer).
 *
 *  Validasi:
 *   1. Sesi peer review harus berstatus 'active' & deadline belum lewat.
 *   2. Reviewee harus sekelas dengan reviewer pada periode aktif.
 *   3. Reviewer belum pernah submit untuk reviewee ini di sesi yang sama.
 *   4. Reviewer ≠ reviewee.
 *
 *  Body:
 *      {
 *        sessionId: uuid,
 *        revieweeId: uuid,
 *        scores: {
 *          courtesy: 1..5,
 *          cooperation: 1..5,
 *          empathy: 1..5,
 *          honesty: 1..5,
 *          responsibility: 1..5,
 *        }
 *      }
 *
 *  Catatan privasi (NF-04, F-03 di SYSTEM_CONTEXT §7.2):
 *   - Tabel `peer_review_submissions` MEMANG menyimpan `reviewer_id`
 *     (untuk FK & uniqueness), tetapi RLS di DB melarang
 *     siswa membaca kolom tersebut. Endpoint ini menulis lewat
 *     service-role client agar konsisten.
 *
 *  Response:
 *      { ok: true, data: { success: true, nextRevieweeId: uuid|null } }
 */

import { type NextRequest } from 'next/server';
import { z } from 'zod';

import { fail, failFromUnknown, ok } from '../../_lib/response';
import { assertStudent } from '../../_lib/auth';
import {
  createClient,
  createServiceRoleClient,
} from '@/lib/supabase/server';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/* ────────────────────────────────────────────────────────────────────
 *  Schema
 * ──────────────────────────────────────────────────────────────────── */

const aspectScale = z.number().int().min(1).max(5);

const submitSchema = z.object({
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

interface SuccessBody {
  success: true;
  nextRevieweeId: string | null;
}

/* ────────────────────────────────────────────────────────────────────
 *  Handler POST
 * ──────────────────────────────────────────────────────────────────── */

export async function POST(req: NextRequest) {
  try {
    const reviewer = await assertStudent();

    const json = await req.json().catch(() => null);
    if (!json) return fail('Body request bukan JSON yang valid', 400);

    const parsed = submitSchema.safeParse(json);
    if (!parsed.success) return failFromUnknown(parsed.error);

    const { sessionId, revieweeId, scores } = parsed.data;

    if (reviewer.id === revieweeId) {
      return fail('Tidak boleh menilai diri sendiri', 400);
    }

    const supabase = await createClient();
    const admin = await createServiceRoleClient();

    // ── 1. Validasi sesi: aktif & deadline belum lewat ────────────
    const { data: session, error: sErr } = await supabase
      .from('peer_review_sessions')
      .select('id, status, deadline, class_period_assignment_id')
      .eq('id', sessionId)
      .maybeSingle();

    if (sErr || !session) {
      return fail('Sesi peer review tidak ditemukan', 404);
    }
    if (session.status !== 'active') {
      return fail('Sesi peer review tidak sedang aktif', 400);
    }
    if (session.deadline) {
      const deadlineDate = new Date(`${session.deadline}T23:59:59`);
      if (deadlineDate.getTime() < Date.now()) {
        return fail('Deadline peer review sudah lewat', 400);
      }
    }

    const assignmentId = session.class_period_assignment_id as string;

    // ── 2. Validasi reviewer & reviewee sekelas ───────────────────
    const { data: enrolls, error: eErr } = await admin
      .from('student_class_enrollments')
      .select('student_id')
      .eq('class_period_assignment_id', assignmentId)
      .eq('status', 'active')
      .in('student_id', [reviewer.id, revieweeId]);

    if (eErr) {
      return fail(`Gagal validasi keanggotaan kelas: ${eErr.message}`, 500);
    }
    const memberIds = new Set(
      (enrolls ?? []).map((e) => (e as { student_id: string }).student_id),
    );
    if (!memberIds.has(reviewer.id) || !memberIds.has(revieweeId)) {
      return fail('Reviewer dan reviewee harus berada di kelas yang sama', 403);
    }

    // ── 3. Cek belum pernah submit untuk reviewee ini ─────────────
    const { data: existing } = await admin
      .from('peer_review_submissions')
      .select('id')
      .eq('session_id', sessionId)
      .eq('reviewer_id', reviewer.id)
      .eq('reviewee_id', revieweeId)
      .maybeSingle();

    if (existing) {
      return fail('Anda sudah menilai siswa ini sebelumnya', 409);
    }

    // ── 4. INSERT submission ──────────────────────────────────────
    const { error: iErr } = await admin
      .from('peer_review_submissions')
      .insert({
        session_id: sessionId,
        reviewer_id: reviewer.id,
        reviewee_id: revieweeId,
        score_courtesy: scores.courtesy,
        score_cooperation: scores.cooperation,
        score_empathy: scores.empathy,
        score_honesty: scores.honesty,
        score_responsibility: scores.responsibility,
      });

    if (iErr) {
      return fail(`Gagal menyimpan penilaian: ${iErr.message}`, 500);
    }

    // ── 5. UPSERT progress reviewer ───────────────────────────────
    // total_count = jumlah teman sekelas - 1 (tidak menilai diri)
    const totalCount = Math.max(memberIds.size - 1, 0);

    // Ambil progress yang ada (kalau belum ada → buat baru)
    const { data: progress } = await admin
      .from('peer_review_progress')
      .select('id, completed_count')
      .eq('session_id', sessionId)
      .eq('student_id', reviewer.id)
      .maybeSingle();

    const completedCount =
      (progress?.completed_count as number | undefined) ?? 0;

    if (progress) {
      await admin
        .from('peer_review_progress')
        .update({
          completed_count: Math.min(completedCount + 1, totalCount),
          last_updated: new Date().toISOString(),
        })
        .eq('id', progress.id as string);
    } else {
      await admin.from('peer_review_progress').insert({
        session_id: sessionId,
        student_id: reviewer.id,
        completed_count: 1,
        total_count: totalCount,
      });
    }

    // ── 6. Hitung X3 sementara untuk reviewee (opsional, untuk UI) ──
    //     Dihitung sebagai rata-rata semua submission yang masuk
    //     sejauh ini. Final aggregate tetap dijalankan oleh trigger
    //     saat sesi ditutup (lihat 01_migration.sql §3.3).
    await recomputePartialX3(admin, sessionId, revieweeId);

    // ── 7. Tentukan reviewee selanjutnya (urutan acak deterministik) ─
    const nextRevieweeId = await pickNextReviewee(
      admin,
      sessionId,
      reviewer.id,
      Array.from(memberIds).filter((id) => id !== reviewer.id),
    );

    return ok<SuccessBody>({
      success: true,
      nextRevieweeId,
    });
  } catch (err) {
    if (err instanceof Error && /akses|login/i.test(err.message)) {
      return fail(err.message, 403);
    }
    return failFromUnknown(err);
  }
}

/* ────────────────────────────────────────────────────────────────────
 *  Helper: hitung ulang X3 parsial untuk satu reviewee
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Upsert agregat X3 untuk reviewee — dijalankan setiap kali ada
 * submission baru, agar UI siswa bisa menampilkan estimasi terkini.
 *
 * Final value yang resmi tetap di-set oleh trigger DB
 * `calculate_x3_on_session_close` saat status sesi menjadi 'closed'.
 */
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

  const rows = (subs ?? []) as Array<{
    score_courtesy: number;
    score_cooperation: number;
    score_empathy: number;
    score_honesty: number;
    score_responsibility: number;
  }>;

  if (rows.length === 0) return;

  let sumC = 0;
  let sumCoop = 0;
  let sumE = 0;
  let sumH = 0;
  let sumR = 0;
  for (const r of rows) {
    sumC += r.score_courtesy;
    sumCoop += r.score_cooperation;
    sumE += r.score_empathy;
    sumH += r.score_honesty;
    sumR += r.score_responsibility;
  }
  const n = rows.length;
  const avgC = sumC / n;
  const avgCoop = sumCoop / n;
  const avgE = sumE / n;
  const avgH = sumH / n;
  const avgR = sumR / n;
  // Skor akhir 0-100 = rata-rata 5 aspek × 20
  const x3 = ((avgC + avgCoop + avgE + avgH + avgR) / 5) * 20;

  await admin.from('student_x3_scores').upsert(
    {
      session_id: sessionId,
      student_id: revieweeId,
      x3_score: Number(x3.toFixed(2)),
      avg_courtesy: Number(avgC.toFixed(2)),
      avg_cooperation: Number(avgCoop.toFixed(2)),
      avg_empathy: Number(avgE.toFixed(2)),
      avg_honesty: Number(avgH.toFixed(2)),
      avg_responsibility: Number(avgR.toFixed(2)),
      reviewer_count: n,
      // computed_at sengaja TIDAK di-set agar UI tahu ini parsial
      computed_at: null,
    },
    { onConflict: 'session_id,student_id' },
  );
}

/* ────────────────────────────────────────────────────────────────────
 *  Helper: pilih reviewee berikutnya
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Cari siswa di kelas yang BELUM dinilai oleh reviewer pada sesi ini.
 * Mengembalikan ID pertama yang tersisa berdasarkan urutan alfabet
 * student_id (deterministic — UI bisa override dengan urutan acak
 * yang disimpan di stores klien).
 */
async function pickNextReviewee(
  admin: Awaited<ReturnType<typeof createServiceRoleClient>>,
  sessionId: string,
  reviewerId: string,
  candidateIds: ReadonlyArray<string>,
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

  // Sort agar deterministic — UI klien yang punya state acak
  // dapat memilih sendiri urutan tampilnya.
  remaining.sort();
  return remaining[0] ?? null;
}
