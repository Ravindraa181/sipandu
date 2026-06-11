/**
 * @file app/admin/kelas/page.tsx
 * @description A4 — Manajemen Kelas.
 *
 * Tabel master kelas (persisten lintas periode). Setiap row ada panel
 * expand "Lihat Siswa" (ClassRow client component). Tombol "Tambah
 * Kelas" di header.
 */

import { createClient } from '@/lib/supabase/server';
import { PageHeader } from '@/components/shared/PageHeader';
import { AddClassDialog } from './_components/AddClassDialog';
import { ClassRow, type ClassStudent } from './_components/ClassRow';

export const metadata = {
  title: 'Manajemen Kelas',
};

interface ClassData {
  id: string;
  name: string;
  gradeLevel: 'X' | 'XI' | 'XII';
  homeroomTeacherName: string | null;
  studentCount: number;
  activeAssignmentId: string | null;
  students: ClassStudent[];
}

async function loadData(): Promise<{
  rows: ClassData[];
  classByAssignment: Array<{ assignmentId: string; className: string }>;
}> {
  const supabase = await createClient();

  // Periode aktif
  const { data: activePeriod } = await supabase
    .from('academic_periods')
    .select('id')
    .eq('status', 'active')
    .maybeSingle();

  const activePeriodId = activePeriod?.id as string | undefined;

  // Daftar kelas
  const { data: classesData } = await supabase
    .from('classes')
    .select('id, name, grade_level')
    .order('grade_level')
    .order('name');

  const classRows = (classesData ?? []) as Array<{
    id: string;
    name: string;
    grade_level: 'X' | 'XI' | 'XII';
  }>;

  // Map class_id → { assignmentId, teacherName, studentCount, students }
  const enriched: ClassData[] = await Promise.all(
    classRows.map(async (c) => {
      let assignmentId: string | null = null;
      let teacherName: string | null = null;
      let students: ClassStudent[] = [];
      let studentCount = 0;

      if (activePeriodId) {
        const { data: assignment } = await supabase
          .from('class_period_assignments')
          .select(
            `id,
             teacher:homeroom_teacher_id (full_name)`, // PERBAIKAN: gunakan homeroom_teacher_id
          )
          .eq('class_id', c.id)
          .eq('period_id', activePeriodId)
          .maybeSingle();

        if (assignment) {
          assignmentId = assignment.id as string;
          const t = assignment.teacher as { full_name: string } | null;
          teacherName = t?.full_name ?? null;

          const { data: enrollments } = await supabase
            .from('student_class_enrollments')
            .select(
              `student:student_id (id, full_name, nisn, gender)`,
            )
            .eq('class_period_assignment_id', assignmentId) // PERBAIKAN: gunakan class_period_assignment_id
            .eq('status', 'active');

          students = (
            (enrollments ?? []) as Array<{
              student: {
                id: string;
                full_name: string;
                nisn: string | null;
                gender: 'L' | 'P' | null;
              } | null;
            }>
          )
            .filter((e) => e.student !== null)
            .map((e) => ({
              id: e.student!.id,
              nisn: e.student!.nisn ?? '—',
              fullName: e.student!.full_name,
              gender: e.student!.gender,
            }));
          studentCount = students.length;
        }
      }

      return {
        id: c.id,
        name: c.name,
        gradeLevel: c.grade_level,
        homeroomTeacherName: teacherName,
        studentCount,
        activeAssignmentId: assignmentId,
        students,
      };
    }),
  );

  // Daftar (assignmentId, className) untuk dropdown pindahkan siswa
  const classByAssignment = enriched
    .filter((c) => c.activeAssignmentId)
    .map((c) => ({
      assignmentId: c.activeAssignmentId as string,
      className: c.name,
    }));

  return { rows: enriched, classByAssignment };
}

export default async function AdminKelasPage() {
  const { rows, classByAssignment } = await loadData();

  return (
    <div className="space-y-3">
      <PageHeader title="Manajemen kelas" actions={<AddClassDialog />} />

      <div className="overflow-hidden rounded-md border border-sipandu-border bg-white">
        <div className="overflow-x-auto">
          <table className="w-full border-collapse text-sm">
            <thead>
              <tr className="border-b border-sipandu-border bg-gray-100 text-left">
                <th className="px-3 py-2 text-xs font-semibold">Nama Kelas</th>
                <th className="px-3 py-2 text-xs font-semibold">Tingkat</th>
                <th className="px-3 py-2 text-xs font-semibold">
                  Wali Kelas (Periode Aktif)
                </th>
                <th className="px-3 py-2 text-xs font-semibold">Jml Siswa</th>
                <th className="px-3 py-2 text-xs font-semibold">Aksi</th>
              </tr>
            </thead>
            <tbody>
              {rows.length === 0 ? (
                <tr>
                  <td
                    colSpan={5}
                    className="px-3 py-10 text-center text-sm italic text-muted-foreground"
                  >
                    Belum ada data kelas. Klik &quot;Tambah Kelas&quot; untuk
                    memulai.
                  </td>
                </tr>
              ) : (
                rows.map((c) => (
                  <ClassRow
                    key={c.id}
                    classId={c.id}
                    className={c.name}
                    gradeLevel={c.gradeLevel}
                    homeroomTeacherName={c.homeroomTeacherName}
                    studentCount={c.studentCount}
                    activeAssignmentId={c.activeAssignmentId}
                    otherAssignments={classByAssignment.filter(
                      (a) => a.assignmentId !== c.activeAssignmentId,
                    )}
                    students={c.students}
                  />
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}