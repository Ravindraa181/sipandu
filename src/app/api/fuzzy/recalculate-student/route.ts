/**
 * @file app/api/fuzzy/recalculate-student/route.ts
 * @description Trigger ulang perhitungan Z* untuk satu siswa.
 *
 *  Auth: hanya teacher atau admin.
 *
 *  Body:
 *      { studentId: uuid, periodId: uuid }
 *
 *  Logika delegasi ke `recomputeStudent` di `_lib/recompute.ts`. Lihat
 *  file tersebut untuk pipeline lengkapnya.
 *
 *  Response (success):
 *      { ok: true, data: {
 *          enrollmentId, x1, x2, rawX2, x3,
 *          zStar, category, computedAt,
 *          activeRulesCount
 *        } }
 *
 *  Response (skip / data tidak lengkap):
 *      { ok: true, data: { computed: false, reason } }   // 200, bukan error
 */

import { type NextRequest } from 'next/server';
import { z } from 'zod';

import { fail, failFromUnknown, ok } from '../../_lib/response';
import { assertTeacherOrAdmin } from '../../_lib/auth';
import { recomputeStudent } from '../../_lib/recompute';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

const inputSchema = z.object({
  studentId: z.string().uuid('studentId harus UUID'),
  periodId: z.string().uuid('periodId harus UUID'),
});

interface SuccessBody {
  computed: boolean;
  enrollmentId: string | null;
  reason?: string;
  x1?: number;
  x2?: number;
  rawX2?: number;
  x3?: number;
  zStar?: number;
  category?: string;
  computedAt?: string;
  activeRulesCount?: number;
}

export async function POST(req: NextRequest) {
  try {
    await assertTeacherOrAdmin();

    const json = await req.json().catch(() => null);
    if (!json) return fail('Body request bukan JSON yang valid', 400);

    const parsed = inputSchema.safeParse(json);
    if (!parsed.success) return failFromUnknown(parsed.error);

    const result = await recomputeStudent({
      studentId: parsed.data.studentId,
      periodId: parsed.data.periodId,
    });

    if (!result.computed) {
      return ok<SuccessBody>({
        computed: false,
        enrollmentId: result.enrollmentId,
        reason: result.reason,
      });
    }

    return ok<SuccessBody>({
      computed: true,
      enrollmentId: result.enrollmentId,
      x1: result.x1,
      x2: result.x2,
      rawX2: result.rawX2,
      x3: result.x3,
      zStar: result.detail.zStar,
      category: result.detail.category,
      computedAt: result.detail.computedAt,
      activeRulesCount: result.detail.activeRules.length,
    });
  } catch (err) {
    if (err instanceof Error && /akses|login/i.test(err.message)) {
      return fail(err.message, 403);
    }
    return failFromUnknown(err);
  }
}
