/**
 * @file app/dashboard/hasil-penilaian/page.tsx
 * @description W6 — Hasil Penilaian Akhir Kelas.
 *
 * Server Component:
 * - Distribusi kategori (bar chart)
 * - Ringkasan statistik (rata-rata, max, min, jumlah per kategori)
 * - Tabel sortable + filter kategori (client)
 * - Catatan naratif untuk top-3 siswa (auto-save) + tombol untuk
 * menambah catatan siswa lain
 * - Tombol Export Excel & PDF
 */

import { redirect } from 'next/navigation';
import { ArrowDown, ArrowUp, BarChart3, Users } from 'lucide-react';

import { createClient } from '@/lib/supabase/server';
// PERBAIKAN: Gunakan getAssignmentContext
import { getAssignmentContext } from '@/lib/teacher/getAssignment';
import { PageHeader } from '@/components/shared/PageHeader';
import { CategoryBadge } from '@/components/shared/CategoryBadge';
import { ROUTES } from '@/constants';
import { formatScore } from '@/lib/utils/format';
import type { CategoryType } from '@/types';
import { StatCard } from '../../admin/dashboard/_components/StatCard';
import { CategoryDistributionChart } from '../../admin/dashboard/_components/CategoryDistributionChart';
import { ResultsTable, type ResultRow } from './_components/ResultsTable';
import { ExportButtons } from './_components/ExportButtons';
import { RecalculateButton } from './_components/RecalculateButton';
import { TeacherNoteForm } from '../siswa/[id]/_components/TeacherNoteForm';

export const metadata = {
  title: 'Hasil Penilaian',
};

interface NarrativeNote {
  enrollmentId: string;
  studentName: string;
  zScore: number | null;
  category: CategoryType | null;
  initialNote: string;
}

interface PageData {
  classId: string;
  periodId: string;
  className: string;
  periodLabel: string;
  totalStudents: number;
  scoredCount: number;
  averageZ: number | null;
  maxZ: number | null;
  minZ: number | null;
  distribution: Record<CategoryType, number>;
  notScoredCount: number;
  rows: ResultRow[];
  /** Top-3 siswa untuk catatan naratif. */
  topNotes: NarrativeNote[];
}

