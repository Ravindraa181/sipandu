/**
 * @file types.ts
 * @description Tipe data untuk fuzzy engine SiPandu (Mamdani method).
 *
 * Semua interface dan type alias untuk:
 *  - Fungsi keanggotaan (Trapesium / Segitiga)
 *  - Variabel fuzzy & himpunan
 *  - Aturan IF–THEN
 *  - Hasil perhitungan tiap tahap (fuzzifikasi → defuzzifikasi)
 *  - Konfigurasi yang dapat dimuat dari database
 *
 * Tidak memiliki dependency eksternal. Semua tipe didesain agar siap
 * diserialisasi sebagai JSON sehingga mudah ditampilkan di UI atau
 * di-cache di Redis/edge.
 */

/* ────────────────────────────────────────────────────────────────────
 * 1. Kategori output Z* (predikat akhir perilaku siswa)
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Empat kategori output sistem Reward & Punishment:
 *  - perlu_pembinaan : skor sangat rendah
 *  - cukup           : skor rendah-tengah
 *  - baik            : skor menengah-atas
 *  - sangat_baik     : skor tinggi (teladan)
 */
export const CategoryType = {
  PerluPembinaan: 'perlu_pembinaan',
  Cukup: 'cukup',
  Baik: 'baik',
  SangatBaik: 'sangat_baik',
} as const;

export type CategoryType = (typeof CategoryType)[keyof typeof CategoryType];

/** Nama himpunan input (X1, X2, X3). */
export type InputSetName = 'rendah' | 'sedang' | 'tinggi';

/** Nama himpunan output (Z*). Identik dengan CategoryType. */
export type OutputSetName = CategoryType;

/* ────────────────────────────────────────────────────────────────────
 * 2. Fungsi keanggotaan (Membership Function)
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Tipe kurva fungsi keanggotaan yang didukung:
 *  - 'trapezoid_left'  : kurva trapesium kiri / linear turun  (2 param: a, b)
 *  - 'triangle'        : kurva segitiga                       (3 param: a, b, c)
 *  - 'trapezoid_right' : kurva trapesium kanan / linear naik  (2 param: a, b)
 *
 * Catatan: trapesium 4 parameter penuh tidak digunakan oleh sistem ini
 * sesuai SYSTEM_CONTEXT.md.
 */
export type MembershipFunctionType =
  | 'trapezoid_left'
  | 'triangle'
  | 'trapezoid_right';

/**
 * Definisi sebuah fungsi keanggotaan.
 *
 * `parameters` panjangnya:
 *  - 2 untuk trapezoid_left dan trapezoid_right (urut: a, b)
 *  - 3 untuk triangle (urut: a, b, c)
 */
export interface MembershipFunction {
  type: MembershipFunctionType;
  parameters: readonly number[];
}

/* ────────────────────────────────────────────────────────────────────
 * 3. Variabel & Himpunan Fuzzy
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Sebuah himpunan fuzzy (bagian dari sebuah variabel).
 * Contoh: { name: 'tinggi', membership: { type:'trapezoid_right', parameters:[85,95] } }
 */
export interface FuzzySet {
  /** Label himpunan, contoh: 'rendah' | 'sedang' | 'tinggi' | 'baik' | 'sangat_baik'. */
  name: string;
  /** Fungsi keanggotaan untuk himpunan ini. */
  membership: MembershipFunction;
}

/**
 * Sebuah variabel fuzzy lengkap dengan semua himpunannya.
 * Universe of discourse semua variabel SiPandu adalah [0, 100].
 */
export interface FuzzyVariable {
  /** Nama variabel: 'x1' | 'x2' | 'x3' | 'z'. */
  name: 'x1' | 'x2' | 'x3' | 'z';
  /** Universe of discourse minimum (default 0). */
  min: number;
  /** Universe of discourse maksimum (default 100). */
  max: number;
  /** Daftar himpunan dalam variabel ini. */
  sets: readonly FuzzySet[];
}

/* ────────────────────────────────────────────────────────────────────
 * 4. Aturan IF–THEN
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Satu baris aturan fuzzy IF–THEN.
 *
 * Bentuk: IF X1 is x1Set AND X2 is x2Set AND X3 is x3Set THEN Z is outputSet
 */
export interface FuzzyRule {
  /** Nomor urut 1..27 (sesuai Tabel 4.3 skripsi). */
  ruleNumber: number;
  x1Set: InputSetName;
  x2Set: InputSetName;
  x3Set: InputSetName;
  outputSet: OutputSetName;
}

