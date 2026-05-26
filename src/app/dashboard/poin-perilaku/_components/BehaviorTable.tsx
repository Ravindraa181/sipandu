'use client';

import React from 'react';

/**
 * @file dashboard/poin-perilaku/_components/BehaviorTable.tsx
 * @description Tabel siswa: raw score, X2 (capped 100), progress bar
 *              berwarna, tombol Reward & Pelanggaran. Klik nama siswa
 *              → expand baris detail riwayat 10 transaksi terakhir.
 *              Setiap baris riwayat memiliki tombol "Batalkan" (soft delete)
 *              yang membalik delta poin via DB trigger secara otomatis.
 */

import { useState, useTransition } from 'react';
import { ChevronDown, Minus, Plus, XCircle } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import { ConfirmDialog } from '@/components/shared/ConfirmDialog';
import { cn } from '@/lib/utils/cn';
import { formatDate } from '@/lib/utils/format';
import { cancelTransaction } from '@/lib/actions/teacher';
import {
  TransactionDialog,
  type TransactionCategory,
} from './TransactionDialog';

export interface TransactionHistory {
  id: string;
  type: 'violation' | 'reward';
  categoryName: string;
  /** Negatif untuk pelanggaran, positif untuk reward. */
  pointChange: number;
  rawAfter: number;
  transactionDate: string;
  notes: string | null;
  recordedByName: string;
}

export interface BehaviorRow {
  enrollmentId: string;
  studentId: string;
  fullName: string;
  rawScore: number;
  /** = min(rawScore, 100). */
  x2: number;
  hasBuffer: boolean;
  /** Riwayat 10 transaksi terakhir. */
  history: TransactionHistory[];
}

export interface BehaviorTableProps {
  assignmentId: string;
  rows: BehaviorRow[];
  violationCategories: TransactionCategory[];
  rewardCategories: TransactionCategory[];
}

function getProgressColor(percent: number): string {
  if (percent >= 85) return '#16A34A';
  if (percent >= 70) return '#2D7DD2';
  if (percent >= 55) return '#D97706';
  return '#DC2626';
}

