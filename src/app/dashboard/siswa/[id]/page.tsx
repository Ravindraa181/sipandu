/**
 * @file app/dashboard/siswa/[id]/page.tsx
 * @description W5 — Detail Siswa (5 tab).
 *
 * Server Component dengan dynamic param `id` = enrollmentId siswa.
 * Fetch lengkap:
 * - Info siswa + skor terkini (X1/X2/X3/Z*)
 * - Detail perhitungan fuzzy (active_rules JSONB)
 * - Riwayat kehadiran per bulan (lock=true atau draft)
 * - Riwayat poin perilaku (semua transaksi)
 * - Peer review aggregate (5 aspek + reviewer count)
 * - Histori skor lintas semester (cross-period via student_id)
 * - Catatan wali kelas (untuk auto-save)
 */

import Link from 'next/link';
import { notFound, redirect } from 'next/navigation';
import { ArrowLeft, MessageCircle } from 'lucide-react';

import { createClient } from '@/lib/supabase/server';
// PERBAIKAN: Gunakan fungsi yang benar
import { getAssignmentContext } from '@/lib/teacher/getAssignment';
import { Button } from '@/components/ui/button';
import { ScoreCard } from '@/components/shared/ScoreCard';
import { CategoryBadge } from '@/components/shared/CategoryBadge';
import {
  CATEGORY_CONFIG,
  MONTHS,
  PEER_REVIEW_ASPECTS,
  ROUTES,
} from '@/constants';
import {
  formatDate,
  formatPercent,
  formatScore,
  getInterpretationText,
} from '@/lib/utils/format';
import type { CategoryType, PeerReviewAspects } from '@/types';
import { StudentDetailTabs } from './_components/StudentDetailTabs';
import { TeacherNoteForm } from './_components/TeacherNoteForm';
import { FuzzyDetailAccordion } from './_components/FuzzyDetailAccordion';
import { AspectBreakdown } from './_components/AspectBreakdown';
import { getAspectLabelMap } from '@/lib/peer-review/getAspects';
import {
  HistoryBarChart,
  type HistoryBar,
} from './_components/HistoryBarChart';

export const metadata = {
  title: 'Detail Siswa',
};

interface AttendanceMonthRow {
  month: number;
  year: number;
  presentDays: number;
  sickDays: number;
  permittedDays: number;
  absentDays: number;
  effectiveDays: number;
  status: 'draft' | 'locked';
}

interface PointTxRow {
  id: string;
  type: 'violation' | 'reward';
  categoryName: string;
  pointChange: number;
  rawAfter: number;
  transactionDate: string;
  notes: string | null;
  recordedByName: string;
}

interface PageData {
  enrollmentId: string;
  studentId: string;
  studentName: string;
  className: string;
  periodLabel: string;
  initialNote: string;
  x1: number | null;
  x2: number | null;
  rawX2: number | null;
  x3: number | null;
  zScore: number | null;
  category: CategoryType | null;
  fuzzification: {
    x1: { low: number; medium: number; high: number };
    x2: { low: number; medium: number; high: number };
    x3: { low: number; medium: number; high: number };
  } | null;
  activeRules: Array<{
    ruleNumber: number;
    alpha: number;
    output: CategoryType;
  }>;
  aggregation: {
    perlu_pembinaan: number;
    cukup: number;
    baik: number;
    sangat_baik: number;
  } | null;
  attendance: AttendanceMonthRow[];
  pointTransactions: PointTxRow[];
  peerAspects: PeerReviewAspects | null;
  peerReviewerCount: number;
  aspectLabels: Record<string, string>;
  peerSessionStatus: 'not_started' | 'active' | 'closed';
  history: HistoryBar[];
}

interface ActiveRulesJson {
  rule_number?: number;
  ruleNumber?: number;
  alpha: number;
  output?: string;
  output_set?: string;
}


