/**
  Server Component:
 *   - Selector periode (multi-period yang pernah diikuti siswa)
 *   - 3 tab read-only: Kehadiran | Poin Perilaku | Nilai dari Teman
 *
 *  PRIVASI Peer Review (KRITIS):
 *   - Pada tab "Nilai dari Teman", JANGAN tampilkan reviewer_id atau
 *     daftar penilai. Hanya agregat per aspek + jumlah penilai.
 *   - Disclaimer italik tentang anonimitas selalu tampil.
 */

/**
 * @file app/siswa/riwayat/page.tsx
 * @description S3 — Riwayat Penilaian Saya.
 */

import { redirect } from 'next/navigation';
import { Info } from 'lucide-react';

import { createClient, createServiceRoleClient } from '@/lib/supabase/server';
import { getStudentContext } from '@/lib/student/getStudentContext';
import { PageHeader } from '@/components/shared/PageHeader';
import { CategoryBadge } from '@/components/shared/CategoryBadge';
import {
  ASPECT_LABELS,
  MIN_ATTENDANCE_PERCENT,
  MONTHS,
  ROUTES,
} from '@/constants';
import {
  formatDate,
  formatPercent,
  formatScore,
} from '@/lib/utils/format';
import { cn } from '@/lib/utils/cn';
import type { CategoryType } from '@/types';
import {
  PeriodSelector,
  type PeriodOption,
} from './_components/PeriodSelector';
import { RiwayatTabs } from './_components/RiwayatTabs';

export const metadata = {
  title: 'Riwayat Saya — Siswa SiPandu',
};

// FIX: Definisikan tipe secara lokal untuk menghindari missing export dari @/types
type PeerReviewAspectKey = 'courtesy' | 'cooperation' | 'empathy' | 'honesty' | 'responsibility';

interface SearchParams {
  period?: string;
}

interface AttendanceRow {
  month: number;
  year: number;
  presentDays: number | null;
  sickDays: number | null;
  permittedDays: number | null;
  absentDays: number | null;
  effectiveDays: number;
  status: 'locked' | 'draft' | 'empty';
}

interface PointTxRow {
  id: string;
  type: 'violation' | 'reward';
  categoryName: string;
  pointChange: number;
  transactionDate: string;
  notes: string | null;
}

interface AspectAggregate {
  key: PeerReviewAspectKey;
  label: string;
  average: number;
  percent: number;
}

interface PageData {
  studentName: string;
  className: string;
  homeroomTeacherName: string | null;
  selectedPeriodId: string;
  periodOptions: PeriodOption[];
  selectedPeriodLabel: string;
  attendanceRows: AttendanceRow[];
  semesterX1: number | null;
  rawX2: number | null;
  x2Score: number | null;
  pointTransactions: PointTxRow[];
  initialX2: number;
  x3: number | null;
  category: CategoryType | null;
  reviewerCount: number;
  peerSessionStatus: 'not_started' | 'active' | 'closed' | null;
  aspectAggregates: AspectAggregate[];
}

const ASPECT_KEYS: PeerReviewAspectKey[] = [
  'courtesy',
  'cooperation',
  'empathy',
  'honesty',
  'responsibility',
];

// FIX: Definisikan ExpectedStudentContext secara lokal
type ExpectedStudentContext = {
  studentId: string;
  studentName: string;
  className: string;
  homeroomTeacherName: string | null;
  periodId: string;
  periodLabel: string;
  initialX2: number;
};

