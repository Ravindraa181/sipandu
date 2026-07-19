/**
 * @file lib/badges/computeStudentBadges.ts
 * @description Service perhitungan 7 lencana (badge) siswa.
 *
 *  PENTING — fitur ini MURNI BACA:
 *   - Tidak ada tabel baru. Sumber data seluruhnya tabel yang sudah ada:
 *       behavior_final_scores        → riwayat Z* & kategori per periode
 *       behavior_point_transactions  → log transaksi reward + kategorinya
 *       peer_review_progress         → status kelengkapan pengisian peer review
 *   - Tidak ada penyimpanan hasil badge; seluruhnya computed on the fly.
 *   - Tidak menyentuh mesin fuzzy maupun alur input Wali Kelas/Admin.
 *
 *  Semua query memakai anon client sehingga tunduk pada RLS: siswa hanya
 *  bisa membaca enrollment, skor, transaksi, dan progress miliknya sendiri.
 */

import 'server-only';

import { createClient } from '@/lib/supabase/server';
import type { CategoryType } from '@/types';
import type { BadgeId } from './definitions';
import { evaluateBadges, type PeriodBadges } from './evaluateBadges';

export type { PeriodBadges } from './evaluateBadges';

/* ═══════════════════════════════════════════════════════════════════
 *  Pemuatan data mentah (satu kali untuk seluruh periode siswa)
 * ═══════════════════════════════════════════════════════════════════ */

interface PeriodRow {
  periodId: string;
  periodLabel: string;
  startDate: string;
  enrollmentId: string;
  assignmentId: string;
}

/**
 * Hitung badge siswa untuk SETIAP periode yang pernah diikuti.
 *
 * Dipakai halaman Riwayat Nilai (butuh badge per periode) dan menjadi
 * basis `computeStudentBadges` untuk satu periode.
 *
 * Aman terhadap siswa baru: bila data historis < 3 periode, badge
 * "Peningkatan Konsisten" & "Teladan" otomatis tidak muncul tanpa error.
 */
