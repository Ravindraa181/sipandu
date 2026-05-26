'use client';

/**
 * @file dashboard/kehadiran/_components/AttendanceTable.tsx
 *
 * FIX TS2353 (103, 125):
 *   saveAttendanceDraft tidak punya prop effectiveDays → hapus dari call
 * FIX TS2345 (142):
 *   lockAttendanceMonth wajib ada effectiveDays → tambahkan ke call
 */

import { useMemo, useState, useTransition } from 'react';
import { Loader2, Lock, Save, AlertCircle } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { ConfirmDialog } from '@/components/shared/ConfirmDialog';
import {
  saveAttendanceDraft,
  lockAttendanceMonth,
  unlockAttendanceMonth,
} from '@/lib/actions/teacher';
import { MIN_ATTENDANCE_PERCENT, MONTHS } from '@/constants';
import { cn } from '@/lib/utils/cn';

export interface AttendanceRowData {
  enrollmentId: string;
  fullName: string;
  presentDays: number;
  sickDays: number;
  permittedDays: number;
  absentDays: number;
}

export interface AttendanceTableProps {
  assignmentId: string;
  month: number;
  year: number;
  effectiveDays: number;
  monthStatus: 'locked' | 'active' | 'upcoming' | 'future';
  initialRows: AttendanceRowData[];
}

