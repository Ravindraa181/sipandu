/**
 * @file app/api/_lib/response.ts
 * @description Helper response yang dipakai di semua route handler.
 *
 * Format error konsisten:
 *   { ok: false, error: string, details?: unknown }
 *
 * Format success konsisten:
 *   { ok: true, data: T }
 */

import { NextResponse } from 'next/server';
import { ZodError } from 'zod';

/** Bentuk response error standar SiPandu. */
export interface ApiError {
  ok: false;
  error: string;
  details?: unknown;
}

/** Bentuk response sukses standar SiPandu. */
export interface ApiSuccess<T> {
  ok: true;
  data: T;
}

/** Buat response sukses JSON. */
export function ok<T>(data: T, init?: ResponseInit): NextResponse<ApiSuccess<T>> {
  return NextResponse.json<ApiSuccess<T>>({ ok: true, data }, init);
}

/** Buat response error JSON dengan status code yang sesuai. */
export function fail(
  error: string,
  status = 400,
  details?: unknown,
): NextResponse<ApiError> {
  const body: ApiError = { ok: false, error };
  if (details !== undefined) body.details = details;
  return NextResponse.json<ApiError>(body, { status });
}

/**
 * Konversi error tak-terduga (Zod, Error, unknown) menjadi NextResponse error.
 *
 *  - ZodError → 400 dengan list message field
 *  - Error    → 500
 *  - unknown  → 500 generic
 *
 * FIX TS2339: ZodError menggunakan `.issues` (bukan `.errors`).
 * `.errors` adalah alias yang tidak selalu tersedia di semua versi Zod/TS.
 */
export function failFromUnknown(err: unknown): NextResponse<ApiError> {
  if (err instanceof ZodError) {
    // FIX: gunakan .issues (properti kanonik ZodError), bukan .errors
    const messages = err.issues.map(
      (issue) => `${issue.path.join('.')}: ${issue.message}`,
    );
    return fail('Validasi input gagal', 400, messages);
  }
  if (err instanceof Error) {
    return fail(err.message || 'Internal server error', 500);
  }
  return fail('Internal server error', 500);
}
