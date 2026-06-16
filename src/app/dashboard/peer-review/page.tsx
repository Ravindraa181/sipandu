/**
 * @file app/dashboard/peer-review/page.tsx
 *
 * FIX TS2305 (line 24):
 *   Import getTeacherAssignment sudah benar — error hilang setelah
 *   getAssignment.ts yang benar di-copy ke proyek.
 *
 * FIX TS7006 (line 88, 130):
 *   assignment.students.map((s) => ...) → tambahkan tipe eksplisit
 *   `(s: TeacherStudent)`.
 *
 * FIX CloseSessionButton:
 *   Prop diganti dari assignmentId → sessionId.
 *   Tambahkan sessionId ke PageData dan teruskan dari loadData().
 */

import { redirect } from 'next/navigation';
import { CheckCircle, Circle, CircleCheck, Info, Loader2 } from 'lucide-react';

import { createClient } from '@/lib/supabase/server';
import { getTeacherAssignment, type TeacherStudent } from '@/lib/teacher/getAssignment';
import { PageHeader } from '@/components/shared/PageHeader';
import { ROUTES } from '@/constants';
import { formatScore, formatDate } from '@/lib/utils/format';
import { OpenSessionForm } from './_components/OpenSessionForm';
import { CloseSessionButton } from './_components/CloseSessionButton';

export const metadata = {
  title: 'Kelola Peer Review',
};

interface ProgressRow {
  studentId: string;
  fullName: string;
  reviewsSubmitted: number;
  totalAssigned: number;
  x3Tentative: number | null;
  reviewerState: 'done' | 'partial' | 'none';
}

interface PageData {
  assignmentId: string;
  // FIX: tambah sessionId untuk CloseSessionButton
  sessionId: string | null;
  className: string;
  sessionStatus: 'not_started' | 'active' | 'closed';
  deadline: string | null;
  daysUntilDeadline: number | null;
  totalCompleteReviewers: number;
  totalStudents: number;
  progressPercent: number;
  rows: ProgressRow[];
}

async function loadData(): Promise<PageData> {
  const assignment = await getTeacherAssignment();
  if (!assignment) redirect(ROUTES.waiting);
  const supabase = await createClient();

  // ── 1. Sesi peer review ─────────────────────────────────────────
  const { data: session } = await supabase
    .from('peer_review_sessions')
    .select('id, status, deadline')
    .eq('class_period_assignment_id', assignment.assignmentId)
    .maybeSingle();

  const sessionStatus =
    (session?.status as 'not_started' | 'active' | 'closed' | undefined) ??
    'not_started';
  const deadline = (session?.deadline as string | undefined) ?? null;
  // FIX: simpan sessionId untuk diteruskan ke CloseSessionButton
  const sessionId = (session?.id as string | undefined) ?? null;

  let daysUntilDeadline: number | null = null;
  if (deadline) {
    const ms = new Date(deadline).getTime() - Date.now();
    daysUntilDeadline = Math.max(0, Math.ceil(ms / (1000 * 60 * 60 * 24)));
  }

  // ── 2. Progress per reviewer (siswa) ────────────────────────────
  const totalAssigned = Math.max(0, assignment.students.length - 1);

  // FIX: tipe eksplisit (s: TeacherStudent) agar tidak implicitly any
  const studentIds = assignment.students.map((s: TeacherStudent) => s.studentId);

  const { data: submissions } = session
    ? await supabase
        .from('peer_review_submissions')
        .select(
          'reviewer_id, reviewee_id, score_courtesy, score_cooperation, score_empathy, score_honesty, score_responsibility',
        )
        .eq('session_id', session.id as string)
        .in('reviewer_id', studentIds)
    : { data: [] };

  const submissionRows = (submissions ?? []) as Array<{
    reviewer_id: string;
    reviewee_id: string;
    score_courtesy: number;
    score_cooperation: number;
    score_empathy: number;
    score_honesty: number;
    score_responsibility: number;
  }>;

  const reviewerCount = new Map<string, number>();
  const revieweeScores = new Map<string, number[]>();

  for (const row of submissionRows) {
    reviewerCount.set(
      row.reviewer_id,
      (reviewerCount.get(row.reviewer_id) ?? 0) + 1,
    );
    const avg5 =
      (row.score_courtesy +
        row.score_cooperation +
        row.score_empathy +
        row.score_honesty +
        row.score_responsibility) /
      5;
    const score100 = avg5 * 20;
    const list = revieweeScores.get(row.reviewee_id) ?? [];
    list.push(score100);
    revieweeScores.set(row.reviewee_id, list);
  }

  // FIX: tipe eksplisit (s: TeacherStudent)
  const rows: ProgressRow[] = assignment.students.map((s: TeacherStudent) => {
    const submitted = reviewerCount.get(s.studentId) ?? 0;
    const myScores = revieweeScores.get(s.studentId) ?? [];
    const x3Tentative =
      myScores.length > 0
        ? myScores.reduce((a, b) => a + b, 0) / myScores.length
        : null;

    const reviewerState: ProgressRow['reviewerState'] =
      submitted === 0 ? 'none' : submitted >= totalAssigned ? 'done' : 'partial';

    return {
      studentId: s.studentId,
      fullName: s.fullName,
      reviewsSubmitted: submitted,
      totalAssigned,
      x3Tentative,
      reviewerState,
    };
  });

  const completeCount = rows.filter((r) => r.reviewerState === 'done').length;
  const progressPercent =
    rows.length > 0 ? Math.round((completeCount / rows.length) * 100) : 0;

  return {
    assignmentId: assignment.assignmentId,
    sessionId,          // FIX: sertakan sessionId
    className: assignment.className,
    sessionStatus,
    deadline,
    daysUntilDeadline,
    totalCompleteReviewers: completeCount,
    totalStudents: rows.length,
    progressPercent,
    rows,
  };
}