export function AttendanceTable({
  assignmentId,
  month,
  year,
  effectiveDays,
  monthStatus,
  initialRows,
}: AttendanceTableProps) {
  const [rows, setRows] = useState<AttendanceRowData[]>(initialRows);
  const [pending, startTransition] = useTransition();

  const isLocked = monthStatus === 'locked';
  const isFuture = monthStatus === 'future';

  /**
   * Hard-navigate ke URL kehadiran bulan ini untuk memaksa full page reload.
   * ALASAN: router.refresh() dan router.replace() ke URL yang sama keduanya
   * tidak andal setelah Server Action — Next.js router meng-intercept atau
   * tidak memicu re-render RSC. window.location.href menjamin browser
   * melakukan request HTTP baru sehingga Server Component pasti re-render.
   */
  function navigateRefresh() {
    window.location.href = `/dashboard/kehadiran?month=${month}&year=${year}`;
  }

  /**
   * Update satu field kehadiran dengan clamp agar total H+S+I+A ≤ hari efektif.
   * Jika nilai yang diinput akan menyebabkan total melebihi hari efektif,
   * nilai di-clamp otomatis dan muncul pesan peringatan.
   */
  function updateField(
    enrollmentId: string,
    key: keyof Omit<AttendanceRowData, 'enrollmentId' | 'fullName'>,
    rawValue: number,
  ) {
    setRows((prev) =>
      prev.map((r) => {
        if (r.enrollmentId !== enrollmentId) return r;

        // Hitung total field lain (selain field yang sedang diubah)
        const KEYS = ['presentDays', 'sickDays', 'permittedDays', 'absentDays'] as const;
        const otherTotal = KEYS.filter((k) => k !== key).reduce((sum, k) => sum + r[k], 0);

        // Maksimum nilai yang diperbolehkan untuk field ini
        const maxAllowed = Math.max(0, effectiveDays - otherTotal);
        const clamped = Math.min(Math.max(0, rawValue), maxAllowed);

        // ALASAN: beri tahu guru jika nilai dikurangi karena melebihi hari efektif
        if (rawValue > maxAllowed) {
          toast.warning(
            `Total H+S+I+A tidak boleh melebihi ${effectiveDays} hari efektif`,
            { id: `clamp-${enrollmentId}` }, // id mencegah toast duplikat saat mengetik cepat
          );
        }

        return { ...r, [key]: clamped };
      }),
    );
  }

  const computedRows = useMemo(
    () =>
      rows.map((r) => {
        const total =
          r.presentDays + r.sickDays + r.permittedDays + r.absentDays;
        const percent =
          effectiveDays > 0
            ? Math.round((r.presentDays / effectiveDays) * 100)
            : 0;
        const totalMatches = total === effectiveDays;
        // ALASAN: tandai jika total melebihi hari efektif (seharusnya tidak terjadi
        // karena clamp, tapi tetap dijaga sebagai pengaman)
        const totalExceeds = total > effectiveDays;
        const lowAttendance = total > 0 && percent < MIN_ATTENDANCE_PERCENT;
        const isFilled = total > 0;
        return { ...r, total, percent, totalMatches, totalExceeds, lowAttendance, isFilled };
      }),
    [rows, effectiveDays],
  );

  // ALASAN: semua siswa WAJIB terisi (bukan hanya yang sudah diisi).
  // Kondisi sebelumnya (!r.isFilled || r.totalMatches) membolehkan baris kosong
  // lolos validasi, sehingga siswa belum diisi tetap bisa dikunci.
  const allValid = computedRows.every((r) => r.totalMatches);
  const emptyCount = computedRows.filter((r) => !r.isFilled).length;
  const mismatchCount = computedRows.filter((r) => r.isFilled && !r.totalMatches).length;

  function handleSaveDraft() {
    startTransition(async () => {
      const result = await saveAttendanceDraft({
        assignmentId,
        month,
        year,
        // FIX: sertakan effectiveDays agar kolom NOT NULL di DB tidak null saat INSERT
        effectiveDays,
        rows: rows.map((r) => ({
          enrollmentId: r.enrollmentId,
          presentDays: r.presentDays,
          sickDays: r.sickDays,
          permittedDays: r.permittedDays,
          absentDays: r.absentDays,
        })),
      });
      if (result.ok) toast.success('Draft kehadiran tersimpan');
      else toast.error('Gagal menyimpan draft', { description: result.error });
    });
  }

  function handleLockMonth(): Promise<void> {
    return new Promise((resolve) => {
      startTransition(async () => {
        const saveResult = await saveAttendanceDraft({
          assignmentId,
          month,
          year,
          // FIX: sertakan effectiveDays agar kolom NOT NULL di DB tidak null saat INSERT
          effectiveDays,
          rows: rows.map((r) => ({
            enrollmentId: r.enrollmentId,
            presentDays: r.presentDays,
            sickDays: r.sickDays,
            permittedDays: r.permittedDays,
            absentDays: r.absentDays,
          })),
        });
        if (!saveResult.ok) {
          toast.error('Gagal simpan sebelum kunci', {
            description: saveResult.error,
          });
          resolve();
          return;
        }

        // FIX: tambahkan effectiveDays — wajib di schema lockAttendanceMonth
        const lockResult = await lockAttendanceMonth({
          assignmentId,
          month,
          year,
          effectiveDays, // FIX: prop sudah ada dari AttendanceTableProps
        });
        if (lockResult.ok) {
          toast.success(`Kehadiran ${MONTHS[month - 1]} ${year} terkunci`);
          navigateRefresh();
        } else {
          toast.error('Gagal mengunci', { description: lockResult.error });
        }
        resolve();
      });
    });
  }

  /** Buka kunci bulan agar data bisa diedit kembali untuk koreksi. */
  function handleUnlock(): Promise<void> {
    return new Promise((resolve) => {
      startTransition(async () => {
        const result = await unlockAttendanceMonth({ assignmentId, month, year });
        if (result.ok) {
          toast.success(`Kunci ${MONTHS[month - 1]} ${year} dibuka — data dapat diedit kembali`);
          navigateRefresh();
        } else {
          toast.error('Gagal membuka kunci', { description: result.error });
        }
        resolve();
      });
    });
  }

  return (
    <>
      <div className="overflow-hidden rounded-md border border-sipandu-border bg-white">
        <div className="overflow-x-auto">
          <table className="w-full border-collapse text-sm">
            <thead>
              <tr className="border-b border-sipandu-border bg-gray-100 text-left">
                <th className="w-10 px-3 py-2 text-xs font-semibold">No</th>
                <th className="px-3 py-2 text-xs font-semibold">Nama Siswa</th>
                <th className="px-3 py-2 text-center text-xs font-semibold">Hadir</th>
                <th className="px-3 py-2 text-center text-xs font-semibold">Sakit</th>
                <th className="px-3 py-2 text-center text-xs font-semibold">Izin</th>
                <th className="px-3 py-2 text-center text-xs font-semibold">Alpa</th>
                <th className="px-3 py-2 text-center text-xs font-semibold">Total</th>
                <th className="px-3 py-2 text-center text-xs font-semibold">% Kehadiran</th>
              </tr>
            </thead>
            <tbody>
              {computedRows.map((r, i) => (
                <tr
                  key={r.enrollmentId}
                  className={cn(
                    'border-b border-gray-100 last:border-b-0',
                    r.isFilled && !r.totalMatches && !isLocked && 'bg-amber-50',
                    r.totalExceeds && !isLocked && 'bg-red-50',
                  )}
                >
                  <td className="px-3 py-1.5 text-center text-muted-foreground">
                    {i + 1}
                  </td>
                  <td className="px-3 py-1.5 font-medium text-foreground">
                    {r.fullName}
                  </td>
                  {(
                    [
                      'presentDays',
                      'sickDays',
                      'permittedDays',
                      'absentDays',
                    ] as const
                  ).map((key) => (
                    <td key={key} className="px-2 py-1.5 text-center">
                      <Input
                        type="number"
                        min={0}
                        max={effectiveDays}
                        value={r[key] || ''}
                        disabled={isLocked || isFuture}
                        onChange={(e) =>
                          updateField(
                            r.enrollmentId,
                            key,
                            Math.max(0, Number(e.target.value)),
                          )
                        }
                        className="mx-auto h-7 w-14 px-1 text-center text-xs"
                      />
                    </td>
                  ))}
                  <td
                    className={cn(
                      'px-3 py-1.5 text-center font-semibold',
                      r.totalExceeds && !isLocked && 'text-status-err',
                      r.isFilled && !r.totalMatches && !r.totalExceeds && !isLocked && 'text-status-warn-text',
                    )}
                  >
                    {r.isFilled
                      ? `${r.total}/${effectiveDays}`
                      : `0/${effectiveDays}`}
                    {r.totalExceeds && !isLocked && (
                      <AlertCircle className="ml-1 inline h-3 w-3 text-status-err" aria-hidden />
                    )}
                  </td>
                  <td
                    className={cn(
                      'px-3 py-1.5 text-center font-semibold',
                      !r.isFilled && 'text-muted-foreground',
                      r.lowAttendance && 'text-status-err',
                    )}
                  >
                    {r.isFilled ? `${r.percent}%` : '—'}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {monthStatus === 'active' && (
        <div className="mt-3.5 flex flex-wrap items-center gap-2">
          <Button
            type="button"
            variant="outline"
            onClick={handleSaveDraft}
            disabled={pending}
            className="gap-1.5"
          >
            {pending && (
              <Loader2 className="h-3.5 w-3.5 animate-spin" aria-hidden />
            )}
            <Save className="h-3.5 w-3.5" aria-hidden /> Simpan Draft
          </Button>

          <ConfirmDialog
            trigger={
              <Button
                type="button"
                disabled={pending || !allValid}
                className="gap-1.5 bg-sipandu-blue text-white hover:bg-sipandu-blue/90"
              >
                <Lock className="h-3.5 w-3.5" aria-hidden /> Simpan &amp; Kunci
                Bulan Ini
              </Button>
            }
            title={`Kunci data kehadiran ${MONTHS[month - 1]} ${year}?`}
            description="Setelah dikunci, data tidak dapat diubah kembali. Pastikan semua input sudah benar."
            confirmLabel="Ya, Kunci Sekarang"
            variant="warning"
            onConfirm={handleLockMonth}
          />

          {/* Pesan validasi — tampilkan detail spesifik agar guru tahu apa yang kurang */}
          {!allValid && (
            <span className="flex items-center gap-1 text-xs text-status-warn-text">
              <AlertCircle className="h-3.5 w-3.5 shrink-0" aria-hidden />
              {emptyCount > 0 && mismatchCount > 0
                ? `${emptyCount} siswa belum diisi dan ${mismatchCount} siswa totalnya tidak pas.`
                : emptyCount > 0
                  ? `${emptyCount} siswa belum diisi (total harus = ${effectiveDays} hari).`
                  : `${mismatchCount} siswa totalnya tidak pas (harus = ${effectiveDays} hari).`}
              {' '}Lengkapi semua data sebelum mengunci.
            </span>
          )}
        </div>
      )}

      {/* Tombol Buka Kunci — hanya tampil saat bulan sudah terkunci */}
      {monthStatus === 'locked' && (
        <div className="mt-3.5 flex items-center gap-3">
          <ConfirmDialog
            trigger={
              <Button
                type="button"
                variant="outline"
                disabled={pending}
                className="gap-1.5 border-status-warn text-status-warn-text hover:bg-amber-50"
              >
                {pending && (
                  <Loader2 className="h-3.5 w-3.5 animate-spin" aria-hidden />
                )}
                <Lock className="h-3.5 w-3.5" aria-hidden />
                Buka Kunci untuk Koreksi
              </Button>
            }
            title={`Buka kunci ${MONTHS[month - 1]} ${year}?`}
            description="Data kehadiran bulan ini akan dibuka kembali sehingga dapat diedit. Setelah selesai koreksi, kunci kembali data tersebut."
            confirmLabel="Ya, Buka Kunci"
            variant="warning"
            onConfirm={handleUnlock}
          />
          <span className="text-xs text-muted-foreground">
            Gunakan fitur ini hanya jika terdapat kesalahan input yang perlu dikoreksi.
          </span>
        </div>
      )}
    </>
  );
}
