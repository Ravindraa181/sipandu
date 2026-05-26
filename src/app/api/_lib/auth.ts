/**
 * @file app/api/_lib/auth.ts
 * @description Helper auth untuk Route Handlers SiPandu.
 *
 *  Menyediakan:
 *   - getCurrentUser  : ambil user + profile dari Supabase session
 *   - assertRole      : pastikan caller punya role tertentu (defense-in-depth)
 *   - assertTeacherOrAdmin : shortcut untuk endpoint fuzzy recalculate
 *
 *  Catatan: middleware sudah memblokir akses path UI berdasarkan role,
 *  tetapi API routes di-skip oleh matcher middleware (lihat
 *  src/middleware.ts §config) — jadi route handler harus melakukan
 *  pengecekan sendiri.
 */

import 'server-only';
import { createClient } from '@/lib/supabase/server';
import type { UserRole } from '@/types';

export interface CurrentUser {
  /** auth.users.id */
  id: string;
  email: string;
  fullName: string;
  role: UserRole;
  isActive: boolean;
}

/** Ambil user + profile saat ini. Throw bila belum login / profile tidak aktif. */
export async function getCurrentUser(): Promise<CurrentUser> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    throw new Error('Belum login');
  }

  const { data: profile, error } = await supabase
    .from('profiles')
    .select('id, email, full_name, role, is_active')
    .eq('id', user.id)
    .single();

  if (error || !profile) {
    throw new Error('Profil pengguna tidak ditemukan');
  }
  if (!profile.is_active) {
    throw new Error('Akun Anda telah dinonaktifkan');
  }

  return {
    id: profile.id as string,
    email: profile.email as string,
    fullName: profile.full_name as string,
    role: profile.role as UserRole,
    isActive: profile.is_active as boolean,
  };
}

/** Pastikan caller memiliki SALAH SATU role yang diperbolehkan. */
export async function assertRole(
  allowed: ReadonlyArray<UserRole>,
): Promise<CurrentUser> {
  const user = await getCurrentUser();
  if (!allowed.includes(user.role)) {
    throw new Error('Akses ditolak — role tidak diizinkan');
  }
  return user;
}

/** Shortcut: hanya teacher atau admin yang boleh. */
export async function assertTeacherOrAdmin(): Promise<CurrentUser> {
  return assertRole(['teacher', 'admin'] as const);
}

/** Shortcut: hanya student. */
export async function assertStudent(): Promise<CurrentUser> {
  return assertRole(['student'] as const);
}
