/**
 * @file engine.ts
 * @description Mesin inferensi Fuzzy Mamdani untuk SiPandu — fungsi utama
 *              `calculateFuzzy` melakukan keempat tahap secara berurutan:
 *              fuzzifikasi → MIN → MAX → defuzzifikasi (Centroid Diskrit).
 *
 *  Algoritma:
 *    1. Clamp input ke [0, 100]
 *    2. Fuzzifikasi X1, X2, X3
 *    3. Evaluasi 27 rule → kumpulkan rule dengan α > 0
 *    4. Agregasi MAX per kategori output (PP, C, B, SB)
 *    5. Defuzzifikasi Centroid Diskrit:
 *         - 1000 titik sampel di domain [0, 100]
 *         - Per titik z: μ_agg(z) = MAX_kategori( MIN(α_kat, μ_kat(z)) )
 *         - z* = Σ(z · μ_agg(z)) / Σμ_agg(z)
 *    6. Petakan z* ke kategori final via threshold
 */

import type {
  AggregationResult,
  CategoryType,
  FuzzyCalculationDetail,
  FuzzyConfig,
  FuzzyConfigDbRow,
  FuzzyDbClient,
  FuzzyRule,
  FuzzyRuleDbRow,
  OutputSetName,
} from './types';
import { calculateMembership, fuzzifyVariable } from './membership';
import {
  DEFAULT_FUZZY_CONFIG,
  DEFAULT_RULES,
  applyRule,
  aggregateRules,
} from './rules';

/* ────────────────────────────────────────────────────────────────────
 * 1. Konstanta defuzzifikasi
 * ──────────────────────────────────────────────────────────────────── */

/** Jumlah titik sampel diskrit untuk defuzzifikasi centroid. */
export const DEFUZZ_SAMPLE_COUNT = 1000 as const;

/** Universe of discourse untuk variabel output. */
export const OUTPUT_DOMAIN_MIN = 0 as const;
export const OUTPUT_DOMAIN_MAX = 100 as const;

/* ────────────────────────────────────────────────────────────────────
 * 2. Helper: clamp
 * ──────────────────────────────────────────────────────────────────── */

/** Clamp angka ke interval [min, max]. NaN/Infinity → min. */
function clamp(value: number, min: number, max: number): number {
  if (!Number.isFinite(value)) return min;
  if (value < min) return min;
  if (value > max) return max;
  return value;
}

/* ────────────────────────────────────────────────────────────────────
 * 3. Defuzzifikasi Centroid Diskrit
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Hitung μ agregat pada satu titik z dengan operator MAX antar kategori.
 * Setiap output set di-clip pada α-nya (Mamdani implication).
 *
 *   μ_agg(z) = MAX_kategori( MIN( α_kat, μ_kat(z) ) )
 */
function aggregateMembershipAt(
  z: number,
  agg: AggregationResult,
  config: FuzzyConfig,
): number {
  // PP (Perlu Pembinaan)
  let mPP = 0;
  if (agg.perlu_pembinaan > 0) {
    const mu = calculateMembership(z, config.output.perlu_pembinaan);
    mPP = Math.min(agg.perlu_pembinaan, mu);
  }
  // C (Cukup)
  let mC = 0;
  if (agg.cukup > 0) {
    const mu = calculateMembership(z, config.output.cukup);
    mC = Math.min(agg.cukup, mu);
  }
  // B (Baik)
  let mB = 0;
  if (agg.baik > 0) {
    const mu = calculateMembership(z, config.output.baik);
    mB = Math.min(agg.baik, mu);
  }
  // SB (Sangat Baik)
  let mSB = 0;
  if (agg.sangat_baik > 0) {
    const mu = calculateMembership(z, config.output.sangat_baik);
    mSB = Math.min(agg.sangat_baik, mu);
  }

  // MAX antar kategori
  let m = mPP;
  if (mC > m) m = mC;
  if (mB > m) m = mB;
  if (mSB > m) m = mSB;
  return m;
}

/**
 * Defuzzifikasi Centroid Diskrit.
 *
 *   z* = Σ(zᵢ · μ_agg(zᵢ)) / Σμ_agg(zᵢ)     untuk i = 0..N-1
 *
 * Bila Σμ = 0 (tidak ada rule aktif), kembalikan 0 sebagai sentinel.
 *
 * @param agg     Hasil agregasi MAX per kategori
 * @param config  Konfigurasi himpunan output
 */
export function defuzzifyCentroid(
  agg: AggregationResult,
  config: FuzzyConfig,
): number {
  const n = DEFUZZ_SAMPLE_COUNT;
  const min = OUTPUT_DOMAIN_MIN;
  const max = OUTPUT_DOMAIN_MAX;
  const step = (max - min) / (n - 1);

  let numerator = 0;
  let denominator = 0;

  for (let i = 0; i < n; i++) {
    const z = min + i * step;
    const mu = aggregateMembershipAt(z, agg, config);
    numerator += z * mu;
    denominator += mu;
  }

  if (denominator <= 0) return 0;
  return numerator / denominator;
}

