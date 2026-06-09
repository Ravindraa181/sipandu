'use server';

import { revalidatePath } from 'next/cache';
import { z } from 'zod';
import { createClient, createServiceRoleClient } from '../supabase/server';
import { ROUTES } from '@/constants';

type ActionResult<T = undefined> =
  | { ok: true; data: T }
  | { ok: false; error: string };

// --- AUTH UTILS ---

async function checkAdminAuth() {
  const supabase = await createClient();
  const { data: authData, error: authErr } = await supabase.auth.getUser();

  if (authErr || !authData?.user) {
    return { ok: false, error: 'Unauthorized' };
  }

  const { data: profileData } = await supabase
    .from('profiles')
    .select('role, is_active')
    .eq('id', authData.user.id)
    .single();

  const profile = profileData as { role: string; is_active: boolean } | null;

  if (!profile || profile.role !== 'admin' || !profile.is_active) {
    return { ok: false, error: 'Unauthorized. Admin access required.' };
  }

  return { ok: true, user: authData.user };
}

// --- PERIOD MANAGEMENT ---

const createPeriodSchema = z.object({
  name: z.string().min(1),
  academicYear: z.string().min(4),
  semester: z.enum(['ganjil', 'genap']),
  startDate: z.string(),
  endDate: z.string(),
  monthlyDays: z.array(
    z.object({
      month: z.number().int().min(1).max(12),
      year: z.number().int().min(2000).max(2100),
      effectiveDays: z.number().int().min(0).max(31),
    })
  ),
  setActive: z.boolean().default(false),
});

export async function createPeriod(rawInput: z.infer<typeof createPeriodSchema>) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const parsed = createPeriodSchema.parse(rawInput);
    const admin = await createServiceRoleClient();

    // 1. Insert Period (Menggunakan nama tabel 'academic_periods')
    const { data: periodData, error: periodErr } = await admin
      .from('academic_periods')
      .insert({
        name: parsed.name,
        academic_year: parsed.academicYear,
        semester: parsed.semester,
        start_date: parsed.startDate,
        end_date: parsed.endDate,
        status: parsed.setActive ? 'active' : 'closed', // Diubah menjadi enum status
      } as any)
      .select('id')
      .single();

    if (periodErr || !periodData) throw periodErr;
    
    const period = periodData as { id: string };

    // 2. Insert Monthly Days (Menggunakan nama tabel 'period_monthly_days')
    if (parsed.monthlyDays.length > 0) {
      const monthlyDaysPayload = parsed.monthlyDays.map((m) => ({
        period_id: period.id,
        month: m.month,
        year: m.year,
        effective_days: m.effectiveDays,
      }));

      const { error: daysErr } = await admin
        .from('period_monthly_days')
        .insert(monthlyDaysPayload as any[]);

      if (daysErr) throw daysErr;
    }

    // 3. If setting active, deactivate others
    if (parsed.setActive) {
      const { error: resetErr } = await admin
        .from('academic_periods')
        .update({ status: 'closed' } as any)
        .neq('id', period.id);

      if (resetErr) console.error('Failed to deactivate other periods:', resetErr);
    }

    revalidatePath((ROUTES as any).adminPeriode ?? '/admin/periode');
    return { ok: true, data: { id: period.id } };
  } catch (error: any) {
    return { ok: false, error: error.message || 'Failed to create period' };
  }
}

export async function updateEffectiveDays(rawInput: {
  periodId: string;
  month: number;
  year: number;
  effectiveDays: number;
}) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const parsed = z
      .object({
        periodId: z.string().uuid(),
        month: z.number().int().min(1).max(12),
        year: z.number().int().min(2000).max(2100),
        effectiveDays: z.number().int().min(0).max(31),
      })
      .parse(rawInput);

    const admin = await createServiceRoleClient();

    const { error } = await admin.from('period_monthly_days').upsert(
      {
        period_id: parsed.periodId,
        month: parsed.month,
        year: parsed.year,
        effective_days: parsed.effectiveDays,
      } as any,
      { onConflict: 'period_id,month,year' }
    );

    if (error) throw error;

    revalidatePath((ROUTES as any).adminPeriode ?? '/admin/periode');
    return { ok: true };
  } catch (error: any) {
    return { ok: false, error: error.message || 'Gagal mengubah hari efektif' };
  }
}

