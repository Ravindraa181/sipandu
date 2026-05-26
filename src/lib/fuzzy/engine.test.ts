/**
 * @file engine.test.ts
 * @description Test suite mandiri untuk fuzzy engine SiPandu.
 *              Tidak butuh framework eksternal (Vitest/Jest).
 *
 * Cara menjalankan:
 *   npx tsx src/lib/fuzzy/engine.test.ts
 *   atau
 *   node --import tsx src/lib/fuzzy/engine.test.ts
 *
 * Adaptasi ke Vitest: ganti `test(...)` & `expectEq/expectClose` dengan
 * `it(...)` & `expect(...).toBe(...)/toBeCloseTo(...)`.
 */

import {
  calculateFuzzy,
  getCategory,
  getCategoryLabel,
  getCategoryColor,
  defuzzifyCentroid,
} from './engine';
import {
  calculateMembership,
  fuzzifyVariable,
  triangle,
  trapezoidLeft,
  trapezoidRight,
} from './membership';
import {
  DEFAULT_FUZZY_CONFIG,
  DEFAULT_RULES,
  validateRules,
  applyRule,
  aggregateRules,
} from './rules';

/* ────────────────────────────────────────────────────────────────────
 *  Minimal test runner (zero deps)
 * ──────────────────────────────────────────────────────────────────── */

type TestFn = () => void | Promise<void>;
interface TestCase {
  name: string;
  fn: TestFn;
}
const tests: TestCase[] = [];

function test(name: string, fn: TestFn): void {
  tests.push({ name, fn });
}

class AssertionError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'AssertionError';
  }
}

function expectEq<T>(actual: T, expected: T, label = ''): void {
  if (actual !== expected) {
    throw new AssertionError(
      `${label}\n  expected: ${String(expected)}\n  actual:   ${String(actual)}`,
    );
  }
}

function expectClose(
  actual: number,
  expected: number,
  tolerance: number,
  label = '',
): void {
  if (!Number.isFinite(actual)) {
    throw new AssertionError(`${label}\n  actual not finite: ${actual}`);
  }
  if (Math.abs(actual - expected) > tolerance) {
    throw new AssertionError(
      `${label}\n  expected: ${expected} ± ${tolerance}\n  actual:   ${actual}`,
    );
  }
}

function expectTruthy(value: unknown, label = ''): void {
  if (!value) throw new AssertionError(`${label}\n  expected truthy, got ${String(value)}`);
}

/* ════════════════════════════════════════════════════════════════════
 *  TEST SUITE 1 — Membership Functions (matematis murni)
 * ════════════════════════════════════════════════════════════════════ */

test('trapezoidLeft: di kiri puncak → 1', () => {
  expectClose(trapezoidLeft(50, 60, 75), 1, 1e-9, 'x=50 ≤ a=60');
  expectClose(trapezoidLeft(60, 60, 75), 1, 1e-9, 'x=a → 1');
});

test('trapezoidLeft: tengah turun → linear', () => {
  // (75-67.5)/(75-60) = 7.5/15 = 0.5
  expectClose(trapezoidLeft(67.5, 60, 75), 0.5, 1e-9, 'midpoint');
});

test('trapezoidLeft: di kanan puncak → 0', () => {
  expectClose(trapezoidLeft(75, 60, 75), 0, 1e-9, 'x=b → 0');
  expectClose(trapezoidLeft(80, 60, 75), 0, 1e-9, 'x>b → 0');
});

test('triangle: puncak → 1', () => {
  expectClose(triangle(75, 60, 75, 90), 1, 1e-9, 'x=b → 1');
});

test('triangle: di luar [a,c] → 0', () => {
  expectClose(triangle(50, 60, 75, 90), 0, 1e-9, 'x<a');
  expectClose(triangle(95, 60, 75, 90), 0, 1e-9, 'x>c');
});

test('triangle: rising slope', () => {
  // x=67.5: (67.5-60)/(75-60) = 7.5/15 = 0.5
  expectClose(triangle(67.5, 60, 75, 90), 0.5, 1e-9, 'rising midpoint');
});

