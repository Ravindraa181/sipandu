/**
 * @file middleware.ts
 * @description Middleware Next.js untuk:
 *               1. Refresh session Supabase (auth cookies) tiap request
 *               2. Routing protection berdasarkan role:
 *                    /admin/*     → admin only
 *                    /dashboard/* → teacher only (cek assignment, kalau belum → /waiting)
 *                    /siswa/*     → student only
 *                    /            → redirect /login
 *
 *  Berjalan di Edge runtime — pakai `@supabase/ssr` (compatible).
 *
 *  Logika tambahan:
 *   - User yang sudah login dan akses /login atau /admin/login akan
 *     diredirect ke beranda role-nya.
 *   - User tanpa profile aktif akan di-signOut dan dilempar ke /login.
 */

import { NextResponse, type NextRequest } from 'next/server';
import { createServerClient, type CookieOptions } from '@supabase/ssr';
import { ROUTES, getRoleHomePath } from '@/constants';
import type { UserRole } from '@/types';

/* ────────────────────────────────────────────────────────────────────
 *  Konstanta path
 * ──────────────────────────────────────────────────────────────────── */

/** Path public — tidak butuh authentication. */
const PUBLIC_PATHS = new Set<string>([
  ROUTES.login,
  ROUTES.adminLogin,
  '/auth/callback',
  '/auth/confirm',
]);

/** Path yang khusus untuk teacher tanpa assignment. */
const WAITING_PATH: string = ROUTES.waiting;

/* ────────────────────────────────────────────────────────────────────
 *  Middleware
 * ──────────────────────────────────────────────────────────────────── */

export async function proxy(req: NextRequest) {
  const { pathname } = req.nextUrl;
  const response = NextResponse.next({ request: req });

  // ── Setup Supabase server client untuk middleware ────────────────
  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return req.cookies.getAll();
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value, options }) => {
            response.cookies.set(name, value, options as CookieOptions);
          });
        },
      },
    },
  );

  // ── 1. Refresh session: getUser() akan auto-rotate JWT bila perlu ──
  const {
    data: { user },
  } = await supabase.auth.getUser();

  // ── 2. Root: redirect ke login (atau home role bila sudah login) ──
  if (pathname === '/') {
    const target = user
      ? await resolveRoleHome(supabase, user.id)
      : ROUTES.login;
    return NextResponse.redirect(new URL(target, req.url));
  }

  // ── 3. Public paths ──────────────────────────────────────────────
  if (PUBLIC_PATHS.has(pathname)) {
    // User yang sudah login → arahkan ke home role-nya
    if (user) {
      const target = await resolveRoleHome(supabase, user.id);
      return NextResponse.redirect(new URL(target, req.url));
    }
    return response;
  }

  // ── 4. Path protected: butuh auth ────────────────────────────────
  if (!user) {
    const loginUrl = pathname.startsWith('/admin')
      ? ROUTES.adminLogin
      : ROUTES.login;
    return NextResponse.redirect(new URL(loginUrl, req.url));
  }

  // ── 5. Ambil role dari profile ───────────────────────────────────
  const { data: profile, error: profileErr } = await supabase
    .from('profiles')
    .select('role, is_active')
    .eq('id', user.id)
    .single();

  if (profileErr || !profile || !profile.is_active) {
    // Profile tidak ada atau dinonaktifkan → sign out paksa
    await supabase.auth.signOut();
    return NextResponse.redirect(new URL(ROUTES.login, req.url));
  }

  const role = profile.role as UserRole;

  // ── 6. Cek role per prefix path ──────────────────────────────────

  // /admin/* → admin only
  if (pathname.startsWith('/admin/')) {
    if (role !== 'admin') {
      return NextResponse.redirect(
        new URL(getRoleHomePath(role), req.url),
      );
    }
    return response;
  }

  // /siswa/* → student only
  if (pathname.startsWith('/siswa')) {
    if (role !== 'student') {
      return NextResponse.redirect(
        new URL(getRoleHomePath(role), req.url),
      );
    }
    return response;
  }

  // /waiting → teacher only
  if (pathname === WAITING_PATH) {
    if (role !== 'teacher') {
      return NextResponse.redirect(
        new URL(getRoleHomePath(role), req.url),
      );
    }
    return response;
  }

  // /dashboard atau /dashboard/* → teacher only + cek assignment aktif
  if (pathname === ROUTES.teacherHome || pathname.startsWith('/dashboard/')) {
    if (role !== 'teacher') {
      return NextResponse.redirect(
        new URL(getRoleHomePath(role), req.url),
      );
    }

    // Cek apakah teacher punya assignment di periode aktif
    // PENTING: kolom FK di migration adalah `homeroom_teacher_id`, bukan `teacher_id`.
    const { data: assignment } = await supabase
      .from('class_period_assignments')
      .select('id, academic_periods!inner(status)')
      .eq('homeroom_teacher_id', user.id)
      .eq('academic_periods.status', 'active')
      .maybeSingle();

    if (!assignment) {
      return NextResponse.redirect(new URL(WAITING_PATH, req.url));
    }
    return response;
  }

  // ── 7. Default: pass through ─────────────────────────────────────
  return response;
}

/* ────────────────────────────────────────────────────────────────────
 *  Helper: resolve home path berdasarkan role user
 * ──────────────────────────────────────────────────────────────────── */

async function resolveRoleHome(
  supabase: ReturnType<typeof createServerClient>,
  userId: string,
): Promise<string> {
  const { data } = await supabase
    .from('profiles')
    .select('role')
    .eq('id', userId)
    .single();
  return getRoleHomePath(data?.role as string | undefined);
}

/* ────────────────────────────────────────────────────────────────────
 *  Matcher — exclude asset & API routes
 * ──────────────────────────────────────────────────────────────────── */

export const config = {
  matcher: [
    /*
     * Match semua request KECUALI:
     *  - _next/static (static files)
     *  - _next/image  (image optimization)
     *  - favicon, robots, manifest, sitemap
     *  - api/* (gunakan Route Handler auth sendiri bila perlu)
     */
    '/((?!_next/static|_next/image|favicon.ico|robots.txt|manifest.webmanifest|sitemap.xml|api/.*).*)',
  ],
};
