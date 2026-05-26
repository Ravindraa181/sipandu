/**
 * @file lib/api/handle-route.ts
 * @description Wrapper sederhana untuk route handler agar konsisten
 *              dalam menangani auth error dan unexpected error.
 *
 *  Pattern pakai:
 *    export const POST = handleRoute(async (req) => {
 *      const user = await requireRole('admin');
 *      const body = await readJsonBody(req);
 *      const parsed = schema.parse(body);
 *      // ... logic
 *      return ok({ ... });
 *    });
 *
 *  Wrapper akan:
 *   - Tangkap AuthError → translate ke fail()
 *   - Tangkap ZodError → fail INVALID_INPUT
 *   - Tangkap Error lain → fail INTERNAL_ERROR (logged)
 */

import type { NextRequest, NextResponse } from 'next/server';
import { AuthError } from './auth';
import { fail, handleError, type ApiErrorBody } from './response';

export type RouteHandler<TParams = Record<string, string>> = (
  req: NextRequest,
  ctx: { params: Promise<TParams> },
) => Promise<NextResponse>;

export function handleRoute<TParams = Record<string, string>>(
  fn: RouteHandler<TParams>,
): RouteHandler<TParams> {
  return async (req, ctx) => {
    try {
      return await fn(req, ctx);
    } catch (err) {
      if (err instanceof AuthError) {
        return fail(err.code, err.message) as NextResponse<ApiErrorBody>;
      }
      return handleError(err);
    }
  };
}
