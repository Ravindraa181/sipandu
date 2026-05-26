/**
 * @file app/admin/siswa/page.tsx
 * @description A5 — Manajemen Siswa.
 */
import { createClient } from '@/lib/supabase/server';
import { PageHeader } from '@/components/shared/PageHeader';
import type { CategoryType } from '@/types';
import { StudentTable, type StudentTableRow } from './_components/StudentTable';
import type { StudentDetail, StudentScoreHistoryRow } from './_components/StudentDetailDialog';
import { AddStudentDialog } from './_components/AddStudentDialog';
import { ImportStudentDialog } from './_components/ImportStudentDialog';

export const metadata = { title: 'Manajemen Siswa — Admin SiPandu' };

async function loadData() {
  const supabase = await createClient();

  const { data: activePeriod } = await supabase
    .from('academic_periods')
    .select('id, name')
    .eq('status', 'active')
    .maybeSingle();

  const { data: classesData } = await supabase.from('classes').select('id, name').order('name');
  const classOptions = (classesData ?? []).map((c) => ({ id: c.id, name: c.name }));

  const { data: studentProfiles } = await supabase
    .from('profiles')
    .select('id, nis, full_name, email, gender, is_active')
    .eq('role', 'student')
    .order('full_name');

  const students = (studentProfiles ?? []) as any[];

  // ALASAN: className harus diambil dari student_class_enrollments, bukan dari
  // behavior_final_scores. Siswa yang belum punya skor akhir tidak akan muncul
  // di behavior_final_scores, sehingga className-nya null dan filter kelas gagal.
  const { data: enrollmentsData } = await supabase
    .from('student_class_enrollments')
    .select(`
      id, student_id,
      assignment:class_period_assignment_id (
        period_id,
        class:class_id (name)
      )
    `)
    .eq('status', 'active');

  const allEnrollments = (enrollmentsData ?? []) as any[];

  // Buat map studentId → { enrollmentId, className } untuk periode aktif
  const enrollMap = new Map<string, { enrollmentId: string; className: string }>();
  for (const e of allEnrollments) {
    const a = e.assignment as any;
    if (a?.period_id === activePeriod?.id && a?.class?.name) {
      enrollMap.set(e.student_id as string, {
        enrollmentId: e.id as string,
        className: a.class.name as string,
      });
    }
  }

  // PERBAIKAN: Type casting langsung ke any[] untuk mencegah SelectQueryError inference
  const { data: scoresData } = await supabase
    .from('behavior_final_scores')
    .select(`
      x1, x2, x3, z_star, category,
      enrollment:enrollment_id (
        id, student_id, status,
        assignment:class_period_assignment_id (
          period_id,
          period:academic_periods(name, start_date),
          class:classes(name)
        )
      )
    `);

  const allScores = (scoresData ?? []) as any[];

  const rows: StudentTableRow[] = students.map((s) => {
    const studentScores = allScores.filter((sc) => sc.enrollment?.student_id === s.id);
    const activeScore = studentScores.find(
      (sc) =>
        sc.enrollment?.assignment?.period_id === activePeriod?.id &&
        sc.enrollment?.status === 'active'
    );

    // ALASAN: gunakan enrollMap sebagai sumber className utama agar siswa tanpa
    // skor akhir tetap memiliki className yang benar untuk keperluan filter.
    const enrollInfo = enrollMap.get(s.id);
    const enroll = enrollInfo
      ? { id: enrollInfo.enrollmentId, className: enrollInfo.className }
      : activeScore
        ? { id: activeScore.enrollment.id, className: activeScore.enrollment.assignment?.class?.name }
        : null;

    const scoreHistory: StudentScoreHistoryRow[] = studentScores.map((row) => ({
      periodLabel: row.enrollment?.assignment?.period?.name ?? '—',
      className: row.enrollment?.assignment?.class?.name ?? '—',
      x1: row.x1, x2: row.x2, x3: row.x3, zScore: row.z_star, category: row.category,
    }));

    const detail: StudentDetail = {
      id: s.id, nis: s.nis ?? '—', fullName: s.full_name, email: s.email, gender: s.gender,
      isActive: s.is_active, currentClassName: enroll?.className ?? null, scoreHistory,
    };

    return {
      id: s.id, nis: s.nis ?? '—', fullName: s.full_name, className: enroll?.className ?? null,
      isActive: s.is_active, zScore: activeScore?.z_star ?? null, category: activeScore?.category ?? null,
      periodLabel: enroll ? (activePeriod?.name ?? null) : null, detail,
    };
  });

  return { rows, classOptions, activePeriodExists: Boolean(activePeriod) };
}

export default async function AdminSiswaPage() {
  const { rows, classOptions, activePeriodExists } = await loadData();
  return (
    <div className="space-y-3">
      <PageHeader
        title="Manajemen siswa"
        actions={
          <>
            <AddStudentDialog />
            <ImportStudentDialog />
          </>
        }
      />
      <StudentTable rows={rows} classOptions={classOptions} activePeriodExists={activePeriodExists} />
    </div>
  );
}