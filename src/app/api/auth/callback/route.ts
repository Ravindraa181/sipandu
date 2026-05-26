/**
 * @file app/api/auth/callback/route.ts
 * @description Supabase OAuth / Magic Link callback handler.
 *
 *  Dipanggil otomatis oleh Supabase setelah:
 *   - User klik link konfirmasi email (sign-up / reset password)
 *   - User selesai OAuth flow (Google, dst — bila aktif)
 *   - User klik magic link login
 *
 *  Tugas handler:
 *   1. Tangkap `?code=...` dari query string.
 *   2. `supabase.auth.exchangeCodeForSession(code)` — Supabase akan
 *      menulis cookies session ke response.
 *   3. Redirect ke beranda role (admin/teacher/student).
 *
 *  Bila `code` hilang atau exchange gagal, redirect ke /login dengan
 *  flag error agar UI bisa menampilkan toast.
 */

import { NextResponse, type NextRequest } from 'next/server';
import { createClient } from '@/lib/supabase/server';
import { ROUTES, getRoleHomePath } from '@/constants';

export const dynamic = 'force-dynamic';

/* ────────────────────────────────────────────────────────────────────
 *  Helper
 * ──────────────────────────────────────────────────────────────────── */

/** Redirect dengan kode error pada query string. */
function redirectError(req: NextRequest, code: string): NextResponse {
  const url = new URL(ROUTES.login, req.url);
  url.searchParams.set('error', code);
  return NextResponse.redirect(url);
}

/* ────────────────────────────────────────────────────────────────────
 *  Handler GET
 * ──────────────────────────────────────────────────────────────────── */

export async function GET(req: NextRequest): Promise<NextResponse> {
  const { searchParams } = new URL(req.url);
  const code = searchParams.get('code');
  /** Optional: tujuan redirect setelah login (mis. dari deep-link). */
  const next = searchParams.get('next');

  if (!code) {
    return redirectError(req, 'missing_code');
  }

  const supabase = await createClient();

  // Tukar `code` → session (Supabase akan set cookies di response)
  const { error: exchErr } = await supabase.auth.exchangeCodeForSession(code);
  if (exchErr) {
    return redirectError(req, 'exchange_failed');
  }

  // Ambil user yang baru login untuk menentukan role
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return redirectError(req, 'no_user');
  }

  const { data: profile } = await supabase
    .from('profiles')
    .select('role, is_active')
    .eq('id', user.id)
    .single();

  if (!profile || !profile.is_active) {
    // Sign out paksa agar tidak ada session zombi
    await supabase.auth.signOut();
    return redirectError(req, 'profile_not_found');
  }

  // Redirect ke beranda role atau ke `next` bila valid
  const fallback = getRoleHomePath(profile.role as string);
  const target =
    next && next.startsWith('/') && !next.startsWith('//') ? next : fallback;

  return NextResponse.redirect(new URL(target, req.url));
}