/** Hapus periode — boleh untuk semua periode tidak aktif, cascade semua data terkait. */
export async function deletePeriod(periodId: string): Promise<ActionResult> {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const admin = await createServiceRoleClient();

    // Guard: periode aktif tidak boleh dihapus
    const { data: periodData, error: periodFetchErr } = await admin
      .from('academic_periods')
      .select('status')
      .eq('id', periodId)
      .single();
    if (periodFetchErr) throw periodFetchErr;
    const period = periodData as { status: string } | null;
    if (!period) throw new Error('Periode tidak ditemukan.');
    if (period.status === 'active') {
      throw new Error('Periode aktif tidak dapat dihapus. Tutup periode terlebih dahulu.');
    }

    // Ambil semua class_period_assignment id untuk periode ini
    const { data: assignments, error: assignErr } = await admin
      .from('class_period_assignments')
      .select('id')
      .eq('period_id', periodId);
    if (assignErr) throw assignErr;

    const assignmentIds = ((assignments ?? []) as Array<{ id: string }>).map((a) => a.id);

    // Hapus student_class_enrollments (cascade ke monthly_attendance,
    // behavior_point_transactions, student_behavior_scores, behavior_final_scores,
    // teacher_narrative_notes)
    if (assignmentIds.length > 0) {
      const { error: enrollErr } = await admin
        .from('student_class_enrollments')
        .delete()
        .in('class_period_assignment_id', assignmentIds);
      if (enrollErr) throw enrollErr;
    }

    // Hapus class_period_assignments (cascade ke peer_review_sessions
    // → peer_review_submissions, peer_review_progress, student_x3_scores)
    if (assignmentIds.length > 0) {
      const { error: cpaErr } = await admin
        .from('class_period_assignments')
        .delete()
        .eq('period_id', periodId);
      if (cpaErr) throw cpaErr;
    }

    // Hapus periode (cascade ke period_monthly_days)
    const { error } = await admin
      .from('academic_periods')
      .delete()
      .eq('id', periodId);
    if (error) throw error;

    revalidatePath('/admin/periode');
    revalidatePath('/admin/dashboard');
    return { ok: true, data: undefined };
  } catch (e) {
    return { ok: false, error: e instanceof Error ? e.message : 'Gagal menghapus periode' };
  }
}

const updatePeriodSchema = z.object({
  periodId: z.string().uuid(),
  name: z.string().min(1),
  academicYear: z.string().min(4),
  semester: z.enum(['ganjil', 'genap']),
  startDate: z.string(),
  endDate: z.string(),
  monthlyDays: z.array(
    z.object({
      month: z.number().int().min(1).max(12),
      year: z.number().int().min(2000).max(2100),
      effectiveDays: z.number().int().min(0).max(31),
    })
  ),
});

/** Edit nama, tanggal, dan hari efektif periode (semua status). */
export async function updatePeriod(rawInput: z.infer<typeof updatePeriodSchema>): Promise<ActionResult> {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const parsed = updatePeriodSchema.parse(rawInput);
    const admin = await createServiceRoleClient();

    const { error: periodErr } = await admin
      .from('academic_periods')
      .update({
        name: parsed.name,
        academic_year: parsed.academicYear,
        semester: parsed.semester,
        start_date: parsed.startDate,
        end_date: parsed.endDate,
      } as any)
      .eq('id', parsed.periodId);

    if (periodErr) throw periodErr;

    // Upsert monthly days
    if (parsed.monthlyDays.length > 0) {
      const payload = parsed.monthlyDays.map((m) => ({
        period_id: parsed.periodId,
        month: m.month,
        year: m.year,
        effective_days: m.effectiveDays,
      }));
      const { error: daysErr } = await admin
        .from('period_monthly_days')
        .upsert(payload as any[], { onConflict: 'period_id,month,year' });
      if (daysErr) throw daysErr;
    }

    revalidatePath('/admin/periode');
    return { ok: true, data: undefined };
  } catch (e) {
    return { ok: false, error: e instanceof Error ? e.message : 'Gagal mengubah periode' };
  }
}

export async function closePeriod(periodId: string): Promise<ActionResult> {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);
    const admin = await createServiceRoleClient();
    const { error } = await admin
      .from('academic_periods')
      .update({ status: 'archived' } as any)
      .eq('id', periodId);
    if (error) throw error;
    revalidatePath('/admin/periode');
    revalidatePath('/admin/dashboard');
    return { ok: true, data: undefined };
  } catch (e) {
    return { ok: false, error: e instanceof Error ? e.message : 'Gagal' };
  }
}

export async function reactivatePeriod(periodId: string): Promise<ActionResult> {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);
    const admin = await createServiceRoleClient();
    // Nonaktifkan periode aktif lain dulu (constraint: hanya 1 'active')
    await admin
      .from('academic_periods')
      .update({ status: 'closed' } as any)
      .eq('status', 'active');
    // Aktifkan periode target
    const { error } = await admin
      .from('academic_periods')
      .update({ status: 'active' } as any)
      .eq('id', periodId);
    if (error) throw error;
    revalidatePath('/admin/periode');
    return { ok: true, data: undefined };
  } catch (e) {
    return { ok: false, error: e instanceof Error ? e.message : 'Gagal' };
  }
}

// --- USER MANAGEMENT (TEACHERS & STUDENTS) ---

const createUserSchema = z.object({
  email: z.string().email(),
  fullName: z.string().min(3),
  nip: z.string().optional(),
  nisn: z.string().optional(),
  gender: z.enum(['L', 'P']).optional(),
  password: z.string().min(6),
  role: z.enum(['teacher', 'student']),
});