export default async function TeacherPeerReviewPage() {
  const data = await loadData();

  return (
    <div className="space-y-3">
      <PageHeader title={`Kelola sesi Peer Review — Kelas ${data.className}`} />

      {/* Banner status sesi */}
      {data.sessionStatus === 'active' && (
        <div
          className="rounded-md border border-status-on-soft bg-green-50 p-4"
          style={{ borderLeftColor: '#16A34A', borderLeftWidth: 4 }}
        >
          <div className="mb-2.5 flex flex-wrap items-center justify-between gap-2">
            <div className="flex items-center gap-2.5">
              <span className="inline-flex items-center rounded-full bg-status-on-soft px-2 py-0.5 text-xs font-semibold text-status-on-text">
                ● SESI AKTIF
              </span>
              <strong className="text-foreground">
                Deadline: {formatDate(data.deadline)}
              </strong>
              {data.daysUntilDeadline !== null && (
                <span className="text-sm text-muted-foreground">
                  ({data.daysUntilDeadline} hari lagi)
                </span>
              )}
            </div>
            {/* FIX: teruskan sessionId bukan assignmentId */}
            {data.sessionId && (
              <CloseSessionButton sessionId={data.sessionId} />
            )}
          </div>

          <div className="mb-2 text-sm text-foreground">
            Progress:{' '}
            <strong>
              {data.totalCompleteReviewers} dari {data.totalStudents} siswa
            </strong>{' '}
            sudah menyelesaikan pengisian ({data.progressPercent}%)
          </div>

          <div className="h-3 overflow-hidden rounded-md bg-gray-200">
            <div
              className="h-full rounded-md bg-status-on transition-[width]"
              style={{ width: `${data.progressPercent}%` }}
            />
          </div>
        </div>
      )}

      {data.sessionStatus === 'closed' && (
        <div className="rounded-md border border-sipandu-border bg-gray-50 p-4">
          <div className="mb-1 flex items-center gap-2.5">
            <CircleCheck className="h-3.5 w-3.5 text-status-on" aria-hidden />
            <strong className="text-foreground">
              Sesi Peer Review telah ditutup
            </strong>
          </div>
          <p className="text-sm text-muted-foreground">
            Skor X3 final sudah dihitung dari penilaian yang masuk. Tidak ada
            perubahan lagi yang dapat dilakukan.
          </p>
        </div>
      )}

      {data.sessionStatus === 'not_started' && (
        <div
          className="rounded-md border border-status-err-soft bg-red-50 p-4"
          style={{ borderLeftColor: '#DC2626', borderLeftWidth: 4 }}
        >
          <div className="mb-2.5 flex items-center gap-2.5">
            <span className="inline-flex items-center rounded-full bg-status-err-soft px-2 py-0.5 text-xs font-semibold text-status-err-text">
              ● BELUM DIBUKA
            </span>
            <strong className="text-foreground">
              Sesi Peer Review belum dimulai
            </strong>
          </div>
          <p className="mb-3 text-sm text-foreground">
            Sesi Peer Review untuk periode ini belum dimulai. Tetapkan deadline
            untuk membukanya.
          </p>

          <OpenSessionForm assignmentId={data.assignmentId} />

          <p className="mt-3 flex items-start gap-1.5 text-xs text-muted-foreground">
            <Info className="mt-0.5 h-3 w-3 flex-shrink-0" aria-hidden />
            Sistem akan menugaskan <strong>5 teman secara acak</strong> kepada
            setiap siswa. Siswa hanya menilai 5 teman yang ditugaskan, bukan
            seluruh kelas.
          </p>
        </div>
      )}

      {/* Tabel progres */}
      <div className="overflow-hidden rounded-md border border-sipandu-border bg-white">
        <div className="border-b border-sipandu-border px-3.5 py-2.5">
          <h2 className="text-base font-bold text-foreground">
            Progres pengisian per siswa
          </h2>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full border-collapse text-sm">
            <thead>
              <tr className="border-b border-sipandu-border bg-gray-100 text-left">
                <th className="w-10 px-3 py-2 text-center text-xs font-semibold">No</th>
                <th className="px-3 py-2 text-xs font-semibold">Nama Siswa</th>
                <th className="px-3 py-2 text-xs font-semibold">Status</th>
                <th className="px-3 py-2 text-center text-xs font-semibold">Selesai / Total</th>
                <th className="px-3 py-2 text-center text-xs font-semibold">X3 Sementara</th>
                <th className="px-3 py-2 text-xs font-semibold">Keterangan</th>
              </tr>
            </thead>
            <tbody>
              {data.rows.length === 0 ? (
                <tr>
                  <td
                    colSpan={6}
                    className="px-3 py-10 text-center text-sm italic text-muted-foreground"
                  >
                    Belum ada siswa di kelas ini.
                  </td>
                </tr>
              ) : (
                data.rows.map((r, i) => (
                  <tr
                    key={r.studentId}
                    className="border-b border-gray-100 hover:bg-blue-50/40"
                  >
                    <td className="px-3 py-1.5 text-center text-muted-foreground">
                      {i + 1}
                    </td>
                    <td className="px-3 py-1.5 font-medium text-foreground">
                      {r.fullName}
                    </td>
                    <td className="px-3 py-1.5">
                      {r.reviewerState === 'done' && (
                        <span className="inline-flex items-center gap-1 text-status-on-text">
                          <CircleCheck className="h-3 w-3" aria-hidden /> Selesai
                        </span>
                      )}
                      {r.reviewerState === 'partial' && (
                        <span className="inline-flex items-center gap-1 text-status-warn-text">
                          <Loader2 className="h-3 w-3" aria-hidden /> Sedang
                        </span>
                      )}
                      {r.reviewerState === 'none' && (
                        <span className="inline-flex items-center gap-1 text-muted-foreground">
                          <Circle className="h-3 w-3" aria-hidden /> Belum mulai
                        </span>
                      )}
                    </td>
                    <td className="px-3 py-1.5 text-center">
                      {r.reviewsSubmitted}/{r.totalAssigned} teman
                    </td>
                    <td className="px-3 py-1.5 text-center font-bold text-sipandu-blue">
                      {r.x3Tentative !== null ? formatScore(r.x3Tentative, 1) : '—'}
                      {r.reviewerState === 'partial' && (
                        <span className="ml-1 text-2xs font-normal text-status-warn-text">
                          (parsial)
                        </span>
                      )}
                    </td>
                    <td className="px-3 py-1.5 text-xs text-muted-foreground">
                      {r.reviewerState === 'partial' && 'Belum selesai'}
                      {r.reviewerState === 'none' && 'Belum mengisi'}
                      {r.reviewerState === 'done' && '—'}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      <div className="flex items-start gap-2 rounded-md border-l-4 border-gray-300 bg-gray-50 px-3 py-2.5 text-sm text-muted-foreground">
        <Info className="mt-0.5 h-3.5 w-3.5 flex-shrink-0" aria-hidden />
        <p>
          X3 dihitung final setelah sesi ditutup atau deadline tercapai. Nilai
          parsial ditampilkan hanya sebagai estimasi untuk pemantauan.
        </p>
      </div>
    </div>
  );
}
