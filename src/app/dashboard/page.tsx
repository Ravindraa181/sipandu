/**
 * @file app/dashboard/page.tsx
 * @description W1 — Dashboard Wali Kelas.
 *
 * Server Component. Menampilkan:
 * - Greeting (nama wali kelas + emoji + meta kelas)
 * - Layout 2 kolom (atas):
 * Kiri: checklist progres pengisian per bulan kehadiran + poin + peer
 * Kanan: 4 stat-card kecil (siswa terdaftar, lengkap, belum, rata-rata)
 * + distribusi kategori
 * - Bawah: tabel siswa lengkap (sortable, link ke detail)
 */

import { redirect } from 'next/navigation';

import { createClient } from '@/lib/supabase/server';
// PERBAIKAN: Gunakan nama fungsi yang diekspor dari getAssignment.ts
import { getAssignmentContext } from '@/lib/teacher/getAssignment';
import { CATEGORY_ORDER, MONTHS, ROUTES } from '@/constants';
import { formatScore } from '@/lib/utils/format';
import type { CategoryType, ChecklistStatus } from '@/types';
import { StatCard } from '../admin/dashboard/_components/StatCard';
import { CategoryDistributionChart } from '../admin/dashboard/_components/CategoryDistributionChart';
import { ChecklistItem } from './_components/ChecklistItem';
import {
  ClassStudentsTable,
  type ClassStudentRow,
} from './_components/ClassStudentsTable';
import { RecalculateButton } from './hasil-penilaian/_components/RecalculateButton';

export const metadata = {
  title: 'Dashboard Wali Kelas',
};

interface DashboardData {
  classId: string;
  periodId: string;
  teacherFirstName: string;
  className: string;
  periodLabel: string;
  totalStudents: number;
  completeCount: number;
  incompleteCount: number;
  averageZ: number | null;
  checklist: ChecklistStatus[];
  distribution: Record<CategoryType, number>;
  notScoredCount: number;
  studentRows: ClassStudentRow[];
}