export async function createUser(rawInput: z.infer<typeof createUserSchema>) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const parsed = createUserSchema.parse(rawInput);
    const admin = await createServiceRoleClient();

    // Cek apakah email sudah ada di auth.users (orphan dari percobaan gagal)
    const { data: existingList } = await admin.auth.admin.listUsers();
    const orphanUser = existingList?.users?.find((u) => u.email === parsed.email);

    let authUserId: string;

    if (orphanUser) {
      // Cek apakah profil-nya sudah ada
      const { data: existingProfile } = await admin
        .from('profiles')
        .select('id')
        .eq('id', orphanUser.id)
        .single();

      if (existingProfile) {
        // Benar-benar duplikat — tolak
        throw new Error(`Email ${parsed.email} sudah terdaftar sebagai pengguna aktif.`);
      }

      // Orphan: auth ada tapi profil tidak ada → update password & lanjut buat profil
      await admin.auth.admin.updateUserById(orphanUser.id, {
        password: parsed.password,
        user_metadata: { role: parsed.role },
      });
      authUserId = orphanUser.id;
    } else {
      // Normal: buat auth user baru
      const { data: authData, error: authErr } = await admin.auth.admin.createUser({
        email: parsed.email,
        password: parsed.password,
        email_confirm: true,
        user_metadata: { role: parsed.role },
      });
      if (authErr || !authData.user) throw authErr || new Error('Auth creation failed');
      authUserId = authData.user.id;
    }

    // Insert profil
    const { error: profileErr } = await admin.from('profiles').insert({
      id: authUserId,
      email: parsed.email,
      full_name: parsed.fullName,
      role: parsed.role,
      ...(parsed.nip ? { nip: parsed.nip } : {}),
      ...(parsed.nisn ? { nisn: parsed.nisn } : {}),
      ...(parsed.gender ? { gender: parsed.gender } : {}),
    } as any);

    if (profileErr) {
      // Rollback: hapus auth user yang baru dibuat supaya tidak jadi orphan
      if (!orphanUser) await admin.auth.admin.deleteUser(authUserId);
      throw profileErr;
    }

    revalidatePath(parsed.role === 'teacher' ? ((ROUTES as any).adminGuru ?? '/admin/guru') : ((ROUTES as any).adminSiswa ?? '/admin/siswa'));
    return { ok: true };
  } catch (error: any) {
    return { ok: false, error: error.message || 'Gagal membuat pengguna' };
  }
}

/** Schema validasi untuk update data siswa. */
const updateStudentSchema = z.object({
  studentId: z.string().uuid(),
  fullName: z.string().min(2, 'Nama minimal 2 karakter'),
  nisn: z.string().regex(/^\d{10}$/, 'NISN harus 10 digit angka'),
  email: z.string().email('Format email tidak valid'),
  gender: z.enum(['L', 'P']).optional(),
});

/**
 * Update data profil siswa (nama, NISN, email, gender).
 * Jika email berubah, juga update di auth.users via Admin API.
 */
export async function updateStudent(
  rawInput: z.infer<typeof updateStudentSchema>,
) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const parsed = updateStudentSchema.parse(rawInput);
    const admin = await createServiceRoleClient();

    // ALASAN: gunakan service role agar bisa update auth.users + profiles
    // tanpa bergantung pada session user yang sedang login.
    const { data: existing } = await admin
      .from('profiles')
      .select('email, role')
      .eq('id', parsed.studentId)
      .single();

    if (!existing || (existing as any).role !== 'student') {
      throw new Error('Siswa tidak ditemukan');
    }

    // Update email di auth.users jika berubah
    const oldEmail = (existing as any).email as string;
    if (oldEmail !== parsed.email) {
      const { error: authErr } = await admin.auth.admin.updateUserById(
        parsed.studentId,
        { email: parsed.email },
      );
      if (authErr) throw authErr;
    }

    // Update profil di tabel profiles
    const { error: profileErr } = await admin
      .from('profiles')
      .update({
        full_name: parsed.fullName,
        nisn: parsed.nisn,
        email: parsed.email,
        ...(parsed.gender ? { gender: parsed.gender } : {}),
      } as any)
      .eq('id', parsed.studentId);

    if (profileErr) throw profileErr;

    revalidatePath('/admin/siswa');
    return { ok: true };
  } catch (e) {
    return {
      ok: false,
      error: e instanceof Error ? e.message : 'Gagal memperbarui data siswa',
    };
  }
}

/**
 * Hapus siswa secara permanen: hapus dari auth.users (cascade ke profiles,
 * enrollments, dan semua data terkait via FK ON DELETE CASCADE).
 */