test('triangle: falling slope', () => {
  // x=82.5: (90-82.5)/(90-75) = 7.5/15 = 0.5
  expectClose(triangle(82.5, 60, 75, 90), 0.5, 1e-9, 'falling midpoint');
});

test('trapezoidRight: di kiri → 0', () => {
  expectClose(trapezoidRight(80, 85, 95), 0, 1e-9, 'x<a');
  expectClose(trapezoidRight(85, 85, 95), 0, 1e-9, 'x=a');
});

test('trapezoidRight: di kanan → 1', () => {
  expectClose(trapezoidRight(95, 85, 95), 1, 1e-9, 'x=b');
  expectClose(trapezoidRight(100, 85, 95), 1, 1e-9, 'x>b');
});

test('trapezoidRight: rising linear', () => {
  // x=90: (90-85)/(95-85) = 5/10 = 0.5
  expectClose(trapezoidRight(90, 85, 95), 0.5, 1e-9, 'midpoint');
});

test('calculateMembership: dispatcher pakai parameter benar', () => {
  expectClose(
    calculateMembership(82, { type: 'triangle', parameters: [60, 75, 90] }),
    (90 - 82) / 15,
    1e-9,
    'X1 Sedang @ 82',
  );
});

test('calculateMembership: NaN → 0', () => {
  expectClose(
    calculateMembership(NaN, { type: 'triangle', parameters: [60, 75, 90] }),
    0,
    0,
    'NaN guard',
  );
});

/* ════════════════════════════════════════════════════════════════════
 *  TEST SUITE 2 — Validasi konfigurasi & rules
 * ════════════════════════════════════════════════════════════════════ */

test('DEFAULT_RULES: berjumlah 27 dan unik', () => {
  expectEq(DEFAULT_RULES.length, 27, 'Jumlah rule');
  const errors = validateRules(DEFAULT_RULES);
  expectEq(errors.length, 0, `Ada error: ${errors.join(', ')}`);
});

test('DEFAULT_RULES: distribusi konsekuen 4/6/7/10', () => {
  const counts: Record<string, number> = {
    sangat_baik: 0,
    baik: 0,
    cukup: 0,
    perlu_pembinaan: 0,
  };
  for (const r of DEFAULT_RULES) counts[r.outputSet]++;
  expectEq(counts.sangat_baik, 4, 'SB count');
  expectEq(counts.baik, 6, 'B count');
  expectEq(counts.cukup, 7, 'C count');
  expectEq(counts.perlu_pembinaan, 10, 'PP count');
});

test('DEFAULT_RULES: rule 14 = SSS → cukup', () => {
  const r = DEFAULT_RULES[13];
  expectEq(r?.ruleNumber, 14);
  expectEq(r?.x1Set, 'sedang');
  expectEq(r?.x2Set, 'sedang');
  expectEq(r?.x3Set, 'sedang');
  expectEq(r?.outputSet, 'cukup');
});

/* ════════════════════════════════════════════════════════════════════
 *  TEST SUITE 3 — Kasus Skripsi 4.2.4
 *  Input: X1=82, X2=70, X3=85
 * ════════════════════════════════════════════════════════════════════ */

test('Skripsi case — fuzzifikasi X1=82', () => {
  const f = fuzzifyVariable(82, DEFAULT_FUZZY_CONFIG.x1);
  expectClose(f.low, 0, 1e-9, 'X1 Rendah');
  expectClose(f.medium, 8 / 15, 1e-9, 'X1 Sedang ≈ 0.533');
  expectClose(f.high, 0, 1e-9, 'X1 Tinggi');
});

test('Skripsi case — fuzzifikasi X2=70', () => {
  const f = fuzzifyVariable(70, DEFAULT_FUZZY_CONFIG.x2);
  expectClose(f.low, 0, 1e-9, 'X2 Rendah');
  expectClose(f.medium, 0.5, 1e-9, 'X2 Sedang = 0.50');
  expectClose(f.high, 0.4, 1e-9, 'X2 Tinggi = 0.40');
});