/* ────────────────────────────────────────────────────────────────────
 * 4. Pemetaan z* → kategori final
 * ──────────────────────────────────────────────────────────────────── */

/** Threshold untuk setiap kategori (lihat SYSTEM_CONTEXT.md §5). */
export const CATEGORY_THRESHOLDS = {
  /** z* ≥ 85 */
  sangat_baik: 85,
  /** 70 ≤ z* < 85 */
  baik: 70,
  /** 55 ≤ z* < 70 */
  cukup: 55,
  /** z* < 55 */
  // perlu_pembinaan: implisit (sisanya)
} as const;

/**
 * Petakan skor crisp z* (0-100) ke kategori final.
 *
 *   z* ≥ 85       → sangat_baik
 *   70 ≤ z* < 85  → baik
 *   55 ≤ z* < 70  → cukup
 *   z* < 55       → perlu_pembinaan
 */
export function getCategory(zScore: number): CategoryType {
  if (zScore >= CATEGORY_THRESHOLDS.sangat_baik) return 'sangat_baik';
  if (zScore >= CATEGORY_THRESHOLDS.baik) return 'baik';
  if (zScore >= CATEGORY_THRESHOLDS.cukup) return 'cukup';
  return 'perlu_pembinaan';
}

/* ────────────────────────────────────────────────────────────────────
 * 5. Label & warna kategori (untuk UI)
 * ──────────────────────────────────────────────────────────────────── */

/** Mapping kategori → label tampil Bahasa Indonesia. */
const CATEGORY_LABELS: Readonly<Record<CategoryType, string>> = {
  perlu_pembinaan: 'Perlu Pembinaan',
  cukup: 'Cukup',
  baik: 'Baik',
  sangat_baik: 'Sangat Baik',
};

/** Mapping kategori → warna hex utama (lihat SYSTEM_CONTEXT.md §8 badge). */
const CATEGORY_COLORS: Readonly<Record<CategoryType, string>> = {
  perlu_pembinaan: '#B91C1C',
  cukup: '#B45309',
  baik: '#1D4ED8',
  sangat_baik: '#15803D',
};

/** Label tampil untuk kategori (Bahasa Indonesia). */
export function getCategoryLabel(category: CategoryType): string {
  return CATEGORY_LABELS[category];
}

/** Warna hex utama (foreground / text) untuk kategori. */
export function getCategoryColor(category: CategoryType): string {
  return CATEGORY_COLORS[category];
}

/* ────────────────────────────────────────────────────────────────────
 * 6. calculateFuzzy — fungsi utama
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Jalankan seluruh pipeline Fuzzy Mamdani untuk satu siswa.
 *
 * @param x1      Kehadiran (%)         — interval [0, 100]
 * @param x2      Poin Perilaku         — interval [0, 100]
 * @param x3      Nilai Teman / Peer    — interval [0, 100]
 * @param config  Opsional. Bila tidak diisi, pakai DEFAULT_FUZZY_CONFIG.
 *
 * @returns Trace lengkap perhitungan, siap disimpan ke
 *          `behavior_final_scores.active_rules` (JSONB) sebagai audit trail.
 */
export function calculateFuzzy(
  x1: number,
  x2: number,
  x3: number,
  config: FuzzyConfig = DEFAULT_FUZZY_CONFIG,
): FuzzyCalculationDetail {
  // Tahap 1: Clamp input ke [0, 100]
  const x1c = clamp(x1, 0, 100);
  const x2c = clamp(x2, 0, 100);
  const x3c = clamp(x3, 0, 100);

  // Tahap 2: Fuzzifikasi
  const f1 = fuzzifyVariable(x1c, config.x1);
  const f2 = fuzzifyVariable(x2c, config.x2);
  const f3 = fuzzifyVariable(x3c, config.x3);

  // Tahap 3: Evaluasi rules dengan operator MIN
  const activeRules = config.rules
    .map((r) => applyRule(r, f1, f2, f3))
    .filter((r): r is NonNullable<typeof r> => r !== null);

  // Tahap 3b: Agregasi MAX per kategori
  const aggregation = aggregateRules(activeRules);

  // Tahap 4: Defuzzifikasi (Centroid Diskrit)
  const zStar = defuzzifyCentroid(aggregation, config);

  // Tahap 5: Pemetaan ke kategori final
  const category = getCategory(zStar);

  return {
    inputs: { x1: x1c, x2: x2c, x3: x3c },
    fuzzification: { x1: f1, x2: f2, x3: f3 },
    activeRules,
    aggregation,
    zStar,
    category,
    computedAt: new Date().toISOString(),
  };
}

