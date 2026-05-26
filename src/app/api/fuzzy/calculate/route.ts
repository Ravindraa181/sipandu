/**
 * @file app/api/fuzzy/calculate/route.ts
 * @description Endpoint kalkulasi fuzzy ad-hoc (POST).
 *
 *  FIX TS2345 (line 67):
 *   `loadConfigFromDb` mendefinisikan parameternya sebagai `FuzzyDbClient`
 *   (tipe minimal yang hanya perlu method `.from().select()`).
 *   Supabase typed client (yang dihasilkan `createClient()`) memiliki
 *   generik yang lebih spesifik sehingga TypeScript menolak assignabilitasnya.
 *   Solusi: cast ke `Parameters<typeof loadConfigFromDb>[0]` agar
 *   aman tanpa menggunakan `any` langsung.
 */

import { type NextRequest } from 'next/server';
import { z } from 'zod';

import { fail, failFromUnknown, ok } from '../../_lib/response';
import {
  calculateFuzzy,
  loadConfigFromDb,
  DEFAULT_FUZZY_CONFIG,
} from '@/lib/fuzzy/engine';
import type { FuzzyCalculationDetail } from '@/lib/fuzzy/types';
import { createClient } from '@/lib/supabase/server';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/* ────────────────────────────────────────────────────────────────────
 *  Schema
 * ──────────────────────────────────────────────────────────────────── */

const calcSchema = z.object({
  x1: z.coerce.number().min(0).max(100),
  x2: z.coerce.number().min(0).max(100),
  x3: z.coerce.number().min(0).max(100),
  useDbConfig: z.boolean().optional().default(false),
});

/* ────────────────────────────────────────────────────────────────────
 *  Handler POST
 * ──────────────────────────────────────────────────────────────────── */

// Alias tipe untuk cast agar konsisten & tidak pakai `any`
type FuzzyDbClientParam = Parameters<typeof loadConfigFromDb>[0];

export async function POST(req: NextRequest) {
  try {
    const json = await req.json().catch(() => null);
    if (!json) return fail('Body request bukan JSON yang valid', 400);

    const parsed = calcSchema.safeParse(json);
    if (!parsed.success) return failFromUnknown(parsed.error);

    // FIX TS2345: cast typed Supabase client ke FuzzyDbClient param type
    const config = parsed.data.useDbConfig
      ? await loadConfigFromDb(
          (await createClient()) as unknown as FuzzyDbClientParam,
        )
      : DEFAULT_FUZZY_CONFIG;

    const result: FuzzyCalculationDetail = calculateFuzzy(
      parsed.data.x1,
      parsed.data.x2,
      parsed.data.x3,
      config,
    );

    return ok<FuzzyCalculationDetail>(result);
  } catch (err) {
    return failFromUnknown(err);
  }
}