test('Skripsi case — fuzzifikasi X3=85', () => {
  const f = fuzzifyVariable(85, DEFAULT_FUZZY_CONFIG.x3);
  expectClose(f.low, 0, 1e-9, 'X3 Rendah');
  expectClose(f.medium, 1 / 3, 1e-9, 'X3 Sedang ≈ 0.333');
  expectClose(f.high, 1 / 3, 1e-9, 'X3 Tinggi ≈ 0.333');
});

test('Skripsi case — jumlah rule aktif (KOREKSI dari skripsi)', () => {
  /*
   * ⚠ Skripsi 4.2.4 hanya menyebut 2 rule aktif (Rule 13 → Cukup,
   *   Rule 4 → Baik). Itu kekeliruan: secara matematis ada 4 rule
   *   yang menyala karena:
   *     - X1 punya 1 himpunan μ>0 (Sedang)
   *     - X2 punya 2 himpunan μ>0 (Sedang, Tinggi)
   *     - X3 punya 2 himpunan μ>0 (Sedang, Tinggi)
   *   Total kombinasi = 1 × 2 × 2 = 4.
   *
   * Rule yang menyala (sesuai DEFAULT_RULES Tabel 4.3):
   *   - Rule 14: S, S, S → Cukup        (α = min(0.533, 0.50, 0.333) = 0.333)
   *   - Rule 13: S, S, T → Baik         (α = min(0.533, 0.50, 0.333) = 0.333)
   *   - Rule 11: S, T, S → Baik         (α = min(0.533, 0.40, 0.333) = 0.333)
   *   - Rule 10: S, T, T → Sangat Baik  (α = min(0.533, 0.40, 0.333) = 0.333)
   */
  const detail = calculateFuzzy(82, 70, 85);
  expectEq(detail.activeRules.length, 4, 'Active rule count');
});

test('Skripsi case — α setiap rule aktif = 1/3', () => {
  const detail = calculateFuzzy(82, 70, 85);
  for (const ar of detail.activeRules) {
    expectClose(ar.alpha, 1 / 3, 1e-9, `Rule #${ar.rule.ruleNumber} alpha`);
  }
});

test('Skripsi case — rule numbers yang aktif: 10, 11, 13, 14', () => {
  const detail = calculateFuzzy(82, 70, 85);
  const numbers = detail.activeRules
    .map((r) => r.rule.ruleNumber)
    .sort((a, b) => a - b);
  expectEq(numbers.join(','), '10,11,13,14', 'Rule numbers');
});

test('Skripsi case — agregasi MAX per kategori', () => {
  const detail = calculateFuzzy(82, 70, 85);
  expectClose(detail.aggregation.perlu_pembinaan, 0, 1e-9, 'PP');
  expectClose(detail.aggregation.cukup, 1 / 3, 1e-9, 'C');
  expectClose(detail.aggregation.baik, 1 / 3, 1e-9, 'B');
  expectClose(detail.aggregation.sangat_baik, 1 / 3, 1e-9, 'SB');
});

test('Skripsi case — z* dengan rigorous discrete centroid', () => {
  /*
   * ⚠ Skripsi menyebut z* = 67.5 (kategori "Cukup"), namun nilai itu
   *   diperoleh dengan:
   *     (a) hanya menghitung 2 rule (bukan 4)
   *     (b) memakai centroid sederhana = AVG(titik tengah kategori),
   *         yaitu (55+80)/2 = 67.5
   *
   *   Dengan rigorous discrete centroid (1000 sampel atas seluruh
   *   domain output [0, 100], aggregasi MAX dari 4 kategori clipped
   *   pada α=1/3), z* ≈ 71.2 → kategori "Baik".
   *
   *   Engine kami mengikuti definisi formal Mamdani sesuai
   *   SYSTEM_CONTEXT.md §5 dan permintaan user (defuzzifikasi
   *   centroid diskrit 1000 titik), sehingga test ini meng-assert
   *   nilai engine yang benar secara matematis.
   *
   *   Untuk mereplikasi z*=67.5 secara persis, perlu:
   *     - Mengabaikan 2 rule aktif (rule 11 dan 14), DAN
   *     - Mengganti defuzzifikasi ke "weighted average of centers"
   *   Keduanya tidak dilakukan engine ini.
   */
  const detail = calculateFuzzy(82, 70, 85);
  expectClose(detail.zStar, 71.2, 1.0, 'z* via rigorous centroid');
  expectEq(detail.category, 'baik', 'Kategori (≥70 < 85)');
});

