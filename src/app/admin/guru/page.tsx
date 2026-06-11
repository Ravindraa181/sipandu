/**
 * @file app/admin/guru/page.tsx
 * @description A3 — Manajemen Guru.
 *
 * Server Component yang fetch:
 * - Daftar semua guru + penugasan aktif (jika ada)
 * - Daftar kelas (untuk dropdown assign)
 * - Daftar periode (untuk dropdown assign)
 *
 * Render:
 * - PageHeader dengan tombol Tambah Guru + Import Excel (placeholder)
 * - TeacherTable (client) dengan filter, search, dan aksi per row
 */

import { createClient } from '@/lib/supabase/server';
import { PageHeader } from '@/components/shared/PageHeader';
import { AddTeacherDialog } from './_components/AddTeacherDialog';
import { ImportTeacherDialog } from './_components/ImportTeacherDialog';
import { TeacherTable, type TeacherRow } from './_components/TeacherTable';
import type {
  ClassOption,
  PeriodOption,
} from './_components/AssignClassDialog';

export const metadata = {
  title: 'Manajemen Guru',
};

interface PageData {
  teachers: TeacherRow[];
  classes: ClassOption[];
  periods: PeriodOption[];
}

async function loadData(): Promise<PageData> {
  const supabase = await createClient();

  // 1. Ambil data Periode
  const { data: periodData } = await supabase
    .from('academic_periods')
    .select('id, name, status')
    .order('start_date', { ascending: false });

  const periods: PeriodOption[] = (
    (periodData ?? []) as Array<{ id: string; name: string; status: string }>
  ).map((p) => ({
    id: p.id,
    name: p.name,
    isActive: p.status === 'active',
  }));

  // Definisikan activePeriodId dan activePeriodName agar tidak error TS2552
  const activePeriod = periods.find((p) => p.isActive);
  const activePeriodId = activePeriod?.id ?? null;
  const activePeriodName = activePeriod?.name ?? '';

  // 2. Ambil data Kelas + wali kelas saat ini (di periode aktif)
  const { data: classesData } = await supabase
    .from('classes')
    .select('id, name, grade_level')
    .order('name');

  const classRows = (classesData ?? []) as Array<{
    id: string;
    name: string;
    grade_level: string;
  }>;

  // Map kelas → wali kelas saat ini (class_id -> full_name)
  const classTeacherMap = new Map<string, string | null>();
  if (activePeriodId) {
    const { data: tAssignClasses } = await supabase
      .from('class_period_assignments')
      .select(`
        class_id,
        teacher:homeroom_teacher_id (full_name)
      `)
      .eq('period_id', activePeriodId)
      .not('homeroom_teacher_id', 'is', null);

    for (const a of ((tAssignClasses ?? []) as Array<{
      class_id: string;
      teacher: { full_name: string } | null;
    }>)) {
      if (a.teacher) {
        classTeacherMap.set(a.class_id, a.teacher.full_name);
      }
    }
  }

  const classes: ClassOption[] = classRows.map((c) => ({
    id: c.id,
    name: c.name,
    currentTeacherName: classTeacherMap.get(c.id) ?? null,
  }));

  // 3. Daftar guru + penugasan aktif (kalau ada)
  const { data: teacherData } = await supabase
    .from('profiles')
    .select('id, full_name, email, nip, is_active')
    .eq('role', 'teacher')
    .order('full_name');

  const teacherRows = (teacherData ?? []) as Array<{
    id: string;
    full_name: string;
    email: string;
    nip: string | null;
    is_active: boolean;
  }>;

  // Map teacherId → assignment label di periode aktif (homeroom_teacher_id -> class name)
  const teacherAssignmentMap = new Map<string, string>();
  if (activePeriodId) {
    const { data: tAssignTeachers } = await supabase
      .from('class_period_assignments')
      .select(`
        homeroom_teacher_id,
        classes:class_id (name)
      `)
      .eq('period_id', activePeriodId)
      .not('homeroom_teacher_id', 'is', null);

    for (const a of ((tAssignTeachers ?? []) as Array<{
      homeroom_teacher_id: string;
      classes: { name: string } | null;
    }>)) {
      if (a.homeroom_teacher_id && a.classes) {
        teacherAssignmentMap.set(
          a.homeroom_teacher_id,
          `${a.classes.name}, ${activePeriodName}`,
        );
      }
    }
  }

  const teachers: TeacherRow[] = teacherRows.map((t) => ({
    id: t.id,
    nip: t.nip ?? '—',
    fullName: t.full_name,
    email: t.email,
    isActive: t.is_active,
    currentAssignment: teacherAssignmentMap.get(t.id) ?? null,
  }));

  return { teachers, classes, periods };
}

export default async function AdminGuruPage() {
  const { teachers, classes, periods } = await loadData();

  return (
    <div className="space-y-3">
      <PageHeader
        title="Manajemen guru"
        actions={
          <>
            <AddTeacherDialog />
            <ImportTeacherDialog />
          </>
        }
      />

      <TeacherTable rows={teachers} classes={classes} periods={periods} />
    </div>
  );
}