/**
 * @file lib/teacher/getAssignment.ts
 *
 * FIX: Tambahkan export `TeacherStudent` dan `getTeacherAssignment` yang
 *      dibutuhkan oleh semua halaman di /dashboard/*.
 *
 *  getAssignmentContext  → versi lama (tanpa students), dipertahankan
 *  getTeacherAssignment  → versi baru dengan TeacherStudent[] + MonthlyDay[]
 *                         (dibutuhkan layout.tsx, peer-review/page.tsx,
 *                          poin-perilaku/page.tsx, kehadiran/page.tsx, dll)
 */

import { cache } from 'react';
import { createClient } from '../supabase/server';

/* ─────────────────────────────────────────────────────────────────────
 *  Tipe yang dibutuhkan halaman-halaman dashboard
 * ───────────────────────────────────────────────────────────────────── */

export interface TeacherStudent {
  enrollmentId: string;
  studentId: string;
  fullName: string;
  /** Initial score X2 saat pendaftaran (biasanya 100). */
  initialScore: number;
}

export interface MonthlyDay {
  month: number;
  year: number;
  effectiveDays: number;
}

export interface TeacherAssignment {
  assignmentId: string;
  teacherId: string;
  teacherName: string;
  classId: string;
  className: string;
  gradeLevel: string;
  periodId: string;
  periodLabel: string;
  academicYear: string;
  semester: string;
  monthlyDays: MonthlyDay[];
  students: TeacherStudent[];
}

/* ─────────────────────────────────────────────────────────────────────
 *  Tipe lama (dipertahankan agar tidak break komponen lain)
 * ───────────────────────────────────────────────────────────────────── */

interface RawClass {
  id: string;
  name: string;
  grade_level: number;
}

interface RawPeriod {
  id: string;
  name: string;
  academic_year: string;
  semester: 'ganjil' | 'genap';
  start_date: string;
  end_date: string;
  // ALASAN: academic_periods pakai kolom status (enum), bukan is_active
  status: string;
}

export interface AssignmentContextData {
  assignmentId: string;
  classId: string;
  className: string;
  gradeLevel: number;
  periodId: string;
  periodName: string;
  academicYear: string;
  semester: string;
  teacherId: string;
  teacherName: string;
}

/* ─────────────────────────────────────────────────────────────────────
 *  getTeacherAssignment — versi baru dengan students[]
 * ───────────────────────────────────────────────────────────────────── */

/**
 * Ambil penugasan wali kelas beserta daftar siswa aktif dan hari efektif.
 * Mengembalikan null bila guru belum di-assign di periode aktif.
 * Di-cache per request (React cache).
 */
export const getTeacherAssignment = cache(
  async (): Promise<TeacherAssignment | null> => {
    const supabase = await createClient();

    // 1. Ambil user
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) return null;

    // 2. Ambil assignment dengan join kelas + periode + hari efektif
    const { data: assignmentData } = await supabase
      .from('class_period_assignments')
      .select(
        `id,
         homeroom_teacher_id,
         class:class_id (id, name, grade_level),
         period:period_id (
           id, name, academic_year, semester, status,
           period_monthly_days (month, year, effective_days)
         )`,
      )
      .eq('homeroom_teacher_id', user.id)
      .maybeSingle();

    if (!assignmentData) return null;

    type RawAssignment = {
      id: string;
      homeroom_teacher_id: string;
      class:
        | { id: string; name: string; grade_level: string }
        | { id: string; name: string; grade_level: string }[]
        | null;
      period:
        | {
            id: string;
            name: string;
            academic_year: string;
            semester: string;
            // ALASAN: academic_periods pakai kolom status (enum), bukan is_active
            status: string;
            period_monthly_days: Array<{
              month: number;
              year: number;
              effective_days: number;
            }>;
          }
        | null;
    };

    const raw = assignmentData as unknown as RawAssignment;
    const clsRaw = Array.isArray(raw.class) ? raw.class[0] : raw.class;
    const period = raw.period;

    if (!clsRaw || !period) return null;
    // ALASAN: filter pakai status === 'active', bukan is_active (tidak ada di tabel)
    if (period.status !== 'active') return null;

    const assignmentId = raw.id;

    // 3. Profil guru
    const { data: teacherProfile } = await supabase
      .from('profiles')
      .select('full_name')
      .eq('id', user.id)
      .single();

    // 4. Daftar siswa aktif
    const { data: enrollments } = await supabase
      .from('student_class_enrollments')
      .select(
        `id,
         student_id,
         initial_score,
         student:student_id (full_name)`,
      )
      .eq('class_period_assignment_id', assignmentId)
      .eq('status', 'active')
      .order('student_id');

    type RawEnrollment = {
      id: string;
      student_id: string;
      initial_score: number | null;
      student: { full_name: string } | null;
    };

    const students: TeacherStudent[] = (
      (enrollments ?? []) as unknown as RawEnrollment[]
    ).map((e) => ({
      enrollmentId: e.id,
      studentId: e.student_id,
      fullName: e.student?.full_name ?? '(Tidak tersedia)',
      initialScore: e.initial_score ?? 100,
    }));

    // 5. Hari efektif
    const monthlyDays: MonthlyDay[] = (period.period_monthly_days ?? [])
      .map((m) => ({
        month: m.month,
        year: m.year,
        effectiveDays: m.effective_days,
      }))
      .sort((a, b) =>
        a.year !== b.year ? a.year - b.year : a.month - b.month,
      );

    return {
      assignmentId,
      teacherId: user.id,
      teacherName: (teacherProfile?.full_name as string | undefined) ?? '',
      classId: clsRaw.id,
      className: clsRaw.name,
      gradeLevel: String(clsRaw.grade_level),
      periodId: period.id,
      periodLabel: `${period.name} — ${period.academic_year} (${period.semester})`,
      academicYear: period.academic_year,
      semester: period.semester,
      monthlyDays,
      students,
    };
  },
);

