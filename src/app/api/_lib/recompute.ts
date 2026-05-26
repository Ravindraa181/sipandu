/**
 * @file app/api/_lib/recompute.ts
 * @description Helper recompute Z* untuk satu siswa.
 *
 *  FIX TS2345 (line 170):
 *   `loadConfigFromDb` expects `FuzzyDbClient` but gets a fully-typed
 *   `SupabaseClient<Database>`. Fix: cast ke `Parameters<typeof loadConfigFromDb>[0]`.
 *   Pada saat runtime perilakunya identik karena `FuzzyDbClient` adalah
 *   subset dari Supabase client.
 */

import 'server-only';
import {
  calculateFuzzy,
  loadConfigFromDb,
  type FuzzyConfig,
} from '@/lib/fuzzy/engine';
import type { FuzzyCalculationDetail } from '@/lib/fuzzy/types';
import { createClient, createServiceRoleClient } from '@/lib/supabase/server';

/* ────────────────────────────────────────────────────────────────────
 *  Tipe
 * ──────────────────────────────────────────────────────────────────── */

export interface RecomputeInput {
  studentId: string;
  periodId: string;
  config?: FuzzyConfig;
}

export type RecomputeOutput =
  | {
      computed: true;
      enrollmentId: string;
      x1: number;
      x2: number;
      rawX2: number;
      x3: number;
      detail: FuzzyCalculationDetail;
    }
  | {
      computed: false;
      enrollmentId: string | null;
      reason: string;
    };

// Alias tipe untuk cast — konsisten dengan route-route lain
type FuzzyDbClientParam = Parameters<typeof loadConfigFromDb>[0];

/* ────────────────────────────────────────────────────────────────────
 *  Helper utama
 * ──────────────────────────────────────────────────────────────────── */

export async function recomputeStudent(
  input: RecomputeInput,
): Promise<RecomputeOutput> {
  const supabase = await createClient();
  const admin = await createServiceRoleClient();

  // ── 1. Resolve enrollment ───────────────────────────────────────
  const { data: enroll, error: enErr } = await admin
    .from('student_class_enrollments')
    .select(
      `id,
       class_period_assignment_id,
       class_period_assignments!inner (period_id)`,
    )
    .eq('student_id', input.studentId)
    .eq('class_period_assignments.period_id', input.periodId)
    .eq('status', 'active')
    .maybeSingle();

  if (enErr || !enroll) {
    return {
      computed: false,
      enrollmentId: null,
      reason: 'Enrollment tidak ditemukan untuk siswa+periode',
    };
  }

  const enrollmentId = enroll.id as string;
  const assignmentId = enroll.class_period_assignment_id as string;

  // ── 2. X1 dari attendance bulanan (hanya bulan locked) ──────────
  const { data: months } = await admin
    .from('monthly_attendance')
    .select('present_days, effective_days, is_locked')
    .eq('enrollment_id', enrollmentId)
    .eq('is_locked', true);

  if (!months || months.length === 0) {
    return {
      computed: false,
      enrollmentId,
      reason: 'Belum ada bulan kehadiran yang dikunci',
    };
  }

  let totalPresent = 0;
  let totalEffective = 0;
  for (const m of months as Array<{
    present_days: number;
    effective_days: number;
  }>) {
    totalPresent += m.present_days;
    totalEffective += m.effective_days;
  }
  if (totalEffective <= 0) {
    return { computed: false, enrollmentId, reason: 'Total hari efektif = 0' };
  }
  const x1 = (totalPresent / totalEffective) * 100;

  // ── 3. X2 dari running score ───────────────────────────────────
  const { data: scoreRow } = await admin
    .from('student_behavior_scores')
    .select('raw_score')
    .eq('enrollment_id', enrollmentId)
    .maybeSingle();

  if (!scoreRow) {
    return {
      computed: false,
      enrollmentId,
      reason: 'Skor perilaku (X2) belum tersedia',
    };
  }
  const rawX2 = (scoreRow.raw_score as number) ?? 0;
  const x2 = Math.min(rawX2, 100);

  // ── 4. X3 dari peer review ─────────────────────────────────────
  const { data: x3Row } = await admin
    .from('student_x3_scores')
    .select(
      `x3_score, computed_at,
       peer_review_sessions!inner (class_period_assignment_id)`,
    )
    .eq('student_id', input.studentId)
    .eq('peer_review_sessions.class_period_assignment_id', assignmentId)
    .order('computed_at', { ascending: false, nullsFirst: false })
    .limit(1)
    .maybeSingle();

  if (!x3Row || x3Row.x3_score === null || x3Row.x3_score === undefined) {
    return {
      computed: false,
      enrollmentId,
      reason: 'Nilai peer review (X3) belum dihitung / sesi belum ditutup',
    };
  }
  const x3 = Number(x3Row.x3_score);

  // ── 5. Fuzzy calculation ───────────────────────────────────────
  // FIX TS2345: cast supabase ke FuzzyDbClientParam
  const config =
    input.config ??
    (await loadConfigFromDb(supabase as unknown as FuzzyDbClientParam));

  const detail = calculateFuzzy(x1, x2, x3, config);

  // ── 6. Upsert ke behavior_final_scores ─────────────────────────
  const { error: upErr } = await admin.from('behavior_final_scores').upsert(
    {
      enrollment_id: enrollmentId,
      x1,
      x2,
      raw_x2: rawX2,
      x3,
      z_star: detail.zStar,
      category: detail.category,
      alpha_pp: detail.aggregation.perlu_pembinaan,
      alpha_c: detail.aggregation.cukup,
      alpha_b: detail.aggregation.baik,
      alpha_sb: detail.aggregation.sangat_baik,
      active_rules: detail.activeRules.map((ar) => ({
        rule_no: ar.rule.ruleNumber,
        alpha: ar.alpha,
        output: ar.rule.outputSet,
      })),
      computed_at: detail.computedAt,
    },
    { onConflict: 'enrollment_id' },
  );

  if (upErr) {
    return {
      computed: false,
      enrollmentId,
      reason: `Gagal menyimpan skor akhir: ${upErr.message}`,
    };
  }

  return { computed: true, enrollmentId, x1, x2, rawX2, x3, detail };
}
