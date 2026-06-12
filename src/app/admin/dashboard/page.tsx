/**
 * @file app/admin/dashboard/page.tsx
 * @description A1 — Dashboard Administrator.
 *
 *  Server Component yang fetch semua data dashboard di server-side:
 *    - 4 stat card (total siswa, kelas lengkap/belum, periode aktif)
 *    - Tabel "Status input per kelas" pada periode aktif
 *    - Distribusi kategori Z* global (bar chart)
 *    - Notifikasi sistem otomatis (kelas belum buka peer review, dst)
 *
 *  Layout: 4 stat card di atas, lalu grid 60/40 (tabel kelas | sidebar
 *  ringkasan & notifikasi).
 */

import {
  AlertCircle,
  CalendarCheck,
  CircleCheck,
  ClockAlert,
  Users,
} from 'lucide-react';

import { createClient } from '@/lib/supabase/server';
import type {
  CategoryType,
  SystemNotification,
} from '@/types';
import { StatCard } from './_components/StatCard';
import {
  ClassStatusTable,
  type ClassStatusRow,
} from './_components/ClassStatusTable';
import { CategoryDistributionChart } from './_components/CategoryDistributionChart';
import { NotificationList } from './_components/NotificationList';

/* ────────────────────────────────────────────────────────────────────
 *  Tipe data hasil agregat
 * ──────────────────────────────────────────────────────────────────── */

interface DashboardData {
  totalStudents: number;
  totalActiveClasses: number;
  classesComplete: number;
  classesIncomplete: number;
  activePeriodLabel: string;
  activePeriodDateRange: string;
  classRows: ClassStatusRow[];
  distribution: Record<CategoryType, number>;
  notScoredCount: number;
  notifications: SystemNotification[];
}

/* ────────────────────────────────────────────────────────────────────
 *  Server-side data loader
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Ambil semua data dashboard dari Supabase. Bila tabel kosong atau
 * belum ada periode aktif, kembalikan placeholder agar UI tetap render.
 */
