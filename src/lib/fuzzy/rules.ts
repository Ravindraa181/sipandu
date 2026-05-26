/**
 * @file rules.ts
 * @description Konfigurasi default fuzzy + 27 aturan IF–THEN sesuai
 *              Tabel 4.3 skripsi, plus helper applyRule & aggregateRules.
 *
 * Sumber data:
 *   - SYSTEM_CONTEXT.md §3 (parameter himpunan)
 *   - SYSTEM_CONTEXT.md §4 (27 rules Mamdani)
 */

import type {
  ActiveRule,
  AggregationResult,
  FuzzificationResult,
  FuzzyConfig,
  FuzzyRule,
  InputSetName,
  OutputSetName,
} from './types';
import { getMembershipBySetName } from './membership';

/* ────────────────────────────────────────────────────────────────────
 * 1. Default parameter himpunan fuzzy
 *
 *   X1 — Kehadiran (%)
 *     Rendah  : trapezoid_left  [60, 75]
 *     Sedang  : triangle        [60, 75, 90]
 *     Tinggi  : trapezoid_right [85, 95]
 *
 *   X2 — Poin Perilaku
 *     Rendah  : trapezoid_left  [40, 60]
 *     Sedang  : triangle        [40, 60, 80]
 *     Tinggi  : trapezoid_right [60, 85]
 *
 *   X3 — Nilai Teman (Peer Review)
 *     Rendah  : trapezoid_left  [50, 70]
 *     Sedang  : triangle        [50, 75, 90]
 *     Tinggi  : trapezoid_right [80, 95]
 *
 *   Z* — Skor Perilaku (output)
 *     Perlu Pembinaan : trapezoid_left  [40, 50]
 *     Cukup           : triangle        [40, 55, 70]
 *     Baik            : triangle        [65, 80, 90]
 *     Sangat Baik     : trapezoid_right [85, 95]
 * ──────────────────────────────────────────────────────────────────── */

/** Default parameter fuzzy lengkap (input + output + rules). */
export const DEFAULT_FUZZY_CONFIG: FuzzyConfig = {
  x1: {
    rendah: { type: 'trapezoid_left', parameters: [60, 75] },
    sedang: { type: 'triangle', parameters: [60, 75, 90] },
    tinggi: { type: 'trapezoid_right', parameters: [85, 95] },
  },
  x2: {
    rendah: { type: 'trapezoid_left', parameters: [40, 60] },
    sedang: { type: 'triangle', parameters: [40, 60, 80] },
    tinggi: { type: 'trapezoid_right', parameters: [60, 85] },
  },
  x3: {
    rendah: { type: 'trapezoid_left', parameters: [50, 70] },
    sedang: { type: 'triangle', parameters: [50, 75, 90] },
    tinggi: { type: 'trapezoid_right', parameters: [80, 95] },
  },
  output: {
    perlu_pembinaan: { type: 'trapezoid_left', parameters: [40, 50] },
    cukup: { type: 'triangle', parameters: [40, 55, 70] },
    baik: { type: 'triangle', parameters: [65, 80, 90] },
    sangat_baik: { type: 'trapezoid_right', parameters: [85, 95] },
  },
  // diisi di bawah setelah DEFAULT_RULES dideklarasikan.
  rules: [],
};

/* ────────────────────────────────────────────────────────────────────
 * 2. 27 Aturan default (Tabel 4.3 skripsi)
 *
 * Distribusi konsekuen: SB=4, B=6, C=7, PP=10
 * ──────────────────────────────────────────────────────────────────── */