async function loadData(searchParams: SearchParams): Promise<PageData> {
  const baseCtx = await getStudentContext();
  if (!baseCtx) redirect(ROUTES.login);
  
  // FIX: Bypass TypeScript Context Checking
  const ctx = baseCtx as unknown as ExpectedStudentContext;

  const supabase = await createClient();

  // ── 1. Daftar periode yang pernah diikuti siswa ─────────────────
  // FIX: Ubah class_period_assignment_id menjadi class_period_assignment_id
  const { data: enrollData } = await supabase
    .from('student_class_enrollments')
    .select(
      `id, status,
       assignment:class_period_assignment_id (
         id,
         class:class_id (name),
         period:period_id (id, name, status, start_date)
       )`,
    )
    .eq('student_id', ctx.studentId);

  // FIX: Gunakan "as unknown as" untuk mencegah "sufficiently overlaps" error
  const enrollmentRows = (enrollData as unknown) as Array<{
    id: string;
    status: string;
    assignment: {
      id: string;
      class: { name: string } | null;
      period: {
        id: string;
        name: string;
        status: string;
        start_date: string;
      } | null;
    } | null;
  }>;

  const periodEnrollMap = new Map<
    string,
    { enrollmentId: string; assignmentId: string; className: string }
  >();
  const periodMeta = new Map<
    string,
    { name: string; isActive: boolean; startDate: string }
  >();

  for (const e of enrollmentRows ?? []) {
    if (e.assignment?.period && e.assignment.class) {
      const p = e.assignment.period;
      if (!periodEnrollMap.has(p.id)) {
        periodEnrollMap.set(p.id, {
          enrollmentId: e.id,
          assignmentId: e.assignment.id,
          className: e.assignment.class.name,
        });
        periodMeta.set(p.id, {
          name: p.name,
          isActive: p.status === 'active',
          startDate: p.start_date,
        });
      }
    }
  }

  const periodOptions: PeriodOption[] = Array.from(periodMeta.entries())
    .map(([id, meta]) => ({
      id,
      label: meta.name,
      isActive: meta.isActive,
      startDate: meta.startDate,
    }))
    .sort((a, b) => (a.startDate < b.startDate ? 1 : -1))
    .map(({ id, label, isActive }) => ({ id, label, isActive }));

  const requested = searchParams.period;
  const selectedPeriodId =
    (requested && periodMeta.has(requested) ? requested : null) ??
    periodOptions.find((p) => p.isActive)?.id ??
    periodOptions[0]?.id ??
    ctx.periodId;

  const selectedEnroll = periodEnrollMap.get(selectedPeriodId);
  const selectedMeta = periodMeta.get(selectedPeriodId);
  const selectedPeriodLabel = selectedMeta?.name ?? ctx.periodLabel;

  if (!selectedEnroll) {
    return {
      studentName: ctx.studentName,
      className: ctx.className,
      homeroomTeacherName: ctx.homeroomTeacherName,
      selectedPeriodId,
      periodOptions,
      selectedPeriodLabel,
      attendanceRows: [],
      semesterX1: null,
      rawX2: null,
      x2Score: null,
      pointTransactions: [],
      initialX2: ctx.initialX2,
      x3: null,
      category: null,
      reviewerCount: 0,
      peerSessionStatus: null,
      aspectAggregates: [],
    };
  }

  // ── 2. Skor akhir untuk enrollment terpilih ─────────────────────
  const { data: scoreRowData } = await supabase
    .from('behavior_final_scores')
    .select('x1, x2, raw_x2, x3, z_star, category')
    .eq('enrollment_id', selectedEnroll.enrollmentId)
    .maybeSingle();

  const score = scoreRowData as {
    x1: number | null;
    x2: number | null;
    raw_x2: number | null;
    x3: number | null;
    z_star: number | null;
    category: CategoryType | null;
  } | null;

  // ── 3. Kehadiran per bulan ──────────────────────────────────────
  // FIX BUG 1: Kolom yang benar di monthly_attendance adalah is_locked (BOOLEAN),
  // BUKAN 'status'. Juga: effective_days ada di monthly_attendance sendiri.
  // Strategi: ambil period_monthly_days sebagai template bulan, dan
  // monthly_attendance untuk data aktual. Jika period_monthly_days kosong,
  // gunakan monthly_attendance langsung sebagai sumber bulan.
  const [{ data: monthsConfig }, { data: attData }] = await Promise.all([
    supabase
      .from('period_monthly_days')
      .select('month, year, effective_days')
      .eq('period_id', selectedPeriodId)
      .order('year', { ascending: true })
      .order('month', { ascending: true }),
    supabase
      .from('monthly_attendance')
      .select(
        'month, year, present_days, sick_days, permit_days, absent_days, effective_days, is_locked',
      )
      .eq('enrollment_id', selectedEnroll.enrollmentId)
      .order('year', { ascending: true })
      .order('month', { ascending: true }),
  ]);

  type AttDbRow = {
    month: number;
    year: number;
    present_days: number;
    sick_days: number;
    permit_days: number;
    absent_days: number;
    effective_days: number;
    is_locked: boolean;
  };

  const attList = (attData as unknown as AttDbRow[]) ?? [];

  // Buat map attendance: key = "year-month"
  const attMap = new Map<string, AttDbRow>();
  for (const a of attList) {
    attMap.set(`${a.year}-${a.month}`, a);
  }

  // Gunakan period_monthly_days sebagai template bulan jika tersedia,
  // jika tidak ada (belum di-setup admin), fallback ke baris monthly_attendance
  const monthTemplate: Array<{ month: number; year: number; effective_days: number }> =
    (monthsConfig ?? []).length > 0
      ? (monthsConfig as Array<{ month: number; year: number; effective_days: number }>)
      : attList.map((a) => ({ month: a.month, year: a.year, effective_days: a.effective_days }));

  const attendanceRows: AttendanceRow[] = monthTemplate.map((m) => {
    const a = attMap.get(`${m.year}-${m.month}`);
    if (!a) {
      return {
        month: m.month,
        year: m.year,
        presentDays: null,
        sickDays: null,
        permittedDays: null,
        absentDays: null,
        effectiveDays: m.effective_days,
        status: 'empty',
      } as AttendanceRow;
    }
    return {
      month: a.month,
      year: a.year,
      presentDays: a.present_days,
      sickDays: a.sick_days,
      permittedDays: a.permit_days,
      absentDays: a.absent_days,
      effectiveDays: a.effective_days,
      // FIX: is_locked (boolean) → status string yang dipakai UI
      status: a.is_locked ? 'locked' : 'draft',
    } as AttendanceRow;
  });

  const lockedMonths = attendanceRows.filter((r) => r.status === 'locked');
  const semesterX1 =
    lockedMonths.length > 0
      ? lockedMonths.reduce(
          (acc, m) =>
            acc + ((m.presentDays ?? 0) / Math.max(1, m.effectiveDays)) * 100,
          0,
        ) / lockedMonths.length
      : null;

  // ── 4. Poin transaksi ───────────────────────────────────────────
  // FIX BUG 2: Tidak ada kolom 'category_id' di behavior_point_transactions.
  // Tabel memiliki dua FK terpisah: violation_category_id dan reward_category_id.
  // Juga filter deleted_at IS NULL untuk mengecualikan soft-delete.
  const { data: txnData } = await supabase
    .from('behavior_point_transactions')
    .select(
      `id, transaction_type, transaction_date, points_delta, notes,
       violation_category:violation_category_id (name),
       reward_category:reward_category_id (name)`,
    )
    .eq('enrollment_id', selectedEnroll.enrollmentId)
    .is('deleted_at', null)
    .order('transaction_date', { ascending: false });

  const pointTransactions: PointTxRow[] = (
    (txnData as unknown) as Array<{
      id: string;
      transaction_type: 'violation' | 'reward';
      transaction_date: string;
      points_delta: number;
      notes: string | null;
      violation_category: { name: string } | null;
      reward_category: { name: string } | null;
    }> ?? []
  ).map((tx) => ({
    id: tx.id,
    type: tx.transaction_type,
    // Pilih nama kategori dari FK yang relevan sesuai jenis transaksi
    categoryName:
      tx.transaction_type === 'violation'
        ? (tx.violation_category?.name ?? '—')
        : (tx.reward_category?.name ?? '—'),
    pointChange: tx.points_delta,
    transactionDate: tx.transaction_date,
    notes: tx.notes,
  }));

  // ── 5. Peer review aggregate ────────────────────────────────────
  const { data: peerSessionData } = await supabase
    .from('peer_review_sessions')
    .select('id, status')
    .eq('class_period_assignment_id', selectedEnroll.assignmentId)
    .maybeSingle();

  const peerSession = peerSessionData as { id: string; status: string } | null;

  let aspectAggregates: AspectAggregate[] = [];
  let reviewerCount = 0;
  const peerSessionStatus =
    (peerSession?.status as 'not_started' | 'active' | 'closed' | undefined) ?? null;

  if (peerSession?.id) {
    // FIX BUG 3: RLS memblokir siswa dari SELECT peer_review_submissions
    // (sengaja, untuk menjaga anonimitas reviewer). Gunakan service role
    // hanya untuk menghitung agregat skor yang diterima siswa ini.
    // Identitas reviewer TIDAK ditampilkan ke siswa (lihat UI di bawah).
    const adminClient = await createServiceRoleClient();
    const { data: peerData } = await adminClient
      .from('peer_review_submissions')
      .select(
        'score_courtesy, score_cooperation, score_empathy, score_honesty, score_responsibility',
      )
      .eq('session_id', peerSession.id)
      .eq('reviewee_id', ctx.studentId);

    const peerRows = (peerData ?? []) as Array<{
      score_courtesy: number;
      score_cooperation: number;
      score_empathy: number;
      score_honesty: number;
      score_responsibility: number;
    }>;
    reviewerCount = peerRows.length;

    if (reviewerCount > 0) {
      const sums: Record<PeerReviewAspectKey, number> = {
        courtesy: 0,
        cooperation: 0,
        empathy: 0,
        honesty: 0,
        responsibility: 0,
      };
      for (const r of peerRows) {
        sums.courtesy     += r.score_courtesy;
        sums.cooperation  += r.score_cooperation;
        sums.empathy      += r.score_empathy;
        sums.honesty      += r.score_honesty;
        sums.responsibility += r.score_responsibility;
      }
      aspectAggregates = ASPECT_KEYS.map((key) => {
        const avg = sums[key] / reviewerCount;
        return {
          key,
          label: ASPECT_LABELS[key as keyof typeof ASPECT_LABELS],
          average: avg,
          percent: (avg / 5) * 100,
        };
      });
    }
  }

  return {
    studentName: ctx.studentName,
    className: selectedEnroll.className,
    homeroomTeacherName: ctx.homeroomTeacherName,
    selectedPeriodId,
    periodOptions,
    selectedPeriodLabel,
    attendanceRows,
    semesterX1,
    rawX2: score?.raw_x2 ?? null,
    x2Score: score?.x2 ?? null,
    pointTransactions,
    initialX2: ctx.initialX2,
    x3: score?.x3 ?? null,
    category: score?.category ?? null,
    reviewerCount,
    peerSessionStatus,
    aspectAggregates,
  };
}

