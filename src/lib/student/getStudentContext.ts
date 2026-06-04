/**
 * @file lib/student/getStudentContext.ts
 * @description Helper server-side: ambil konteks siswa yang sedang login.
 *
 *  Dipanggil oleh semua Server Components di /siswa/* untuk
 *  mendapatkan enrollmentId, periodId, assignmentId, dsb.
 *
 *  Patch 7.7.5 sudah diterapkan — nama kolom DB yang benar:
 *   - student_class_enrollments → class_period_assignment_id (bukan class_period_assignment_id)
 *   - class_period_assignments  → homeroom_teacher_id (bukan teacher_id)
 *   - student_class_enrollments → initial_score (bukan initial_x2)
 *
 *  Return null bila siswa tidak punya enrollment aktif.
 *  Caller wajib handle null (redirect ke /login).
 */

import 'server-only';
import { createClient } from '@/lib/supabase/server';

export interface StudentContext {
  studentId: string;
  studentName: string;
  studentEmail: string;
  nisn: string;
  gender: 'L' | 'P' | null;
  enrollmentId: string;
  assignmentId: string;
  classId: string;
  className: string;
  gradeLevel: 'X' | 'XI' | 'XII';
  homeroomTeacherName: string | null;
  periodId: string;
  periodLabel: string;
  periodStartDate: string;
  periodEndDate: string;
  initialX2: number;
  peerSessionId: string | null;
  peerSessionStatus: 'not_started' | 'active' | 'closed';
  peerDeadline: string | null;
  totalReviewees: number;
  myReviewsSubmitted: number;
  hasPeerReviewActive: boolean;
}

export async function getStudentContext(): Promise<StudentContext | null> {
  const supabase = await createClient();

  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return null;

  const { data: profile } = await supabase
    .from('profiles')
    .select('id, role, full_name, email, nisn, gender, is_active')
    .eq('id', user.id)
    .single();

  if (!profile || profile.role !== 'student' || !profile.is_active) return null;

  const { data: period } = await supabase
    .from('academic_periods')
    .select('id, name, start_date, end_date')
    .eq('status', 'active')
    .maybeSingle();

  if (!period) return null;

  const { data: enrollment } = await supabase
    .from('student_class_enrollments')
    .select(`
      id,
      initial_score,
      assignment:class_period_assignment_id (
        id,
        class_id,
        period_id,
        homeroom:homeroom_teacher_id (full_name),
        classes:class_id (id, name, grade_level)
      )
    `)
    .eq('student_id', user.id)
    .eq('status', 'active')
    .maybeSingle();

  if (!enrollment) return null;

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const a = enrollment.assignment as any;
  if (!a || a.period_id !== period.id || !a.classes) return null;

  const { data: peerSession } = await supabase
    .from('peer_review_sessions')
    .select('id, status, deadline')
    .eq('class_period_assignment_id', a.id)
    .maybeSingle();

  const sessionStatus =
    (peerSession?.status as 'not_started' | 'active' | 'closed' | undefined) ??
    'not_started';

  const { count: totalEnrollments } = await supabase
    .from('student_class_enrollments')
    .select('id', { count: 'exact', head: true })
    .eq('class_period_assignment_id', a.id)
    .eq('status', 'active');

  const totalReviewees = Math.max(0, (totalEnrollments ?? 1) - 1);

  let myReviewsSubmitted = 0;
  if (peerSession?.id) {
    const { count } = await supabase
      .from('peer_review_submissions')
      .select('id', { count: 'exact', head: true })
      .eq('session_id', peerSession.id as string)
      .eq('reviewer_id', user.id);
    myReviewsSubmitted = count ?? 0;
  }

  const hasPeerReviewActive =
    sessionStatus === 'active' && myReviewsSubmitted < totalReviewees;

  return {
    studentId: user.id,
    studentName: (profile.full_name as string) ?? 'Siswa',
    studentEmail: profile.email as string,
    nisn: (profile.nisn as string | null) ?? '—',
    gender: (profile.gender as 'L' | 'P' | null) ?? null,
    enrollmentId: enrollment.id as string,
    assignmentId: a.id,
    classId: a.classes.id,
    className: a.classes.name,
    gradeLevel: a.classes.grade_level,
    homeroomTeacherName: a.homeroom?.full_name ?? null,
    periodId: period.id as string,
    periodLabel: period.name as string,
    periodStartDate: period.start_date as string,
    periodEndDate: period.end_date as string,
    initialX2: (enrollment.initial_score as number | null) ?? 75,
    peerSessionId: (peerSession?.id as string | undefined) ?? null,
    peerSessionStatus: sessionStatus,
    peerDeadline: (peerSession?.deadline as string | undefined) ?? null,
    totalReviewees,
    myReviewsSubmitted,
    hasPeerReviewActive,
  };
}