async function loadDetail(enrollmentId: string): Promise<PageData | null> {
  const assignment = await getAssignmentContext();
  if (!assignment) redirect(ROUTES.waiting);

  const supabase = await createClient();

  // Pastikan enrollment ini milik kelas wali kelas yang sedang login
  const { data: enrollData } = await supabase
    .from('student_class_enrollments')
    .select('id, student_id, student:profiles(full_name)')
    .eq('id', enrollmentId)
    .eq('class_period_assignment_id', assignment.assignmentId)
    .single();

  if (!enrollData) return null;

  const targetStudent = {
    studentId: enrollData.student_id,
    fullName: (enrollData.student as any)?.full_name ?? 'Unknown',
  };

  // ── 1. Skor terkini ──────────────────────────────────────────────
  // CATATAN: kolom yang ada di DB: x1,x2,raw_x2,x3,z_star,category,
  //          alpha_pp,alpha_c,alpha_b,alpha_sb,active_rules
  //          (fuzzification & aggregation TIDAK ada → jangan di-select)
  const { data: scoreRow } = await supabase
    .from('behavior_final_scores')
    .select(
      `x1, x2, raw_x2, x3, z_star, category,
       alpha_pp, alpha_c, alpha_b, alpha_sb, active_rules`,
    )
    .eq('enrollment_id', enrollmentId)
    .maybeSingle();

  const score = scoreRow as {
    x1: number | null;
    x2: number | null;
    raw_x2: number | null;
    x3: number | null;
    z_star: number | null;
    category: CategoryType | null;
    alpha_pp: number | null;
    alpha_c: number | null;
    alpha_b: number | null;
    alpha_sb: number | null;
    active_rules: ActiveRulesJson[] | null;
  } | null;

  // ── 2. Catatan wali kelas ────────────────────────────────────────
  const { data: noteRow } = await supabase
    .from('teacher_narrative_notes')
    .select('note_text') // PERBAIKAN: gunakan note_text
    .eq('enrollment_id', enrollmentId)
    .maybeSingle();
  const initialNote = ((noteRow?.note_text as string | undefined) ?? '').toString();

  // ── 3. Kehadiran per bulan ──────────────────────────────────────
  const { data: attData } = await supabase
    .from('monthly_attendance')
    .select(
      'month, year, present_days, sick_days, permit_days, absent_days, effective_days, is_locked',
    ) // PERBAIKAN: is_locked, bukan status
    .eq('enrollment_id', enrollmentId)
    .order('year', { ascending: true })
    .order('month', { ascending: true });

  const attendance: AttendanceMonthRow[] = (
    (attData ?? []) as Array<{
      month: number;
      year: number;
      present_days: number;
      sick_days: number;
      permit_days: number;
      absent_days: number;
      effective_days: number;
      is_locked: boolean;
    }>
  ).map((a) => ({
    month: a.month,
    year: a.year,
    presentDays: a.present_days,
    sickDays: a.sick_days,
    permittedDays: a.permit_days,
    absentDays: a.absent_days,
    effectiveDays: a.effective_days,
    status: a.is_locked ? 'locked' : 'draft',
  }));

  // ── 4. Poin transaksi (semua) ───────────────────────────────────
  const { data: txnData } = await supabase
    .from('behavior_point_transactions')
    .select(
      `id, transaction_type, transaction_date, points_delta, raw_score_after, notes,
       violation:violation_categories(name),
       reward:reward_categories(name),
       recorder:profiles!recorded_by(full_name)`,
    ) // PERBAIKAN: transaction_type, points_delta
    .eq('enrollment_id', enrollmentId)
    .order('transaction_date', { ascending: false });

  const pointTransactions: PointTxRow[] = (
    (txnData ?? []) as Array<{
      id: string;
      transaction_type: 'violation' | 'reward';
      transaction_date: string;
      points_delta: number;
      raw_score_after: number;
      notes: string | null;
      violation: { name: string } | null;
      reward: { name: string } | null;
      recorder: { full_name: string } | null;
    }>
  ).map((tx) => ({
    id: tx.id,
    type: tx.transaction_type,
    categoryName: tx.transaction_type === 'violation' 
      ? (tx.violation?.name ?? '—') 
      : (tx.reward?.name ?? '—'),
    pointChange: tx.points_delta,
    rawAfter: tx.raw_score_after,
    transactionDate: tx.transaction_date,
    notes: tx.notes,
    recordedByName: tx.recorder?.full_name ?? '—',
  }));

  // ── 5. Peer review breakdown ────────────────────────────────────
  const { data: peerSession } = await supabase
    .from('peer_review_sessions')
    .select('id, status')
    .eq('class_period_assignment_id', assignment.assignmentId)
    .maybeSingle();

  let peerAspects: PeerReviewAspects | null = null;
  let peerReviewerCount = 0;
  const peerSessionStatus =
    (peerSession?.status as
      | 'not_started'
      | 'active'
      | 'closed'
      | undefined) ?? 'not_started';

  if (peerSession?.id) {
    const { data: peerData } = await supabase
      .from('peer_review_submissions')
      .select(
        'score_courtesy, score_cooperation, score_empathy, score_honesty, score_responsibility',
      )
      .eq('session_id', peerSession.id as string)
      .eq('reviewee_id', targetStudent.studentId);

    const peerRows = (peerData ?? []) as Array<{
      score_courtesy: number;
      score_cooperation: number;
      score_empathy: number;
      score_honesty: number;
      score_responsibility: number;
    }>;

    if (peerRows.length > 0) {
      const sum = peerRows.reduce(
        (acc, r) => ({
          courtesy: acc.courtesy + r.score_courtesy,
          cooperation: acc.cooperation + r.score_cooperation,
          empathy: acc.empathy + r.score_empathy,
          honesty: acc.honesty + r.score_honesty,
          responsibility: acc.responsibility + r.score_responsibility,
        }),
        {
          courtesy: 0,
          cooperation: 0,
          empathy: 0,
          honesty: 0,
          responsibility: 0,
        },
      );
      const n = peerRows.length;
      peerAspects = {
        courtesy: sum.courtesy / n,
        cooperation: sum.cooperation / n,
        empathy: sum.empathy / n,
        honesty: sum.honesty / n,
        responsibility: sum.responsibility / n,
      };
      peerReviewerCount = n;
    }
  }

  // ── 6. Histori skor lintas periode ──────────────────────────────
  const { data: historyData } = await supabase
    .from('behavior_final_scores')
    .select(
      `z_star, category,
       enrollment:enrollment_id (
         student_id,
         assignment:class_period_assignment_id (
           period:period_id (name, start_date)
         )
       )`,
    );

  const historyRows = (
    (historyData ?? []) as Array<{
      z_star: number | null;
      category: CategoryType | null;
      enrollment: {
        student_id: string;
        assignment: {
          period: { name: string; start_date: string } | null;
        } | null;
      } | null;
    }>
  )
    .filter((h) => h.enrollment?.student_id === targetStudent.studentId)
    .map((h) => ({
      label: h.enrollment?.assignment?.period?.name ?? '—',
      startDate: h.enrollment?.assignment?.period?.start_date ?? '',
      zScore: h.z_star,
      category: h.category,
    }))
    .sort((a, b) => (a.startDate > b.startDate ? 1 : -1));

  const history: HistoryBar[] = historyRows.map((h) => ({
    label: h.label,
    zScore: h.zScore,
    category: h.category,
  }));

  // ── 7. Active rules dari JSONB → format ke camelCase ────────────
  const activeRules =
    score?.active_rules?.map((r) => ({
      ruleNumber: (r.rule_number ?? r.ruleNumber ?? 0) as number,
      alpha: r.alpha,
      output: ((r.output ?? r.output_set ?? 'cukup') as CategoryType),
    })) ?? [];

  return {
    enrollmentId,
    studentId: targetStudent.studentId,
    studentName: targetStudent.fullName,
    className: assignment.className,
    periodLabel: assignment.periodName, // PERBAIKAN: periodName
    initialNote,
    x1: score?.x1 ?? null,
    x2: score?.x2 ?? null,
    rawX2: score?.raw_x2 ?? null,
    x3: score?.x3 ?? null,
    zScore: score?.z_star ?? null,
    category: score?.category ?? null,
    fuzzification: null, // kolom tidak disimpan di DB; tampilkan via active_rules
    activeRules,
    aggregation:
      (score?.alpha_pp != null || score?.alpha_c != null ||
       score?.alpha_b != null || score?.alpha_sb != null)
        ? {
            perlu_pembinaan: score?.alpha_pp ?? 0,
            cukup: score?.alpha_c ?? 0,
            baik: score?.alpha_b ?? 0,
            sangat_baik: score?.alpha_sb ?? 0,
          }
        : null,
    attendance,
    pointTransactions,
    peerAspects,
    peerReviewerCount,
    aspectLabels: await getAspectLabelMap(),
    peerSessionStatus,
    history,
  };
}

