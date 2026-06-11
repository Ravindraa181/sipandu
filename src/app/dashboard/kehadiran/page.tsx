/**
 * @file app/dashboard/kehadiran/page.tsx
 * @description W2 — Input Kehadiran Bulanan.
 *
 *  Server Component:
 *   - Tentukan bulan aktif via search params (?month=10&year=2024) atau
 *     fallback ke bulan saat ini.
 *   - Ambil monthly_attendance untuk bulan tsb (status, H/S/I/A per siswa).
 *   - Tentukan UI state per bulan (locked/active/upcoming/future).
 *   - Render: pill tabs + banner status + tabel input + accordion akumulasi.
 */

import { redirect } from 'next/navigation';
import { Calendar, Lock } from 'lucide-react';

import { createClient } from '@/lib/supabase/server';
import { getAssignmentContext } from '@/lib/teacher/getAssignment';
import { PageHeader } from '@/components/shared/PageHeader';
import { MONTHS, ROUTES } from '@/constants';
import { MonthTabs, type MonthTab } from './_components/MonthTabs';
import {
  AttendanceTable,
  type AttendanceRowData,
} from './_components/AttendanceTable';
import {
  X1AccumulationAccordion,
  type X1Row,
} from './_components/X1AccumulationAccordion';

export const metadata = {
  title: 'Input Kehadiran',
};

interface SearchParams {
  month?: string;
  year?: string;
}

interface PageData {
  assignmentId: string;
  monthTabs: MonthTab[];
  selectedMonth: number;
  selectedYear: number;
  selectedEffectiveDays: number;
  monthStatus: 'locked' | 'active' | 'upcoming' | 'future';
  rows: AttendanceRowData[];
  /** Untuk accordion akumulasi. */
  accumulationRows: X1Row[];
  monthOrder: Array<{ month: number; year: number }>;
}

/** Tentukan UI state untuk satu bulan dalam periode. */
function deriveUiState(
  month: number,
  year: number,
  monthlyDbStatus: 'locked' | 'draft' | undefined,
): MonthTab['uiState'] {
  if (monthlyDbStatus === 'locked') return 'locked';
  const now = new Date();
  const nowYear = now.getFullYear();
  const nowMonth = now.getMonth() + 1;
  const isPast = year < nowYear || (year === nowYear && month < nowMonth);
  const isCurrent = year === nowYear && month === nowMonth;
  if (isCurrent || isPast) return 'active';
  return 'future';
}