export function BehaviorTable({
  assignmentId,
  rows,
  violationCategories,
  rewardCategories,
}: BehaviorTableProps) {
  const [expanded, setExpanded] = useState<Set<string>>(new Set());
  const [violationTarget, setViolationTarget] = useState<BehaviorRow | null>(null);
  const [rewardTarget, setRewardTarget] = useState<BehaviorRow | null>(null);
  const [pending, startTransition] = useTransition();

  /**
   * Batalkan satu transaksi via soft delete.
   * DB trigger otomatis membalik points_delta dari raw_score siswa.
   * Setelah berhasil, reload halaman agar tabel skor ter-refresh.
   */
  function handleCancel(transactionId: string, desc: string): Promise<void> {
    return new Promise((resolve) => {
      startTransition(async () => {
        const result = await cancelTransaction({ transactionId });
        if (result.ok) {
          toast.success(`Transaksi "${desc}" berhasil dibatalkan — skor otomatis disesuaikan`);
          window.location.reload();
        } else {
          toast.error('Gagal membatalkan transaksi', { description: result.error });
        }
        resolve();
      });
    });
  }

  function toggleExpand(id: string) {
    setExpanded((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  }

  return (
    <>
      <div className="overflow-hidden rounded-md border border-sipandu-border bg-white">
        <div className="overflow-x-auto">
          <table className="w-full border-collapse text-sm">
            <thead>
              <tr className="border-b border-sipandu-border bg-gray-100 text-left">
                <th className="w-12 px-3 py-2 text-center text-xs font-semibold">
                  No
                </th>
                <th className="px-3 py-2 text-xs font-semibold">
                  Nama Siswa
                </th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  Raw Score
                </th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  X2
                </th>
                <th className="min-w-[120px] px-3 py-2 text-xs font-semibold">
                  Progress
                </th>
                <th className="px-3 py-2 text-xs font-semibold">Aksi</th>
              </tr>
            </thead>
            <tbody>
              {rows.length === 0 ? (
                <tr>
                  <td
                    colSpan={6}
                    className="px-3 py-10 text-center text-sm italic text-muted-foreground"
                  >
                    Belum ada siswa di kelas ini.
                  </td>
                </tr>
              ) : (
                rows.map((r, i) => {
                  const isExpanded = expanded.has(r.enrollmentId);
                  const progressPct = r.x2;
                  return (
                    // ALASAN: key harus di Fragment terluar, bukan di <tr> di dalamnya
                    <React.Fragment key={r.enrollmentId}>
                      <tr
                        className="border-b border-gray-100 hover:bg-blue-50/40"
                      >
                        <td className="px-3 py-1.5 text-center text-muted-foreground">
                          {i + 1}
                        </td>
                        <td className="px-3 py-1.5">
                          <button
                            type="button"
                            onClick={() => toggleExpand(r.enrollmentId)}
                            className="flex items-center gap-1.5 font-medium text-sipandu-blue hover:underline"
                          >
                            {r.fullName}
                            <ChevronDown
                              className={cn(
                                'h-3 w-3 transition-transform',
                                isExpanded && 'rotate-180',
                              )}
                              aria-hidden
                            />
                          </button>
                        </td>
                        <td className="px-3 py-1.5 text-center font-bold">
                          {r.rawScore}
                          {r.hasBuffer && (
                            <span
                              title={`Raw ${r.rawScore}, X2 tetap 100`}
                              className="ml-1.5 inline-flex items-center rounded-full bg-status-warn-soft px-1.5 py-0.5 text-2xs font-semibold text-status-warn-text"
                            >
                              ⚠ buffer
                            </span>
                          )}
                        </td>
                        <td className="px-3 py-1.5 text-center font-bold text-sipandu-blue">
                          {r.x2}
                        </td>
                        <td className="px-3 py-1.5">
                          <div className="flex items-center gap-1.5">
                            <div className="h-2.5 flex-1 overflow-hidden rounded-sm bg-gray-200">
                              <div
                                className="h-full rounded-sm transition-[width]"
                                style={{
                                  width: `${progressPct}%`,
                                  backgroundColor: getProgressColor(progressPct),
                                }}
                              />
                            </div>
                            <span className="w-8 text-2xs text-muted-foreground">
                              {progressPct}%
                            </span>
                          </div>
                        </td>
                        <td className="whitespace-nowrap px-3 py-1.5">
                          <div className="flex flex-wrap gap-1">
                            <Button
                              size="sm"
                              onClick={() => setRewardTarget(r)}
                              className="gap-1 bg-status-on text-white hover:bg-status-on/90"
                            >
                              <Plus className="h-3 w-3" aria-hidden /> Reward
                            </Button>
                            <Button
                              size="sm"
                              variant="outline"
                              onClick={() => setViolationTarget(r)}
                              className="gap-1 border-status-err text-status-err hover:bg-red-50"
                            >
                              <Minus className="h-3 w-3" aria-hidden />{' '}
                              Pelanggaran
                            </Button>
                          </div>
                        </td>
                      </tr>

                      {isExpanded && (
                        <tr key={`${r.enrollmentId}-history`}>
                          <td colSpan={6} className="bg-gray-50 p-0">
                            <div className="px-3.5 py-3">
                              <div className="mb-2 text-xs font-semibold text-foreground">
                                Riwayat transaksi — {r.fullName}{' '}
                                <span className="font-normal text-muted-foreground">
                                  (10 terakhir)
                                </span>
                              </div>

                              {r.history.length === 0 ? (
                                <p className="rounded-md border border-sipandu-border bg-white py-4 text-center text-xs italic text-muted-foreground">
                                  Belum ada riwayat transaksi untuk{' '}
                                  {r.fullName}.
                                </p>
                              ) : (
                                <div className="overflow-hidden rounded-md border border-sipandu-border bg-white">
                                  <table className="w-full border-collapse text-sm">
                                    <thead>
                                      <tr className="border-b border-sipandu-border bg-gray-100 text-left">
                                        <th className="px-3 py-1 text-2xs font-semibold">Tanggal</th>
                                        <th className="px-3 py-1 text-2xs font-semibold">Jenis</th>
                                        <th className="px-3 py-1 text-2xs font-semibold">Kategori</th>
                                        <th className="px-3 py-1 text-2xs font-semibold">Poin</th>
                                        <th className="px-3 py-1 text-2xs font-semibold">Raw Setelah</th>
                                        <th className="px-3 py-1 text-2xs font-semibold">Dicatat oleh</th>
                                        <th className="px-3 py-1 text-2xs font-semibold">Aksi</th>
                                      </tr>
                                    </thead>
                                    <tbody>
                                      {r.history.map((tx) => (
                                        <tr
                                          key={tx.id}
                                          className="border-b border-gray-100 last:border-b-0"
                                        >
                                          <td className="px-3 py-1 text-2xs">
                                            {formatDate(tx.transactionDate)}
                                          </td>
                                          <td className="px-3 py-1">
                                            <span
                                              className={cn(
                                                'inline-flex items-center rounded-full px-1.5 py-0.5 text-2xs font-semibold',
                                                tx.type === 'violation'
                                                  ? 'bg-status-err-soft text-status-err-text'
                                                  : 'bg-status-on-soft text-status-on-text',
                                              )}
                                            >
                                              {tx.type === 'violation'
                                                ? '🔴 Pelanggaran'
                                                : '🟢 Reward'}
                                            </span>
                                          </td>
                                          <td className="px-3 py-1 text-2xs">
                                            {tx.categoryName}
                                          </td>
                                          <td
                                            className={cn(
                                              'px-3 py-1 text-2xs font-bold',
                                              tx.pointChange < 0
                                                ? 'text-status-err'
                                                : 'text-status-on-text',
                                            )}
                                          >
                                            {tx.pointChange > 0 ? '+' : ''}
                                            {tx.pointChange}
                                          </td>
                                          <td className="px-3 py-1 text-center text-2xs font-semibold">
                                            {tx.rawAfter}
                                          </td>
                                          <td className="px-3 py-1 text-2xs text-muted-foreground">
                                            {tx.recordedByName}
                                          </td>
                                          <td className="px-3 py-1">
                                            <ConfirmDialog
                                              trigger={
                                                <Button
                                                  size="sm"
                                                  variant="ghost"
                                                  disabled={pending}
                                                  className="h-6 gap-1 px-2 text-2xs text-status-err hover:bg-red-50 hover:text-status-err"
                                                >
                                                  <XCircle className="h-3 w-3" aria-hidden />
                                                  Batalkan
                                                </Button>
                                              }
                                              title="Batalkan transaksi ini?"
                                              description={`Transaksi "${tx.categoryName}" (${tx.pointChange > 0 ? '+' : ''}${tx.pointChange} poin) akan dibatalkan. Poin siswa akan otomatis dikembalikan ke nilai sebelumnya.`}
                                              confirmLabel="Ya, Batalkan"
                                              variant="destructive"
                                              onConfirm={() =>
                                                handleCancel(tx.id, tx.categoryName)
                                              }
                                            />
                                          </td>
                                        </tr>
                                      ))}
                                    </tbody>
                                  </table>
                                </div>
                              )}
                            </div>
                          </td>
                        </tr>
                      )}
                    </React.Fragment>
                  );
                })
              )}
            </tbody>
          </table>
        </div>
      </div>

      {violationTarget && (
        <TransactionDialog
          open={Boolean(violationTarget)}
          onOpenChange={(o) => !o && setViolationTarget(null)}
          type="violation"
          studentName={violationTarget.fullName}
          enrollmentId={violationTarget.enrollmentId}
          assignmentId={assignmentId}
          currentRaw={violationTarget.rawScore}
          categories={violationCategories}
        />
      )}
      {rewardTarget && (
        <TransactionDialog
          open={Boolean(rewardTarget)}
          onOpenChange={(o) => !o && setRewardTarget(null)}
          type="reward"
          studentName={rewardTarget.fullName}
          enrollmentId={rewardTarget.enrollmentId}
          assignmentId={assignmentId}
          currentRaw={rewardTarget.rawScore}
          categories={rewardCategories}
        />
      )}
    </>
  );
}