test('Skripsi case — replikasi 67.5 via simplified centroid (informational)', () => {
  /*
   * Demonstrasi: bila hanya 2 rule (Cukup, Baik) dan pakai
   * weighted-average titik tengah:
   *   z* = (55*α_C + 80*α_B) / (α_C + α_B)
   *      = (55*0.333 + 80*0.333) / 0.666
   *      = 67.5
   * Hanya untuk dokumentasi; bukan output engine.
   */
  const alpha = 1 / 3;
  const zStarSimplified =
    (55 * alpha + 80 * alpha) / (alpha + alpha);
  expectClose(zStarSimplified, 67.5, 1e-9, 'simplified centroid');
});

/* ════════════════════════════════════════════════════════════════════
 *  TEST SUITE 4 — Edge cases
 * ════════════════════════════════════════════════════════════════════ */

test('Edge: semua input 100 → kategori sangat_baik', () => {
  const detail = calculateFuzzy(100, 100, 100);
  // X1=100, X2=100, X3=100: hanya himpunan Tinggi yang μ=1
  expectClose(detail.fuzzification.x1.high, 1, 1e-9);
  expectClose(detail.fuzzification.x2.high, 1, 1e-9);
  expectClose(detail.fuzzification.x3.high, 1, 1e-9);
  // Hanya rule 1 (T,T,T → SB) yang aktif
  expectEq(detail.activeRules.length, 1, 'Active rules');
  expectEq(detail.activeRules[0]?.rule.ruleNumber, 1, 'Rule 1 only');
  expectClose(detail.aggregation.sangat_baik, 1, 1e-9, 'α_SB = 1');
  expectEq(detail.category, 'sangat_baik', 'Kategori');
  // z* untuk SB curve [85,95] (linear naik) + [95,100] plateau di α=1
  // Centroid analitik ≈ 94.58 (lihat hand-calc di komentar engine.ts)
  expectClose(detail.zStar, 94.58, 0.5, 'z* tinggi');
});

test('Edge: semua input 0 → kategori perlu_pembinaan', () => {
  const detail = calculateFuzzy(0, 0, 0);
  expectClose(detail.fuzzification.x1.low, 1, 1e-9);
  expectClose(detail.fuzzification.x2.low, 1, 1e-9);
  expectClose(detail.fuzzification.x3.low, 1, 1e-9);
  // Hanya rule 27 (R,R,R → PP) aktif
  expectEq(detail.activeRules.length, 1);
  expectEq(detail.activeRules[0]?.rule.ruleNumber, 27);
  expectClose(detail.aggregation.perlu_pembinaan, 1, 1e-9, 'α_PP = 1');
  expectEq(detail.category, 'perlu_pembinaan');
  // PP curve trapezoid_left [40,50]: plateau 1 di [0,40], turun ke 0 di [50,100]
  // Centroid analitik ≈ 22.6
  expectClose(detail.zStar, 22.6, 0.5, 'z* rendah');
});

test('Edge: X1=75 tepat di puncak Sedang → medium=1, low=0, high=0', () => {
  const f = fuzzifyVariable(75, DEFAULT_FUZZY_CONFIG.x1);
  expectClose(f.low, 0, 1e-9, 'di b dari trapezoid_left → 0');
  expectClose(f.medium, 1, 1e-9, 'di b puncak triangle → 1');
  expectClose(f.high, 0, 1e-9, 'sebelum a trapezoid_right → 0');
});

