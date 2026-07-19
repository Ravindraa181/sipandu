/**
 * @file constants/index.ts
 * @description Konstanta yang dipakai di seluruh aplikasi (UI strings,
 *              warna, label aspek peer review, tingkat kelas, dll).
 *
 * Catatan: warna disini cukup berisi token HEX. Untuk styling Tailwind
 * gunakan class `bg-category-*` / `text-category-*` yang sudah didefine
 * di tailwind.config.ts.
 */

import type { CategoryType, GradeLevel } from '@/types';

/* ────────────────────────────────────────────────────────────────────
 *  1. Konfigurasi kategori Z*
 * ──────────────────────────────────────────────────────────────────── */

export interface CategoryConfigEntry {
  /** Label tampil bahasa Indonesia. */
  label: string;
  /** Hex foreground utama. */
  color: string;
  /** Hex background pucat (untuk badge). */
  bgColor: string;
  /** Hex border halus untuk card/banner. */
  borderColor: string;
  /** Hex teks gelap (untuk badge text). */
  textColor: string;
  /** Tailwind class shortcut (selaras `tailwind.config.ts`). */
  badgeClass: string;
  /** Threshold minimum z* (inclusive) untuk kategori ini. */
  minZScore: number;
}

/**
 * Konfigurasi lengkap setiap kategori output Z*.
 * Diurut dari yang paling rendah → tertinggi.
 */
export const CATEGORY_CONFIG: Readonly<Record<CategoryType, CategoryConfigEntry>> =
  {
    perlu_pembinaan: {
      label: 'Perlu Pembinaan',
      color: '#DC2626',
      bgColor: '#FEE2E2',
      borderColor: '#FECACA',
      textColor: '#B91C1C',
      badgeClass:
        'bg-category-perlu-pembinaan-soft text-category-perlu-pembinaan-text',
      minZScore: 0,
    },
    cukup: {
      label: 'Cukup',
      color: '#D97706',
      bgColor: '#FEF3C7',
      borderColor: '#FDE68A',
      textColor: '#B45309',
      badgeClass: 'bg-category-cukup-soft text-category-cukup-text',
      minZScore: 55,
    },
    baik: {
      label: 'Baik',
      color: '#2563EB',
      bgColor: '#DBEAFE',
      borderColor: '#BFDBFE',
      textColor: '#1D4ED8',
      badgeClass: 'bg-category-baik-soft text-category-baik-text',
      minZScore: 70,
    },
    sangat_baik: {
      label: 'Sangat Baik',
      color: '#16A34A',
      bgColor: '#DCFCE7',
      borderColor: '#BBF7D0',
      textColor: '#15803D',
      badgeClass: 'bg-category-sangat-baik-soft text-category-sangat-baik-text',
      minZScore: 85,
    },
  } as const;

/** Daftar kategori dari paling rendah ke tertinggi. */
export const CATEGORY_ORDER: readonly CategoryType[] = [
  'perlu_pembinaan',
  'cukup',
  'baik',
  'sangat_baik',
] as const;

/* ────────────────────────────────────────────────────────────────────
 *  2. Bulan (Bahasa Indonesia)
 * ──────────────────────────────────────────────────────────────────── */

/** 12 nama bulan, indeks 0 = Januari. */
export const MONTHS: readonly string[] = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
] as const;

/** Singkatan bulan untuk header tabel/grid (3 huruf). */
export const MONTHS_SHORT: readonly string[] = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
] as const;

/** Daftar hari (indeks 0 = Minggu). */
export const DAYS: readonly string[] = [
  'Minggu',
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
] as const;

/* ────────────────────────────────────────────────────────────────────
 *  3. Aspek Peer Review (5 aspek)
 * ──────────────────────────────────────────────────────────────────── */

/** Key aspek di tabel peer_review_submissions. */
export type PeerReviewAspectKey =
  | 'courtesy'
  | 'cooperation'
  | 'empathy'
  | 'honesty'
  | 'responsibility';

export interface PeerReviewAspectDef {
  key: PeerReviewAspectKey;
  /** Label tampil. */
  label: string;
  /** Deskripsi singkat untuk membantu siswa menilai. */
  description: string;
  /** Kolom DB di `peer_review_submissions`. */
  dbColumn: string;
}

/**
 * 5 aspek penilaian peer review SiPandu.
 *
 * Label & deskripsi mengacu pada dimensi Profil Lulusan pada
 * Permendikdasmen No. 10 Tahun 2025 (Standar Kompetensi Lulusan).
 * `key` & `dbColumn` TETAP (terikat ke kolom skor & trigger X3) — hanya
 * label/deskripsi yang berubah. Digunakan sebagai fallback bila tabel
 * `peer_review_aspects` kosong; sumber utama tetap dari DB.
 */
