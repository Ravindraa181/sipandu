/**
 * @file app/siswa/page.tsx
 * @description S1 — Dashboard Siswa.
 *
 *  Server Component. Menampilkan:
 *   - Greeting "Halo, [Nama]" + meta kelas/periode
 *   - Conditional banner peer review (saat sesi aktif & belum 100% selesai)
 *   - Card besar Penilaian Perilaku (4 tile X1/X2/X3/Z* + kategori +
 *     interpretasi naratif positif)
 *   - 2 kolom: Kehadiran bulanan + Histori Z* SVG bar chart
 */

import { redirect } from 'next/navigation';

import { createClient } from '@/lib/supabase/server';
import { getStudentContext } from '@/lib/student/getStudentContext';
import { ROUTES } from '@/constants';
import type { CategoryType } from '@/types';
import { PeerReviewBanner } from './_components/PeerReviewBanner';
import { StudentScoreCard } from './_components/StudentScoreCard';
import {
  AttendanceSummary,
  type MonthSummary,
} from './_components/AttendanceSummary';
import {
  StudentHistoryChart,
  type HistoryItem,
} from './_components/StudentHistoryChart';

export const metadata = {
  title: 'Dashboard Saya — Siswa SiPandu',
};

interface DashboardData {
  studentFirstName: string;
  className: string;
  periodLabel: string;
  hasPeerReviewActive: boolean;
  peerDeadline: string | null;
  totalReviewees: number;
  myReviewsSubmitted: number;
  // Skor terkini
  x1: number | null;
  x2: number | null;
  x3: number | null;
  zScore: number | null;
  category: CategoryType | null;
  // Kehadiran
  monthSummaries: MonthSummary[];
  semesterX1: number | null;
  lockedMonthCount: number;
  // Histori
  history: HistoryItem[];
}

async function loadDashboard(): Promise<DashboardData> {
  const ctx = await getStudentContext();
  if (!ctx) redirect(ROUTES.login);
  const supabase = await createClient();

  // ── 1. Skor terkini ──────────────────────────────────────────────
  const { data: scoreRow } = await supabase
    .from('behavior_final_scores')
    .select('x1, x2, x3, z_star, category')
    .eq('enrollment_id', ctx.enrollmentId)
    .maybeSingle();

  const score = scoreRow as {
    x1: number | null;
    x2: number | null;
    x3: number | null;
    z_star: number | null;
    category: CategoryType | null;
  } | null;

  // ── 2. Kehadiran bulanan ────────────────────────────────────────
  const { data: monthsConfig } = await supabase
    .from('period_monthly_days')
    .select('month, year, effective_days')
    .eq('period_id', ctx.periodId)
    .order('year', { ascending: true })
    .order('month', { ascending: true });

  const { data: attendanceData } = await supabase
    .from('monthly_attendance')
    .select('month, year, present_days, is_locked')
    .eq('enrollment_id', ctx.enrollmentId);

  const attendMap = new Map<
    string,
    { present_days: number; is_locked: boolean }
  >();
    for (const a of ((attendanceData ?? []) as Array<{
      month: number;
      year: number;
      present_days: number;
      is_locked: boolean;
    }>)) {
    attendMap.set(`${a.year}-${a.month}`, {
      present_days: a.present_days,
      is_locked: a.is_locked,
    });
  }

  const monthsList = ((monthsConfig ?? []) as Array<{
    month: number;
    year: number;
    effective_days: number;
  }>);

  const monthSummaries: MonthSummary[] = monthsList.map((m) => {
    const a = attendMap.get(`${m.year}-${m.month}`);
    if (!a) {
      return {
        month: m.month,
        year: m.year,
        presentDays: null,
        effectiveDays: m.effective_days,
        status: 'empty',
      };
    }
    return {
      month: m.month,
      year: m.year,
      presentDays: a.present_days,
      effectiveDays: m.effective_days,
      // status: a.status,
      status: a.is_locked ? 'locked' : 'draft',
    };
  });

  const lockedMonths = monthSummaries.filter((m) => m.status === 'locked');
  const semesterX1 =
    lockedMonths.length > 0
      ? lockedMonths.reduce(
          (acc, m) =>
            acc + ((m.presentDays ?? 0) / Math.max(1, m.effectiveDays)) * 100,
          0,
        ) / lockedMonths.length
      : null;

  // ── 3. Histori Z* lintas periode ────────────────────────────────
  const { data: historyData } = await supabase
    .from('behavior_final_scores')
    .select(`
      z_star, category,
      enrollment:enrollment_id (
        student_id,
        assignment:class_period_assignment_id (
          period:period_id (name, start_date)
         )
       )`,
    );

  const history: HistoryItem[] = (
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
    .filter((h) => h.enrollment?.student_id === ctx.studentId)
    .map((h) => ({
      label: h.enrollment?.assignment?.period?.name ?? '—',
      startDate: h.enrollment?.assignment?.period?.start_date ?? '',
      zScore: h.z_star,
      category: h.category,
    }))
    .sort((a, b) => (a.startDate > b.startDate ? 1 : -1))
    .map(({ label, zScore, category }) => ({ label, zScore, category }));

  return {
    studentFirstName: ctx.studentName.split(/\s+/)[0] ?? ctx.studentName,
    className: ctx.className,
    periodLabel: ctx.periodLabel,
    hasPeerReviewActive: ctx.hasPeerReviewActive,
    peerDeadline: ctx.peerDeadline,
    totalReviewees: ctx.totalReviewees,
    myReviewsSubmitted: ctx.myReviewsSubmitted,
    x1: score?.x1 ?? null,
    x2: score?.x2 ?? null,
    x3: score?.x3 ?? null,
    zScore: score?.z_star ?? null,
    category: score?.category ?? null,
    monthSummaries,
    semesterX1,
    lockedMonthCount: lockedMonths.length,
    history,
  };
}

export default async function StudentDashboardPage() {
  const data = await loadDashboard();

  return (
    <div className="space-y-3.5">
      {/* Greeting */}
      <div>
        <h1 className="text-2xl font-bold text-foreground">
          Halo, {data.studentFirstName}!{' '}
          <span className="text-xl">👋</span>
        </h1>
        <p className="mt-0.5 text-sm text-muted-foreground">
          Kelas {data.className} · Semester {data.periodLabel}
        </p>
      </div>

      {/* Conditional banner peer review */}
      {data.hasPeerReviewActive && (
        <PeerReviewBanner
          deadline={data.peerDeadline}
          totalReviewees={data.totalReviewees}
          myReviewsSubmitted={data.myReviewsSubmitted}
        />
      )}

      {/* Score card 4 tile */}
      <StudentScoreCard
        periodLabel={data.periodLabel}
        x1={data.x1}
        x2={data.x2}
        x3={data.x3}
        zScore={data.zScore}
        category={data.category}
      />

      {/* Bottom: kehadiran + histori */}
      <div className="grid grid-cols-1 gap-3.5 lg:grid-cols-2">
        <AttendanceSummary
          months={data.monthSummaries}
          semesterX1={data.semesterX1}
          lockedMonthCount={data.lockedMonthCount}
        />
        <StudentHistoryChart bars={data.history} />
      </div>
    </div>
  );
}