async function loadDashboard(): Promise<DashboardData> {
  const assignment = await getAssignmentContext();
  if (!assignment) redirect(ROUTES.waiting);

  const supabase = await createClient();

  // PERBAIKAN: Ambil daftar siswa yang terdaftar di kelas-periode ini
  const { data: enrollData } = await supabase
    .from('student_class_enrollments')
    .select('id, student_id, student:profiles(full_name)')
    .eq('class_period_assignment_id', assignment.assignmentId)
    .eq('status', 'active');

  const students = (enrollData ?? []).map((e: any) => ({
    enrollmentId: e.id,
    studentId: e.student_id,
    fullName: e.student?.full_name ?? 'Unknown',
  }));

  const enrollmentIds = students.map((s) => s.enrollmentId);

  // Ambil data hari aktif per bulan untuk kelas ini
  const { data: monthlyDaysData } = await supabase
    .from('period_monthly_days')
    .select('month, year, effective_days')
    .eq('period_id', assignment.periodId);
  const monthlyDays = monthlyDaysData ?? [];

  // ── 1. Kehadiran per bulan: cek mana yang locked / draft / kosong
  const { data: attendance } = await supabase
    .from('monthly_attendance')
    .select('month, year, is_locked') // PERBAIKAN: gunakan is_locked, bukan status
    .in('enrollment_id', enrollmentIds);

  const monthStatusMap = new Map<string, 'locked' | 'draft'>();
  for (const r of ((attendance ?? []) as Array<{
    month: number;
    year: number;
    is_locked: boolean;
  }>)) {
    const key = `${r.year}-${r.month}`;
    const status = r.is_locked ? 'locked' : 'draft';
    if (monthStatusMap.get(key) === 'locked') continue;
    monthStatusMap.set(key, status);
  }

  // ── 2. Poin transaksi exists?
  const { count: pointTxnCount } = await supabase
    .from('behavior_point_transactions')
    .select('id', { count: 'exact', head: true })
    .in('enrollment_id', enrollmentIds);

  // ── 3. Status sesi peer review
  const { data: peerSession } = await supabase
    .from('peer_review_sessions')
    .select('status')
    .eq('class_period_assignment_id', assignment.assignmentId)
    .maybeSingle();

  const peerStatus =
    (peerSession?.status as 'not_started' | 'active' | 'closed' | undefined) ??
    'not_started';

  // ── 4. Skor akhir Z* per enrollment
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

  // ── 5. Build student rows + ranking
  const unranked = students.map((s) => {
    const score = scoreMap.get(s.enrollmentId);
    return {
      enrollmentId: s.enrollmentId,
      studentId: s.studentId,
      fullName: s.fullName,
      x1: score?.x1 ?? null,
      x2: score?.x2 ?? null,
      x3: score?.x3 ?? null,
      zScore: score?.zScore ?? null,
      category: score?.category ?? null,
    };
  });

  const ranked = [...unranked]
    .sort((a, b) => (b.zScore ?? -1) - (a.zScore ?? -1))
    .map((s, i) => ({ ...s, rank: i + 1 }));

  // ── 6. Statistik
  const validZ = ranked
    .map((r) => r.zScore)
    .filter((z): z is number => typeof z === 'number');
  const completeCount = validZ.length;
  const incompleteCount = ranked.length - completeCount;
  const averageZ =
    validZ.length > 0
      ? validZ.reduce((a, b) => a + b, 0) / validZ.length
      : null;

  // ── 7. Distribusi
  const distribution: Record<CategoryType, number> = {
    sangat_baik: 0,
    baik: 0,
    cukup: 0,
    perlu_pembinaan: 0,
  };
  for (const r of ranked) {
    if (r.category) distribution[r.category as CategoryType] += 1;
  }

  // ── 8. Build checklist progres
  const checklist: ChecklistStatus[] = [];
  for (const m of monthlyDays) {
    const key = `${m.year}-${m.month}`;
    const status = monthStatusMap.get(key);
    const monthLabel = MONTHS[m.month - 1] ?? '';
    if (status === 'locked') {
      checklist.push({
        id: `att-${key}`,
        label: `Kehadiran ${monthLabel}`,
        status: 'done',
        helperText: 'Selesai & Terkunci',
      });
    } else if (status === 'draft') {
      checklist.push({
        id: `att-${key}`,
        label: `Kehadiran ${monthLabel}`,
        status: 'in_progress',
        helperText: 'Tersimpan (draft)',
        actionLabel: 'Lanjutkan',
        actionHref: ROUTES.teacherKehadiran,
      });
    } else {
      const now = new Date();
      const isCurrent = now.getMonth() + 1 === m.month && now.getFullYear() === m.year;
      const isPast =
        m.year < now.getFullYear() ||
        (m.year === now.getFullYear() && m.month < now.getMonth() + 1);
      if (isCurrent) {
        checklist.push({
          id: `att-${key}`,
          label: `Kehadiran ${monthLabel}`,
          status: 'in_progress',
          helperText: 'Belum diisi',
          actionLabel: 'Isi Sekarang',
          actionHref: ROUTES.teacherKehadiran,
        });
      } else if (isPast) {
        checklist.push({
          id: `att-${key}`,
          label: `Kehadiran ${monthLabel}`,
          status: 'overdue',
          helperText: 'Terlewat — segera isi',
          actionLabel: 'Isi',
          actionHref: ROUTES.teacherKehadiran,
        });
      } else {
        checklist.push({
          id: `att-${key}`,
          label: `Kehadiran ${monthLabel}`,
          status: 'pending',
          helperText: 'Belum waktunya',
        });
      }
    }
  }

  if ((pointTxnCount ?? 0) > 0) {
    checklist.push({
      id: 'points',
      label: 'Input Poin Perilaku',
      status: 'done',
      helperText: 'Data tersedia (bisa diperbarui)',
    });
  } else {
    checklist.push({
      id: 'points',
      label: 'Input Poin Perilaku',
      status: 'pending',
      helperText: 'Belum ada catatan',
      actionLabel: 'Mulai',
      actionHref: ROUTES.teacherPoin,
    });
  }

  if (peerStatus === 'closed') {
    checklist.push({
      id: 'peer',
      label: 'Peer Review',
      status: 'done',
      helperText: 'Sesi telah ditutup',
    });
  } else if (peerStatus === 'active') {
    checklist.push({
      id: 'peer',
      label: 'Peer Review',
      status: 'in_progress',
      helperText: 'Sesi sedang berlangsung',
      actionLabel: 'Kelola',
      actionHref: ROUTES.teacherPeerReview,
    });
  } else {
    checklist.push({
      id: 'peer',
      label: 'Peer Review',
      status: 'overdue',
      helperText: 'Belum dibuka',
      actionLabel: 'Buka Sesi',
      actionHref: ROUTES.teacherPeerReview,
    });
  }

  return {
    classId: assignment.classId,
    periodId: assignment.periodId,
    teacherFirstName: assignment.teacherName.split(/\s+/)[0] ?? assignment.teacherName,
    className: assignment.className,
    periodLabel: assignment.periodName,
    totalStudents: students.length,
    completeCount,
    incompleteCount,
    averageZ,
    checklist,
    distribution,
    notScoredCount: incompleteCount,
    studentRows: ranked,
  };
}

