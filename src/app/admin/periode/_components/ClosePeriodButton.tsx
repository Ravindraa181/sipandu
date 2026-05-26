'use client';

/**
 * @file admin/periode/_components/ClosePeriodButton.tsx
 * @description Tombol "Tutup Periode" dengan ConfirmDialog.
 *              Setelah konfirmasi → call closePeriod server action.
 */

import { useTransition } from 'react';
import { Lock } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import { ConfirmDialog } from '@/components/shared/ConfirmDialog';
import { closePeriod } from '@/lib/actions/admin';

export interface ClosePeriodButtonProps {
  periodId: string;
  periodName: string;
}

export function ClosePeriodButton({
  periodId,
  periodName,
}: ClosePeriodButtonProps) {
  const [pending, startTransition] = useTransition();

  function handleConfirm(): Promise<void> {
    return new Promise((resolve) => {
      startTransition(async () => {
        const result = await closePeriod(periodId);
        if (result.ok) {
          toast.success(`Periode ${periodName} berhasil ditutup`);
        } else {
          toast.error('Gagal menutup periode', { description: result.error });
        }
        resolve();
      });
    });
  }

  return (
    <ConfirmDialog
      trigger={
        <Button
          variant="outline"
          size="sm"
          className="gap-1.5 border-status-err text-status-err hover:bg-red-50"
          disabled={pending}
        >
          <Lock className="h-3 w-3" aria-hidden /> Tutup Periode
        </Button>
      }
      title={`Tutup periode ${periodName}?`}
      description="Periode yang ditutup akan diarsipkan dan tidak dapat diubah lagi. Semua data observasi akan menjadi read-only."
      confirmLabel="Ya, Tutup Periode"
      cancelLabel="Batal"
      variant="destructive"
      onConfirm={handleConfirm}
    />
  );
}