/** 27 aturan IF–THEN Mamdani lengkap. Tidak ada dead zone. */
export const DEFAULT_RULES: readonly FuzzyRule[] = [
  // ┌───────── X1 = TINGGI ─────────────────────────────────────────┐
  {
    ruleNumber: 1,
    x1Set: 'tinggi',
    x2Set: 'tinggi',
    x3Set: 'tinggi',
    outputSet: 'sangat_baik',
  },
  {
    ruleNumber: 2,
    x1Set: 'tinggi',
    x2Set: 'tinggi',
    x3Set: 'sedang',
    outputSet: 'sangat_baik',
  },
  {
    ruleNumber: 3,
    x1Set: 'tinggi',
    x2Set: 'tinggi',
    x3Set: 'rendah',
    outputSet: 'baik',
  },
  {
    ruleNumber: 4,
    x1Set: 'tinggi',
    x2Set: 'sedang',
    x3Set: 'tinggi',
    outputSet: 'sangat_baik',
  },
  {
    ruleNumber: 5,
    x1Set: 'tinggi',
    x2Set: 'sedang',
    x3Set: 'sedang',
    outputSet: 'baik',
  },
  {
    ruleNumber: 6,
    x1Set: 'tinggi',
    x2Set: 'sedang',
    x3Set: 'rendah',
    outputSet: 'cukup',
  },
  {
    ruleNumber: 7,
    x1Set: 'tinggi',
    x2Set: 'rendah',
    x3Set: 'tinggi',
    outputSet: 'baik',
  },
  {
    ruleNumber: 8,
    x1Set: 'tinggi',
    x2Set: 'rendah',
    x3Set: 'sedang',
    outputSet: 'cukup',
  },
  {
    ruleNumber: 9,
    x1Set: 'tinggi',
    x2Set: 'rendah',
    x3Set: 'rendah',
    outputSet: 'perlu_pembinaan',
  },

  // ┌───────── X1 = SEDANG ─────────────────────────────────────────┐
  {
    ruleNumber: 10,
    x1Set: 'sedang',
    x2Set: 'tinggi',
    x3Set: 'tinggi',
    outputSet: 'sangat_baik',
  },
  {
    ruleNumber: 11,
    x1Set: 'sedang',
    x2Set: 'tinggi',
    x3Set: 'sedang',
    outputSet: 'baik',
  },
  {
    ruleNumber: 12,
    x1Set: 'sedang',
    x2Set: 'tinggi',
    x3Set: 'rendah',
    outputSet: 'cukup',
  },
  {
    ruleNumber: 13,
    x1Set: 'sedang',
    x2Set: 'sedang',
    x3Set: 'tinggi',
    outputSet: 'baik',
  },
  {
    ruleNumber: 14,
    x1Set: 'sedang',
    x2Set: 'sedang',
    x3Set: 'sedang',
    outputSet: 'cukup',
  },
  {
    ruleNumber: 15,
    x1Set: 'sedang',
    x2Set: 'sedang',
    x3Set: 'rendah',
    outputSet: 'perlu_pembinaan',
  },
  {
    ruleNumber: 16,
    x1Set: 'sedang',
    x2Set: 'rendah',
    x3Set: 'tinggi',
    outputSet: 'cukup',
  },
  {
    ruleNumber: 17,
    x1Set: 'sedang',
    x2Set: 'rendah',
    x3Set: 'sedang',
    outputSet: 'perlu_pembinaan',
  },
  {
    ruleNumber: 18,
    x1Set: 'sedang',
    x2Set: 'rendah',
    x3Set: 'rendah',
    outputSet: 'perlu_pembinaan',
  },

  // ┌───────── X1 = RENDAH ─────────────────────────────────────────┐
  {
    ruleNumber: 19,
    x1Set: 'rendah',
    x2Set: 'tinggi',
    x3Set: 'tinggi',
    outputSet: 'baik',
  },
  {
    ruleNumber: 20,
    x1Set: 'rendah',
    x2Set: 'tinggi',
    x3Set: 'sedang',
    outputSet: 'cukup',
  },
  {
    ruleNumber: 21,
    x1Set: 'rendah',
    x2Set: 'tinggi',
    x3Set: 'rendah',
    outputSet: 'perlu_pembinaan',
  },
  {
    ruleNumber: 22,
    x1Set: 'rendah',
    x2Set: 'sedang',
    x3Set: 'tinggi',
    outputSet: 'cukup',
  },
  {
    ruleNumber: 23,
    x1Set: 'rendah',
    x2Set: 'sedang',
    x3Set: 'sedang',
    outputSet: 'perlu_pembinaan',
  },
  {
    ruleNumber: 24,
    x1Set: 'rendah',
    x2Set: 'sedang',
    x3Set: 'rendah',
    outputSet: 'perlu_pembinaan',
  },
  {
    ruleNumber: 25,
    x1Set: 'rendah',
    x2Set: 'rendah',
    x3Set: 'tinggi',
    outputSet: 'perlu_pembinaan',
  },
  {
    ruleNumber: 26,
    x1Set: 'rendah',
    x2Set: 'rendah',
    x3Set: 'sedang',
    outputSet: 'perlu_pembinaan',
  },
  {
    ruleNumber: 27,
    x1Set: 'rendah',
    x2Set: 'rendah',
    x3Set: 'rendah',
    outputSet: 'perlu_pembinaan',
  },
] as const;

