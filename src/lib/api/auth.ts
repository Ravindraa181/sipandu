/**
 * @file lib/api/auth.ts
 * @description Helper auth & role check untuk route handler API.
 *
 *  - `requireUser`        — hanya butuh session login (role apa pun)
 *  - `requireRole(role)`  — butuh role tertentu (admin/teacher/student)
 *  - `requireAnyRole([])` — butuh salah satu dari beberapa role
 *
 *  Helper ini melempar `AuthError` agar caller bisa di-handle via
 *  catch + fail(). Caller selalu pakai try/catch + handleError.
 */

import { createClient } from '@/lib/supabase/server';
import type { UserRole } from '@/types';

export class AuthError extends Error {
  code: 'UNAUTHORIZED' | 'FORBIDDEN';
  constructor(code: 'UNAUTHORIZED' | 'FORBIDDEN', message: string) {
    super(message);
    this.code = code;
    this.name = 'AuthError';
  }
}

export interface AuthenticatedUser {
  id: string;
  email: string;
  fullName: string;
  role: UserRole;
  isActive: boolean;
}

/**
 * Verifikasi caller punya session valid dan profil aktif.
 *
 * @throws AuthError(UNAUTHORIZED) bila belum login atau profil tidak aktif.
 */
export async function requireUser(): Promise<AuthenticatedUser> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    throw new AuthError('UNAUTHORIZED', 'Belum login');
  }

  const { data: profile } = await supabase
    .from('profiles')
    .select('id, role, full_name, email, is_active')
    .eq('id', user.id)
    .single();

  if (!profile || !profile.is_active) {
    throw new AuthError('UNAUTHORIZED', 'Akun tidak aktif atau tidak ditemukan');
  }

  return {
    id: profile.id as string,
    email: profile.email as string,
    fullName: profile.full_name as string,
    role: profile.role as UserRole,
    isActive: profile.is_active as boolean,
  };
}

/**
 * Verifikasi caller punya role tertentu.
 *
 * @throws AuthError(FORBIDDEN) bila role tidak cocok.
 */
export async function requireRole(role: UserRole): Promise<AuthenticatedUser> {
  const user = await requireUser();
  if (user.role !== role) {
    throw new AuthError(
      'FORBIDDEN',
      `Akses ditolak — endpoint ini khusus untuk role '${role}'`,
    );
  }
  return user;
}

/**
 * Verifikasi caller punya salah satu role dari daftar.
 *
 * @throws AuthError(FORBIDDEN) bila role tidak cocok.
 */
export async function requireAnyRole(
  roles: readonly UserRole[],
): Promise<AuthenticatedUser> {
  const user = await requireUser();
  if (!roles.includes(user.role)) {
    throw new AuthError(
      'FORBIDDEN',
      `Akses ditolak — endpoint ini khusus untuk role: ${roles.join(', ')}`,
    );
  }
  return user;
}