async function loadData(searchParams: SearchParams): Promise<PageData> {
  const assignment = await getAssignmentContext();
  if (!assignment) redirect(ROUTES.waiting);
  const supabase = await createClient();

  // ── Ambil Hari Efektif (Monthly Days) ───────────────────────────
  const { data: monthlyDaysData } = await supabase
    .from('period_monthly_days')
    .select('month, year, effective_days')
    .eq('period_id', assignment.periodId);

  const monthlyDays = (monthlyDaysData ?? []).map((m) => ({
    month: m.month,
    year: m.year,
    effectiveDays: m.effective_days,
  }));

  // ── Ambil Siswa (Enrollments) ───────────────────────────────────
  const { data: enrollmentsData } = await supabase
    .from('student_class_enrollments')
    .select('id, student:student_id (id, full_name)')
    .eq('class_period_assignment_id', assignment.assignmentId)
    .eq('status', 'active');

  const students = (((enrollmentsData as unknown) as Array<{
    id: string;
    student: { id: string; full_name: string } | null;
  }>) ?? [])
    .filter((e) => e.student)
    .map((e) => ({
      enrollmentId: e.id,
      fullName: e.student!.full_name,
    }));

  const enrollmentIds = students.map((s) => s.enrollmentId);

  // ── 1. Status setiap bulan dari DB ──────────────────────────────
  let allAttendance: any[] = [];
  if (enrollmentIds.length > 0) {
    const { data } = await supabase
      .from('monthly_attendance')
      .select('month, year, is_locked')
      .in('enrollment_id', enrollmentIds);
    allAttendance = data ?? [];
  }

  const monthDbStatusMap = new Map<string, 'locked' | 'draft'>();
  for (const r of (allAttendance as unknown) as Array<{
    month: number;
    year: number;
    is_locked: boolean;
  }>) {
    const key = `${r.year}-${r.month}`;
    if (monthDbStatusMap.get(key) === 'locked') continue;
    // Jika ada satu saja yang belum di-lock, kita anggap masih draft/active (tergantung implementasi spesifik)
    // Asumsinya wali kelas mengunci secara kolektif
    monthDbStatusMap.set(key, r.is_locked ? 'locked' : 'draft');
  }

  // ── 2. Build month tabs ─────────────────────────────────────────
  const monthTabs: MonthTab[] = monthlyDays.map((m) => {
    const dbStatus = monthDbStatusMap.get(`${m.year}-${m.month}`);
    return {
      month: m.month,
      year: m.year,
      effectiveDays: m.effectiveDays,
      uiState: deriveUiState(m.month, m.year, dbStatus),
    };
  });

  // ── 3. Tentukan bulan terpilih ───────────────────────────────────
  const requestedMonth = searchParams.month ? Number(searchParams.month) : null;
  const requestedYear = searchParams.year ? Number(searchParams.year) : null;

  let selectedTab: MonthTab | undefined;
  if (requestedMonth && requestedYear) {
    selectedTab = monthTabs.find(
      (t) => t.month === requestedMonth && t.year === requestedYear,
    );
  }
  if (!selectedTab) {
    selectedTab =
      monthTabs.find((t) => t.uiState === 'active') ??
      [...monthTabs].reverse().find((t) => t.uiState === 'locked') ??
      monthTabs[0];
  }

  if (!selectedTab) {
    // Periode belum ada hari efektif sama sekali
    return {
      assignmentId: assignment.assignmentId,
      monthTabs: [],
      selectedMonth: new Date().getMonth() + 1,
      selectedYear: new Date().getFullYear(),
      selectedEffectiveDays: 0,
      monthStatus: 'future',
      rows: [],
      accumulationRows: [],
      monthOrder: [],
    };
  }

  // ── 4. Ambil data attendance untuk bulan terpilih ────────────────
  let attendData: any[] = [];
  if (enrollmentIds.length > 0) {
    const { data } = await supabase
      .from('monthly_attendance')
      .select('enrollment_id, present_days, sick_days, permit_days, absent_days')
      .in('enrollment_id', enrollmentIds)
      .eq('month', selectedTab.month)
      .eq('year', selectedTab.year);
    attendData = data ?? [];
  }

  const attendMap = new Map<
    string,
    {
      present_days: number;
      sick_days: number;
      permit_days: number;
      absent_days: number;
    }
  >();
  for (const a of (attendData as unknown) as Array<{
    enrollment_id: string;
    present_days: number;
    sick_days: number;
    permit_days: number;
    absent_days: number;
  }>) {
    attendMap.set(a.enrollment_id, {
      present_days: a.present_days,
      sick_days: a.sick_days,
      permit_days: a.permit_days, // Fix the permit_days column reference
      absent_days: a.absent_days,
    });
  }

  const rows: AttendanceRowData[] = students.map((s) => {
    const a = attendMap.get(s.enrollmentId);
    return {
      enrollmentId: s.enrollmentId,
      fullName: s.fullName,
      presentDays: a?.present_days ?? 0,
      sickDays: a?.sick_days ?? 0,
      permittedDays: a?.permit_days ?? 0, // Disesuaikan untuk UI
      absentDays: a?.absent_days ?? 0,
    };
  });

  // ── 5. Akumulasi X1 ──────────────────────────────────────────────
  let lockedAttend: any[] = [];
  if (enrollmentIds.length > 0) {
    const { data } = await supabase
      .from('monthly_attendance')
      .select('enrollment_id, month, year, present_days, effective_days')
      .in('enrollment_id', enrollmentIds)
      .eq('is_locked', true); // Fix: use is_locked instead of status='locked'
    lockedAttend = data ?? [];
  }

  const lockedRows = (lockedAttend as unknown) as Array<{
    enrollment_id: string;
    month: number;
    year: number;
    present_days: number;
    effective_days: number;
  }>;

  const accumulationRows: X1Row[] = students.slice(0, 10).map((s) => {
    const cells = monthlyDays.map((md) => {
      const found = lockedRows.find(
        (l) =>
          l.enrollment_id === s.enrollmentId &&
          l.month === md.month &&
          l.year === md.year,
      );
      const percent =
        found && found.effective_days > 0
          ? Math.round((found.present_days / found.effective_days) * 100)
          : null;
      return { month: md.month, year: md.year, percent };
    });
    const validPercents = cells
      .map((c) => c.percent)
      .filter((p): p is number => typeof p === 'number');
    const avg =
      validPercents.length > 0
        ? validPercents.reduce((a, b) => a + b, 0) / validPercents.length
        : null;
    return {
      enrollmentId: s.enrollmentId,
      fullName: s.fullName,
      cells,
      averageX1: avg,
    };
  });

  return {
    assignmentId: assignment.assignmentId,
    monthTabs,
    selectedMonth: selectedTab.month,
    selectedYear: selectedTab.year,
    selectedEffectiveDays: selectedTab.effectiveDays,
    monthStatus: selectedTab.uiState,
    rows,
    accumulationRows,
    monthOrder: monthlyDays.map((m) => ({
      month: m.month,
      year: m.year,
    })),
  };
}

