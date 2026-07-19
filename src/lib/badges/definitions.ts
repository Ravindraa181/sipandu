/**
 * @file lib/badges/definitions.ts
 * @description Katalog 7 lencana (badge) gamifikasi SiPandu — HANYA untuk aktor Siswa.
 *
 *  Dua kelompok:
 *   - group 'hasil'      → badge 1-6, dihitung dari Z* & transaksi reward.
 *   - group 'partisipasi'→ badge 7, dihitung dari kelengkapan pengisian peer review.
 *
 *  Badge TIDAK disimpan di DB — seluruhnya computed on the fly dari data
 *  yang sudah permanen (behavior_final_scores, behavior_point_transactions,
 *  peer_review_progress). Lihat lib/badges/computeStudentBadges.ts.
 *
 *  Palet warna sengaja memakai token yang sudah ada di tailwind.config.ts
 *  (category-*, status-*, sipandu-*) agar tidak menabrak desain existing.
 */

/** Identitas kanonik setiap badge. */
export type BadgeId =
  | 'kehadiran_sempurna'
  | 'prestasi'
  | 'kolaborator_aktif'
  | 'bintang_perilaku'
  | 'peningkatan_konsisten'
  | 'teladan'
  | 'penilai_aktif';

/** Kelompok badge — menentukan penanda visual & lokasi tampil. */
export type BadgeGroup = 'hasil' | 'partisipasi';

/** Tingkat kesulitan meraih badge. */
export type BadgeTier = 'mudah' | 'sedang' | 'sulit';

/** Kunci ikon lucide-react; dipetakan ke komponen di AchievementBadge.tsx. */
export type BadgeIconKey =
  | 'calendar-check'
  | 'trophy'
  | 'handshake'
  | 'star'
  | 'trending-up'
  | 'crown'
  | 'clipboard-check';

export interface BadgeDefinition {
  id: BadgeId;
  /** Nama tampil ke siswa. */
  name: string;
  /** Kalimat singkat: bagaimana badge ini diraih. */
  requirement: string;
  tier: BadgeTier;
  group: BadgeGroup;
  iconKey: BadgeIconKey;
  /** Class Tailwind untuk lingkaran/kotak ikon (bg + warna ikon). */
  iconClass: string;
  /** Class Tailwind untuk chip/kartu badge (bg + border + teks). */
  chipClass: string;
}

/** Label tingkat untuk tooltip/keterangan. */
export const BADGE_TIER_LABEL: Readonly<Record<BadgeTier, string>> = {
  mudah: 'Mudah',
  sedang: 'Sedang',
  sulit: 'Sulit',
} as const;

/**
 * Nama kategori reward (kolom `reward_categories.name`) yang memicu
 * badge "Kehadiran Sempurna". Dicocokkan case-insensitive.
 */
export const BADGE_ATTENDANCE_REWARD_NAME = 'Tanpa alpa sebulan penuh';

/**
 * Label dimensi Profil Lulusan (kolom `reward_categories.category_label`,
 * Permendikdasmen No. 10 Tahun 2025) yang memicu badge tertentu.
 */
export const BADGE_ACHIEVEMENT_LABEL = 'Penalaran Kritis dan Kreativitas';
export const BADGE_COLLABORATION_LABEL = 'Kolaborasi';

/** Ambang Z* kategori "Sangat Baik" (selaras CATEGORY_CONFIG.sangat_baik). */
export const BADGE_EXCELLENT_MIN_Z = 85;

/**
 * Katalog lengkap, diurut sesuai urutan tampil (kelompok hasil dulu,
 * lalu badge partisipasi di akhir).
 */
