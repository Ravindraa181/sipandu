/**
 * @file app/api/fuzzy/recalculate-class/route.ts
 * @description Trigger recompute Z* untuk SEMUA siswa pada satu kelas.
 *
 *  FIX TS2304 (line 104):
 *   Variabel `supabase` tidak terdefinisi di scope ini — yang ada hanya `admin`
 *   (service role client). Ganti dengan `admin` dan cast ke `FuzzyDbClientParam`
 *   sama seperti calculate/route.ts.
 */

import { type NextRequest } from 'next/server';
import { z } from 'zod';

import { fail, failFromUnknown, ok } from '../../_lib/response';
import { assertTeacherOrAdmin } from '../../_lib/auth';
import { recomputeStudent } from '../../_lib/recompute';
import { createServiceRoleClient } from '@/lib/supabase/server';
import { loadConfigFromDb } from '@/lib/fuzzy/engine';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

const inputSchema = z.object({
  classId: z.string().uuid('classId harus UUID'),
  periodId: z.string().uuid('periodId harus UUID'),
});

interface DetailItem {
  studentId: string;
  computed: boolean;
  reason?: string;
  zStar?: number;
  category?: string;
}

interface SuccessBody {
  processed: number;
  success: number;
  failed: number;
  details: DetailItem[];
}

// Alias tipe untuk cast agar konsisten
type FuzzyDbClientParam = Parameters<typeof loadConfigFromDb>[0];

export async function POST(req: NextRequest) {
  try {
    await assertTeacherOrAdmin();

    const json = await req.json().catch(() => null);
    if (!json) return fail('Body request bukan JSON yang valid', 400);

    const parsed = inputSchema.safeParse(json);
    if (!parsed.success) return failFromUnknown(parsed.error);

    const admin = await createServiceRoleClient();

    // ── 1. Cari assignment kelas-periode ──────────────────────────
    const { data: assignment, error: aErr } = await admin
      .from('class_period_assignments')
      .select('id')
      .eq('class_id', parsed.data.classId)
      .eq('period_id', parsed.data.periodId)
      .maybeSingle();

    if (aErr || !assignment) {
      return fail('Assignment kelas-periode tidak ditemukan', 404);
    }

    // ── 2. Ambil daftar siswa aktif ───────────────────────────────
    const { data: enrolls, error: eErr } = await admin
      .from('student_class_enrollments')
      .select('student_id')
      .eq('class_period_assignment_id', assignment.id as string)
      .eq('status', 'active');

    if (eErr) {
      return fail(`Gagal memuat siswa: ${eErr.message}`, 500);
    }
    const students = (enrolls ?? []) as Array<{ student_id: string }>;

    if (students.length === 0) {
      return ok<SuccessBody>({ processed: 0, success: 0, failed: 0, details: [] });
    }

    // ── 3. Load fuzzy config sekali ───────────────────────────────
    // FIX TS2304: `supabase` tidak ada → gunakan `admin` dengan cast
    const config = await loadConfigFromDb(
      admin as unknown as FuzzyDbClientParam,
    );

    // ── 4. Loop sequential ────────────────────────────────────────
    const details: DetailItem[] = [];
    let success = 0;
    let failed = 0;

    for (const s of students) {
      const result = await recomputeStudent({
        studentId: s.student_id,
        periodId: parsed.data.periodId,
        config,
      });

      if (result.computed) {
        success++;
        details.push({
          studentId: s.student_id,
          computed: true,
          zStar: result.detail.zStar,
          category: result.detail.category,
        });
      } else {
        failed++;
        details.push({
          studentId: s.student_id,
          computed: false,
          reason: result.reason,
        });
      }
    }

    return ok<SuccessBody>({
      processed: students.length,
      success,
      failed,
      details,
    });
  } catch (err) {
    if (err instanceof Error && /akses|login/i.test(err.message)) {
      return fail(err.message, 403);
    }
    return failFromUnknown(err);
  }
}
