/**
 * @file app/siswa/peer-review/page.tsx
 * @description S2 — Form Peer Review Siswa.
 *
 *  Server Component:
 *   - getStudentContext untuk session + enrollment siswa
 *   - 4 mode tampilan:
 *      a. not_opened → info card: sesi belum dibuka guru
 *      b. closed     → info card: sesi sudah selesai
 *      c. complete   → CompletionScreen: semua teman sudah dinilai
 *      d. form       → PeerReviewForm: form penilaian aktif
 *
 *  PATCH: query classmates menggunakan createServiceRoleClient() karena
 *  RLS `enroll_select_self_teacher_admin` hanya membolehkan siswa melihat
 *  enrollment dirinya sendiri. Service role dibutuhkan untuk melihat
 *  seluruh enrollment sekelas (demi peer review).
 */
import { redirect } from 'next/navigation';
import { Calendar, CircleX, CheckCircle2, Users } from 'lucide-react';

import { createClient } from '@/lib/supabase/server';
import { createServiceRoleClient } from '@/lib/supabase/server';
import { getStudentContext } from '@/lib/student/getStudentContext';
import { deterministicShuffle } from '@/lib/student/shuffle';
import { PageHeader } from '@/components/shared/PageHeader';
import { ROUTES } from '@/constants';
import { formatDate } from '@/lib/utils/format';
import { PeerReviewForm } from './_components/PeerReviewForm';
import { CompletionScreen } from './_components/CompletionScreen';

export const metadata = { title: 'Peer Review — Siswa SiPandu' };

async function loadData() {
  const ctx = await getStudentContext();
  if (!ctx || !ctx.assignmentId) redirect(ROUTES.waiting);

  // anon client untuk query yang boleh kena RLS
  const supabase = await createClient();
  // ALASAN: service role diperlukan untuk query classmates — RLS hanya
  // membolehkan siswa melihat enrollment dirinya sendiri.
  const admin = createServiceRoleClient();

  // ── 1. Cek status sesi ──────────────────────────────────────────
  const { data: session } = await supabase
    .from('peer_review_sessions')
    .select('id, status, deadline')
    .eq('class_period_assignment_id', ctx.assignmentId)
    .maybeSingle();

  if (!session || session.status === 'not_started') {
    return { mode: 'not_opened' as const, className: ctx.className, periodLabel: ctx.periodLabel };
  }
  if (session.status === 'closed') {
    return { mode: 'closed' as const, className: ctx.className, periodLabel: ctx.periodLabel };
  }

  const sessionId = session.id as string;

  // ── 2. Ambil teman sekelas via service role (bypass RLS) ────────
  // ALASAN: RLS policy enroll_select_self_teacher_admin hanya return
  // baris milik siswa sendiri sehingga list teman selalu kosong.
  const { data: classmatesData } = await admin
    .from('student_class_enrollments')
    .select('student_id, student:profiles(full_name)')
    .eq('class_period_assignment_id', ctx.assignmentId)
    .eq('status', 'active');

  const rawClassmates = (classmatesData ?? [])
    .map((c: any) => ({
      id: c.student_id as string,
      fullName: (c.student?.full_name as string) ?? 'Unknown',
    }))
    .filter((c) => c.id !== ctx.studentId); // exclude diri sendiri

  const totalReviewees = rawClassmates.length;

  // ── 3. Cek progres siswa ini ────────────────────────────────────
  const { data: progressData } = await supabase
    .from('peer_review_progress')
    .select('completed_count')
    .eq('session_id', sessionId)
    .eq('student_id', ctx.studentId)
    .maybeSingle();

  if (progressData && progressData.completed_count >= totalReviewees && totalReviewees > 0) {
    return {
      mode: 'complete' as const,
      className: ctx.className,
      periodLabel: ctx.periodLabel,
      totalReviewees,
    };
  }

  // ── 4. Shuffle deterministik + submissions yang sudah ada ───────
  const shuffledReviewees = deterministicShuffle(
    rawClassmates,
    `${sessionId}-${ctx.studentId}`,
  );

  // ALASAN: service role diperlukan — RLS tidak punya SELECT policy untuk siswa
  // di peer_review_submissions (demi anonimitas). Ini sisi server, aman.
  const { data: submissions } = await admin
    .from('peer_review_submissions')
    .select(
      'reviewee_id, score_courtesy, score_cooperation, score_empathy, score_honesty, score_responsibility',
    )
    .eq('session_id', sessionId)
    .eq('reviewer_id', ctx.studentId);

  const initialSubmittedIds = (submissions ?? []).map((s) => s.reviewee_id as string);

  /** Skor yang sudah pernah dikirim, untuk pre-fill saat mode edit. */
  type SubRow = {
    reviewee_id: string;
    score_courtesy: number;
    score_cooperation: number;
    score_empathy: number;
    score_honesty: number;
    score_responsibility: number;
  };
  const initialSubmittedScores: Record<string, [number, number, number, number, number]> = {};
  for (const s of (submissions ?? []) as SubRow[]) {
    initialSubmittedScores[s.reviewee_id] = [
      s.score_courtesy,
      s.score_cooperation,
      s.score_empathy,
      s.score_honesty,
      s.score_responsibility,
    ];
  }

  let daysRemaining: number | null = null;
  if (session.deadline) {
    const ms = new Date(session.deadline).getTime() - Date.now();
    daysRemaining = Math.max(0, Math.ceil(ms / (1000 * 60 * 60 * 24)));
  }

  return {
    mode: 'form' as const,
    sessionId,
    className: ctx.className,
    periodLabel: ctx.periodLabel,
    deadline: session.deadline as string | null,
    daysRemaining,
    reviewees: shuffledReviewees,
    initialSubmittedIds,
    initialSubmittedScores,
  };
}

