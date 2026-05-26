/**
 * @file lib/utils/format.ts
 * @description Helper format umum: tanggal Indonesia, persentase, skor,
 *              dan helper kategori (label, warna, interpretasi).
 *
 * Tidak butuh dependency eksternal — `formatDate` pakai `Intl.DateTimeFormat`
 * built-in browser/Node. Bila ingin lebih kaya (relative time, dll), tinggal
 * tambah `date-fns` (sudah ada di package-additions.md).
 */

import type { CategoryType } from '@/types';

/* ────────────────────────────────────────────────────────────────────
 *  Tanggal
 * ──────────────────────────────────────────────────────────────────── */

/** Locale konstan agar Intl konsisten di server & client. */
const ID_LOCALE = 'id-ID';

const dateFormatter = new Intl.DateTimeFormat(ID_LOCALE, {
  day: '2-digit',
  month: 'long',
  year: 'numeric',
});

const dateWithDayFormatter = new Intl.DateTimeFormat(ID_LOCALE, {
  weekday: 'long',
  day: 'numeric',
  month: 'long',
  year: 'numeric',
});

/**
 * Format tanggal Indonesia: "12 Agustus 2024".
 *
 * @param date  Date object, ISO string, atau timestamp ms.
 * @returns String tanggal, atau '—' bila input invalid.
 */
export function formatDate(date: Date | string | number | null | undefined): string {
  if (date === null || date === undefined) return '—';
  const d = date instanceof Date ? date : new Date(date);
  if (Number.isNaN(d.getTime())) return '—';
  return dateFormatter.format(d);
}

/**
 * Format tanggal lengkap dengan hari: "Senin, 12 Agustus 2024".
 */
export function formatDateWithDay(
  date: Date | string | number | null | undefined,
): string {
  if (date === null || date === undefined) return '—';
  const d = date instanceof Date ? date : new Date(date);
  if (Number.isNaN(d.getTime())) return '—';
  return dateWithDayFormatter.format(d);
}

/* ────────────────────────────────────────────────────────────────────
 *  Angka
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Format persentase dengan 1 desimal: 87.5 → "87.5%".
 *
 * @returns "—" bila value null/undefined/NaN.
 */
export function formatPercent(
  value: number | null | undefined,
  fractionDigits = 1,
): string {
  if (value === null || value === undefined || Number.isNaN(value)) return '—';
  return `${value.toFixed(fractionDigits)}%`;
}

/**
 * Format skor 0-100 dengan 1 desimal: 88.245 → "88.2".
 *
 * @returns "—" bila value null/undefined/NaN.
 */
export function formatScore(
  value: number | null | undefined,
  fractionDigits = 1,
): string {
  if (value === null || value === undefined || Number.isNaN(value)) return '—';
  return value.toFixed(fractionDigits);
}

/**
 * Format raw integer dengan separator ribuan Indonesia: 1234 → "1.234".
 */
export function formatInt(value: number | null | undefined): string {
  if (value === null || value === undefined || Number.isNaN(value)) return '—';
  return new Intl.NumberFormat(ID_LOCALE).format(Math.round(value));
}

/* ────────────────────────────────────────────────────────────────────
 *  Kategori Z*
 * ──────────────────────────────────────────────────────────────────── */

const CATEGORY_LABEL_MAP: Readonly<Record<CategoryType, string>> = {
  perlu_pembinaan: 'Perlu Pembinaan',
  cukup: 'Cukup',
  baik: 'Baik',
  sangat_baik: 'Sangat Baik',
};

const CATEGORY_COLOR_MAP: Readonly<Record<CategoryType, string>> = {
  perlu_pembinaan: '#DC2626',
  cukup: '#D97706',
  baik: '#2563EB',
  sangat_baik: '#16A34A',
};

/** Label tampil bahasa Indonesia untuk kategori. */
export function getCategoryLabel(category: CategoryType | null | undefined): string {
  if (!category) return 'Belum Dinilai';
  return CATEGORY_LABEL_MAP[category];
}

/** Warna hex utama untuk kategori (foreground / accent). */
export function getCategoryColor(category: CategoryType | null | undefined): string {
  if (!category) return '#9CA3AF';
  return CATEGORY_COLOR_MAP[category];
}

/* ────────────────────────────────────────────────────────────────────
 *  Interpretasi naratif
 * ──────────────────────────────────────────────────────────────────── */