export const BADGE_DEFINITIONS: readonly BadgeDefinition[] = [
  {
    id: 'kehadiran_sempurna',
    name: 'Kehadiran Sempurna',
    requirement: 'Tercatat tanpa alpa selama satu bulan penuh.',
    tier: 'mudah',
    group: 'hasil',
    iconKey: 'calendar-check',
    iconClass: 'bg-category-baik-soft text-category-baik',
    chipClass: 'border-category-baik-border bg-category-baik-soft/60 text-category-baik-text',
  },
  {
    id: 'prestasi',
    name: 'Prestasi',
    requirement:
      'Meraih prestasi lomba atau menulis karya (dimensi Penalaran Kritis dan Kreativitas).',
    tier: 'mudah',
    group: 'hasil',
    iconKey: 'trophy',
    iconClass: 'bg-category-cukup-soft text-category-cukup',
    chipClass: 'border-category-cukup-border bg-category-cukup-soft/60 text-category-cukup-text',
  },
  {
    id: 'kolaborator_aktif',
    name: 'Kolaborator Aktif',
    requirement:
      'Aktif membantu guru, OSIS, atau menjadi panitia kegiatan (dimensi Kolaborasi).',
    tier: 'sedang',
    group: 'hasil',
    iconKey: 'handshake',
    iconClass: 'bg-tile-x2 text-[#6D28D9]',
    chipClass: 'border-[#DDD6FE] bg-tile-x2/60 text-[#6D28D9]',
  },
  {
    id: 'bintang_perilaku',
    name: 'Bintang Perilaku',
    requirement: `Skor akhir Z* mencapai kategori Sangat Baik (≥ ${BADGE_EXCELLENT_MIN_Z}).`,
    tier: 'sedang',
    group: 'hasil',
    iconKey: 'star',
    iconClass: 'bg-category-sangat-baik-soft text-category-sangat-baik',
    chipClass:
      'border-category-sangat-baik-border bg-category-sangat-baik-soft/60 text-category-sangat-baik-text',
  },
  {
    id: 'peningkatan_konsisten',
    name: 'Peningkatan Konsisten',
    requirement: 'Skor Z* naik dua periode berturut-turut.',
    tier: 'sedang',
    group: 'hasil',
    iconKey: 'trending-up',
    iconClass: 'bg-tile-x1 text-sipandu-blue',
    chipClass: 'border-sipandu-blue/30 bg-tile-x1/60 text-sipandu-blue-deep',
  },
  {
    id: 'teladan',
    name: 'Teladan',
    requirement: 'Kategori Sangat Baik pada tiga periode berturut-turut.',
    tier: 'sulit',
    group: 'hasil',
    iconKey: 'crown',
    iconClass: 'bg-category-sangat-baik-soft text-category-sangat-baik-text',
    chipClass:
      'border-category-sangat-baik-border bg-category-sangat-baik-soft text-category-sangat-baik-text',
  },
  {
    id: 'penilai_aktif',
    name: 'Penilai Aktif',
    requirement:
      'Menyelesaikan seluruh penilaian teman yang ditugaskan sebelum sesi ditutup.',
    tier: 'mudah',
    group: 'partisipasi',
    iconKey: 'clipboard-check',
    iconClass: 'bg-amber-100 text-amber-600',
    chipClass: 'border-amber-300 bg-amber-50 text-amber-700',
  },
] as const;

/** Lookup cepat id → definisi. */
export const BADGE_BY_ID: Readonly<Record<BadgeId, BadgeDefinition>> =
  Object.fromEntries(BADGE_DEFINITIONS.map((b) => [b.id, b])) as Record<
    BadgeId,
    BadgeDefinition
  >;

/** Badge kelompok "hasil" saja (badge 1-6) — dipakai di halaman Riwayat. */
export const BADGE_RESULT_IDS: readonly BadgeId[] = BADGE_DEFINITIONS.filter(
  (b) => b.group === 'hasil',
).map((b) => b.id);

/** Urutkan sekumpulan id badge sesuai urutan katalog. */
export function sortBadgeIds(ids: readonly BadgeId[]): BadgeId[] {
  const order = new Map(BADGE_DEFINITIONS.map((b, i) => [b.id, i]));
  return [...ids].sort((a, b) => (order.get(a) ?? 0) - (order.get(b) ?? 0));
}