async function loadDashboardData(): Promise<DashboardData> {
  const supabase = await createClient();

  // ── 1. Periode aktif ────────────────────────────────────────────
  const { data: activePeriod } = await supabase
    .from('academic_periods')
    .select('id, name, start_date, end_date')
    .eq('status', 'active')
    .maybeSingle();

  const periodId = (activePeriod?.id as string | undefined) ?? null;
  const activePeriodLabel =
    (activePeriod?.name as string | undefined) ?? 'Belum ada periode aktif';
  const activePeriodDateRange = activePeriod
    ? formatDateRange(
        activePeriod.start_date as string,
        activePeriod.end_date as string,
      )
    : '—';

  // Bila belum ada periode aktif, return early dengan defaults
  if (!periodId) {
    return {
      totalStudents: 0,
      totalActiveClasses: 0,
      classesComplete: 0,
      classesIncomplete: 0,
      activePeriodLabel,
      activePeriodDateRange,
      classRows: [],
      distribution: {
        sangat_baik: 0,
        baik: 0,
        cukup: 0,
        perlu_pembinaan: 0,
      },
      notScoredCount: 0,
      notifications: [
        {
          id: 'no-period',
          level: 'warning',
          message: 'Belum ada periode akademik aktif. Buat periode di menu Manajemen Periode.',
          createdAt: new Date().toISOString(),
        },
      ],
    };
  }

  // ── 2. Kelas + assignment + wali kelas pada periode aktif ─────
  const { data: assignments } = await supabase
    .from('class_period_assignments')
    .select(
      `id,
       class_id,
       homeroom_teacher_id,
       classes:class_id (id, name, grade_level),
       teacher:homeroom_teacher_id (full_name)`,
    )
    .eq('period_id', periodId);

  const assignmentRows = (assignments ?? []) as unknown as Array<{
    id: string;
    class_id: string;
    homeroom_teacher_id: string | null;
    classes: { id: string; name: string; grade_level: string } | null;
    teacher: { full_name: string } | null;
  }>;

  // ── 3. Total bulan efektif di periode ──────────────────────────
  const { count: totalMonthsInPeriod } = await supabase
    .from('period_monthly_days')
    .select('id', { count: 'exact', head: true })
    .eq('period_id', periodId);

  const totalMonths = totalMonthsInPeriod ?? 0;

  // ── 4. Per kelas: hitung enrollment, attendance, points, peer ─
  const classRows: ClassStatusRow[] = [];
  // Akumulasi distribusi langsung di loop per-kelas (hindari .in() dengan 700+ ID)
  const distribution: Record<CategoryType, number> = {
    sangat_baik: 0,
    baik: 0,
    cukup: 0,
    perlu_pembinaan: 0,
  };
  let scoredGlobal = 0;

  for (const a of assignmentRows) {
    if (!a.classes) continue;

    // Ambil ID enrollment siswa aktif di kelas ini
    const { data: enrollments } = await supabase
      .from('student_class_enrollments')
      .select('id')
      .eq('class_period_assignment_id', a.id)
      .eq('status', 'active');

    const enrollmentIds = (enrollments || []).map((e) => e.id);
    const total = enrollmentIds.length;

    let lockedM = 0;
    let hasPoints = false;
    let scored = 0;

    // Lakukan query data perilaku & absen JIKA ada siswa
    if (total > 0) {
      // Bulan kehadiran yang sudah dikunci (hitung total record / total siswa)
      const { count: lockedCount } = await supabase
        .from('monthly_attendance')
        .select('id', { count: 'exact', head: true })
        .in('enrollment_id', enrollmentIds)
        .eq('is_locked', true);

      lockedM = Math.floor((lockedCount ?? 0) / total);

      // Apakah ada transaksi poin di kelas ini?
      const { count: pointTxnCount } = await supabase
        .from('behavior_point_transactions')
        .select('id', { count: 'exact', head: true })
        .in('enrollment_id', enrollmentIds);

      hasPoints = (pointTxnCount ?? 0) > 0;

      // Ambil skor Z* per siswa di kelas ini — sekaligus untuk distribusi global
      const { data: classScores } = await supabase
        .from('behavior_final_scores')
        .select('category')
        .in('enrollment_id', enrollmentIds)
        .not('z_star', 'is', null);

      for (const s of (classScores ?? []) as Array<{ category: CategoryType | null }>) {
        if (s.category) {
          distribution[s.category] += 1;
          scoredGlobal += 1;
        }
      }
      scored = classScores?.length ?? 0;
    }

    // Status sesi peer review tetap menggunakan class_period_assignment_id terbaru
    const { data: peerSession } = await supabase
      .from('peer_review_sessions')
      .select('status')
      .eq('class_period_assignment_id', a.id)
      .maybeSingle();

    const peerActive = ((peerSession?.status as string | undefined) ?? 'not_started') !== 'not_started';

    let status: ClassStatusRow['status'] = 'belum';
    if (
      lockedM === totalMonths &&
      totalMonths > 0 &&
      hasPoints &&
      peerActive &&
      scored === total &&
      total > 0
    ) {
      status = 'lengkap';
    } else if (lockedM > 0 || hasPoints || peerActive) {
      status = 'proses';
    }

    classRows.push({
      classId: a.class_id,
      className: a.classes.name,
      homeroomTeacherName: a.teacher?.full_name ?? null,
      attendanceProgress:
        totalMonths > 0 ? `${lockedM}/${totalMonths} bln` : '0 bln',
      hasPointTransactions: hasPoints,
      peerReviewActive: peerActive,
      scoredCount: scored,
      totalStudents: total,
      status,
    });
  }

  // ── 5. Total siswa aktif di seluruh kelas pada periode ─────────
  const totalStudents = classRows.reduce((sum, r) => sum + r.totalStudents, 0);

  // ── 6. Distribusi sudah diakumulasi di loop kelas di atas ──────
  const notScoredCount = Math.max(0, totalStudents - scoredGlobal);

  // ── 7. Build notifikasi otomatis ────────────────────────────────
  const notifications: SystemNotification[] = [];
  const peerNotOpen = classRows.filter((r) => !r.peerReviewActive).length;
  const noPoints = classRows.filter((r) => !r.hasPointTransactions).length;
  const completeClasses = classRows.filter((r) => r.status === 'lengkap');

  if (peerNotOpen > 0) {
    notifications.push({
      id: 'peer-closed',
      level: 'error',
      message: `${peerNotOpen} kelas belum membuka sesi Peer Review`,
      createdAt: new Date().toISOString(),
    });
  }
  if (noPoints > 0) {
    notifications.push({
      id: 'no-points',
      level: 'warning',
      message: `${noPoints} kelas belum mencatat poin perilaku`,
      createdAt: new Date().toISOString(),
    });
  }
  if (completeClasses.length > 0) {
    notifications.push({
      id: 'classes-complete',
      level: 'success',
      message: `${completeClasses.length} kelas data sudah lengkap (${completeClasses
        .slice(0, 3)
        .map((c) => c.className)
        .join(', ')}${completeClasses.length > 3 ? ', ...' : ''})`,
      createdAt: new Date().toISOString(),
    });
  }

  return {
    totalStudents,
    totalActiveClasses: classRows.length,
    classesComplete: classRows.filter((r) => r.status === 'lengkap').length,
    classesIncomplete: classRows.filter((r) => r.status !== 'lengkap').length,
    activePeriodLabel,
    activePeriodDateRange,
    classRows,
    distribution,
    notScoredCount,
    notifications,
  };
}