test('Edge: X1=85 tepat di a Tinggi → medium=1/3, high=0', () => {
  const f = fuzzifyVariable(85, DEFAULT_FUZZY_CONFIG.x1);
  // Triangle [60,75,90] @ 85: (90-85)/(90-75) = 5/15 = 1/3
  expectClose(f.medium, 1 / 3, 1e-9, 'falling slope mid');
  // trapezoid_right [85,95] @ 85: μ = 0 (boundary)
  expectClose(f.high, 0, 1e-9, 'di a → 0');
});

test('Edge: X1=0, X2=100, X3=100', () => {
  // X1: low=1, X2: high=1, X3: high=1
  // Rule 19 (R,T,T → Baik) aktif dengan α = min(1,1,1) = 1
  const detail = calculateFuzzy(0, 100, 100);
  expectClose(detail.fuzzification.x1.low, 1, 1e-9);
  expectClose(detail.fuzzification.x2.high, 1, 1e-9);
  expectClose(detail.fuzzification.x3.high, 1, 1e-9);
  expectEq(detail.activeRules.length, 1, 'Hanya rule 19');
  expectEq(detail.activeRules[0]?.rule.ruleNumber, 19);
  expectEq(detail.activeRules[0]?.rule.outputSet, 'baik');
  expectEq(detail.category, 'baik', 'Kategori baik');
  // Centroid Baik triangle [65,80,90] dengan α=1 ≈ 78.33
  expectClose(detail.zStar, 78.33, 0.5, 'z* baik');
});

test('Edge: input di luar [0,100] di-clamp', () => {
  const above = calculateFuzzy(150, 200, 999);
  const max = calculateFuzzy(100, 100, 100);
  expectClose(above.zStar, max.zStar, 0.01, 'clamp ke 100');

  const below = calculateFuzzy(-50, -1, -999);
  const min = calculateFuzzy(0, 0, 0);
  expectClose(below.zStar, min.zStar, 0.01, 'clamp ke 0');
});

test('Edge: NaN input → di-clamp ke 0 dan tetap menghasilkan output valid', () => {
  const detail = calculateFuzzy(NaN, NaN, NaN);
  expectTruthy(Number.isFinite(detail.zStar), 'z* finite');
  expectEq(detail.category, 'perlu_pembinaan', 'NaN ≡ 0');
});

/* ════════════════════════════════════════════════════════════════════
 *  TEST SUITE 5 — getCategory & helpers
 * ════════════════════════════════════════════════════════════════════ */

test('getCategory: threshold map', () => {
  expectEq(getCategory(0), 'perlu_pembinaan');
  expectEq(getCategory(54.99), 'perlu_pembinaan');
  expectEq(getCategory(55), 'cukup');
  expectEq(getCategory(69.99), 'cukup');
  expectEq(getCategory(70), 'baik');
  expectEq(getCategory(84.99), 'baik');
  expectEq(getCategory(85), 'sangat_baik');
  expectEq(getCategory(100), 'sangat_baik');
});

test('getCategoryLabel: bahasa Indonesia', () => {
  expectEq(getCategoryLabel('perlu_pembinaan'), 'Perlu Pembinaan');
  expectEq(getCategoryLabel('cukup'), 'Cukup');
  expectEq(getCategoryLabel('baik'), 'Baik');
  expectEq(getCategoryLabel('sangat_baik'), 'Sangat Baik');
});

test('getCategoryColor: hex valid 7 char', () => {
  for (const cat of ['perlu_pembinaan', 'cukup', 'baik', 'sangat_baik'] as const) {
    const c = getCategoryColor(cat);
    expectEq(c.length, 7, `${cat} length`);
    expectEq(c[0], '#', `${cat} starts with #`);
  }
});

/* ════════════════════════════════════════════════════════════════════
 *  TEST SUITE 6 — applyRule & aggregateRules unit
 * ════════════════════════════════════════════════════════════════════ */

test('applyRule: α=0 → null', () => {
  const ar = applyRule(
    DEFAULT_RULES[0]!, // Rule 1: TTT → SB
    { low: 1, medium: 0, high: 0 }, // X1 Rendah penuh
    { low: 0, medium: 1, high: 0 }, // X2 Sedang penuh
    { low: 0, medium: 0, high: 1 }, // X3 Tinggi penuh
  );
  expectEq(ar, null, 'Rule TTT tidak menyala karena X1 Rendah');
});

