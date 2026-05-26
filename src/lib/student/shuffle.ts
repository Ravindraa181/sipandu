/**
 * @file lib/student/shuffle.ts
 * @description Deterministic shuffle untuk urutan teman yang akan dinilai
 *              di Peer Review.
 *
 *  Setiap siswa dapat urutan berbeda, tapi konsisten antar refresh
 *  (sesuai Sistem Context §7.2 dan DATABASE_ENTITIES §2.12).
 *
 *  Algoritma:
 *   1. Hash string seed (`sessionId|studentId`) → 32-bit integer
 *   2. Pakai Mulberry32 PRNG (deterministic & cepat)
 *   3. Fisher-Yates shuffle pakai PRNG tersebut
 *
 *  Tidak butuh dependency eksternal.
 */

/** Hash string sederhana (FNV-1a 32-bit). */
function hashString(s: string): number {
  let h = 0x811c9dc5;
  for (let i = 0; i < s.length; i++) {
    h ^= s.charCodeAt(i);
    h = Math.imul(h, 0x01000193);
  }
  // Pastikan unsigned
  return h >>> 0;
}

/** Mulberry32 PRNG — deterministic, cepat, period 2^32. */
function mulberry32(seed: number): () => number {
  let a = seed >>> 0;
  return () => {
    a = (a + 0x6d2b79f5) >>> 0;
    let t = a;
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

/**
 * Shuffle array secara deterministic berdasarkan seed string.
 *
 * @param items     Array yang akan di-shuffle (tidak dimutasi).
 * @param seedKey   String seed; pasangan yang sama → urutan sama.
 * @returns Array baru hasil shuffle.
 *
 * @example
 *   const order = deterministicShuffle(reviewees, `${sessionId}|${myStudentId}`);
 */
export function deterministicShuffle<T>(items: readonly T[], seedKey: string): T[] {
  const arr = [...items];
  if (arr.length <= 1) return arr;

  const seed = hashString(seedKey);
  const rand = mulberry32(seed);

  // Fisher-Yates
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(rand() * (i + 1));
    const tmp = arr[i]!;
    arr[i] = arr[j]!;
    arr[j] = tmp;
  }
  return arr;
}