async function loadData(): Promise<PageData> {
  const assignment = await getAssignmentContext();
  if (!assignment) redirect(ROUTES.waiting);

  const supabase = await createClient();

  // PERBAIKAN: Fetch siswa manual karena getAssignmentContext tidak memuat array students
  const { data: enrollData } = await supabase
    .from('student_class_enrollments')
    .select('id, student:profiles(full_name)')
    .eq('class_period_assignment_id', assignment.assignmentId)
    .eq('status', 'active');

  const students = (enrollData ?? []).map((e: any) => ({
    enrollmentId: e.id,
    fullName: e.student?.full_name ?? 'Unknown',
  }));

  const enrollmentIds = students.map((s) => s.enrollmentId);

  // ── 1. Skor akhir per enrollment ────────────────────────────────
  // PERBAIKAN: Filter menggunakan list enrollmentIds, bukan class_period_assignment_id
  const { data: scoresData } = await supabase
    .from('behavior_final_scores')
    .select('enrollment_id, x1, x2, x3, z_star, category')
    .in('enrollment_id', enrollmentIds);

  const scoreMap = new Map<
    string,
    {
      x1: number | null;
      x2: number | null;
      x3: number | null;
      zScore: number | null;
      category: CategoryType | null;
    }
  >();
  
  for (const s of ((scoresData ?? []) as Array<{
    enrollment_id: string;
    x1: number | null;
    x2: number | null;
    x3: number | null;
    z_star: number | null;
    category: CategoryType | null;
  }>)) {
    scoreMap.set(s.enrollment_id, {
      x1: s.x1,
      x2: s.x2,
      x3: s.x3,
      zScore: s.z_star,
      category: s.category,
    });
  }

  // ── 2. Build rows + ranking ─────────────────────────────────────
  const unranked = students.map((s) => {
    const score = scoreMap.get(s.enrollmentId);
    return {
      enrollmentId: s.enrollmentId,
      fullName: s.fullName,
      x1: score?.x1 ?? null,
      x2: score?.x2 ?? null,
      x3: score?.x3 ?? null,
      zScore: score?.zScore ?? null,
      category: score?.category ?? null,
    };
  });
  
  const ranked: ResultRow[] = [...unranked]
    .sort((a, b) => (b.zScore ?? -1) - (a.zScore ?? -1))
    .map((s, i) => ({ ...s, rank: i + 1 }));

  // ── 3. Statistik ────────────────────────────────────────────────
  const validZ = ranked
    .map((r) => r.zScore)
    .filter((z): z is number => typeof z === 'number');
  const averageZ =
    validZ.length > 0
      ? validZ.reduce((a, b) => a + b, 0) / validZ.length
      : null;
  const maxZ = validZ.length > 0 ? Math.max(...validZ) : null;
  const minZ = validZ.length > 0 ? Math.min(...validZ) : null;

  const distribution: Record<CategoryType, number> = {
    sangat_baik: 0,
    baik: 0,
    cukup: 0,
    perlu_pembinaan: 0,
  };
  for (const r of ranked) {
    if (r.category) distribution[r.category as CategoryType] += 1;
  }

  // ── 4. Catatan naratif top-3 ────────────────────────────────────
  const topThree = ranked.slice(0, 3);
  const topEnrollmentIds = topThree.map((t) => t.enrollmentId);

  // PERBAIKAN: Gunakan note_text
  const { data: notesData } =
    topEnrollmentIds.length > 0
      ? await supabase
          .from('teacher_narrative_notes')
          .select('enrollment_id, note_text')
          .in('enrollment_id', topEnrollmentIds)
      : { data: [] };

  const noteMap = new Map<string, string>();
  for (const n of ((notesData ?? []) as Array<{
    enrollment_id: string;
    note_text: string;
  }>)) {
    noteMap.set(n.enrollment_id, n.note_text);
  }

  const topNotes: NarrativeNote[] = topThree.map((t) => ({
    enrollmentId: t.enrollmentId,
    studentName: t.fullName,
    zScore: t.zScore,
    category: t.category,
    initialNote: noteMap.get(t.enrollmentId) ?? '',
  }));

  return {
    classId: assignment.classId,
    periodId: assignment.periodId,
    className: assignment.className,
    periodLabel: assignment.periodName,
    totalStudents: students.length,
    scoredCount: validZ.length,
    averageZ,
    maxZ,
    minZ,
    distribution,
    notScoredCount: ranked.length - validZ.length,
    rows: ranked,
    topNotes,
  };
}

