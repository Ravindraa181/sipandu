/**
 * @file app/dashboard/poin-perilaku/page.tsx
 * @description W3 — Manajemen Poin Perilaku Siswa.
 *
 *  Server Component:
 *   - Ambil assignment aktif via getTeacherAssignment().
 *   - Fetch raw_score semua siswa dari student_behavior_scores.
 *   - Fetch riwayat 10 transaksi terakhir per siswa.
 *   - Fetch kategori pelanggaran & penghargaan untuk TransactionDialog.
 *   - Render: header + BehaviorTable (client component).
 */

import { redirect } from 'next/navigation';

import { createClient } from '@/lib/supabase/server';
import { getTeacherAssignment } from '@/lib/teacher/getAssignment';
import { PageHeader } from '@/components/shared/PageHeader';
import { ROUTES } from '@/constants';
import {
  BehaviorTable,
  type BehaviorRow,
  type TransactionHistory,
} from './_components/BehaviorTable';
import { type TransactionCategory } from './_components/TransactionDialog';

export const metadata = {
  title: 'Poin Perilaku',
};

/** Ambil semua data yang dibutuhkan halaman poin perilaku. */
async function loadData() {
  const assignment = await getTeacherAssignment();
  if (!assignment) redirect(ROUTES.waiting);

  const supabase = await createClient();

  // ── 1. Skor perilaku aktif per siswa ────────────────────────────────
  const enrollmentIds = assignment.students.map((s) => s.enrollmentId);

  const { data: scores } = await supabase
    .from('student_behavior_scores')
    .select('enrollment_id, raw_score')
    .in('enrollment_id', enrollmentIds);

  type RawScore = { enrollment_id: string; raw_score: number };
  const scoreMap = new Map<string, number>(
    ((scores ?? []) as RawScore[]).map((s) => [
      s.enrollment_id,
      s.raw_score ?? 0,
    ]),
  );

  // ── 2. Riwayat transaksi (10 terbaru per siswa) ───────────────────
  const { data: txAll } = await supabase
    .from('behavior_point_transactions')
    .select(
      `id, enrollment_id, transaction_type, points_delta, transaction_date,
       raw_score_after, notes, recorded_by,
       violation_category:violation_category_id (name),
       reward_category:reward_category_id (name),
       recorder:recorded_by (full_name)`,
    )
    .in('enrollment_id', enrollmentIds)
    .is('deleted_at', null)
    .order('transaction_date', { ascending: false })
    .order('created_at', { ascending: false });

  type RawTx = {
    id: string;
    enrollment_id: string;
    transaction_type: string;
    points_delta: number;
    transaction_date: string;
    raw_score_after: number;
    notes: string | null;
    recorded_by: string;
    violation_category: { name: string } | null;
    reward_category: { name: string } | null;
    recorder: { full_name: string } | null;
  };

  // Kelompokkan per enrollmentId, ambil 10 terbaru masing-masing
  const txByEnrollment = new Map<string, TransactionHistory[]>();
  for (const tx of (txAll ?? []) as unknown as RawTx[]) {
    const list = txByEnrollment.get(tx.enrollment_id) ?? [];
    if (list.length < 10) {
      const isViolation = tx.transaction_type === 'violation';
      list.push({
        id: tx.id,
        type: isViolation ? 'violation' : 'reward',
        categoryName:
          (isViolation
            ? tx.violation_category?.name
            : tx.reward_category?.name) ?? '—',
        pointChange: tx.points_delta,
        rawAfter: tx.raw_score_after,
        transactionDate: tx.transaction_date,
        notes: tx.notes,
        recordedByName: tx.recorder?.full_name ?? '—',
      });
      txByEnrollment.set(tx.enrollment_id, list);
    }
  }

  // ── 3. Kategori pelanggaran & penghargaan ────────────────────────
  const [{ data: vCats }, { data: rCats }] = await Promise.all([
    supabase
      .from('violation_categories')
      .select('id, name, point_deduction')
      .order('name'),
    supabase
      .from('reward_categories')
      .select('id, name, point_addition')
      .order('name'),
  ]);

  type RawVCat = { id: string; name: string; point_deduction: number };
  type RawRCat = { id: string; name: string; point_addition: number };

  const violationCategories: TransactionCategory[] = (
    (vCats ?? []) as RawVCat[]
  ).map((c) => ({ id: c.id, name: c.name, pointValue: c.point_deduction }));

  const rewardCategories: TransactionCategory[] = (
    (rCats ?? []) as RawRCat[]
  ).map((c) => ({ id: c.id, name: c.name, pointValue: c.point_addition }));

  // ── 4. Rakit rows ─────────────────────────────────────────────────
  const initialScore = assignment.students[0]?.initialScore ?? 100;
  const rows: BehaviorRow[] = assignment.students.map((s) => {
    const rawScore = scoreMap.get(s.enrollmentId) ?? initialScore;
    const x2 = Math.min(rawScore, 100);
    return {
      enrollmentId: s.enrollmentId,
      studentId: s.studentId,
      fullName: s.fullName,
      rawScore,
      x2,
      hasBuffer: rawScore > 100,
      history: txByEnrollment.get(s.enrollmentId) ?? [],
    };
  });

  return {
    assignmentId: assignment.assignmentId,
    className: assignment.className,
    rows,
    violationCategories,
    rewardCategories,
  };
}

export default async function PoinPerilakuPage() {
  const data = await loadData();

  return (
    <div className="space-y-3">
      <PageHeader title={`Poin Perilaku — Kelas ${data.className}`} />

      <BehaviorTable
        assignmentId={data.assignmentId}
        rows={data.rows}
        violationCategories={data.violationCategories}
        rewardCategories={data.rewardCategories}
      />
    </div>
  );
}