export async function deleteStudent(studentId: string) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const parsed = z.string().uuid().parse(studentId);
    const admin = await createServiceRoleClient();

    // Verifikasi role sebelum hapus — jangan sampai hapus guru/admin
    const { data: profile } = await admin
      .from('profiles')
      .select('role, full_name')
      .eq('id', parsed)
      .single();

    if (!profile || (profile as any).role !== 'student') {
      throw new Error('Hanya akun siswa yang bisa dihapus melalui halaman ini');
    }

    // Langkah 1: hapus via auth API (cascade ke profiles via FK).
    const { error: authErr } = await admin.auth.admin.deleteUser(parsed);

    if (authErr) {
      // Langkah 2: fallback jika auth user tidak ada (siswa dimasukkan via SQL/seed)
      const isNotFound =
        authErr.message?.toLowerCase().includes('not found') ||
        authErr.status === 404;

      if (!isNotFound) throw authErr;

      const { error: profileErr } = await admin
        .from('profiles')
        .delete()
        .eq('id', parsed);
      if (profileErr) throw profileErr;
    }

    revalidatePath('/admin/siswa');
    return { ok: true };
  } catch (e) {
    return {
      ok: false,
      error: e instanceof Error ? e.message : 'Gagal menghapus siswa',
    };
  }
}

/**
 * Hapus banyak siswa sekaligus. Setiap ID diverifikasi role-nya sebelum dihapus.
 * Strategi hapus:
 *   1. Coba hapus via auth.admin.deleteUser (cascade ke profiles via FK).
 *   2. Jika auth user tidak ditemukan (siswa dibuat via SQL/seed tanpa auth),
 *      fallback: hapus langsung dari tabel profiles.
 * Mengembalikan jumlah yang berhasil dihapus dan daftar error jika ada yang gagal.
 */
export async function bulkDeleteStudents(studentIds: string[]) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const parsed = z.array(z.string().uuid()).min(1).parse(studentIds);
    const adminClient = await createServiceRoleClient();

    // Verifikasi semua ID adalah siswa sebelum menghapus satu pun
    const { data: profiles, error: fetchErr } = await adminClient
      .from('profiles')
      .select('id, role, full_name')
      .in('id', parsed);

    if (fetchErr) throw fetchErr;

    const nonStudents = (profiles ?? []).filter((p: any) => p.role !== 'student');
    if (nonStudents.length > 0) {
      throw new Error('Beberapa ID bukan akun siswa — operasi dibatalkan');
    }

    const errors: string[] = [];
    let deletedCount = 0;

    for (const id of parsed) {
      // Langkah 1: hapus via auth API (cascade ke profiles)
      const { error: authErr } = await adminClient.auth.admin.deleteUser(id);

      if (!authErr) {
        deletedCount++;
        continue;
      }

      // Langkah 2: fallback — jika auth user tidak ada, hapus langsung dari profiles
      // Ini terjadi ketika siswa dimasukkan via SQL/seed tanpa membuat auth user
      const isNotFound =
        authErr.message?.toLowerCase().includes('not found') ||
        authErr.message?.toLowerCase().includes('user not found') ||
        authErr.status === 404;

      if (isNotFound) {
        const { error: profileErr } = await adminClient
          .from('profiles')
          .delete()
          .eq('id', id);

        if (profileErr) {
          errors.push(`${id}: ${profileErr.message}`);
        } else {
          deletedCount++;
        }
      } else {
        errors.push(`${id}: ${authErr.message}`);
      }
    }

    revalidatePath('/admin/siswa');
    return { ok: true, deletedCount, errors };
  } catch (e) {
    return {
      ok: false,
      deletedCount: 0,
      errors: [],
      error: e instanceof Error ? e.message : 'Gagal menghapus siswa',
    };
  }
}

export async function assignHomeroomTeacher(rawInput: {
  classId: string;
  periodId: string;
  teacherId: string;
}) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const parsed = z
      .object({
        classId: z.string().uuid(),
        periodId: z.string().uuid(),
        teacherId: z.string().uuid(),
      })
      .parse(rawInput);

    const admin = await createServiceRoleClient();

    const { data: existingData } = await admin
      .from('class_period_assignments')
      .select('id')
      .eq('class_id', parsed.classId)
      .eq('period_id', parsed.periodId)
      .single();

    if (existingData) {
      const existing = existingData as { id: string };
      const { error: updateErr } = await admin
        .from('class_period_assignments')
        .update({ homeroom_teacher_id: parsed.teacherId } as any)
        .eq('id', existing.id);
      if (updateErr) throw updateErr;
    } else {
      const { error: insertErr } = await admin.from('class_period_assignments').insert({
        class_id: parsed.classId,
        period_id: parsed.periodId,
        homeroom_teacher_id: parsed.teacherId,
      } as any);
      if (insertErr) throw insertErr;
    }

    revalidatePath((ROUTES as any).adminKelas ?? '/admin/kelas');
    return { ok: true };
  } catch (error: any) {
    return { ok: false, error: error.message || 'Gagal menetapkan wali kelas' };
  }
}

export async function setUserActive(input: { userId: string; isActive: boolean; role: string }) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const admin = await createServiceRoleClient();
    const { error } = await admin
      .from('profiles')
      .update({ is_active: input.isActive } as any)
      .eq('id', input.userId);

    if (error) throw error;

    revalidatePath(input.role === 'teacher' ? ((ROUTES as any).adminGuru ?? '/admin/guru') : ((ROUTES as any).adminSiswa ?? '/admin/siswa'));
    return { ok: true };
  } catch (error: any) {
    return { ok: false, error: error.message || 'Gagal mengubah status' };
  }
}