// Lengkapi default config dengan rules
(DEFAULT_FUZZY_CONFIG as { rules: readonly FuzzyRule[] }).rules = DEFAULT_RULES;

/* ────────────────────────────────────────────────────────────────────
 * 3. Validator: pastikan 27 kombinasi unik (no dead zone)
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Validasi sebuah array rules:
 *  - Apakah berjumlah 27?
 *  - Apakah setiap kombinasi (x1Set, x2Set, x3Set) unik?
 *
 * @returns array pesan error; kosong berarti valid.
 */
export function validateRules(rules: readonly FuzzyRule[]): string[] {
  const errors: string[] = [];

  if (rules.length !== 27) {
    errors.push(
      `Diperlukan tepat 27 aturan (3³ kombinasi); ditemukan ${rules.length}.`,
    );
  }

  const seen = new Set<string>();
  for (const r of rules) {
    const key = `${r.x1Set}|${r.x2Set}|${r.x3Set}`;
    if (seen.has(key)) {
      errors.push(`Duplikat kombinasi rule: ${key}`);
    }
    seen.add(key);
  }

  return errors;
}

/* ────────────────────────────────────────────────────────────────────
 * 4. Evaluasi sebuah aturan (operator MIN)
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Terapkan satu aturan terhadap hasil fuzzifikasi 3 variabel input.
 *
 *   α = MIN( μX1[x1Set], μX2[x2Set], μX3[x3Set] )
 *
 * @returns ActiveRule jika α > 0, atau null jika rule tidak menyala.
 */
export function applyRule(
  rule: FuzzyRule,
  x1Fuzzy: FuzzificationResult,
  x2Fuzzy: FuzzificationResult,
  x3Fuzzy: FuzzificationResult,
): ActiveRule | null {
  const m1 = getMembershipBySetName(x1Fuzzy, rule.x1Set);
  const m2 = getMembershipBySetName(x2Fuzzy, rule.x2Set);
  const m3 = getMembershipBySetName(x3Fuzzy, rule.x3Set);

  const alpha = Math.min(m1, m2, m3);
  if (alpha <= 0) return null;

  return { rule, alpha };
}

/* ────────────────────────────────────────────────────────────────────
 * 5. Agregasi MAX per kategori output
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Agregasi α aktif per kategori output dengan operator MAX.
 *
 * Bila beberapa rule menghasilkan kategori sama (mis. dua rule
 * berbeda → "Baik"), α agregat = MAX(α1, α2, ...).
 *
 * @param activeRules  Rules yang sudah lolos applyRule (α > 0).
 */
export function aggregateRules(
  activeRules: readonly ActiveRule[],
): AggregationResult {
  const out: AggregationResult = {
    perlu_pembinaan: 0,
    cukup: 0,
    baik: 0,
    sangat_baik: 0,
  };

  for (const ar of activeRules) {
    const cat: OutputSetName = ar.rule.outputSet;
    if (ar.alpha > out[cat]) {
      out[cat] = ar.alpha;
    }
  }

  return out;
}

/* ────────────────────────────────────────────────────────────────────
 * 6. Helper: enumerasi label himpunan input (untuk testing/UI)
 * ──────────────────────────────────────────────────────────────────── */

/** Daftar lengkap label himpunan input. */
export const INPUT_SET_NAMES: readonly InputSetName[] = [
  'rendah',
  'sedang',
  'tinggi',
] as const;

/** Daftar lengkap label himpunan output (= CategoryType). */
export const OUTPUT_SET_NAMES: readonly OutputSetName[] = [
  'perlu_pembinaan',
  'cukup',
  'baik',
  'sangat_baik',
] as const;