export default async function PeerReviewPage() {
  const data = await loadData();

  if (data.mode === 'not_opened') {
    return (
      <div className="space-y-3">
        <PageHeader title="Peer Review" />
        <div className="flex items-start gap-3 rounded-md border border-sipandu-border bg-white p-5">
          <CircleX className="mt-0.5 h-5 w-5 shrink-0 text-muted-foreground" aria-hidden />
          <div>
            <p className="font-semibold text-foreground">Sesi peer review belum dibuka</p>
            <p className="mt-1 text-sm text-muted-foreground">
              Wali kelas belum membuka sesi penilaian untuk kelas{' '}
              <strong>{data.className}</strong>. Tunggu informasi dari guru.
            </p>
          </div>
        </div>
      </div>
    );
  }

  if (data.mode === 'closed') {
    return (
      <div className="space-y-3">
        <PageHeader title="Peer Review" />
        <div className="flex items-start gap-3 rounded-md border border-sipandu-border bg-white p-5">
          <CheckCircle2 className="mt-0.5 h-5 w-5 shrink-0 text-status-on" aria-hidden />
          <div>
            <p className="font-semibold text-foreground">Sesi peer review sudah selesai</p>
            <p className="mt-1 text-sm text-muted-foreground">
              Sesi penilaian kelas <strong>{data.className}</strong> sudah ditutup.
              Hasil akan diproses oleh sistem.
            </p>
          </div>
        </div>
      </div>
    );
  }

  if (data.mode === 'complete') {
    return (
      <div className="space-y-3">
        <PageHeader title="Peer Review" />
        <CompletionScreen totalReviewees={data.totalReviewees} />
      </div>
    );
  }

  // mode === 'form'
  return (
    <div className="space-y-3">
      <PageHeader title="Peer Review" />

      {/* Banner deadline */}
      {data.deadline && (
        <div className="flex items-center gap-2.5 rounded-md border border-sipandu-blue/40 bg-blue-50 px-3.5 py-2.5 text-sm">
          <Calendar className="h-3.5 w-3.5 shrink-0 text-sipandu-blue" aria-hidden />
          <span className="text-sipandu-blue-deep">
            Batas waktu penilaian:{' '}
            <strong>{formatDate(data.deadline)}</strong>
            {data.daysRemaining !== null && (
              <span className="ml-1 text-muted-foreground">
                ({data.daysRemaining === 0 ? 'hari ini' : `${data.daysRemaining} hari lagi`})
              </span>
            )}
          </span>
        </div>
      )}

      {data.reviewees.length === 0 ? (
        <div className="flex items-start gap-3 rounded-md border border-sipandu-border bg-white p-5">
          <Users className="mt-0.5 h-5 w-5 shrink-0 text-muted-foreground" aria-hidden />
          <div>
            <p className="font-semibold text-foreground">Tidak ada teman yang perlu dinilai</p>
            <p className="mt-1 text-sm text-muted-foreground">
              Belum ada siswa lain yang terdaftar di kelas <strong>{data.className}</strong>.
            </p>
          </div>
        </div>
      ) : (
        <PeerReviewForm
          sessionId={data.sessionId}
          reviewees={data.reviewees}
          initialSubmittedIds={data.initialSubmittedIds}
          initialSubmittedScores={data.initialSubmittedScores}
        />
      )}
    </div>
  );
}