test('aggregateRules: MAX antar α dengan kategori sama', () => {
  // 3 rule baik dengan α berbeda → MAX
  const agg = aggregateRules([
    { rule: { ruleNumber: 11, x1Set: 'sedang', x2Set: 'tinggi', x3Set: 'sedang', outputSet: 'baik' }, alpha: 0.4 },
    { rule: { ruleNumber: 13, x1Set: 'sedang', x2Set: 'sedang', x3Set: 'tinggi', outputSet: 'baik' }, alpha: 0.6 },
    { rule: { ruleNumber: 19, x1Set: 'rendah', x2Set: 'tinggi', x3Set: 'tinggi', outputSet: 'baik' }, alpha: 0.2 },
  ]);
  expectClose(agg.baik, 0.6, 1e-9, 'MAX dari 0.4, 0.6, 0.2');
  expectClose(agg.cukup, 0, 1e-9, 'C kosong');
});

/* ════════════════════════════════════════════════════════════════════
 *  TEST SUITE 7 — defuzzifyCentroid edge cases
 * ════════════════════════════════════════════════════════════════════ */

test('defuzzifyCentroid: agregasi nol → 0 (sentinel)', () => {
  const z = defuzzifyCentroid(
    { perlu_pembinaan: 0, cukup: 0, baik: 0, sangat_baik: 0 },
    DEFAULT_FUZZY_CONFIG,
  );
  expectEq(z, 0, 'denominator nol');
});

test('defuzzifyCentroid: PP-only → centroid kurva PP', () => {
  // α_PP = 1 → centroid PP curve (trapezoid_left [40,50] di domain [0,100])
  const z = defuzzifyCentroid(
    { perlu_pembinaan: 1, cukup: 0, baik: 0, sangat_baik: 0 },
    DEFAULT_FUZZY_CONFIG,
  );
  expectClose(z, 22.6, 0.5, 'PP centroid');
});

/* ════════════════════════════════════════════════════════════════════
 *  TEST SUITE 8 — Snapshot detail (smoke)
 * ════════════════════════════════════════════════════════════════════ */

test('calculateFuzzy: detail.computedAt valid ISO', () => {
  const d = calculateFuzzy(80, 80, 80);
  expectTruthy(
    !Number.isNaN(Date.parse(d.computedAt)),
    'computedAt parseable',
  );
});

test('calculateFuzzy: inputs di-snapshot setelah clamp', () => {
  const d = calculateFuzzy(150, -10, 50);
  expectEq(d.inputs.x1, 100, 'clamped 150 → 100');
  expectEq(d.inputs.x2, 0, 'clamped -10 → 0');
  expectEq(d.inputs.x3, 50, '50 unchanged');
});

/* ════════════════════════════════════════════════════════════════════
 *  RUNNER
 * ════════════════════════════════════════════════════════════════════ */

async function run(): Promise<void> {
  const startMs = Date.now();
  let passed = 0;
  let failed = 0;
  const failures: { name: string; error: string }[] = [];

  console.log(`\n  Running ${tests.length} tests…\n`);

  for (const t of tests) {
    try {
      await t.fn();
      console.log(`  ✓ ${t.name}`);
      passed++;
    } catch (err) {
      console.error(`  ✗ ${t.name}`);
      const msg = err instanceof Error ? err.message : String(err);
      console.error(
        msg
          .split('\n')
          .map((line) => `      ${line}`)
          .join('\n'),
      );
      failed++;
      failures.push({ name: t.name, error: msg });
    }
  }

  const elapsed = Date.now() - startMs;
  console.log(
    `\n  ${passed} passed, ${failed} failed (${elapsed}ms)\n`,
  );

  if (failed > 0 && typeof process !== 'undefined') {
    process.exit(1);
  }
}

// Auto-run bila dieksekusi langsung (bukan diimport)
// Cek environment Node-like
if (typeof process !== 'undefined' && process.argv) {
  void run();
}

export { run, tests };
