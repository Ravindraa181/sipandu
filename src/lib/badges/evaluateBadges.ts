/**
 * @file lib/badges/evaluateBadges.ts
 * @description Logika murni evaluasi 7 syarat badge (tanpa I/O).
 *
 *  Dipisah dari computeStudentBadges.ts (yang mengurus query Supabase)
 *  agar aturan badge mudah dibaca, di-review, dan diuji tanpa database.
 */

import type { CategoryType } from '@/types';
import {
  BADGE_ACHIEVEMENT_LABEL,
  BADGE_ATTENDANCE_REWARD_NAME,
  BADGE_COLLABORATION_LABEL,
  BADGE_EXCELLENT_MIN_Z,
  sortBadgeIds,
  type BadgeId,
} from './definitions';

/** Badge yang diraih siswa pada satu periode akademik. */
export interface PeriodBadges {
  periodId: string;
  periodLabel: string;
  /** ISO date; dipakai untuk mengurutkan periode. */
  startDate: string;
  /** Id badge yang diraih, sudah terurut sesuai katalog. */
  earned: BadgeId[];
}

/** Data satu periode yang sudah dinormalisasi, siap dievaluasi. */
export interface PeriodBadgeInput {
  periodId: string;
  periodLabel: string;
  /** ISO date; input HARUS sudah terurut kronologis menaik. */
  startDate: string;
  zStar: number | null;
  category: CategoryType | null;
  /** Nama kategori reward (lowercase) yang diterima pada periode ini. */
  rewardNames: string[];
  /** Label dimensi reward (lowercase) yang diterima pada periode ini. */
  rewardLabels: string[];
  peerReviewCompleted: number;
  peerReviewTotal: number;
}

/**
 * Evaluasi ketujuh syarat badge atas daftar periode kronologis.
 *
 * Aman untuk siswa dengan < 3 periode: badge yang butuh data historis
 * panjang (Peningkatan Konsisten, Teladan) hanya dievaluasi mulai indeks
 * ke-3, sehingga otomatis tidak muncul tanpa menyebabkan error.
 */
export function evaluateBadges(
  periods: readonly PeriodBadgeInput[],
): PeriodBadges[] {
  const isExcellent = (idx: number): boolean => {
    const p = periods[idx];
    if (!p) return false;
    if (p.category) return p.category === 'sangat_baik';
    return p.zStar !== null && p.zStar >= BADGE_EXCELLENT_MIN_Z;
  };

  const zAt = (idx: number): number | null => periods[idx]?.zStar ?? null;

  return periods.map((p, i) => {
    const earned: BadgeId[] = [];

    // ── Kelompok 1: badge hasil perilaku ──────────────────────────
    if (p.rewardNames.includes(BADGE_ATTENDANCE_REWARD_NAME.toLowerCase())) {
      earned.push('kehadiran_sempurna');
    }
    if (p.rewardLabels.includes(BADGE_ACHIEVEMENT_LABEL.toLowerCase())) {
      earned.push('prestasi');
    }
    if (p.rewardLabels.includes(BADGE_COLLABORATION_LABEL.toLowerCase())) {
      earned.push('kolaborator_aktif');
    }

    if (isExcellent(i)) earned.push('bintang_perilaku');

    // Butuh minimal 3 periode historis — otomatis dilewati bila kurang.
    if (i >= 2) {
      const z0 = zAt(i - 2);
      const z1 = zAt(i - 1);
      const z2 = zAt(i);
      if (z0 !== null && z1 !== null && z2 !== null && z2 > z1 && z1 > z0) {
        earned.push('peningkatan_konsisten');
      }
      if (isExcellent(i) && isExcellent(i - 1) && isExcellent(i - 2)) {
        earned.push('teladan');
      }
    }

    // ── Kelompok 2: badge partisipasi ─────────────────────────────
    // Hanya bila SELURUH penilaian yang ditugaskan sudah disubmit.
    if (p.peerReviewTotal > 0 && p.peerReviewCompleted >= p.peerReviewTotal) {
      earned.push('penilai_aktif');
    }

    return {
      periodId: p.periodId,
      periodLabel: p.periodLabel,
      startDate: p.startDate,
      earned: sortBadgeIds(earned),
    };
  });
}