/**
 * Skor X1, X2, X3 untuk membantu menentukan teks interpretasi.
 * Semua optional — fungsi tetap menghasilkan teks generik bila salah satu null.
 */
export interface InterpretationScores {
  x1?: number | null;
  x2?: number | null;
  x3?: number | null;
}

/**
 * Hasilkan kalimat interpretasi naratif untuk ditampilkan di Detail Siswa
 * (W5) atau Dashboard Siswa (S1). Kalimat dipilih berdasarkan kategori
 * dan komponen mana (X1/X2/X3) yang paling rendah/tinggi.
 *
 * Tujuan: memberi konteks edukatif, bukan menghakimi.
 */
export function getInterpretationText(
  category: CategoryType | null | undefined,
  scores: InterpretationScores = {},
): string {
  if (!category) {
    return 'Skor perilaku belum dapat dihitung. Pastikan data kehadiran, poin perilaku, dan peer review sudah lengkap.';
  }

  const { x1, x2, x3 } = scores;
  const lowest = pickLowest({ x1, x2, x3 });

  switch (category) {
    case 'sangat_baik':
      return 'Anda menjadi teladan dalam disiplin, perilaku, dan hubungan sosial. Pertahankan dan terus tingkatkan!';

    case 'baik': {
      if (lowest === 'x1') {
        return 'Perilaku dan hubungan sosial Anda sudah baik. Terus tingkatkan kedisiplinan kehadiran agar mencapai potensi terbaik.';
      }
      if (lowest === 'x2') {
        return 'Kehadiran dan hubungan sosial Anda sudah baik. Hindari pelanggaran kecil agar skor poin perilaku stabil.';
      }
      if (lowest === 'x3') {
        return 'Tingkat kedisiplinan dan poin perilaku sudah baik. Coba perkuat interaksi positif dengan teman sekelas.';
      }
      return 'Perilaku Anda dinilai baik secara keseluruhan. Pertahankan!';
    }

    case 'cukup': {
      if (lowest === 'x1') {
        return 'Tingkat kehadiran perlu ditingkatkan. Disiplin kehadiran akan membantu Anda meraih kategori yang lebih tinggi.';
      }
      if (lowest === 'x2') {
        return 'Beberapa pelanggaran tercatat. Fokus pada kepatuhan tata tertib akan banyak membantu.';
      }
      if (lowest === 'x3') {
        return 'Penilaian dari teman menunjukkan ada area yang perlu diperbaiki dalam interaksi sosial. Coba lebih aktif berkolaborasi dan menunjukkan empati.';
      }
      return 'Perilaku Anda di kategori cukup. Identifikasi satu area yang ingin diperbaiki dan fokus di sana.';
    }

    case 'perlu_pembinaan':
      return 'Sistem mendeteksi beberapa area yang perlu perhatian. Diskusikan bersama wali kelas untuk merancang langkah perbaikan yang sesuai dengan situasi Anda.';

    default:
      return 'Skor perilaku Anda telah dihitung.';
  }
}

/* ────────────────────────────────────────────────────────────────────
 *  Internal helpers
 * ──────────────────────────────────────────────────────────────────── */

type ScoreKey = 'x1' | 'x2' | 'x3';

/**
 * Tentukan skor terendah dari trio X1/X2/X3.
 * Mengabaikan nilai yang null/undefined.
 */
function pickLowest(scores: InterpretationScores): ScoreKey | null {
  const entries = (Object.entries(scores) as [ScoreKey, number | null | undefined][])
    .filter((e): e is [ScoreKey, number] => typeof e[1] === 'number');

  if (entries.length === 0) return null;

  return entries.reduce<[ScoreKey, number]>((acc, cur) => (cur[1] < acc[1] ? cur : acc), entries[0]!)[0];
}

/* ────────────────────────────────────────────────────────────────────
 *  Truncate / inisial
 * ──────────────────────────────────────────────────────────────────── */

/** Ambil inisial 1-2 karakter dari nama (untuk avatar). */
export function getInitials(name: string | null | undefined): string {
  if (!name) return '?';
  const parts = name.trim().split(/\s+/).slice(0, 2);
  return parts.map((p) => p.charAt(0).toUpperCase()).join('');
}

/** Potong string panjang dengan ellipsis. */
export function truncate(text: string, maxLength: number): string {
  if (text.length <= maxLength) return text;
  return text.slice(0, maxLength - 1).trimEnd() + '…';
}