/* ─────────────────────────────────────────────────────────────────────
 *  getAssignmentContext — versi lama, dipertahankan
 * ───────────────────────────────────────────────────────────────────── */

export const getAssignmentContext = cache(
  async (assignmentIdParam?: string): Promise<AssignmentContextData | null> => {
    const supabase = await createClient();

    const {
      data: { user },
      error: authErr,
    } = await supabase.auth.getUser();
    if (authErr || !user) return null;

    const teacherId = user.id;

    if (assignmentIdParam) {
      // ALASAN: nama tabel relasi harus 'academic_periods', bukan 'periods'.
      //         Kolom is_active tidak ada — gunakan 'status'.
      const { data: assignmentData, error: assignmentError } = await supabase
        .from('class_period_assignments')
        .select(
          `id, class_id, period_id, homeroom_teacher_id,
           class:classes (id, name, grade_level),
           period:academic_periods (id, name, academic_year, semester, start_date, end_date, status)`,
        )
        .eq('id', assignmentIdParam)
        .single();

      if (assignmentError || !assignmentData) return null;

      const assignment = assignmentData as unknown as {
        id: string;
        class_id: string;
        period_id: string;
        homeroom_teacher_id: string;
        class: unknown;
        period: unknown;
      };

      if (assignment.homeroom_teacher_id !== teacherId) return null;

      const clsData = Array.isArray(assignment.class)
        ? assignment.class[0]
        : assignment.class;
      const periodData = Array.isArray(assignment.period)
        ? assignment.period[0]
        : assignment.period;

      const cls = clsData as RawClass | null;
      const period = periodData as RawPeriod | null;
      if (!cls || !period) return null;

      const { data: tp } = await supabase
        .from('profiles')
        .select('id, full_name, role')
        .eq('id', teacherId)
        .single();
      const teacherProfile = tp as { full_name: string } | null;

      return {
        assignmentId: assignment.id,
        classId: cls.id,
        className: cls.name,
        gradeLevel: cls.grade_level,
        periodId: period.id,
        periodName: period.name,
        academicYear: period.academic_year,
        semester: period.semester,
        teacherId,
        teacherName: teacherProfile?.full_name ?? '',
      };
    }

    // Tanpa assignmentIdParam — ambil assignment dengan periode aktif
    // ALASAN: nama tabel relasi harus 'academic_periods', bukan 'periods'.
    //         Filter status='active' dilakukan di JS karena PostgREST tidak
    //         mendukung filter pada kolom hasil join secara langsung.
    const { data: activeAssignments, error: fetchErr } = await supabase
      .from('class_period_assignments')
      .select(
        `id, class_id, period_id, homeroom_teacher_id,
         class:classes (id, name, grade_level),
         period:academic_periods (id, name, academic_year, semester, start_date, end_date, status)`,
      )
      .eq('homeroom_teacher_id', teacherId);

    if (fetchErr || !activeAssignments || activeAssignments.length === 0) return null;

    // Pilih assignment yang periodenya berstatus 'active'
    const activeAssignmentsFiltered = (activeAssignments as unknown as Array<{
      id: string;
      class_id: string;
      period_id: string;
      homeroom_teacher_id: string;
      class: unknown;
      period: unknown;
    }>).filter((a) => {
      const p = Array.isArray(a.period) ? a.period[0] : a.period;
      return (p as RawPeriod | null)?.status === 'active';
    });

    if (activeAssignmentsFiltered.length === 0) return null;

    const defaultAssignment = activeAssignmentsFiltered[0] as unknown as {
      id: string;
      class_id: string;
      period_id: string;
      homeroom_teacher_id: string;
      class: unknown;
      period: unknown;
    };

    const clsData = Array.isArray(defaultAssignment.class)
      ? defaultAssignment.class[0]
      : defaultAssignment.class;
    const periodData = Array.isArray(defaultAssignment.period)
      ? defaultAssignment.period[0]
      : defaultAssignment.period;

    const cls = clsData as RawClass | null;
    const period = periodData as RawPeriod | null;
    if (!cls || !period) return null;

    const { data: tp } = await supabase
      .from('profiles')
      .select('id, full_name, role')
      .eq('id', teacherId)
      .single();
    const teacherProfile = tp as { full_name: string } | null;

    return {
      assignmentId: defaultAssignment.id,
      classId: cls.id,
      className: cls.name,
      gradeLevel: cls.grade_level,
      periodId: period.id,
      periodName: period.name,
      academicYear: period.academic_year,
      semester: period.semester,
      teacherId,
      teacherName: teacherProfile?.full_name ?? '',
    };
  },
);
