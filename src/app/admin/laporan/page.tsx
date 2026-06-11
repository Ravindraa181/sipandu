/**
 * @file app/admin/laporan/page.tsx
 * @description A7 — Laporan Global Z* Lintas Kelas.
 *
 *  FIXES:
 *   - z_star → z_star  (nama kolom di behavior_final_scores)
 *   - Hapus filter .in('class_period_assignment_id', ...) — kolom tidak ada di behavior_final_scores
 *     Ganti: ambil enrollment_id terlebih dahulu dari student_class_enrollments
 *   - Perbaiki join path: assignment:class_period_assignment_id (bukan assignment:class_period_assignment_id)
 */

import { ArrowDown, ArrowUp, BarChart3, Users } from 'lucide-react';

import { createClient } from '@/lib/supabase/server';
import { PageHeader } from '@/components/shared/PageHeader';
import type { CategoryType } from '@/types';
import { formatScore } from '@/lib/utils/format';
import { StatCard } from '../dashboard/_components/StatCard';
import { CategoryDistributionChart } from '../dashboard/_components/CategoryDistributionChart';
import { ReportFilterBar } from './_components/ReportFilterBar';
import { RankingTable, type RankingRow } from './_components/RankingTable';
import { ExportReportButtons } from './_components/ExportReportButtons';

export const metadata = {
  title: 'Laporan Global',
};

interface ReportData {
  rows: RankingRow[];
  totalShown: number;
  avgZ: number | null;
  maxZ: number | null;
  minZ: number | null;
  distribution: Record<CategoryType, number>;
  periods: Array<{ id: string; label: string; isActive: boolean }>;
  classes: Array<{ id: string; name: string }>;
  selectedPeriodId: string;
  selectedClassId: string;
}

interface SearchParams {
  period?: string;
  class?: string;
}

/** Nilai kosong yang dikembalikan saat tidak ada data. */
function emptyReport(
  periods: ReportData['periods'],
  classes: ReportData['classes'],
  selectedPeriodId: string,
  selectedClassId: string,
): ReportData {
  return {
    rows: [],
    totalShown: 0,
    avgZ: null,
    maxZ: null,
    minZ: null,
    distribution: { sangat_baik: 0, baik: 0, cukup: 0, perlu_pembinaan: 0 },
    periods,
    classes,
    selectedPeriodId,
    selectedClassId,
  };
}