/** Format range tanggal: "12 Agu 2024 – 24 Jan 2025". */
function formatDateRange(startISO: string, endISO: string): string {
  try {
    const f = new Intl.DateTimeFormat('id-ID', {
      day: 'numeric',
      month: 'short',
      year: 'numeric',
    });
    return `${f.format(new Date(startISO))} – ${f.format(new Date(endISO))}`;
  } catch {
    return '—';
  }
}

/* ────────────────────────────────────────────────────────────────────
 *  Page component
 * ──────────────────────────────────────────────────────────────────── */

export const metadata = {
  title: 'Dashboard Admin',
};

export default async function AdminDashboardPage() {
  const data = await loadDashboardData();

  return (
    <div className="space-y-4">
      {/* ── 4 Stat Cards ─────────────────────────────────────────── */}
      <div className="grid grid-cols-1 gap-3.5 sm:grid-cols-2 lg:grid-cols-4">
        <StatCard
          label="Total Siswa Aktif"
          value={data.totalStudents}
          subLabel={`${data.totalActiveClasses} kelas aktif`}
          icon={Users}
          accent="blue"
        />
        <StatCard
          label="Kelas Data Lengkap"
          value={data.classesComplete}
          subLabel={`dari ${data.totalActiveClasses} kelas`}
          icon={CircleCheck}
          accent="green"
        />
        <StatCard
          label="Kelas Belum Lengkap"
          value={data.classesIncomplete}
          subLabel="perlu perhatian"
          icon={ClockAlert}
          accent="amber"
        />
        <StatCard
          label="Periode Aktif"
          value={data.activePeriodLabel}
          subLabel={data.activePeriodDateRange}
          icon={CalendarCheck}
          accent="navy"
          smallValue
        />
      </div>

      {/* ── Konten utama: tabel + sidebar ────────────────────────── */}
      <div className="grid grid-cols-1 gap-3.5 lg:grid-cols-[60%_40%]">
        {/* Tabel status per kelas */}
        <section className="rounded-md border border-sipandu-border bg-white p-3.5">
          <h2 className="mb-2.5 text-base font-bold text-foreground">
            Status input per kelas
          </h2>
          <ClassStatusTable rows={data.classRows} />
        </section>

        {/* Sidebar kanan: distribusi + notifikasi */}
        <div className="flex flex-col gap-3.5">
          <section className="rounded-md border border-sipandu-border bg-white p-3.5">
            <h2 className="mb-2.5 text-base font-bold text-foreground">
              Distribusi kategori global
            </h2>
            <CategoryDistributionChart
              counts={data.distribution}
              totalStudents={data.totalStudents}
              notScoredCount={data.notScoredCount}
            />
          </section>

          <section className="rounded-md border border-sipandu-border bg-white p-3.5">
            <h2 className="mb-2 flex items-center gap-1.5 text-base font-bold text-foreground">
              <AlertCircle className="h-3.5 w-3.5" aria-hidden />
              Notifikasi sistem
            </h2>
            <NotificationList notifications={data.notifications} />
          </section>
        </div>
      </div>
    </div>
  );
}
