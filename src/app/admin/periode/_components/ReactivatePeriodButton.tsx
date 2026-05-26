'use client';

/**
 * @file admin/periode/_components/ReactivatePeriodButton.tsx
 * @description Tombol "Aktifkan Kembali" untuk periode berstatus closed atau archived.
 *              Periode aktif yang ada saat ini akan otomatis ditutup (constraint 1 aktif).
 */

import { useTransition } from 'react';
import { RotateCcw } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import { ConfirmDialog } from '@/components/shared/ConfirmDialog';
import { reactivatePeriod } from '@/lib/actions/admin';

export interface ReactivatePeriodButtonProps {
  periodId: string;
  periodName: string;
  /** Nama periode aktif saat ini, jika ada — ditampilkan di pesan konfirmasi. */
  activePeriodName?: string;
}

export function ReactivatePeriodButton({
  periodId,
  periodName,
  activePeriodName,
}: ReactivatePeriodButtonProps) {
  const [pending, startTransition] = useTransition();

  function handleConfirm(): Promise<void> {
    return new Promise((resolve) => {
      startTransition(async () => {
        const result = await reactivatePeriod(periodId);
        if (result.ok) {
          toast.success(`Periode ${periodName} berhasil diaktifkan kembali`);
        } else {
          toast.error('Gagal mengaktifkan periode', { description: result.error });
        }
        resolve();
      });
    });
  }

  const description = activePeriodName
    ? `Periode "${activePeriodName}" yang sedang aktif akan otomatis ditutup. Periode "${periodName}" akan menjadi periode aktif yang baru.`
    : `Periode "${periodName}" akan menjadi periode aktif. Semua input kehadiran dan poin perilaku akan kembali bisa diisi.`;

  return (
    <ConfirmDialog
      trigger={
        <Button
          variant="ghost"
          size="icon"
          className="h-7 w-7 text-sipandu-blue hover:bg-blue-50"
          disabled={pending}
          title="Aktifkan kembali periode"
        >
          <RotateCcw className="h-3.5 w-3.5" aria-hidden />
        </Button>
      }
      title={`Aktifkan kembali periode ${periodName}?`}
      description={description}
      confirmLabel="Ya, Aktifkan"
      cancelLabel="Batal"
      variant="warning"
      onConfirm={handleConfirm}
    />
  );
}