export default async function StudentDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const data = await loadDetail(id);
  if (!data) notFound();

  const interpretation = getInterpretationText(data.category, {
    x1: data.x1,
    x2: data.x2,
    x3: data.x3,
  });

  // ── Ringkasan tab ───────────────────────────────────────────────
  const ringkasanContent = (
    <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">
      <div className="space-y-3">
        <ScoreCard
          x1={data.x1}
          x2={data.x2}
          x3={data.x3}
          zScore={data.zScore}
          category={data.category}
        />

        <div className="flex items-start gap-2 rounded-md border border-sipandu-border bg-blue-50 p-3 text-sm">
          <MessageCircle
            className="mt-0.5 h-3.5 w-3.5 flex-shrink-0 text-sipandu-blue"
            aria-hidden
          />
          <p className="text-foreground">{interpretation}</p>
        </div>
      </div>

      <div className="space-y-3">
        <FuzzyDetailAccordion
          inputs={{ x1: data.x1, x2: data.x2, x3: data.x3 }}
          zScore={data.zScore}
          fuzzification={data.fuzzification}
          activeRules={data.activeRules}
          aggregation={data.aggregation}
        />

        <div className="rounded-md border border-sipandu-border bg-white p-3.5">
          <TeacherNoteForm
            enrollmentId={data.enrollmentId}
            initialNote={data.initialNote}
            studentName={data.studentName}
          />
        </div>
      </div>
    </div>
  );

  // ── Kehadiran tab ──────────────────────────────────────────────
  const totalAttendance = data.attendance.reduce(
    (acc, a) => ({
      hadir: acc.hadir + a.presentDays,
      sakit: acc.sakit + a.sickDays,
      izin: acc.izin + a.permittedDays,
      alpa: acc.alpa + a.absentDays,
      efektif: acc.efektif + a.effectiveDays,
    }),
    { hadir: 0, sakit: 0, izin: 0, alpa: 0, efektif: 0 },
  );
  const x1Average =
    totalAttendance.efektif > 0
      ? (totalAttendance.hadir / totalAttendance.efektif) * 100
      : null;

  const kehadiranContent = (
    <div className="space-y-3">
      <div className="overflow-hidden rounded-md border border-sipandu-border bg-white">
        <div className="overflow-x-auto">
          <table className="w-full border-collapse text-sm">
            <thead>
              <tr className="border-b border-sipandu-border bg-gray-100 text-left">
                <th className="px-3 py-2 text-xs font-semibold">Bulan</th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  Hadir
                </th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  Sakit
                </th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  Izin
                </th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  Alpa
                </th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  Hari Efektif
                </th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  %
                </th>
                <th className="px-3 py-2 text-xs font-semibold">Status</th>
              </tr>
            </thead>
            <tbody>
              {data.attendance.length === 0 ? (
                <tr>
                  <td
                    colSpan={8}
                    className="px-3 py-8 text-center text-sm italic text-muted-foreground"
                  >
                    Belum ada data kehadiran tercatat.
                  </td>
                </tr>
              ) : (
                data.attendance.map((a) => {
                  const pct =
                    a.effectiveDays > 0
                      ? (a.presentDays / a.effectiveDays) * 100
                      : 0;
                  return (
                    <tr
                      key={`${a.year}-${a.month}`}
                      className="border-b border-gray-100 last:border-b-0"
                    >
                      <td className="px-3 py-1.5 font-medium">
                        {MONTHS[a.month - 1]} {a.year}
                      </td>
                      <td className="px-3 py-1.5 text-center">
                        {a.presentDays}
                      </td>
                      <td className="px-3 py-1.5 text-center">
                        {a.sickDays}
                      </td>
                      <td className="px-3 py-1.5 text-center">
                        {a.permittedDays}
                      </td>
                      <td className="px-3 py-1.5 text-center">
                        {a.absentDays}
                      </td>
                      <td className="px-3 py-1.5 text-center">
                        {a.effectiveDays}
                      </td>
                      <td className="px-3 py-1.5 text-center font-semibold">
                        {pct.toFixed(1)}%
                      </td>
                      <td className="px-3 py-1.5">
                        <span
                          className={
                            a.status === 'locked'
                              ? 'inline-flex items-center rounded-full bg-status-on-soft px-2 py-0.5 text-2xs font-semibold text-status-on-text'
                              : 'inline-flex items-center rounded-full bg-status-warn-soft px-2 py-0.5 text-2xs font-semibold text-status-warn-text'
                          }
                        >
                          {a.status === 'locked' ? 'Terkunci' : 'Draft'}
                        </span>
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>
      </div>

      <div className="rounded-md border border-sipandu-border bg-blue-50 p-3 text-sm">
        <span className="text-foreground">
          Rata-rata kehadiran semester (X1):{' '}
          <strong className="text-sipandu-blue">
            {formatPercent(x1Average, 1)}
          </strong>
        </span>
      </div>
    </div>
  );

  // ── Poin Perilaku tab ──────────────────────────────────────────
  const poinContent = (
    <div className="space-y-3">
      <div className="grid grid-cols-1 gap-3 lg:grid-cols-3">
        <div className="rounded-md border border-sipandu-border bg-white p-3.5">
          <div className="text-xs text-muted-foreground">Raw Score</div>
          <div className="text-3xl font-bold text-foreground">
            {data.rawX2 ?? '—'}
            {data.rawX2 !== null && data.rawX2 > 100 && (
              <span className="ml-1.5 inline-flex items-center rounded-full bg-status-warn-soft px-1.5 py-0.5 text-2xs font-semibold text-status-warn-text">
                ⚠ buffer
              </span>
            )}
          </div>
        </div>
        <div className="rounded-md border border-sipandu-border bg-white p-3.5">
          <div className="text-xs text-muted-foreground">X2 (capped)</div>
          <div className="text-3xl font-bold text-sipandu-blue">
            {formatScore(data.x2, 0)}
          </div>
        </div>
        <div className="rounded-md border border-sipandu-border bg-white p-3.5">
          <div className="text-xs text-muted-foreground">Total Transaksi</div>
          <div className="text-3xl font-bold text-foreground">
            {data.pointTransactions.length}
          </div>
        </div>
      </div>

      <div className="overflow-hidden rounded-md border border-sipandu-border bg-white">
        <div className="border-b border-sipandu-border px-3.5 py-2.5">
          <h3 className="text-sm font-bold text-foreground">
            Riwayat semua transaksi
          </h3>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full border-collapse text-sm">
            <thead>
              <tr className="border-b border-sipandu-border bg-gray-100 text-left">
                <th className="px-3 py-2 text-xs font-semibold">Tanggal</th>
                <th className="px-3 py-2 text-xs font-semibold">Jenis</th>
                <th className="px-3 py-2 text-xs font-semibold">Kategori</th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  Poin
                </th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  Raw Setelah
                </th>
                <th className="px-3 py-2 text-xs font-semibold">Catatan</th>
              </tr>
            </thead>
            <tbody>
              {data.pointTransactions.length === 0 ? (
                <tr>
                  <td
                    colSpan={6}
                    className="px-3 py-8 text-center text-sm italic text-muted-foreground"
                  >
                    Belum ada transaksi tercatat untuk siswa ini.
                  </td>
                </tr>
              ) : (
                data.pointTransactions.map((tx) => (
                  <tr
                    key={tx.id}
                    className="border-b border-gray-100 last:border-b-0"
                  >
                    <td className="px-3 py-1.5 text-xs">
                      {formatDate(tx.transactionDate)}
                    </td>
                    <td className="px-3 py-1.5">
                      <span
                        className={
                          tx.type === 'violation'
                            ? 'inline-flex items-center rounded-full bg-status-err-soft px-1.5 py-0.5 text-2xs font-semibold text-status-err-text'
                            : 'inline-flex items-center rounded-full bg-status-on-soft px-1.5 py-0.5 text-2xs font-semibold text-status-on-text'
                        }
                      >
                        {tx.type === 'violation' ? 'Pelanggaran' : 'Reward'}
                      </span>
                    </td>
                    <td className="px-3 py-1.5">{tx.categoryName}</td>
                    <td
                      className={
                        tx.pointChange < 0
                          ? 'px-3 py-1.5 text-center font-bold text-status-err'
                          : 'px-3 py-1.5 text-center font-bold text-status-on-text'
                      }
                    >
                      {tx.pointChange > 0 ? '+' : ''}
                      {tx.pointChange}
                    </td>
                    <td className="px-3 py-1.5 text-center font-semibold">
                      {tx.rawAfter}
                    </td>
                    <td className="px-3 py-1.5 text-xs text-muted-foreground">
                      {tx.notes ?? <span className="italic">—</span>}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );

  // ── Peer Review tab ────────────────────────────────────────────
  const peerContent = (
    <div className="space-y-3">
      <div className="rounded-md border border-sipandu-border bg-blue-50 p-4">
        <div className="mb-2 flex items-center justify-between">
          <span className="text-sm font-semibold text-sipandu-blue-deep">
            X3 — Nilai dari Teman
          </span>
          <span
            className={
              data.peerSessionStatus === 'closed'
                ? 'inline-flex items-center rounded-full bg-status-on-soft px-2 py-0.5 text-2xs font-semibold text-status-on-text'
                : data.peerSessionStatus === 'active'
                  ? 'inline-flex items-center rounded-full bg-status-warn-soft px-2 py-0.5 text-2xs font-semibold text-status-warn-text'
                  : 'inline-flex items-center rounded-full bg-status-err-soft px-2 py-0.5 text-2xs font-semibold text-status-err-text'
            }
          >
            {data.peerSessionStatus === 'closed' && 'Sesi Tutup'}
            {data.peerSessionStatus === 'active' && 'Sesi Aktif (parsial)'}
            {data.peerSessionStatus === 'not_started' && 'Sesi Belum Dibuka'}
          </span>
        </div>
        <div className="text-3xl font-bold text-sipandu-blue">
          {formatScore(data.x3, 1)}
        </div>
        <p className="mt-1 text-xs text-muted-foreground">
          Skala 0–100 (rata-rata 5 aspek × 20)
        </p>
      </div>

      <div className="rounded-md border border-sipandu-border bg-white p-3.5">
        <h3 className="mb-3 text-sm font-bold text-foreground">
          Breakdown 5 aspek
        </h3>
        {data.peerAspects ? (
          <AspectBreakdown
            aspects={data.peerAspects}
            reviewerCount={data.peerReviewerCount}
            labels={data.aspectLabels}
          />
        ) : (
          <p className="rounded-md border border-sipandu-border bg-gray-50 py-6 text-center text-sm italic text-muted-foreground">
            Belum ada penilaian masuk untuk siswa ini.
          </p>
        )}
      </div>

      <div className="rounded-md border-l-4 border-gray-300 bg-gray-50 px-3 py-2.5 text-xs italic text-muted-foreground">
        Identitas teman penilai dirahasiakan. Wali kelas hanya melihat
        agregat per aspek, bukan siapa memberi nilai berapa.
      </div>
    </div>
  );

  // ── Histori tab ────────────────────────────────────────────────
  const historiContent = (
    <div className="space-y-3">
      <div className="rounded-md border border-sipandu-border bg-white p-3.5">
        <h3 className="mb-3 text-sm font-bold text-foreground">
          Tren Z* lintas semester
        </h3>
        <HistoryBarChart bars={data.history} />
      </div>

      {data.history.length > 0 && (
        <div className="overflow-hidden rounded-md border border-sipandu-border bg-white">
          <div className="overflow-x-auto">
            <table className="w-full border-collapse text-sm">
              <thead>
                <tr className="border-b border-sipandu-border bg-gray-100 text-left">
                  <th className="px-3 py-2 text-xs font-semibold">Periode</th>
                  <th className="px-3 py-2 text-center text-xs font-semibold">
                    Z*
                  </th>
                  <th className="px-3 py-2 text-xs font-semibold">Kategori</th>
                </tr>
              </thead>
              <tbody>
                {data.history.map((h, i) => (
                  <tr
                    key={`${h.label}-${i}`}
                    className="border-b border-gray-100 last:border-b-0"
                  >
                    <td className="px-3 py-1.5 font-medium">{h.label}</td>
                    <td className="px-3 py-1.5 text-center font-bold">
                      {formatScore(h.zScore, 1)}
                    </td>
                    <td className="px-3 py-1.5">
                      <CategoryBadge category={h.category} size="sm" />
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  );

  return (
    <div className="space-y-3">
      {/* Header dengan back button */}
      <div className="flex items-center gap-2.5">
        <Button asChild variant="outline" size="sm" className="gap-1.5">
          <Link href={ROUTES.teacherHome}>
            <ArrowLeft className="h-3 w-3" aria-hidden /> Kembali
          </Link>
        </Button>
        <div>
          <h1 className="text-md font-bold text-foreground">
            Detail Siswa: {data.studentName}
          </h1>
          <p className="text-xs text-muted-foreground">
            Kelas {data.className} · {data.periodLabel}
          </p>
        </div>
        <div className="ml-auto flex items-center gap-2">
          <CategoryBadge category={data.category} size="md" />
          {CATEGORY_CONFIG[data.category ?? 'cukup'] && data.zScore !== null && (
            <span className="text-base font-bold text-foreground">
              Z* {formatScore(data.zScore, 1)}
            </span>
          )}
        </div>
      </div>

      <StudentDetailTabs
        ringkasanContent={ringkasanContent}
        kehadiranContent={kehadiranContent}
        poinContent={poinContent}
        peerContent={peerContent}
        historiContent={historiContent}
      />
    </div>
  );
}

// ── PEER_REVIEW_ASPECTS hanya di-import agar tipe tetap konsisten
void PEER_REVIEW_ASPECTS;