export default async function TeacherHasilPenilaianPage() {
  const data = await loadData();

  return (
    <div className="space-y-3">
      <PageHeader
        title={`Hasil penilaian — Kelas ${data.className}`}
        subtitle={data.periodLabel}
        actions={
          <div className="flex flex-wrap items-center gap-2">
            <RecalculateButton classId={data.classId} periodId={data.periodId} />
            {/* Oper classId & periodId agar ExportButtons bisa memanggil API nyata */}
            <ExportButtons classId={data.classId} periodId={data.periodId} />
          </div>
        }
      />

      {/* Banner info saat belum ada siswa yang dihitung */}
      {data.scoredCount === 0 && (
        <div className="rounded-md border border-sipandu-blue/40 bg-blue-50 px-4 py-3 text-sm text-sipandu-blue-deep">
          <strong>Data nilai belum dihitung.</strong> Klik tombol{' '}
          <strong>Hitung / Perbarui Nilai Akhir</strong> di kanan atas untuk
          menjalankan kalkulasi Fuzzy Mamdani. Pastikan minimal satu bulan
          kehadiran sudah dikunci dan sesi peer review sudah ditutup.
        </div>
      )}

      {/* Stat tile */}
      <div className="grid grid-cols-2 gap-3.5 lg:grid-cols-4">
        <StatCard
          label="Total Siswa"
          value={data.totalStudents}
          subLabel={`${data.scoredCount} sudah dinilai`}
          icon={Users}
          accent="navy"
        />
        <StatCard
          label="Rata-rata Nilai Akhir"
          value={data.averageZ !== null ? formatScore(data.averageZ, 1) : '—'}
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

      {/* Distribusi + ringkasan */}
      <div className="grid grid-cols-1 gap-3.5 lg:grid-cols-2">
        <div className="rounded-md border border-sipandu-border bg-white p-3.5">
          <h2 className="mb-2.5 text-base font-bold text-foreground">
            Distribusi kategori
          </h2>
          <CategoryDistributionChart
            counts={data.distribution}
            totalStudents={data.totalStudents}
            notScoredCount={data.notScoredCount}
          />
        </div>

        <div className="rounded-md border border-sipandu-border bg-white p-3.5">
          <h2 className="mb-2.5 text-base font-bold text-foreground">
            Ringkasan statistik
          </h2>
          <div className="space-y-2 text-sm">
            <div className="flex justify-between border-b border-sipandu-border py-1.5">
              <span className="text-foreground">Total siswa</span>
              <strong>{data.totalStudents}</strong>
            </div>
            <div className="flex justify-between border-b border-sipandu-border py-1.5">
              <span className="text-foreground">Sudah dinilai</span>
              <strong>{data.scoredCount}</strong>
            </div>
            <div className="flex justify-between border-b border-sipandu-border py-1.5">
              <span className="text-foreground">Belum dinilai</span>
              <strong>{data.notScoredCount}</strong>
            </div>
            <div className="flex justify-between border-b border-sipandu-border py-1.5">
              <span className="text-foreground">Rata-rata Nilai Akhir</span>
              <strong className="text-sipandu-blue">
                {data.averageZ !== null ? formatScore(data.averageZ, 2) : '—'}
              </strong>
            </div>
            <div className="flex justify-between py-1.5">
              <span className="text-foreground">Range</span>
              <strong>
                {data.minZ !== null && data.maxZ !== null
                  ? `${formatScore(data.minZ, 1)} – ${formatScore(data.maxZ, 1)}`
                  : '—'}
              </strong>
            </div>
          </div>
        </div>
      </div>

      {/* Tabel ranking */}
      <div>
        <h2 className="mb-3 text-base font-bold text-foreground">
          Tabel ranking siswa
        </h2>
        <ResultsTable rows={data.rows} />
      </div>

      {/* Catatan naratif top-3 */}
      {data.topNotes.length > 0 && (
        <div className="rounded-md border border-sipandu-border bg-white p-3.5">
          <h2 className="mb-1 text-base font-bold text-foreground">
            Catatan naratif untuk laporan
          </h2>
          <p className="mb-3 text-xs text-muted-foreground">
            Gunakan textarea ini untuk catatan naratif siswa top-3. Catatan
            akan tersimpan otomatis saat Anda berhenti mengetik. Untuk siswa
            lain, buka halaman Detail Siswa.
          </p>

          <div className="grid grid-cols-1 gap-3 lg:grid-cols-3">
            {data.topNotes.map((n) => (
              <div
                key={n.enrollmentId}
                className="rounded-md border border-sipandu-border bg-gray-50 p-3"
              >
                <div className="mb-2 flex items-center justify-between">
                  <strong className="text-sm text-foreground">
                    {n.studentName}
                  </strong>
                  <CategoryBadge category={n.category} size="sm" />
                </div>
                <div className="mb-2 text-2xs text-muted-foreground">
                  Nilai Akhir = {formatScore(n.zScore, 2)}
                </div>
                <TeacherNoteForm
                  enrollmentId={n.enrollmentId}
                  initialNote={n.initialNote}
                  studentName={n.studentName}
                  label="Catatan naratif"
                />
              </div>
            ))}
          </div>

          <div className="mt-3 text-xs text-muted-foreground">
            Untuk menambah catatan siswa lain, buka halaman{' '}
            <strong>Detail Siswa</strong> dari tabel ranking di atas.
          </div>
        </div>
      )}
    </div>
  );
}