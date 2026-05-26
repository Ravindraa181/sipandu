'use client';

/**
 * @file admin/periode/_components/DeletePeriodButton.tsx
 * @description Tombol hapus periode — hanya aktif jika totalClasses === 0.
 */

import { useTransition } from 'react';
import { Trash2 } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import { ConfirmDialog } from '@/components/shared/ConfirmDialog';
import { deletePeriod } from '@/lib/actions/admin';

export interface DeletePeriodButtonProps {
  periodId: string;
  periodName: string;
  /** Jika true, periode punya data kelas/siswa — tampilkan peringatan lebih keras. */
  hasData?: boolean;
}

export function DeletePeriodButton({ periodId, periodName, hasData = false }: DeletePeriodButtonProps) {
  const [pending, startTransition] = useTransition();

  function handleConfirm(): Promise<void> {
    return new Promise((resolve) => {
      startTransition(async () => {
        const result = await deletePeriod(periodId);
        if (result.ok) {
          toast.success(`Periode ${periodName} berhasil dihapus`);
        } else {
          toast.error('Gagal menghapus periode', { description: result.error });
        }
        resolve();
      });
    });
  }

  const description = hasData
    ? `Semua data terkait periode ini — termasuk kehadiran, poin perilaku, dan peer review — akan ikut terhapus secara permanen dan tidak bisa dibatalkan.`
    : `Periode ini belum memiliki data. Menghapusnya permanen dan tidak bisa dibatalkan.`;

  return (
    <ConfirmDialog
      trigger={
        <Button
          variant="ghost"
          size="icon"
          className="h-7 w-7 text-status-err hover:bg-red-50"
          disabled={pending}
          title="Hapus periode"
        >
          <Trash2 className="h-3.5 w-3.5" aria-hidden />
        </Button>
      }
      title={`Hapus periode ${periodName}?`}
      description={description}
      confirmLabel="Ya, Hapus Permanen"
      cancelLabel="Batal"
      variant="destructive"
      onConfirm={handleConfirm}
    />
  );
}