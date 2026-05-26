/**
 * @file app/dashboard/layout.tsx
 *
 * Tidak ada perubahan logika — file ini sudah benar.
 * Error TS2305 ("no exported member 'getTeacherAssignment'") terjadi karena
 * file getAssignment.ts yang lama tidak mengekspor fungsi ini.
 * Pastikan src/lib/teacher/getAssignment.ts yang sudah diperbaiki
 * (dari batch sebelumnya) sudah di-copy ke proyek.
 */
import type { ReactNode } from 'react';
import { redirect } from 'next/navigation';
import { Toaster } from 'sonner';

import { createClient } from '@/lib/supabase/server';
import { TeacherSidebar } from '@/components/shared/TeacherSidebar';
import { TopHeader } from '@/components/shared/TopHeader';
import { MobileLayoutShell } from '@/components/shared/MobileLayoutShell';
import { ROUTES } from '@/constants';
// PERBAIKAN: Gunakan getAssignmentContext
import { getAssignmentContext } from '@/lib/teacher/getAssignment';

export default async function DashboardLayout({ children }: { children: ReactNode }) {
  const supabase = await createClient();

  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect(ROUTES.login);

  const { data: profile } = await supabase
    .from('profiles')
    .select('role, is_active')
    .eq('id', user.id)
    .single();

  if (!profile || !profile.is_active) {
    await supabase.auth.signOut();
    redirect(ROUTES.login);
  }
  if (profile.role === 'admin') redirect(ROUTES.adminHome);
  if (profile.role === 'student') redirect(ROUTES.studentHome);

  const assignment = await getAssignmentContext();
  if (!assignment) redirect(ROUTES.waiting);

  // PERBAIKAN: Fetch jumlah siswa secara eksplisit
  const { count } = await supabase
    .from('student_class_enrollments')
    .select('id', { count: 'exact', head: true })
    .eq('class_period_assignment_id', assignment.assignmentId)
    .eq('status', 'active');

  return (
    <MobileLayoutShell
      sidebar={
        <TeacherSidebar
          userName={assignment.teacherName}
          className={assignment.className}
          periodLabel={assignment.periodName}
          studentCount={count ?? 0}
        />
      }
    >
      <TopHeader breadcrumb={[]} userName={assignment.teacherName} role="teacher" notifCount={0} />
      <main className="flex-1 overflow-y-auto p-3 md:p-5">{children}</main>
      <Toaster position="top-right" richColors />
    </MobileLayoutShell>
  );
}