export async function resetUserPassword(userId: string, newPassword: string) {
  try {
    const validatedPassword = z.string().min(6).parse(newPassword);

    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const admin = await createServiceRoleClient();
    const { error } = await admin.auth.admin.updateUserById(userId, {
      password: validatedPassword,
    });

    if (error) throw error;
    return { ok: true };
  } catch (error: any) {
    return { ok: false, error: error.message || 'Gagal mereset password' };
  }
}

/**
 * Hapus guru secara permanen dari auth.users (cascade ke profiles dan data terkait).
 * Cegah penghapusan jika guru masih assign sebagai wali kelas aktif.
 */
export async function deleteTeacher(teacherId: string) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const parsed = z.string().uuid().parse(teacherId);
    const admin = await createServiceRoleClient();

    // Verifikasi role
    const { data: profile } = await admin
      .from('profiles')
      .select('role, full_name')
      .eq('id', parsed)
      .single();

    if (!profile || (profile as any).role !== 'teacher') {
      throw new Error('Hanya akun guru yang bisa dihapus melalui halaman ini');
    }

    // Cek apakah guru masih jadi wali kelas di assignment aktif
    const { data: activeAssignment } = await admin
      .from('class_period_assignments')
      .select('id, classes:class_id(name)')
      .eq('homeroom_teacher_id', parsed)
      .limit(1)
      .maybeSingle();

    if (activeAssignment) {
      const cls = (activeAssignment as any).classes;
      const clsName = cls?.name ?? 'suatu kelas';
      throw new Error(
        `Guru ini masih menjadi wali kelas ${clsName}. Lepas penugasan terlebih dahulu sebelum menghapus.`,
      );
    }

    const { error: deleteErr } = await admin.auth.admin.deleteUser(parsed);
    if (deleteErr) throw deleteErr;

    revalidatePath('/admin/guru');
    return { ok: true };
  } catch (e) {
    return {
      ok: false,
      error: e instanceof Error ? e.message : 'Gagal menghapus guru',
    };
  }
}

/**
 * Shorthand untuk membuat akun guru — dipakai oleh ImportTeacherDialog.
 */
export async function createTeacher(input: {
  nip: string;
  fullName: string;
  email: string;
  password: string;
}) {
  return createUser({
    email: input.email,
    fullName: input.fullName,
    nip: input.nip,
    password: input.password || '12345678',
    role: 'teacher',
  });
}

// --- CLASS MANAGEMENT ---

export async function createClass(rawInput: { name: string; gradeLevel: string }) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const parsed = z
      .object({ name: z.string().min(1), gradeLevel: z.string().min(1) })
      .parse(rawInput);

    const admin = await createServiceRoleClient();
    const { data: returnData, error } = await admin
      .from('classes')
      .insert({ name: parsed.name, grade_level: parsed.gradeLevel } as any)
      .select('id')
      .single();

    if (error || !returnData) throw error;
    
    const data = returnData as { id: string };

    revalidatePath((ROUTES as any).adminKelas ?? '/admin/kelas');
    return { ok: true, data: { id: data.id } };
  } catch (error: any) {
    return { ok: false, error: error.message || 'Gagal membuat kelas' };
  }
}

/**
 * Ubah nama & tingkat kelas.
 */
export async function updateClassName(rawInput: {
  classId: string;
  name: string;
  gradeLevel: string;
}) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const parsed = z
      .object({
        classId: z.string().uuid(),
        name: z
          .string()
          .min(2, 'Minimal 2 karakter')
          .max(10, 'Maks 10 karakter')
          .regex(/^(X|XI|XII)-[A-Z0-9]+$/, 'Format: X-1, XI-2, XII-A, dst.'),
        gradeLevel: z.enum(['X', 'XI', 'XII']),
      })
      .parse(rawInput);

    const admin = await createServiceRoleClient();
    const { error } = await admin
      .from('classes')
      .update({ name: parsed.name, grade_level: parsed.gradeLevel } as any)
      .eq('id', parsed.classId);

    if (error) throw error;

    revalidatePath('/admin/kelas');
    return { ok: true };
  } catch (e: any) {
    return { ok: false, error: e.message || 'Gagal mengubah nama kelas' };
  }
}

/**
 * Hapus kelas. Hanya bisa dihapus jika tidak ada class_period_assignments
 * yang mengacu ke kelas ini (ON DELETE RESTRICT di DB).
 */