async function loadReport(searchParams: SearchParams): Promise<ReportData> {
  const supabase = await createClient();

  // ── Daftar periode ──────────────────────────────────────────────
  const { data: periodsData } = await supabase
    .from('academic_periods')
    .select('id, name, status')
    .order('start_date', { ascending: false });

  const periods = (
    (periodsData ?? []) as Array<{ id: string; name: string; status: string }>
  ).map((p) => ({
    id: p.id,
    label: p.name,
    isActive: p.status === 'active',   // FIX: status enum, bukan is_active boolean
  }));

  const selectedPeriodId =
    searchParams.period ??
    (periods.find((p) => p.isActive)?.id ?? periods[0]?.id ?? '');

  // ── Daftar kelas ────────────────────────────────────────────────
  const { data: classesData } = await supabase
    .from('classes')
    .select('id, name')
    .order('name');
  const classes = (classesData ?? []) as Array<{ id: string; name: string }>;

  const selectedClassId = searchParams.class ?? 'all';

  if (!selectedPeriodId) {
    return emptyReport(periods, classes, selectedPeriodId, selectedClassId);
  }

  // ── Cari assignment untuk filter ───────────────────────────────
  let assignmentQuery = supabase
    .from('class_period_assignments')
    .select('id, class_id')
    .eq('period_id', selectedPeriodId);

  if (selectedClassId !== 'all') {
    assignmentQuery = assignmentQuery.eq('class_id', selectedClassId);
  }

  const { data: assignmentsData } = await assignmentQuery;
  const assignmentIds = (
    (assignmentsData ?? []) as Array<{ id: string; class_id: string }>
  ).map((a) => a.id);

  if (assignmentIds.length === 0) {
    return emptyReport(periods, classes, selectedPeriodId, selectedClassId);
  }

  // ── FIX: Ambil enrollment_id dari student_class_enrollments ────
  //    behavior_final_scores tidak punya kolom class_period_assignment_id —
  //    filter harus melalui enrollment_id.
  const { data: enrollmentsForFilter } = await supabase
    .from('student_class_enrollments')
    .select('id')
    .in('class_period_assignment_id', assignmentIds)
    .eq('status', 'active');

  const enrollmentIds = (
    (enrollmentsForFilter ?? []) as Array<{ id: string }>
  ).map((e) => e.id);

  if (enrollmentIds.length === 0) {
    return emptyReport(periods, classes, selectedPeriodId, selectedClassId);
  }

  // ── Ambil skor — filter by enrollment_id, kolom z_star ────────
  const { data: scoresData } = await supabase
    .from('behavior_final_scores')
    .select(
      `x1, x2, x3, z_star, category,
       enrollment:enrollment_id (
         student:student_id (id, full_name, nisn),
         assignment:class_period_assignment_id (
           class:class_id (name)
         )
       )`,
      // FIX: z_star (bukan z_star)
      // FIX: assignment:class_period_assignment_id (bukan assignment:class_period_assignment_id)
    )
    .in('enrollment_id', enrollmentIds);  // FIX: filter by enrollment_id

  type ScoreRow = {
    x1: number | null;
    x2: number | null;
    x3: number | null;
    z_star: number | null;              // FIX: z_star
    category: CategoryType | null;
    enrollment: {
      student: { id: string; full_name: string; nisn: string | null } | null;
      assignment: { class: { name: string } | null } | null;
    } | null;
  };

  const scoreRows = (scoresData ?? []) as unknown as ScoreRow[];

  // ── Build rows + ranking ────────────────────────────────────────
  const unranked = scoreRows
    .filter((s) => s.enrollment?.student)
    .map((s) => ({
      studentId: s.enrollment!.student!.id,
      nisn: s.enrollment!.student!.nisn ?? '—',
      fullName: s.enrollment!.student!.full_name,
      className: s.enrollment!.assignment?.class?.name ?? '—',
      x1: s.x1,
      x2: s.x2,
      x3: s.x3,
      zScore: s.z_star,                // FIX: z_star → zScore (TS alias)
      category: s.category,
    }))
    .sort((a, b) => (b.zScore ?? -1) - (a.zScore ?? -1));

  const rows: RankingRow[] = unranked.map((r, i) => ({ rank: i + 1, ...r }));

  // ── Statistik ──────────────────────────────────────────────────
  const validZ = rows
    .map((r) => r.zScore)
    .filter((z): z is number => typeof z === 'number');
  const avgZ =
    validZ.length > 0 ? validZ.reduce((a, b) => a + b, 0) / validZ.length : null;
  const maxZ = validZ.length > 0 ? Math.max(...validZ) : null;
  const minZ = validZ.length > 0 ? Math.min(...validZ) : null;

  // ── Distribusi ─────────────────────────────────────────────────
  const distribution: Record<CategoryType, number> = {
    sangat_baik: 0,
    baik: 0,
    cukup: 0,
    perlu_pembinaan: 0,
  };
  for (const r of rows) {
    if (r.category) distribution[r.category as CategoryType] += 1;
  }

  return {
    rows,
    totalShown: rows.length,
    avgZ,
    maxZ,
    minZ,
    distribution,
    periods,
    classes,
    selectedPeriodId,
    selectedClassId,
  };
}

export default async function AdminLaporanPage({
  searchParams,
}: {
  searchParams: Promise<SearchParams>;
}) {
  const params = await searchParams;
  const data = await loadReport(params);

  return (
    <div className="space-y-3">
      <PageHeader
        title="Laporan global"
        actions={
          /* Tombol export hanya aktif jika kelas spesifik sudah dipilih */
          <ExportReportButtons
            classId={data.selectedClassId}
            periodId={data.selectedPeriodId}
          />
        }
      />

      <ReportFilterBar
        periods={data.periods}
        classes={data.classes}
        selectedPeriodId={data.selectedPeriodId}
        selectedClassId={data.selectedClassId}
      />

      {/* Stat tiles */}
      <div className="grid grid-cols-2 gap-3.5 lg:grid-cols-4">
        <StatCard
          label="Siswa Tampil"
          value={data.totalShown}
          subLabel="berdasarkan filter"
          icon={Users}
          accent="navy"
        />
        <StatCard
          label="Rata-rata Nilai Akhir"
          value={data.avgZ !== null ? formatScore(data.avgZ, 1) : '—'}
          icon={BarChart3}
          accent="blue"
        />
        <StatCard
          label="Tertinggi"
          value={data.maxZ !== null ? formatScore(data.maxZ, 1) : '—'}
          icon={ArrowUp}
          accent="green"
        />
        <StatCard
          label="Terendah"
          value={data.minZ !== null ? formatScore(data.minZ, 1) : '—'}
          icon={ArrowDown}
          accent="amber"
        />
      </div>

      {/* Layout: tabel + distribusi */}
      <div className="grid grid-cols-1 gap-3.5 lg:grid-cols-[65%_35%]">
        <RankingTable rows={data.rows} />

        <div className="rounded-md border border-sipandu-border bg-white p-3.5">
          <h2 className="mb-2.5 text-base font-bold text-foreground">
            Distribusi kategori
          </h2>
          <CategoryDistributionChart
            counts={data.distribution}
            totalStudents={data.totalShown}
          />
        </div>
      </div>
    </div>
  );
}
