/**
 * @file app/api/auth/admin-login/route.ts
 * @description Endpoint login admin (POST) — alternatif "fast-track"
 *              tanpa Supabase Auth.
 *
 *  Alur:
 *   1. Validasi body { username, password } via Zod.
 *   2. Bandingkan `username` dengan ENV `ADMIN_USERNAME`.
 *   3. `bcrypt.compare(password, ADMIN_PASSWORD_HASH)`.
 *   4. Bila match → set httpOnly cookie session admin yang ditandatangani
 *      HMAC-SHA256 (rahasia diambil dari SUPABASE_SERVICE_ROLE_KEY).
 *   5. Return { success: true, redirectTo: '/admin/dashboard' } atau
 *      pesan error 401.
 *
 *  Catatan keamanan:
 *   - Cookie dibatasi httpOnly + sameSite=strict + secure (production).
 *   - Tidak ada timing-safe shortcut: bila username salah kita tetap
 *     menjalankan bcrypt.compare dummy agar response time tidak bocor.
 *   - Maks 8 jam (sesuai default sesi admin). Refresh dilakukan pada
 *     kunjungan berikutnya jika perlu.
 */

import { NextResponse, type NextRequest } from 'next/server';
import { cookies } from 'next/headers';
import { z } from 'zod';
import bcrypt from 'bcrypt';
import crypto from 'node:crypto';

import { fail, failFromUnknown, ok } from '../../_lib/response';

export const runtime = 'nodejs'; // bcrypt butuh Node runtime
export const dynamic = 'force-dynamic';

/* ────────────────────────────────────────────────────────────────────
 *  Konstanta
 * ──────────────────────────────────────────────────────────────────── */

/** Nama cookie session admin custom. */
export const ADMIN_SESSION_COOKIE = 'sipandu_admin_session';

/** TTL cookie admin: 8 jam. */
const SESSION_TTL_SECONDS = 8 * 60 * 60;

/**
 * Hash dummy bcrypt — dipakai saat username tidak cocok agar `compare`
 * tetap dijalankan (mencegah timing attack).
 */
const DUMMY_HASH =
  '$2b$10$CwTycUXWue0Thq9StjUM0uJ8C6/QvwS/Df2C5Dq3R7r6h0rGRkfWS';

/* ────────────────────────────────────────────────────────────────────
 *  Schema input
 * ──────────────────────────────────────────────────────────────────── */

const loginSchema = z.object({
  username: z.string().min(1, 'Username wajib diisi').max(150),
  password: z.string().min(1, 'Password wajib diisi').max(200),
});

/* ────────────────────────────────────────────────────────────────────
 *  Helper: tanda tangan token
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Token format: `<username_b64>.<expiry>.<hmac>`
 *
 *   - username_b64 : base64url(username)
 *   - expiry       : unix timestamp detik
 *   - hmac         : HMAC-SHA256(rahasia, `${username_b64}.${expiry}`)
 */
function buildSessionToken(username: string, secret: string): string {
  const expiry = Math.floor(Date.now() / 1000) + SESSION_TTL_SECONDS;
  const usernameB64 = Buffer.from(username, 'utf8').toString('base64url');
  const payload = `${usernameB64}.${expiry}`;
  const hmac = crypto
    .createHmac('sha256', secret)
    .update(payload)
    .digest('base64url');
  return `${payload}.${hmac}`;
}

/** Ambil rahasia HMAC; fallback ke key yang ada. Throw bila tidak ada. */
function getSessionSecret(): string {
  const secret =
    process.env.SUPABASE_SERVICE_ROLE_KEY ||
    process.env.ADMIN_PASSWORD_HASH ||
    '';
  if (!secret) {
    throw new Error(
      'Server belum dikonfigurasi: SUPABASE_SERVICE_ROLE_KEY atau ADMIN_PASSWORD_HASH wajib di-set',
    );
  }
  return secret;
}

/* ────────────────────────────────────────────────────────────────────
 *  Handler POST
 * ──────────────────────────────────────────────────────────────────── */

interface LoginSuccessBody {
  success: true;
  redirectTo: string;
}

export async function POST(req: NextRequest): Promise<NextResponse> {
  try {
    const json = await req.json().catch(() => null);
    if (!json) {
      return fail('Body request bukan JSON yang valid', 400);
    }

    const parsed = loginSchema.safeParse(json);
    if (!parsed.success) {
      return failFromUnknown(parsed.error);
    }

    const expectedUsername = process.env.ADMIN_USERNAME;
    const expectedHash = process.env.ADMIN_PASSWORD_HASH;
    if (!expectedUsername || !expectedHash) {
      return fail(
        'Server belum dikonfigurasi (ADMIN_USERNAME / ADMIN_PASSWORD_HASH)',
        500,
      );
    }

    const usernameMatch = parsed.data.username === expectedUsername;
    const hashToCompare = usernameMatch ? expectedHash : DUMMY_HASH;

    // Selalu jalankan bcrypt.compare untuk timing safety
    const passwordMatch = await bcrypt.compare(
      parsed.data.password,
      hashToCompare,
    );

    if (!usernameMatch || !passwordMatch) {
      return fail('Username atau password salah', 401);
    }

    // Build & set cookie session admin
    const token = buildSessionToken(expectedUsername, getSessionSecret());
    const cookieStore = await cookies();
    cookieStore.set(ADMIN_SESSION_COOKIE, token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict',
      path: '/',
      maxAge: SESSION_TTL_SECONDS,
    });

    return ok<LoginSuccessBody>({
      success: true,
      redirectTo: '/admin/dashboard',
    });
  } catch (err) {
    return failFromUnknown(err);
  }
}