export async function computeStudentBadgesByPeriod(
  studentId: string,
): Promise<PeriodBadges[]> {
  const supabase = await createClient();

  // ── 1. Seluruh enrollment siswa + metadata periode ────────────────
  const { data: enrollData } = await supabase
    .from('student_class_enrollments')
    .select(
      `id,
       assignment:class_period_assignment_id (
         id,
         period:period_id (id, name, start_date)
       )`,
    )
    .eq('student_id', studentId);

  const enrollRows = (enrollData ?? []) as unknown as Array<{
    id: string;
    assignment: {
      id: string;
      period: { id: string; name: string; start_date: string } | null;
    } | null;
  }>;

  const periods: PeriodRow[] = [];
  for (const e of enrollRows) {
    const p = e.assignment?.period;
    if (!p || !e.assignment) continue;
    // Satu siswa hanya punya satu enrollment aktif per periode; bila ada
    // duplikat (pindah kelas), ambil yang pertama ditemukan.
    if (periods.some((x) => x.periodId === p.id)) continue;
    periods.push({
      periodId: p.id,
      periodLabel: p.name,
      startDate: p.start_date,
      enrollmentId: e.id,
      assignmentId: e.assignment.id,
    });
  }

  if (periods.length === 0) return [];

  // Urutkan kronologis — wajib untuk badge berbasis tren antar-periode.
  periods.sort((a, b) => (a.startDate < b.startDate ? -1 : 1));

  const enrollmentIds = periods.map((p) => p.enrollmentId);
  const assignmentIds = periods.map((p) => p.assignmentId);

  // ── 2. Riwayat Z* + transaksi reward + sesi peer review ───────────
  const [{ data: scoreData }, { data: rewardData }, { data: sessionData }] =
    await Promise.all([
      supabase
        .from('behavior_final_scores')
        .select('enrollment_id, z_star, category')
        .in('enrollment_id', enrollmentIds),
      supabase
        .from('behavior_point_transactions')
        .select(
          'enrollment_id, reward_category:reward_category_id (name, category_label)',
        )
        .in('enrollment_id', enrollmentIds)
        .eq('transaction_type', 'reward')
        .is('deleted_at', null),
      supabase
        .from('peer_review_sessions')
        .select('id, class_period_assignment_id')
        .in('class_period_assignment_id', assignmentIds),
    ]);

  const scoreByEnrollment = new Map<
    string,
    { zStar: number | null; category: CategoryType | null }
  >();
  for (const s of (scoreData ?? []) as unknown as Array<{
    enrollment_id: string;
    z_star: number | null;
    category: CategoryType | null;
  }>) {
    scoreByEnrollment.set(s.enrollment_id, {
      zStar: s.z_star,
      category: s.category,
    });
  }

  /** enrollmentId → set label/nama kategori reward yang pernah diterima. */
  const rewardsByEnrollment = new Map<
    string,
    { names: Set<string>; labels: Set<string> }
  >();
  for (const tx of (rewardData ?? []) as unknown as Array<{
    enrollment_id: string;
    reward_category: { name: string | null; category_label: string | null } | null;
  }>) {
    let bucket = rewardsByEnrollment.get(tx.enrollment_id);
    if (!bucket) {
      bucket = { names: new Set<string>(), labels: new Set<string>() };
      rewardsByEnrollment.set(tx.enrollment_id, bucket);
    }
    const name = tx.reward_category?.name;
    const label = tx.reward_category?.category_label;
    if (name) bucket.names.add(name.trim().toLowerCase());
    if (label) bucket.labels.add(label.trim().toLowerCase());
  }

  const sessionByAssignment = new Map<string, string>();
  for (const s of (sessionData ?? []) as unknown as Array<{
    id: string;
    class_period_assignment_id: string;
  }>) {
    sessionByAssignment.set(s.class_period_assignment_id, s.id);
  }

  // ── 3. Progress peer review siswa ini pada sesi-sesi tersebut ─────
  const sessionIds = [...sessionByAssignment.values()];
  const progressBySession = new Map<
    string,
    { completed: number; total: number }
  >();

  if (sessionIds.length > 0) {
    const { data: progressData } = await supabase
      .from('peer_review_progress')
      .select('session_id, completed_count, total_count')
      .eq('student_id', studentId)
      .in('session_id', sessionIds);

    for (const p of (progressData ?? []) as unknown as Array<{
      session_id: string;
      completed_count: number;
      total_count: number;
    }>) {
      progressBySession.set(p.session_id, {
        completed: p.completed_count ?? 0,
        total: p.total_count ?? 0,
      });
    }
  }

  // ── 4. Evaluasi badge per periode (logika murni di evaluateBadges.ts) ──
  return evaluateBadges(
    periods.map((p) => {
      const score = scoreByEnrollment.get(p.enrollmentId);
      const rewards = rewardsByEnrollment.get(p.enrollmentId);
      const sessionId = sessionByAssignment.get(p.assignmentId);
      const prog = sessionId ? progressBySession.get(sessionId) : undefined;

      return {
        periodId: p.periodId,
        periodLabel: p.periodLabel,
        startDate: p.startDate,
        zStar: score?.zStar ?? null,
        category: score?.category ?? null,
        rewardNames: [...(rewards?.names ?? [])],
        rewardLabels: [...(rewards?.labels ?? [])],
        peerReviewCompleted: prog?.completed ?? 0,
        peerReviewTotal: prog?.total ?? 0,
      };
    }),
  );
}

/* ═══════════════════════════════════════════════════════════════════
 *  API utama — badge satu siswa pada satu periode
 * ═══════════════════════════════════════════════════════════════════ */

/**
 * Hitung badge yang diraih seorang siswa pada satu periode akademik.
 *
 * @param studentId  profiles.id siswa (role = 'student')
 * @param periodId   academic_periods.id periode yang dievaluasi
 * @returns daftar id badge yang diraih (kosong bila belum ada yang memenuhi)
 */
export async function computeStudentBadges(
  studentId: string,
  periodId: string,
): Promise<BadgeId[]> {
  const all = await computeStudentBadgesByPeriod(studentId);
  return all.find((p) => p.periodId === periodId)?.earned ?? [];
}
