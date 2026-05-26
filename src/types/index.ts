/**
 * @file types/index.ts
 * @description Custom TypeScript types yang dipakai di seluruh aplikasi.
 *
 * Tipe yang BERASAL dari skema Supabase (per-tabel Row/Insert/Update)
 * sebaiknya di-import dari `lib/supabase/database.types.ts` (hasil
 * `supabase gen types typescript`). File ini hanya berisi tipe domain
 * dan view-model yang lebih tinggi (composite, derived, atau khusus UI).
 */

/* ────────────────────────────────────────────────────────────────────
 *  1. Enum domain (literal union)
 * ──────────────────────────────────────────────────────────────────── */

/** Peran pengguna sistem. Identik dengan enum DB `user_role`. */
export type UserRole = 'admin' | 'teacher' | 'student';

/** Empat kategori output Z*. Identik dengan enum DB `behavior_category`. */
export type CategoryType = 'perlu_pembinaan' | 'cukup' | 'baik' | 'sangat_baik';

/** Semester. Identik dengan enum DB `semester_type`. */
export type SemesterType = 'ganjil' | 'genap';

/** Tingkat kelas (X / XI / XII). */
export type GradeLevel = 'X' | 'XI' | 'XII';

/** Status periode akademik. */
export type PeriodStatus = 'active' | 'closed' | 'archived';

/** Status sesi peer review. */
export type PeerReviewSessionStatus = 'not_started' | 'active' | 'closed';

/** Jenis transaksi poin. */
export type TransactionType = 'violation' | 'reward';

/** Status data bulanan (kehadiran). */
export type DataStatus = 'draft' | 'locked';

/* ────────────────────────────────────────────────────────────────────
 *  2. View-model siswa & kelas
 * ──────────────────────────────────────────────────────────────────── */

/** Profil minimum siswa untuk ditampilkan di list/tabel. */
export interface StudentProfile {
  id: string;
  nis: string;
  fullName: string;
  email: string;
  gender: 'L' | 'P' | null;
  isActive: boolean;
}

/**
 * Siswa lengkap dengan skor terkini di periode aktif.
 * Dipakai di W1 Dashboard, W6 Hasil Penilaian, A5 Manajemen Siswa.
 */
export interface StudentWithScore extends StudentProfile {
  /** Periode atau tahun ajaran dari skor (mis. "Ganjil 2024/2025"). */
  periodLabel: string | null;
  /** Persentase kehadiran semester (0-100). */
  x1: number | null;
  /** Skor poin perilaku (0-100, sudah `min(raw, 100)`). */
  x2: number | null;
  /** Raw poin perilaku (bisa > 100 jika buffer). */
  rawX2: number | null;
  /** Skor peer review (0-100). */
  x3: number | null;
  /** Skor akhir defuzzifikasi. */
  zScore: number | null;
  /** Kategori akhir (dari z*). */
  category: CategoryType | null;
}

/** Ringkasan satu kelas pada periode aktif (untuk A1 dashboard admin). */
export interface ClassSummary {
  classId: string;
  className: string;
  gradeLevel: GradeLevel;
  homeroomTeacherName: string | null;
  studentCount: number;
  /** Status pengisian per jenis data. */
  attendanceStatus: 'complete' | 'partial' | 'empty';
  pointStatus: 'complete' | 'partial' | 'empty';
  peerReviewStatus: PeerReviewSessionStatus;
  /** Berapa siswa sudah punya z*; total siswa kelas. */
  scoredCount: number;
  /** Status agregat untuk badge di tabel. */
  overallStatus: 'lengkap' | 'proses' | 'belum';
}

/** Penugasan wali kelas untuk satu periode. */
export interface TeacherAssignment {
  assignmentId: string;
  classId: string;
  className: string;
  periodId: string;
  periodLabel: string;
  studentCount: number;
}

/* ────────────────────────────────────────────────────────────────────
 *  3. View-model kehadiran (X1)
 * ──────────────────────────────────────────────────────────────────── */

/** Data kehadiran satu siswa untuk satu bulan. */
export interface AttendanceMonthData {
  enrollmentId: string;
  studentName: string;
  month: number;          // 1-12
  year: number;
  presentDays: number;    // Hadir
  sickDays: number;       // Sakit
  permittedDays: number;  // Izin
  absentDays: number;     // Alpa
  effectiveDays: number;
  /** Locked = tidak boleh diubah. */
  status: DataStatus;
  /** Persentase = present / effective × 100. */
  percentage: number;
}

/** Status setiap bulan dalam periode (untuk tab bulan di W2). */
export interface MonthTabState {
  monthId: string;     // 'ags' | 'sep' | ... untuk URL hash
  monthLabel: string;  // 'Agustus'
  monthNumber: number; // 1-12
  year: number;
  effectiveDays: number;
  /** active = bulan saat ini editable. */
  uiState: 'locked' | 'active' | 'upcoming' | 'future';
}