/* ────────────────────────────────────────────────────────────────────
 * 5. Hasil per tahap perhitungan
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Hasil fuzzifikasi sebuah variabel input (X1 / X2 / X3).
 * Setiap nilai berada pada interval [0, 1].
 *
 * Property memakai nama Inggris (low/medium/high) agar konsisten
 * lintas-bahasa dan mudah di-serialize ke JSON. Untuk presentasi UI
 * gunakan helper di engine.ts.
 */
export interface FuzzificationResult {
  /** μ_rendah(x) ∈ [0,1] */
  low: number;
  /** μ_sedang(x) ∈ [0,1] */
  medium: number;
  /** μ_tinggi(x) ∈ [0,1] */
  high: number;
}

/** Hasil sebuah aturan yang aktif (α > 0). */
export interface ActiveRule {
  rule: FuzzyRule;
  /** Derajat aktivasi α = MIN(μX1, μX2, μX3). Pasti > 0. */
  alpha: number;
}

/**
 * Hasil agregasi MAX per kategori output. Setiap nilai
 * adalah α agregat tertinggi untuk kategori bersangkutan
 * di antara semua aturan yang aktif. Range [0, 1].
 */
export interface AggregationResult {
  perlu_pembinaan: number;
  cukup: number;
  baik: number;
  sangat_baik: number;
}

/**
 * Trace lengkap perhitungan fuzzy untuk satu siswa.
 * Disimpan ke `behavior_final_scores.active_rules` (JSONB) sebagai
 * audit trail dan ditampilkan di halaman Detail Siswa (W5).
 */
export interface FuzzyCalculationDetail {
  /** Input mentah (sudah di-clamp ke [0, 100]). */
  inputs: {
    x1: number;
    x2: number;
    x3: number;
  };
  /** Hasil tahap 1: fuzzifikasi setiap variabel input. */
  fuzzification: {
    x1: FuzzificationResult;
    x2: FuzzificationResult;
    x3: FuzzificationResult;
  };
  /** Tahap 2 & 3: aturan yang menyala (α > 0) setelah operator MIN. */
  activeRules: readonly ActiveRule[];
  /** Tahap 3: agregasi MAX per kategori. */
  aggregation: AggregationResult;
  /** Tahap 4: hasil defuzzifikasi (Centroid Diskrit). */
  zStar: number;
  /** Pemetaan z* → kategori final menggunakan threshold. */
  category: CategoryType;
  /** ISO timestamp saat perhitungan dijalankan. */
  computedAt: string;
}

/* ────────────────────────────────────────────────────────────────────
 * 6. Konfigurasi (loadable dari DB)
 * ──────────────────────────────────────────────────────────────────── */

/** Set himpunan untuk variabel input (3 himpunan). */
export interface InputVariableSets {
  rendah: MembershipFunction;
  sedang: MembershipFunction;
  tinggi: MembershipFunction;
}

/** Set himpunan untuk variabel output (4 himpunan). */
export interface OutputVariableSets {
  perlu_pembinaan: MembershipFunction;
  cukup: MembershipFunction;
  baik: MembershipFunction;
  sangat_baik: MembershipFunction;
}

/**
 * Konfigurasi penuh fuzzy engine. Bisa di-load dari tabel
 * `fuzzy_configurations` & `fuzzy_rules` di Supabase, atau
 * gunakan DEFAULT_FUZZY_CONFIG dari rules.ts untuk fallback.
 */
export interface FuzzyConfig {
  x1: InputVariableSets;
  x2: InputVariableSets;
  x3: InputVariableSets;
  output: OutputVariableSets;
  rules: readonly FuzzyRule[];
}

/* ────────────────────────────────────────────────────────────────────
 * 7. Tipe pendukung untuk loadConfigFromDb
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Bentuk minimum baris dari tabel `fuzzy_configurations` di Supabase.
 * Didefinisikan terpisah agar engine.ts tidak ber-depend pada
 * package @supabase/supabase-js secara langsung.
 */
export interface FuzzyConfigDbRow {
  variable_name: 'x1' | 'x2' | 'x3' | 'z';
  set_name:
    | 'rendah'
    | 'sedang'
    | 'tinggi'
    | 'perlu_pembinaan'
    | 'cukup'
    | 'baik'
    | 'sangat_baik';
  function_type: MembershipFunctionType;
  parameters: number[];
}

/** Bentuk minimum baris dari tabel `fuzzy_rules`. */
export interface FuzzyRuleDbRow {
  rule_number: number;
  x1_set: InputSetName;
  x2_set: InputSetName;
  x3_set: InputSetName;
  output_set: OutputSetName;
}

/**
 * Antarmuka minimum bagi client database (mis. SupabaseClient).
 * Generic agar engine.ts tidak mengimpor library eksternal apa pun.
 */
export interface FuzzyDbClient {
  from(table: string): {
    select(columns: string): Promise<{
      data: unknown[] | null;
      error: { message: string } | null;
    }>;
  };
}