export async function deleteClass(classId: string) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const parsed = z.string().uuid().parse(classId);
    const admin = await createServiceRoleClient();

    // Cek apakah kelas pernah dipakai di assignment (ada siswa/wali kelas)
    const { count } = await admin
      .from('class_period_assignments')
      .select('id', { count: 'exact', head: true })
      .eq('class_id', parsed);

    if ((count ?? 0) > 0) {
      throw new Error(
        'Kelas ini sudah digunakan di periode aktif atau sebelumnya. ' +
        'Tidak bisa dihapus untuk menjaga riwayat data.',
      );
    }

    const { error } = await admin
      .from('classes')
      .delete()
      .eq('id', parsed);

    if (error) throw error;

    revalidatePath('/admin/kelas');
    return { ok: true };
  } catch (e: any) {
    return { ok: false, error: e.message || 'Gagal menghapus kelas' };
  }
}

/**
 * Assign satu atau banyak siswa ke kelas pada periode aktif.
 * Jika class_period_assignment belum ada untuk kelas+periode ini, dibuat otomatis.
 */
export async function assignStudentsToClass(rawInput: {
  studentIds: string[];
  classId: string;
}): Promise<ActionResult<{ enrolled: number }>> {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const parsed = z
      .object({
        studentIds: z.array(z.string().uuid()).min(1),
        classId: z.string().uuid(),
      })
      .parse(rawInput);

    const admin = await createServiceRoleClient();

    // Ambil periode aktif
    const { data: periodData, error: periodErr } = await admin
      .from('academic_periods')
      .select('id')
      .eq('status', 'active')
      .maybeSingle();
    if (periodErr) throw periodErr;
    if (!periodData) throw new Error('Tidak ada periode aktif. Aktifkan periode terlebih dahulu.');
    const activePeriodId = (periodData as { id: string }).id;

    // Upsert class_period_assignment
    const { data: assignData, error: assignErr } = await admin
      .from('class_period_assignments')
      .upsert(
        { class_id: parsed.classId, period_id: activePeriodId } as any,
        { onConflict: 'class_id,period_id', ignoreDuplicates: false }
      )
      .select('id')
      .single();
    if (assignErr) throw assignErr;
    const assignmentId = (assignData as { id: string }).id;

    // Enroll setiap siswa
    let enrolled = 0;
    for (const studentId of parsed.studentIds) {
      // Tandai enrollment aktif sebelumnya sebagai 'transferred'
      await admin
        .from('student_class_enrollments')
        .update({ status: 'transferred' } as any)
        .eq('student_id', studentId)
        .eq('status', 'active');

      // ALASAN: uq_student_class_period = UNIQUE(student_id, class_period_assignment_id).
      // Jika siswa pernah terdaftar di kelas ini sebelumnya (status 'transferred'),
      // INSERT baru akan melanggar constraint. Solusi: cek dulu, lalu UPDATE atau INSERT.
      const { data: existing } = await admin
        .from('student_class_enrollments')
        .select('id')
        .eq('student_id', studentId)
        .eq('class_period_assignment_id', assignmentId)
        .maybeSingle();

      if (existing) {
        // Reaktivasi enrollment yang sudah ada
        const { error: updateErr } = await admin
          .from('student_class_enrollments')
          .update({ status: 'active' } as any)
          .eq('id', (existing as { id: string }).id);
        if (updateErr) throw updateErr;
      } else {
        const { error: insertErr } = await admin.from('student_class_enrollments').insert({
          student_id: studentId,
          class_period_assignment_id: assignmentId,
          initial_score: 75,
        } as any);
        if (insertErr) throw insertErr;
      }
      enrolled++;
    }

    revalidatePath('/admin/siswa');
    revalidatePath('/admin/kelas');
    return { ok: true, data: { enrolled } };
  } catch (e) {
    return { ok: false, error: e instanceof Error ? e.message : 'Gagal mendaftarkan siswa ke kelas' };
  }
}

export async function enrollStudent(rawInput: { studentId: string; assignmentId: string }) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const parsed = z
      .object({ studentId: z.string().uuid(), assignmentId: z.string().uuid() })
      .parse(rawInput);

    const admin = await createServiceRoleClient();

    const { error: updateErr } = await admin
      .from('student_class_enrollments')
      .update({ status: 'transferred' } as any)
      .eq('student_id', parsed.studentId)
      .eq('status', 'active');

    if (updateErr) throw updateErr;

    // ALASAN: uq_student_class_period = UNIQUE(student_id, class_period_assignment_id).
    // Siswa yang pernah terdaftar di kelas target (lalu dipindah ke kelas lain) sudah
    // punya baris dengan status 'transferred' → INSERT akan gagal duplicate key.
    // Solusi: cek keberadaan baris terlebih dahulu, lalu UPDATE atau INSERT.
    const { data: existing } = await admin
      .from('student_class_enrollments')
      .select('id')
      .eq('student_id', parsed.studentId)
      .eq('class_period_assignment_id', parsed.assignmentId)
      .maybeSingle();

    if (existing) {
      // Reaktivasi enrollment lama alih-alih membuat baris baru
      const { error: reactivateErr } = await admin
        .from('student_class_enrollments')
        .update({ status: 'active' } as any)
        .eq('id', (existing as { id: string }).id);
      if (reactivateErr) throw reactivateErr;
    } else {
      const { error: insertErr } = await admin.from('student_class_enrollments').insert({
        student_id: parsed.studentId,
        class_period_assignment_id: parsed.assignmentId,
        initial_score: 75,
      } as any);
      if (insertErr) throw insertErr;
    }

    revalidatePath((ROUTES as any).adminKelas ?? '/admin/kelas');
    revalidatePath((ROUTES as any).adminSiswa ?? '/admin/siswa');
    return { ok: true };
  } catch (error: any) {
    return { ok: false, error: error.message || 'Gagal mendaftarkan siswa' };
  }
}