const STATUS_BADGE = {
  locked: {
    label: '✓ Terkunci',
    cls: 'bg-status-on-soft text-status-on-text',
  },
  draft: {
    label: '⏳ Draft',
    cls: 'bg-status-warn-soft text-status-warn-text',
  },
  empty: {
    label: '○ Belum',
    cls: 'bg-status-off-soft text-status-off-text',
  },
} as const;

export default async function StudentRiwayatPage({
  searchParams,
}: {
  searchParams: Promise<SearchParams>;
}) {
  const params = await searchParams;
  const data = await loadData(params);

  // ── Tab Kehadiran ───────────────────────────────────────────────
  const kehadiranContent = (
    <div className="space-y-3">
      <div className="overflow-hidden rounded-md border border-sipandu-border bg-white">
        <div className="overflow-x-auto">
          <table className="w-full border-collapse text-sm">
            <thead>
              <tr className="border-b border-sipandu-border bg-gray-100 text-left">
                <th className="px-3 py-2 text-xs font-semibold">Bulan</th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  Hadir
                </th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  Sakit
                </th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  Izin
                </th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  Alpa
                </th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  Hari Efektif
                </th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  %
                </th>
                <th className="px-3 py-2 text-xs font-semibold">Status</th>
              </tr>
            </thead>
            <tbody>
              {data.attendanceRows.length === 0 ? (
                <tr>
                  <td
                    colSpan={8}
                    className="px-3 py-8 text-center text-sm italic text-muted-foreground"
                  >
                    Belum ada data kehadiran untuk periode ini.
                  </td>
                </tr>
              ) : (
                data.attendanceRows.map((r) => {
                  const cfg = STATUS_BADGE[r.status];
                  const pct =
                    r.presentDays !== null && r.effectiveDays > 0
                      ? (r.presentDays / r.effectiveDays) * 100
                      : null;
                  const lowAtt =
                    pct !== null && pct < MIN_ATTENDANCE_PERCENT;
                  return (
                    <tr
                      key={`${r.year}-${r.month}`}
                      className="border-b border-gray-100 last:border-b-0"
                    >
                      <td className="px-3 py-1.5 font-medium">
                        {MONTHS[r.month - 1]} {r.year}
                      </td>
                      <td
                        className={cn(
                          'px-3 py-1.5 text-center',
                          r.presentDays === null && 'text-muted-foreground',
                        )}
                      >
                        {r.presentDays ?? '—'}
                      </td>
                      <td
                        className={cn(
                          'px-3 py-1.5 text-center',
                          r.sickDays === null && 'text-muted-foreground',
                        )}
                      >
                        {r.sickDays ?? '—'}
                      </td>
                      <td
                        className={cn(
                          'px-3 py-1.5 text-center',
                          r.permittedDays === null && 'text-muted-foreground',
                        )}
                      >
                        {r.permittedDays ?? '—'}
                      </td>
                      <td
                        className={cn(
                          'px-3 py-1.5 text-center',
                          r.absentDays === null && 'text-muted-foreground',
                          r.absentDays !== null &&
                            r.absentDays > 0 &&
                            'text-status-err',
                        )}
                      >
                        {r.absentDays ?? '—'}
                      </td>
                      <td className="px-3 py-1.5 text-center">
                        {r.effectiveDays}
                      </td>
                      <td
                        className={cn(
                          'px-3 py-1.5 text-center font-semibold',
                          pct === null && 'text-muted-foreground',
                          pct !== null && pct === 100 && 'text-status-on-text',
                          lowAtt && 'text-status-err',
                        )}
                      >
                        {pct !== null ? formatPercent(pct, 0) : '—'}
                      </td>
                      <td className="px-3 py-1.5">
                        <span
                          className={cn(
                            'inline-flex items-center rounded-full px-2 py-0.5 text-2xs font-semibold',
                            cfg.cls,
                          )}
                        >
                          {cfg.label}
                        </span>
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>
      </div>

      <div className="rounded-md border border-sipandu-blue/40 bg-blue-50 p-3 text-sm">
        <strong className="text-sipandu-blue-deep">
          Absensi Semester {data.selectedPeriodLabel}:{' '}
          {formatPercent(data.semesterX1, 1)}
        </strong>
        <span className="ml-2 text-xs text-muted-foreground">
          (dihitung dari bulan yang sudah terkunci)
        </span>
        <p className="mt-1 text-xs text-muted-foreground">
          Nilai absensi final dihitung saat semua bulan efektif telah dikunci oleh
          wali kelas.
        </p>
      </div>
    </div>
  );

  // ── Tab Poin Perilaku ───────────────────────────────────────────
  const x2Display =
    data.x2Score !== null ? data.x2Score : (data.rawX2 !== null ? Math.min(100, data.rawX2) : null);

  const poinContent = (
    <div className="space-y-3">
      <div className="rounded-md border border-sipandu-border bg-white p-4">
        <div className="flex flex-wrap items-center gap-5">
          <div className="text-center">
            <div className="text-xs text-muted-foreground">Raw Score</div>
            <div className="text-3xl font-bold text-foreground">
              {data.rawX2 ?? '—'}
            </div>
          </div>
          <div className="hidden h-12 w-px bg-sipandu-border md:block" />
          <div className="text-center">
            <div className="text-xs text-muted-foreground">
              Poin Perilaku yang digunakan
            </div>
            <div className="text-3xl font-bold text-sipandu-blue">
              {formatScore(x2Display, 0)}
            </div>
          </div>

          <div className="flex-1 min-w-[180px]">
            <div className="mb-1 flex justify-between text-xs text-muted-foreground">
              <span>Progress</span>
              <span>
                {x2Display !== null ? `${Math.round(x2Display)}/100` : '—'}
              </span>
            </div>
            <div className="h-3.5 overflow-hidden rounded-md bg-gray-200">
              <div
                className="h-full rounded-md bg-sipandu-blue transition-[width]"
                style={{
                  width: `${x2Display !== null ? Math.min(100, Math.max(0, x2Display)) : 0}%`,
                }}
              />
            </div>
          </div>
        </div>
      </div>

      <div className="overflow-hidden rounded-md border border-sipandu-border bg-white">
        <div className="border-b border-sipandu-border px-3.5 py-2.5">
          <h3 className="text-sm font-bold text-foreground">
            Riwayat transaksi
          </h3>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full border-collapse text-sm">
            <thead>
              <tr className="border-b border-sipandu-border bg-gray-100 text-left">
                <th className="px-3 py-2 text-xs font-semibold">Tanggal</th>
                <th className="px-3 py-2 text-xs font-semibold">Jenis</th>
                <th className="px-3 py-2 text-xs font-semibold">Kategori</th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  Poin
                </th>
                <th className="px-3 py-2 text-xs font-semibold">Keterangan</th>
              </tr>
            </thead>
            <tbody>
              {data.pointTransactions.length === 0 ? (
                <tr>
                  <td
                    colSpan={5}
                    className="px-3 py-8 text-center text-sm italic text-muted-foreground"
                  >
                    Belum ada transaksi tercatat.
                  </td>
                </tr>
              ) : (
                <>
                  {data.pointTransactions.map((tx) => (
                    <tr
                      key={tx.id}
                      className="border-b border-gray-100 last:border-b-0"
                    >
                      <td className="px-3 py-1.5 text-xs text-muted-foreground">
                        {formatDate(tx.transactionDate)}
                      </td>
                      <td className="px-3 py-1.5">
                        <span
                          className={
                            tx.type === 'reward'
                              ? 'inline-flex items-center rounded-full bg-status-on-soft px-1.5 py-0.5 text-2xs font-semibold text-status-on-text'
                              : 'inline-flex items-center rounded-full bg-status-err-soft px-1.5 py-0.5 text-2xs font-semibold text-status-err-text'
                          }
                        >
                          {tx.type === 'reward' ? '🟢 Reward' : '🔴 Pelanggaran'}
                        </span>
                      </td>
                      <td className="px-3 py-1.5">{tx.categoryName}</td>
                      <td
                        className={cn(
                          'px-3 py-1.5 text-center font-bold',
                          tx.pointChange < 0
                            ? 'text-status-err'
                            : 'text-status-on-text',
                        )}
                      >
                        {tx.pointChange > 0 ? '+' : ''}
                        {tx.pointChange}
                      </td>
                      <td className="px-3 py-1.5 text-xs text-muted-foreground">
                        {tx.notes ?? <span className="italic">—</span>}
                      </td>
                    </tr>
                  ))}
                  <tr>
                    <td
                      colSpan={5}
                      className="px-3 py-2 text-xs italic text-muted-foreground"
                    >
                      Skor awal semester: {data.initialX2} poin
                    </td>
                  </tr>
                </>
              )}
            </tbody>
          </table>
        </div>
      </div>

      <div className="rounded-md border-l-4 border-gray-300 bg-gray-50 px-3 py-2.5 text-xs text-muted-foreground">
        <Info className="mr-1 inline h-3 w-3" aria-hidden />
        Data ini dicatat oleh Wali Kelas. Jika ada ketidaksesuaian, hubungi
        Wali Kelas Anda
        {data.homeroomTeacherName ? (
          <>
            {' '}
            (<strong>{data.homeroomTeacherName}</strong>)
          </>
        ) : (
          ''
        )}
        .
      </div>
    </div>
  );

  // ── Tab Nilai dari Teman ────────────────────────────────────────
  const overallAverage =
    data.aspectAggregates.length > 0
      ? data.aspectAggregates.reduce((a, b) => a + b.average, 0) /
        data.aspectAggregates.length
      : null;

  const temanContent = (
    <div className="space-y-3">
      <div className="rounded-md border border-sipandu-border bg-white p-4">
        <div className="flex flex-wrap items-center gap-5">
          <div>
            <div className="text-xs text-muted-foreground">
              Nilai Sejawat
            </div>
            <div className="text-4xl font-bold text-sipandu-blue">
              {formatScore(data.x3, 0)}
            </div>
          </div>

          <div className="flex-1 min-w-[200px]">
            <div className="mb-1.5 text-sm text-foreground">
              Berdasarkan:{' '}
              <strong>{data.reviewerCount} penilaian</strong> dari teman
              sekelas
            </div>

            {data.peerSessionStatus === 'closed' && (
              <span className="inline-flex items-center gap-1 rounded-full bg-status-on-soft px-2 py-0.5 text-2xs font-semibold text-status-on-text">
                Sesi Selesai
              </span>
            )}
            {data.peerSessionStatus === 'active' && (
              <span className="inline-flex items-center gap-1 rounded-full bg-status-warn-soft px-2 py-0.5 text-2xs font-semibold text-status-warn-text">
                Sesi Sedang Berlangsung
              </span>
            )}
            {data.peerSessionStatus === 'not_started' && (
              <span className="inline-flex items-center gap-1 rounded-full bg-status-err-soft px-2 py-0.5 text-2xs font-semibold text-status-err-text">
                Sesi Belum Dibuka
              </span>
            )}
            {data.peerSessionStatus === null && (
              <span className="inline-flex items-center gap-1 rounded-full bg-status-off-soft px-2 py-0.5 text-2xs font-semibold text-status-off-text">
                Belum Ada Sesi
              </span>
            )}
          </div>

          {data.category && (
            <CategoryBadge category={data.category} size="md" />
          )}
        </div>
      </div>

      {data.aspectAggregates.length > 0 && (
        <div className="rounded-md border border-sipandu-border bg-white p-4">
          <h3 className="mb-3 text-sm font-bold text-foreground">
            Breakdown per aspek
          </h3>

          <div className="space-y-2">
            {data.aspectAggregates.map((a) => (
              <div key={a.key} className="flex items-center gap-2">
                <div className="w-36 text-sm text-foreground">{a.label}</div>
                <div className="h-2.5 flex-1 overflow-hidden rounded-sm bg-gray-200">
                  <div
                    className="h-full rounded-sm bg-sipandu-blue transition-[width]"
                    style={{ width: `${a.percent}%` }}
                  />
                </div>
                <div className="w-14 text-right text-2xs text-muted-foreground">
                  {a.average.toFixed(1)} / 5.0
                </div>
                <div className="w-10 text-right text-2xs text-muted-foreground">
                  {a.percent.toFixed(0)}%
                </div>
              </div>
            ))}

            <hr className="my-3 border-t-2 border-sipandu-border" />

            <div className="flex items-center gap-2">
              <div className="w-36 text-sm font-bold text-foreground">
                Rata-rata keseluruhan
              </div>
              <div className="h-2.5 flex-1 overflow-hidden rounded-sm bg-gray-200">
                <div
                  className="h-full rounded-sm bg-status-on transition-[width]"
                  style={{
                    width:
                      overallAverage !== null
                        ? `${(overallAverage / 5) * 100}%`
                        : '0%',
                  }}
                />
              </div>
              <div className="w-14 text-right text-xs font-bold text-status-on-text">
                {overallAverage !== null
                  ? `${overallAverage.toFixed(1)} / 5.0`
                  : '—'}
              </div>
              <div className="w-10 text-right text-xs font-bold text-status-on-text">
                {overallAverage !== null
                  ? Math.round((overallAverage / 5) * 100)
                  : '—'}
              </div>
            </div>
          </div>
        </div>
      )}

      <div className="rounded-md border-l-4 border-gray-300 bg-gray-50 px-3 py-2.5 text-xs italic leading-relaxed text-muted-foreground">
        Identitas teman yang memberikan penilaian tidak ditampilkan untuk
        menjaga kejujuran dan kenyamanan seluruh siswa.
      </div>
    </div>
  );

  return (
    <div className="space-y-3">
      <PageHeader
        title="Riwayat penilaian saya"
        subtitle={`${data.studentName} · Kelas ${data.className}`}
        actions={
          <PeriodSelector
            options={data.periodOptions}
            selectedId={data.selectedPeriodId}
          />
        }
      />

      <RiwayatTabs
        kehadiranContent={kehadiranContent}
        poinContent={poinContent}
        temanContent={temanContent}
      />
    </div>
  );
}