/* ────────────────────────────────────────────────────────────────────
 *  4. View-model poin perilaku (X2)
 * ──────────────────────────────────────────────────────────────────── */

/** Satu transaksi reward atau pelanggaran. */
export interface BehaviorTransaction {
  id: string;
  enrollmentId: string;
  type: TransactionType;
  /** Nama kategori, mis. "Terlambat masuk kelas". */
  categoryName: string;
  /** Referensi SOP (untuk pelanggaran) atau label kategori (untuk reward). */
  referenceText: string | null;
  /** Negatif untuk pelanggaran, positif untuk reward. */
  pointChange: number;
  /** Snapshot raw_score setelah transaksi ini. */
  rawScoreAfter: number;
  transactionDate: string; // ISO date
  notes: string | null;
  recordedByName: string;
}

/** Snapshot running score siswa (X2 + buffer). */
export interface StudentRunningScore {
  enrollmentId: string;
  rawScore: number;       // bisa > 100
  x2Score: number;        // = min(rawScore, 100)
  hasBuffer: boolean;     // rawScore > 100
  lastTransactionAt: string | null;
}

/* ────────────────────────────────────────────────────────────────────
 *  5. View-model peer review (X3)
 * ──────────────────────────────────────────────────────────────────── */

/** 5 aspek penilaian peer review (skala 1-5). */
export interface PeerReviewAspects {
  courtesy: number;        // Kesantunan
  cooperation: number;     // Gotong royong / kerja sama
  empathy: number;         // Empati
  honesty: number;         // Kejujuran
  responsibility: number;  // Tanggung jawab
}

/** Progress reviewer (siswa) dalam mengisi peer review. */
export interface PeerReviewProgress {
  reviewerId: string;
  reviewerName: string;
  totalAssigned: number;
  totalCompleted: number;
  /** Persentase 0-100. */
  progressPercent: number;
  /** Daftar reviewee yang sudah dinilai (untuk skip di urutan). */
  completedReviewees: string[];
  /** Urutan random siswa yang harus dinilai. */
  randomizedOrder: string[];
  lastSubmittedAt: string | null;
  /** UI state saat ini. */
  uiState: 'done' | 'in_progress' | 'not_started';
}

/** Agregat X3 per siswa (reviewee) di sebuah sesi. */
export interface StudentX3Aggregate {
  studentId: string;
  reviewerCount: number;
  /** Rata-rata per aspek (1-5). */
  avgAspects: PeerReviewAspects;
  /** Skor X3 final (0-100) = avg semua aspek × 20. */
  x3Score: number | null;
  computedAt: string | null;
}

/* ────────────────────────────────────────────────────────────────────
 *  6. Dashboard & UI helpers
 * ──────────────────────────────────────────────────────────────────── */

/** Statistik untuk kartu KPI dashboard (admin/teacher). */
export interface DashboardStats {
  /** A1: total siswa aktif, total kelas, dst. */
  totalStudents: number;
  totalClasses: number;
  totalActiveTeachers: number;
  /** Kelas yang data-nya komplet di periode aktif. */
  classesCompleteCount: number;
  classesIncompleteCount: number;
  activePeriodLabel: string | null;
  /** Distribusi kategori (jumlah siswa per kategori). */
  distribution: {
    sangat_baik: number;
    baik: number;
    cukup: number;
    perlu_pembinaan: number;
    not_scored: number;
  };
}

/** Item checklist progres pengisian (W1). */
export interface ChecklistStatus {
  id: string;
  label: string;
  status: 'done' | 'in_progress' | 'pending' | 'overdue';
  helperText?: string;
  /** Tombol CTA jika ada. */
  actionLabel?: string;
  actionHref?: string;
}

/** Notifikasi sistem yang muncul di dashboard. */
export interface SystemNotification {
  id: string;
  level: 'info' | 'warning' | 'error' | 'success';
  message: string;
  href?: string;
  createdAt: string;
}

/* ────────────────────────────────────────────────────────────────────
 *  7. Kategori master (untuk dropdown CRUD A8)
 * ──────────────────────────────────────────────────────────────────── */

export interface ViolationCategory {
  id: string;
  name: string;
  pointValue: number;
  sopReference: string | null;
  description: string | null;
  isActive: boolean;
}

export interface RewardCategory {
  id: string;
  name: string;
  pointValue: number;
  categoryLabel: string | null;
  description: string | null;
  isActive: boolean;
}

/* ────────────────────────────────────────────────────────────────────
 *  8. Pagination & sorting (untuk tabel besar)
 * ──────────────────────────────────────────────────────────────────── */

export interface PaginationState {
  pageIndex: number; // 0-based
  pageSize: number;
}

export interface SortState {
  columnId: string;
  direction: 'asc' | 'desc';
}

/** Generic envelope untuk response paginated dari Supabase. */
export interface PaginatedResult<T> {
  rows: T[];
  totalCount: number;
  pageIndex: number;
  pageSize: number;
}
