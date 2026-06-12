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
import { PaginationBar } from './_components/PaginationBar';

export const metadata = {
  title: 'Laporan Global',
};

const PAGE_SIZE = 25;

interface ReportData {
  rows: RankingRow[];        // sudah dipaginasi
  totalFiltered: number;     // jumlah setelah filter kategori
  currentPage: number;
  totalPages: number;
  avgZ: number | null;
  maxZ: number | null;
  minZ: number | null;
  distribution: Record<CategoryType, number>;
  periods: Array<{ id: string; label: string; isActive: boolean }>;
  classes: Array<{ id: string; name: string }>;
  selectedPeriodId: string;
  selectedClassId: string;
  selectedCategory: string;
}

interface SearchParams {
  period?: string;
  class?: string;
  category?: string;
  page?: string;
}

/** Nilai kosong yang dikembalikan saat tidak ada data. */
function emptyReport(
  periods: ReportData['periods'],
  classes: ReportData['classes'],
  selectedPeriodId: string,
  selectedClassId: string,
  selectedCategory: string,
): ReportData {
  return {
    rows: [],
    totalFiltered: 0,
    currentPage: 1,
    totalPages: 0,
    avgZ: null,
    maxZ: null,
    minZ: null,
    distribution: { sangat_baik: 0, baik: 0, cukup: 0, perlu_pembinaan: 0 },
    periods,
    classes,
    selectedPeriodId,
    selectedClassId,
    selectedCategory,
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
    isActive: p.status === 'active',
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

  const selectedClassId    = searchParams.class    ?? 'all';
  const selectedCategory   = searchParams.category ?? 'all';
  const currentPage        = Math.max(1, parseInt(searchParams.page ?? '1', 10));

  if (!selectedPeriodId) {
    return emptyReport(periods, classes, selectedPeriodId, selectedClassId, selectedCategory);
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
    return emptyReport(periods, classes, selectedPeriodId, selectedClassId, selectedCategory);
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
    return emptyReport(periods, classes, selectedPeriodId, selectedClassId, selectedCategory);
  }

  // ── Ambil skor — batch 200 per request (hindari URL terlalu panjang) ─
  const SCORE_BATCH = 200;
  const allScoreRows: unknown[] = [];
  for (let i = 0; i < enrollmentIds.length; i += SCORE_BATCH) {
    const chunk = enrollmentIds.slice(i, i + SCORE_BATCH);
    const { data: batch } = await supabase
      .from('behavior_final_scores')
      .select(
        `x1, x2, x3, z_star, category,
         enrollment:enrollment_id (
           student:student_id (id, full_name, nisn),
           assignment:class_period_assignment_id (
             class:class_id (name)
           )
         )`,
      )
      .in('enrollment_id', chunk);
    allScoreRows.push(...(batch ?? []));
  }
  const scoresData = allScoreRows;

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

  // ── Build ranked rows (seluruh data setelah filter periode+kelas) ─
  const allRanked: RankingRow[] = scoreRows
    .filter((s) => s.enrollment?.student)
    .map((s) => ({
      studentId: s.enrollment!.student!.id,
      nisn: s.enrollment!.student!.nisn ?? '—',
      fullName: s.enrollment!.student!.full_name,
      className: s.enrollment!.assignment?.class?.name ?? '—',
      x1: s.x1,
      x2: s.x2,
      x3: s.x3,
      zScore: s.z_star,
      category: s.category,
    }))
    .sort((a, b) => (b.zScore ?? -1) - (a.zScore ?? -1))
    .map((r, i) => ({ rank: i + 1, ...r }));

  // ── Distribusi (dari seluruh data, sebelum filter kategori) ────
  const distribution: Record<CategoryType, number> = {
    sangat_baik: 0,
    baik: 0,
    cukup: 0,
    perlu_pembinaan: 0,
  };
  for (const r of allRanked) {
    if (r.category) distribution[r.category as CategoryType] += 1;
  }

  // ── Statistik (dari seluruh data, sebelum filter kategori) ─────
  const validZ = allRanked
    .map((r) => r.zScore)
    .filter((z): z is number => typeof z === 'number');
  const avgZ =
    validZ.length > 0 ? validZ.reduce((a, b) => a + b, 0) / validZ.length : null;
  const maxZ = validZ.length > 0 ? Math.max(...validZ) : null;
  const minZ = validZ.length > 0 ? Math.min(...validZ) : null;

  // ── Filter kategori ────────────────────────────────────────────
  const filtered =
    selectedCategory === 'all'
      ? allRanked
      : allRanked.filter((r) => r.category === selectedCategory);

  const totalFiltered = filtered.length;
  const totalPages = Math.max(1, Math.ceil(totalFiltered / PAGE_SIZE));
  const safePage = Math.min(currentPage, totalPages);
  const rows = filtered.slice((safePage - 1) * PAGE_SIZE, safePage * PAGE_SIZE);

  return {
    rows,
    totalFiltered,
    currentPage: safePage,
    totalPages,
    avgZ,
    maxZ,
    minZ,
    distribution,
    periods,
    classes,
    selectedPeriodId,
    selectedClassId,
    selectedCategory,
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
        selectedCategory={data.selectedCategory}
      />

      {/* Stat tiles */}
      <div className="grid grid-cols-2 gap-3.5 lg:grid-cols-4">
        <StatCard
          label="Siswa Tampil"
          value={data.totalFiltered}
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
        <div className="flex flex-col gap-2">
          <RankingTable rows={data.rows} />
          <PaginationBar
            currentPage={data.currentPage}
            totalPages={data.totalPages}
            totalRows={data.totalFiltered}
            pageSize={PAGE_SIZE}
          />
        </div>

        <div className="rounded-md border border-sipandu-border bg-white p-3.5">
          <h2 className="mb-2.5 text-base font-bold text-foreground">
            Distribusi kategori
          </h2>
          <CategoryDistributionChart
            counts={data.distribution}
            totalStudents={Object.values(data.distribution).reduce((a, b) => a + b, 0)}
          />
        </div>
      </div>
    </div>
  );
}
