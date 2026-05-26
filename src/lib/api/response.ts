/**
 * @file lib/api/response.ts
 * @description Helper konsisten untuk membangun JSON response API SiPandu.
 *
 *  Format envelope:
 *    Sukses: { ok: true, data: T }
 *    Gagal:  { ok: false, error: { code, message, details? } }
 *
 *  Status code default sudah selaras dengan konvensi REST:
 *    200 sukses biasa
 *    400 invalid input (zod error / business rule)
 *    401 belum login
 *    403 role tidak sesuai
 *    404 resource tidak ditemukan
 *    409 konflik (duplikat, sudah diisi, dll.)
 *    500 unexpected server error
 *
 *  Semua handler dijamin return NextResponse.json — tidak boleh
 *  throw tanpa caught.
 */

import { NextResponse } from 'next/server';
import { ZodError } from 'zod';

export type ApiErrorCode =
  | 'INVALID_INPUT'
  | 'UNAUTHORIZED'
  | 'FORBIDDEN'
  | 'NOT_FOUND'
  | 'CONFLICT'
  | 'INTERNAL_ERROR';

export interface ApiErrorBody {
  ok: false;
  error: {
    code: ApiErrorCode;
    message: string;
    details?: unknown;
  };
}

export interface ApiSuccessBody<T> {
  ok: true;
  data: T;
}

const STATUS_FOR_CODE: Record<ApiErrorCode, number> = {
  INVALID_INPUT: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  CONFLICT: 409,
  INTERNAL_ERROR: 500,
};

/** Bangun response sukses 200 dengan envelope `{ ok: true, data }`. */
export function ok<T>(data: T, init?: ResponseInit): NextResponse<ApiSuccessBody<T>> {
  return NextResponse.json({ ok: true, data }, { status: 200, ...init });
}

/** Bangun response gagal dengan envelope `{ ok: false, error }`. */
export function fail(
  code: ApiErrorCode,
  message: string,
  details?: unknown,
): NextResponse<ApiErrorBody> {
  return NextResponse.json(
    {
      ok: false,
      error: { code, message, details },
    },
    { status: STATUS_FOR_CODE[code] },
  );
}

/**
 * Tangani error tak terduga di dalam route handler.
 *
 *  - ZodError → 400 INVALID_INPUT dengan field details
 *  - Error biasa → 500 INTERNAL_ERROR (message di-log, tidak diekspos)
 *  - Selain itu → 500 INTERNAL_ERROR generic
 */
export function handleError(err: unknown): NextResponse<ApiErrorBody> {
  if (err instanceof ZodError) {
    return fail(
      'INVALID_INPUT',
      'Validasi input gagal',
      // (err as ZodError).errors.map((e: any) => ({
      (err as ZodError).issues.map((e: { path: PropertyKey[]; message: string }) => ({
        path: e.path.join('.'),
        message: e.message,
      })),
    );
  }
  if (err instanceof Error) {
    // Catatan: jangan ekspos message ke client untuk error tak terduga.
    // Log di server-side. Di Next.js, console.error muncul di server log.
    console.error('[api] unexpected error:', err);
    return fail('INTERNAL_ERROR', 'Terjadi kesalahan tak terduga');
  }
  console.error('[api] non-Error throw:', err);
  return fail('INTERNAL_ERROR', 'Terjadi kesalahan tak terduga');
}

/**
 * Parse JSON body dengan penanganan error eksplisit.
 *
 *  Bila body tidak JSON valid → throw ZodError-like dengan code 400.
 */
export async function readJsonBody(req: Request): Promise<unknown> {
  try {
    return await req.json();
  } catch {
    throw new Error('Body bukan JSON valid');
  }
}