export default async function TeacherDashboardPage() {
  const data = await loadDashboard();

  return (
    <div className="space-y-4">
      {/* ── Greeting ──────────────────────────────────────────────── */}
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div>
          <h1 className="text-xl font-bold text-foreground">
            Selamat datang, {data.teacherFirstName}!{' '}
            <span className="text-md">👋</span>
          </h1>
          <p className="mt-0.5 text-sm text-muted-foreground">
            Kelas {data.className} · {data.periodLabel} · {data.totalStudents}{' '}
            siswa
          </p>
        </div>
        {/* Tombol hitung nilai akhir — aktif setelah semua data terisi */}
        <RecalculateButton classId={data.classId} periodId={data.periodId} />
      </div>

      {/* ── 2 kolom: checklist + sidebar ──────────────────────────── */}
      <div className="grid grid-cols-1 gap-3.5 lg:grid-cols-2">
        {/* Checklist progres */}
        <section className="rounded-md border border-sipandu-border bg-white p-3.5">
          <h2 className="mb-2.5 text-base font-bold text-foreground">
            Progres pengisian data
          </h2>
          {data.checklist.map((item) => (
            <ChecklistItem key={item.id} item={item} />
          ))}
        </section>

        {/* Sidebar kanan: stat + distribusi */}
        <div className="flex flex-col gap-3.5">
          <div className="grid grid-cols-2 gap-2.5">
            <StatCard
              label="Siswa Terdaftar"
              value={data.totalStudents}
              accent="blue"
            />
            <StatCard
              label="Data Lengkap"
              value={data.completeCount}
              accent="green"
            />
            <StatCard
              label="Belum Lengkap"
              value={data.incompleteCount}
              accent="amber"
            />
            <StatCard
              label="Rata-rata Z*"
              value={
                data.averageZ !== null ? formatScore(data.averageZ, 1) : '—'
              }
              accent="navy"
            />
          </div>

          <section className="rounded-md border border-sipandu-border bg-white p-3.5">
            <h2 className="mb-2.5 text-base font-bold text-foreground">
              Distribusi kategori
            </h2>
            <CategoryDistributionChart
              counts={data.distribution}
              totalStudents={data.totalStudents}
              notScoredCount={data.notScoredCount}
            />
          </section>
        </div>
      </div>

      {/* ── Tabel siswa ───────────────────────────────────────────── */}
      <ClassStudentsTable rows={data.studentRows} />
    </div>
  );
}