export default async function TeacherKehadiranPage({
  searchParams,
}: {
  searchParams: Promise<SearchParams>;
}) {
  const params = await searchParams;
  const data = await loadData(params);

  return (
    <div className="space-y-3">
      <PageHeader title="Input kehadiran siswa" />

      {/* Pill tabs */}
      <MonthTabs
        tabs={data.monthTabs}
        activeMonth={data.selectedMonth}
        activeYear={data.selectedYear}
      />

      {/* Banner status */}
      {data.monthStatus === 'locked' ? (
        <div className="flex items-center gap-2.5 rounded-md border border-status-on-soft bg-green-50 px-3.5 py-2.5 text-sm">
          <Lock className="h-3.5 w-3.5 text-status-on" aria-hidden />
          <span className="text-status-on-text">
            Data {MONTHS[data.selectedMonth - 1]} {data.selectedYear} sudah
            terkunci
          </span>
          <span className="ml-auto inline-flex items-center gap-1 rounded-full bg-status-on-soft px-2 py-0.5 text-2xs font-semibold text-status-on-text">
            <Lock className="h-2.5 w-2.5" aria-hidden /> Terkunci
          </span>
        </div>
      ) : data.monthStatus === 'active' ? (
        <div className="flex items-center gap-2.5 rounded-md border border-sipandu-blue/40 bg-blue-50 px-3.5 py-2.5 text-sm">
          <Calendar className="h-3.5 w-3.5 text-sipandu-blue" aria-hidden />
          <span className="text-sipandu-blue-deep">
            Hari efektif {MONTHS[data.selectedMonth - 1]}{' '}
            {data.selectedYear}: <strong>{data.selectedEffectiveDays} hari</strong>
          </span>
        </div>
      ) : (
        <div className="rounded-md border border-status-warn-soft bg-amber-50 px-3.5 py-2.5 text-sm text-status-warn-text">
          Bulan ini belum waktunya untuk diisi.
        </div>
      )}

      {/* Tabel input */}
      <AttendanceTable
        assignmentId={data.assignmentId}
        month={data.selectedMonth}
        year={data.selectedYear}
        effectiveDays={data.selectedEffectiveDays}
        monthStatus={data.monthStatus}
        initialRows={data.rows}
      />

      {/* Akumulasi X1 */}
      <X1AccumulationAccordion
        rows={data.accumulationRows}
        monthOrder={data.monthOrder}
      />
    </div>
  );
}