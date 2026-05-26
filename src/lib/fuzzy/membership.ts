/**
 * @file membership.ts
 * @description Implementasi matematis fungsi keanggotaan (membership functions)
 *              untuk fuzzy engine SiPandu.
 *
 * Dukungan kurva:
 *   - trapezoid_left  (turun)  : 2 parameter [a, b]
 *   - triangle        (segitiga): 3 parameter [a, b, c]
 *   - trapezoid_right (naik)   : 2 parameter [a, b]
 *
 * Semua fungsi murni (no side effects), zero dependency, deterministik.
 * Output dijamin berada pada interval [0, 1].
 */

import type {
  MembershipFunction,
  FuzzificationResult,
  InputVariableSets,
} from './types';

/* ────────────────────────────────────────────────────────────────────
 * 1. Fungsi atomic per tipe kurva
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Trapesium kiri (linear turun).
 *
 *   μ(x) = 1                if x ≤ a
 *   μ(x) = (b - x) / (b - a) if a < x < b
 *   μ(x) = 0                if x ≥ b
 *
 * @param x  Nilai input crisp
 * @param a  Titik puncak (mulai turun)
 * @param b  Titik akhir (mencapai 0)
 */
export function trapezoidLeft(x: number, a: number, b: number): number {
  if (b <= a) {
    // Konfigurasi cacat: kembalikan step function konservatif.
    return x <= a ? 1 : 0;
  }
  if (x <= a) return 1;
  if (x >= b) return 0;
  return (b - x) / (b - a);
}

/**
 * Segitiga.
 *
 *   μ(x) = 0                if x ≤ a OR x ≥ c
 *   μ(x) = (x - a) / (b - a) if a < x ≤ b
 *   μ(x) = (c - x) / (c - b) if b < x < c
 *
 * @param x  Nilai input crisp
 * @param a  Titik kiri (mulai naik dari 0)
 * @param b  Titik puncak (μ = 1)
 * @param c  Titik kanan (kembali ke 0)
 */
export function triangle(x: number, a: number, b: number, c: number): number {
  if (b <= a || c <= b) {
    // Konfigurasi cacat (titik tidak terurut): kembalikan 0.
    return 0;
  }
  if (x <= a || x >= c) return 0;
  if (x <= b) return (x - a) / (b - a);
  return (c - x) / (c - b);
}

/**
 * Trapesium kanan (linear naik).
 *
 *   μ(x) = 0                if x ≤ a
 *   μ(x) = (x - a) / (b - a) if a < x < b
 *   μ(x) = 1                if x ≥ b
 *
 * @param x  Nilai input crisp
 * @param a  Titik mulai (μ = 0)
 * @param b  Titik puncak (mulai plateau di μ = 1)
 */
export function trapezoidRight(x: number, a: number, b: number): number {
  if (b <= a) {
    return x >= b ? 1 : 0;
  }
  if (x <= a) return 0;
  if (x >= b) return 1;
  return (x - a) / (b - a);
}

/* ────────────────────────────────────────────────────────────────────
 * 2. Dispatcher umum
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Hitung derajat keanggotaan untuk fungsi keanggotaan apa pun.
 * Output di-clamp ke [0, 1] untuk menahan kemungkinan floating-point drift.
 *
 * @throws Error jika `func.parameters` tidak sesuai dengan `func.type`.
 */
export function calculateMembership(
  x: number,
  func: MembershipFunction,
): number {
  // Penjagaan input non-finite (NaN/Infinity)
  if (!Number.isFinite(x)) return 0;

  const p = func.parameters;
  let raw: number;

  switch (func.type) {
    case 'trapezoid_left':
      if (p.length < 2) {
        throw new Error(
          `trapezoid_left butuh 2 parameter, dapat ${p.length}`,
        );
      }
      raw = trapezoidLeft(x, p[0]!, p[1]!);
      break;

    case 'triangle':
      if (p.length < 3) {
        throw new Error(`triangle butuh 3 parameter, dapat ${p.length}`);
      }
      raw = triangle(x, p[0]!, p[1]!, p[2]!);
      break;

    case 'trapezoid_right':
      if (p.length < 2) {
        throw new Error(
          `trapezoid_right butuh 2 parameter, dapat ${p.length}`,
        );
      }
      raw = trapezoidRight(x, p[0]!, p[1]!);
      break;

    default: {
      // Exhaustiveness check
      const _exhaustive: never = func.type;
      throw new Error(`Tipe fungsi keanggotaan tidak dikenal: ${_exhaustive}`);
    }
  }

  // Clamp ke [0, 1] sebagai pengaman terhadap float error.
  if (raw < 0) return 0;
  if (raw > 1) return 1;
  return raw;
}

/* ────────────────────────────────────────────────────────────────────
 * 3. Fuzzifikasi sebuah variabel
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Fuzzifikasi nilai crisp `x` terhadap 3 himpunan input
 * (rendah/sedang/tinggi) dari sebuah variabel.
 *
 * Property output:
 *   - low    = μ_rendah(x)
 *   - medium = μ_sedang(x)
 *   - high   = μ_tinggi(x)
 *
 * @param x     Nilai crisp pada interval [0, 100].
 * @param sets  Konfigurasi himpunan (rendah, sedang, tinggi).
 */
export function fuzzifyVariable(
  x: number,
  sets: InputVariableSets,
): FuzzificationResult {
  return {
    low: calculateMembership(x, sets.rendah),
    medium: calculateMembership(x, sets.sedang),
    high: calculateMembership(x, sets.tinggi),
  };
}

/* ────────────────────────────────────────────────────────────────────
 * 4. Helper: pemetaan label himpunan input → property fuzzifikasi
 * ──────────────────────────────────────────────────────────────────── */

import type { InputSetName } from './types';

/**
 * Ambil derajat keanggotaan dari hasil fuzzifikasi berdasarkan
 * label himpunan ('rendah' | 'sedang' | 'tinggi').
 *
 * Berguna saat mengevaluasi rule yang menyebut himpunan via nama.
 */
export function getMembershipBySetName(
  result: FuzzificationResult,
  setName: InputSetName,
): number {
  switch (setName) {
    case 'rendah':
      return result.low;
    case 'sedang':
      return result.medium;
    case 'tinggi':
      return result.high;
    default: {
      const _exhaustive: never = setName;
      throw new Error(`InputSetName tidak dikenal: ${_exhaustive}`);
    }
  }
}