export async function setStudentEnrollmentActive(input: { enrollmentId: string; isActive: boolean }) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const admin = await createServiceRoleClient();
    const { error } = await admin
      .from('student_class_enrollments')
      .update({ status: input.isActive ? 'active' : 'left' } as any) // Enum implementation
      .eq('id', input.enrollmentId);

    if (error) throw error;

    revalidatePath((ROUTES as any).adminKelas ?? '/admin/kelas');
    return { ok: true };
  } catch (error: any) {
    return { ok: false, error: error.message || 'Gagal mengubah status pendaftaran' };
  }
}

// --- CATEGORY MANAGEMENT ---

export async function upsertViolationCategory(data: {
  id?: string;
  name: string;
  pointValue: number;
  sopReference: string | null;
  description: string | null;
}) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const admin = await createServiceRoleClient();
    const payload = {
      name: data.name,
      point_deduction: data.pointValue,
      sop_reference: data.sopReference,
      description: data.description,
      is_active: true,
    };

    if (data.id) {
      const { error } = await admin.from('violation_categories').update(payload as any).eq('id', data.id);
      if (error) throw error;
    } else {
      const { error } = await admin.from('violation_categories').insert(payload as any);
      if (error) throw error;
    }

    revalidatePath((ROUTES as any).adminKategori ?? '/admin/kategori-poin');
    return { ok: true };
  } catch (error: any) {
    return { ok: false, error: error.message || 'Gagal menyimpan kategori pelanggaran' };
  }
}

export async function upsertRewardCategory(data: {
  id?: string;
  name: string;
  pointValue: number;
  categoryLabel: string | null;
  description: string | null;
}) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const admin = await createServiceRoleClient();
    const payload = {
      name: data.name,
      point_addition: data.pointValue,
      category_label: data.categoryLabel,
      description: data.description,
      is_active: true,
    };

    if (data.id) {
      const { error } = await admin.from('reward_categories').update(payload as any).eq('id', data.id);
      if (error) throw error;
    } else {
      const { error } = await admin.from('reward_categories').insert(payload as any);
      if (error) throw error;
    }

    revalidatePath((ROUTES as any).adminKategori ?? '/admin/kategori-poin');
    return { ok: true };
  } catch (error: any) {
    return { ok: false, error: error.message || 'Gagal menyimpan kategori reward' };
  }
}

export async function deleteCategory(type: 'violation' | 'reward', id: string) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const admin = await createServiceRoleClient();
    const table = type === 'violation' ? 'violation_categories' : 'reward_categories';

    // Soft delete: set is_active menjadi false
    const { error } = await admin
      .from(table)
      .update({ is_active: false } as any)
      .eq('id', id);

    if (error) throw error;

    revalidatePath((ROUTES as any).adminKategori ?? '/admin/kategori-poin');
    return { ok: true };
  } catch (error: any) {
    return { ok: false, error: error.message || 'Gagal menghapus kategori' };
  }
}

// --- FUZZY CONFIGURATION ---

export async function updateMembershipParams(rawInput: {
  id: string;
  paramA: number;
  paramB: number | null;
  paramC: number | null;
}) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const parsed = z
      .object({
        id: z.string().uuid(),
        paramA: z.number(),
        paramB: z.number().nullable(),
        paramC: z.number().nullable(),
      })
      .parse(rawInput);

    // Array parameter konversi untuk fuzzy_configurations table (NUMERIC[])
    const paramsArray = [parsed.paramA];
    if (parsed.paramB !== null) paramsArray.push(parsed.paramB);
    if (parsed.paramC !== null) paramsArray.push(parsed.paramC);

    const admin = await createServiceRoleClient();
    const { error } = await admin
      .from('fuzzy_configurations')
      .update({
        parameters: paramsArray,
      } as any)
      .eq('id', parsed.id);

    if (error) throw error;

    revalidatePath((ROUTES as any).adminKonfigFuzzy ?? '/admin/konfig-fuzzy');
    return { ok: true };
  } catch (error: any) {
    return { ok: false, error: error.message || 'Gagal memperbarui fungsi keanggotaan' };
  }
}

export async function updateRuleOutput(rawInput: {
  id: string;
  outputSet: 'perlu_pembinaan' | 'cukup' | 'baik' | 'sangat_baik';
}) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const parsed = z
      .object({
        id: z.string().uuid(),
        outputSet: z.enum(['perlu_pembinaan', 'cukup', 'baik', 'sangat_baik']),
      })
      .parse(rawInput);

    const admin = await createServiceRoleClient();
    const { error } = await admin
      .from('fuzzy_rules')
      .update({ output_set: parsed.outputSet } as any)
      .eq('id', parsed.id);

    if (error) throw error;

    revalidatePath((ROUTES as any).adminKonfigFuzzy ?? '/admin/konfig-fuzzy');
    return { ok: true };
  } catch (error: any) {
    return { ok: false, error: error.message || 'Gagal memperbarui aturan' };
  }
}