/* ────────────────────────────────────────────────────────────────────
 * 7. loadConfigFromDb — muat konfigurasi dari Supabase
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Muat konfigurasi fuzzy dari tabel Supabase
 * (`fuzzy_configurations` & `fuzzy_rules`).
 *
 * Bila salah satu query gagal atau hasilnya tidak lengkap, fallback
 * ke `DEFAULT_FUZZY_CONFIG`. Tidak melempar error — kegagalan dicatat
 * lewat console.warn agar caller bisa terus berjalan.
 *
 * @param client  Supabase client (atau objek apa pun yang memenuhi
 *                kontrak `FuzzyDbClient`).
 */
export async function loadConfigFromDb(
  client: FuzzyDbClient,
): Promise<FuzzyConfig> {
  try {
    // Query paralel untuk dua tabel
    const [cfgRes, ruleRes] = await Promise.all([
      client
        .from('fuzzy_configurations')
        .select('variable_name, set_name, function_type, parameters'),
      client
        .from('fuzzy_rules')
        .select('rule_number, x1_set, x2_set, x3_set, output_set'),
    ]);

    if (cfgRes.error || ruleRes.error) {
      console.warn(
        '[fuzzy] loadConfigFromDb: error → fallback ke DEFAULT_FUZZY_CONFIG',
        cfgRes.error || ruleRes.error,
      );
      return DEFAULT_FUZZY_CONFIG;
    }

    const cfgRows = (cfgRes.data ?? []) as FuzzyConfigDbRow[];
    const ruleRows = (ruleRes.data ?? []) as FuzzyRuleDbRow[];

    if (cfgRows.length === 0 || ruleRows.length === 0) {
      console.warn(
        '[fuzzy] loadConfigFromDb: tabel kosong → fallback ke DEFAULT_FUZZY_CONFIG',
      );
      return DEFAULT_FUZZY_CONFIG;
    }

    // Bangun config dari baris DB. Mulai dari default, lalu override.
    const cfg: FuzzyConfig = {
      x1: { ...DEFAULT_FUZZY_CONFIG.x1 },
      x2: { ...DEFAULT_FUZZY_CONFIG.x2 },
      x3: { ...DEFAULT_FUZZY_CONFIG.x3 },
      output: { ...DEFAULT_FUZZY_CONFIG.output },
      rules: DEFAULT_RULES,
    };

    for (const row of cfgRows) {
      const fn = {
        type: row.function_type,
        parameters: row.parameters,
      };
      if (row.variable_name === 'x1') {
        if (row.set_name === 'rendah') cfg.x1.rendah = fn;
        else if (row.set_name === 'sedang') cfg.x1.sedang = fn;
        else if (row.set_name === 'tinggi') cfg.x1.tinggi = fn;
      } else if (row.variable_name === 'x2') {
        if (row.set_name === 'rendah') cfg.x2.rendah = fn;
        else if (row.set_name === 'sedang') cfg.x2.sedang = fn;
        else if (row.set_name === 'tinggi') cfg.x2.tinggi = fn;
      } else if (row.variable_name === 'x3') {
        if (row.set_name === 'rendah') cfg.x3.rendah = fn;
        else if (row.set_name === 'sedang') cfg.x3.sedang = fn;
        else if (row.set_name === 'tinggi') cfg.x3.tinggi = fn;
      } else if (row.variable_name === 'z') {
        if (row.set_name === 'perlu_pembinaan')
          cfg.output.perlu_pembinaan = fn;
        else if (row.set_name === 'cukup') cfg.output.cukup = fn;
        else if (row.set_name === 'baik') cfg.output.baik = fn;
        else if (row.set_name === 'sangat_baik') cfg.output.sangat_baik = fn;
      }
    }

    // Konversi rule dari snake_case DB ke camelCase domain
    const rules: FuzzyRule[] = ruleRows
      .slice()
      .sort((a, b) => a.rule_number - b.rule_number)
      .map((r) => ({
        ruleNumber: r.rule_number,
        x1Set: r.x1_set,
        x2Set: r.x2_set,
        x3Set: r.x3_set,
        outputSet: r.output_set as OutputSetName,
      }));

    cfg.rules = rules;
    return cfg;
  } catch (err) {
    console.warn(
      '[fuzzy] loadConfigFromDb: exception → fallback ke DEFAULT_FUZZY_CONFIG',
      err,
    );
    return DEFAULT_FUZZY_CONFIG;
  }
}

/* ────────────────────────────────────────────────────────────────────
 * 8. Re-export untuk konsumen
 * ──────────────────────────────────────────────────────────────────── */

export {
  DEFAULT_FUZZY_CONFIG,
  DEFAULT_RULES,
  applyRule,
  aggregateRules,
} from './rules';
export {
  calculateMembership,
  fuzzifyVariable,
  trapezoidLeft,
  triangle,
  trapezoidRight,
} from './membership';
export type {
  CategoryType,
  FuzzyCalculationDetail,
  FuzzyConfig,
  FuzzyRule,
  FuzzificationResult,
  ActiveRule,
  AggregationResult,
  MembershipFunction,
  MembershipFunctionType,
  FuzzyVariable,
  FuzzySet,
} from './types';