export const PEER_REVIEW_ASPECTS: readonly PeerReviewAspectDef[] = [
  {
    key: 'courtesy',
    label: 'Akhlak Mulia',
    description:
      'Seberapa jujur dan baik sikap siswa ini dalam berkata dan bertindak kepada guru maupun teman-teman?',
    dbColumn: 'score_courtesy',
  },
  {
    key: 'cooperation',
    label: 'Kewargaan',
    description:
      'Seberapa taat siswa ini terhadap aturan sekolah dan bertanggung jawab menjaga nama baik kelas maupun sekolah?',
    dbColumn: 'score_cooperation',
  },
  {
    key: 'empathy',
    label: 'Kolaborasi',
    description:
      'Seberapa aktif siswa ini peduli, berbagi, dan bekerja sama dengan teman-teman dalam kegiatan bersama?',
    dbColumn: 'score_empathy',
  },
  {
    key: 'honesty',
    label: 'Kemandirian',
    description:
      'Seberapa bertanggung jawab dan berinisiatif siswa ini dalam menyelesaikan tugas dan kewajibannya sendiri?',
    dbColumn: 'score_honesty',
  },
  {
    key: 'responsibility',
    label: 'Komunikasi',
    description:
      'Seberapa sopan siswa ini saat berbicara atau menyampaikan pendapat kepada teman-teman?',
    dbColumn: 'score_responsibility',
  },
] as const;

/** Map cepat key → label (dimensi Permendikdasmen No. 10 Tahun 2025). */
export const ASPECT_LABELS: Readonly<Record<PeerReviewAspectKey, string>> = {
  courtesy: 'Akhlak Mulia',
  cooperation: 'Kewargaan',
  empathy: 'Kolaborasi',
  honesty: 'Kemandirian',
  responsibility: 'Komunikasi',
} as const;

/** 5 label tampil skala 1-5 (untuk button rating di S2). */
export const ASPECT_SCALE_LABELS: readonly string[] = [
  'Sangat Buruk', // 1
  'Buruk',        // 2
  'Cukup',        // 3
  'Baik',         // 4
  'Sangat Baik',  // 5
] as const;

/* ────────────────────────────────────────────────────────────────────
 *  4. Tingkat kelas
 * ──────────────────────────────────────────────────────────────────── */

export const GRADE_LEVELS: readonly GradeLevel[] = ['X', 'XI', 'XII'] as const;

/* ────────────────────────────────────────────────────────────────────
 *  5. Threshold & limit aplikasi
 * ──────────────────────────────────────────────────────────────────── */

/** Persentase kehadiran minimum (di bawah ini akan diberi warning). */
export const MIN_ATTENDANCE_PERCENT = 75 as const;

/** Skor X2 awal default saat siswa enroll baru. */
export const DEFAULT_INITIAL_X2 = 75 as const;

/** Domain output Z*. */
export const Z_DOMAIN_MIN = 0 as const;
export const Z_DOMAIN_MAX = 100 as const;

/** Page size default untuk tabel berat (Manajemen Siswa, Laporan). */
export const DEFAULT_PAGE_SIZE = 10 as const;

/* ────────────────────────────────────────────────────────────────────
 *  6. UI strings global
 * ──────────────────────────────────────────────────────────────────── */

export const UI_STRINGS = {
  appName: 'SiPandu',
  appTagline: 'Sistem Penilaian Terpadu',
  schoolName: 'SMAN 13 Bandung',
  notScored: 'Belum Dinilai',
  notSet: '—',
  loading: 'Memuat…',
  emptyState: 'Belum ada data',
  errorGeneric: 'Terjadi kesalahan. Silakan coba lagi.',
  saveDraft: 'Simpan Draft',
  saveAndLock: 'Simpan & Kunci',
  cancel: 'Batal',
  save: 'Simpan',
  delete: 'Hapus',
  edit: 'Edit',
  view: 'Lihat',
  back: 'Kembali',
} as const;

/* ────────────────────────────────────────────────────────────────────
 *  7. Path / route map
 * ──────────────────────────────────────────────────────────────────── */

export const ROUTES = {
  // Public
  login: '/login',
  adminLogin: '/admin/login',
  waiting: '/waiting',

  // Admin — path harus match dengan nama folder di src/app/admin/*
  adminHome: '/admin/dashboard',
  adminPeriode: '/admin/periode',
  adminGuru: '/admin/guru',
  adminKelas: '/admin/kelas',
  adminSiswa: '/admin/siswa',
  adminFuzzy: '/admin/konfigurasi-fuzzy',
  adminLaporan: '/admin/laporan',
  adminKategori: '/admin/kategori-poin',

  // Teacher — path harus match dengan nama folder di src/app/dashboard/*
  teacherHome: '/dashboard',
  teacherKehadiran: '/dashboard/kehadiran',
  teacherPoin: '/dashboard/poin-perilaku',
  teacherPeerReview: '/dashboard/peer-review',
  teacherHasil: '/dashboard/hasil-penilaian',
  teacherStudentDetail: (id: string) => `/dashboard/siswa/${id}` as const,

  // Student
  studentHome: '/siswa',
  studentPeerReview: '/siswa/peer-review',
  studentRiwayat: '/siswa/riwayat',
} as const;

/** Beranda berdasarkan role. */
export function getRoleHomePath(role: string | null | undefined): string {
  switch (role) {
    case 'admin':
      return ROUTES.adminHome;
    case 'teacher':
      return ROUTES.teacherHome;
    case 'student':
      return ROUTES.studentHome;
    default:
      return ROUTES.login;
  }
}