// --- FUZZY CONFIGURATION ---

export async function updateFuzzyConfig(rawInput: {
  variableName: string;
  setName: string;
  functionType: string;
  parameters: number[];
}) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const parsed = z
      .object({
        variableName: z.string(),
        setName: z.string(),
        functionType: z.string(),
        parameters: z.array(z.number()),
      })
      .parse(rawInput);

    const admin = await createServiceRoleClient();
    const { error } = await admin
      .from('fuzzy_configurations')
      .update({
        function_type: parsed.functionType,
        parameters: parsed.parameters,
      } as any)
      .eq('variable_name', parsed.variableName)
      // PERBAIKAN: Gunakan as any agar tidak bentrok dengan strict literal type
      .eq('set_name', parsed.setName as any);

    if (error) throw error;

    revalidatePath((ROUTES as any).adminKonfigFuzzy ?? '/admin/konfig-fuzzy');
    return { ok: true };
  } catch (error: any) {
    return { ok: false, error: error.message || 'Gagal memperbarui fungsi keanggotaan' };
  }
}

// --- SCHOOL SETTINGS ---

const schoolSettingsSchema = z.object({
  principalName: z.string().max(200),
  principalNip:  z.string().max(30),
});

/**
 * Simpan nama dan NIP kepala sekolah ke tabel school_settings.
 * Digunakan di konfigurasi-fuzzy → tab Pengaturan Sekolah.
 */
export async function updateSchoolSettings(
  rawInput: z.infer<typeof schoolSettingsSchema>,
): Promise<ActionResult> {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const parsed = schoolSettingsSchema.parse(rawInput);
    const admin = await createServiceRoleClient();

    // ALASAN: upsert per key agar mudah ditambah field baru tanpa ubah skema
    const { error } = await admin.from('school_settings' as any).upsert([
      { key: 'principal_name', value: parsed.principalName },
      { key: 'principal_nip',  value: parsed.principalNip  },
    ]);

    if (error) throw error;

    revalidatePath('/admin/konfigurasi-fuzzy');
    return { ok: true, data: undefined };
  } catch (err: any) {
    return { ok: false, error: err.message ?? 'Gagal menyimpan pengaturan sekolah' };
  }
}

// --- FUZZY ---

export async function updateFuzzyRuleOutput(rawInput: {
  ruleNumber: number;
  outputSet: 'perlu_pembinaan' | 'cukup' | 'baik' | 'sangat_baik';
}) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const parsed = z
      .object({
        ruleNumber: z.number().int(),
        outputSet: z.enum(['perlu_pembinaan', 'cukup', 'baik', 'sangat_baik']),
      })
      .parse(rawInput);

    const admin = await createServiceRoleClient();
    const { error } = await admin
      .from('fuzzy_rules')
      .update({ output_set: parsed.outputSet } as any)
      .eq('rule_number', parsed.ruleNumber);

    if (error) throw error;

    revalidatePath((ROUTES as any).adminKonfigFuzzy ?? '/admin/konfig-fuzzy');
    return { ok: true };
  } catch (error: any) {
    return { ok: false, error: error.message || 'Gagal memperbarui aturan' };
  }
}

// --- PEER ASSESSMENT ASPECTS ---

const updateAspectSchema = z.object({
  aspectKey: z.enum([
    'courtesy',
    'cooperation',
    'empathy',
    'honesty',
    'responsibility',
  ]),
  label: z.string().min(3, 'Label minimal 3 karakter').max(100),
  description: z.string().min(5, 'Deskripsi minimal 5 karakter').max(500),
});

/**
 * Perbarui label & deskripsi satu aspek peer assessment.
 * Hanya admin. Kunci (aspect_key) & jumlah aspek TIDAK bisa diubah —
 * hanya teks yang ditampilkan ke siswa.
 */
export async function updatePeerReviewAspect(
  rawInput: z.infer<typeof updateAspectSchema>,
) {
  try {
    const auth = await checkAdminAuth();
    if (!auth.ok) throw new Error(auth.error);

    const parsed = updateAspectSchema.parse(rawInput);
    const admin = await createServiceRoleClient();

    const { error } = await admin
      .from('peer_review_aspects')
      .update({
        label: parsed.label,
        description: parsed.description,
        updated_by: auth.user?.id ?? null,
      } as any)
      .eq('aspect_key', parsed.aspectKey);

    if (error) throw error;

    revalidatePath((ROUTES as any).adminKategori ?? '/admin/kategori-poin');
    return { ok: true };
  } catch (error: any) {
    return { ok: false, error: error.message || 'Gagal memperbarui aspek' };
  }
}