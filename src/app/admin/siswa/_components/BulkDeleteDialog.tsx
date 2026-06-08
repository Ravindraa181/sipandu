'use client';

/**
 * @file admin/siswa/_components/BulkDeleteDialog.tsx
 * @description Modal konfirmasi hapus banyak siswa sekaligus.
 *              Menampilkan daftar nama siswa yang akan dihapus dan
 *              peringatan bahwa aksi ini tidak dapat dibatalkan.
 */

import { useTransition } from 'react';
import { Loader2, Trash2, AlertTriangle, Users } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { bulkDeleteStudents } from '@/lib/actions/admin';

export interface BulkDeleteDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  /** ID siswa yang akan dihapus. */
  selectedStudentIds: string[];
  /** Nama siswa untuk ditampilkan di preview (maks 5). */
  selectedStudentNames: string[];
}

export function BulkDeleteDialog({
  open,
  onOpenChange,
  selectedStudentIds,
  selectedStudentNames,
}: BulkDeleteDialogProps) {
  const [pending, startTransition] = useTransition();

  const previewNames = selectedStudentNames.slice(0, 5);
  const extraCount = selectedStudentNames.length - previewNames.length;

  function handleDelete() {
    startTransition(async () => {
      const result = await bulkDeleteStudents(selectedStudentIds);
      if (result.ok) {
        if (result.deletedCount > 0) {
          toast.success(`${result.deletedCount} siswa berhasil dihapus`);
        }
        if (result.errors.length > 0) {
          // Ambil pesan unik dari error (bukan UUID), tampilkan ke user
          const uniqueReasons = [
            ...new Set(result.errors.map((e) => e.split(': ').slice(1).join(': '))),
          ];
          toast.error(`${result.errors.length} siswa gagal dihapus`, {
            description: uniqueReasons[0] ?? 'Terjadi kesalahan pada server.',
          });
        }
        onOpenChange(false);
      } else {
        toast.error('Gagal menghapus siswa', { description: result.error });
      }
    });
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-[480px]">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2 text-red-600">
            <Trash2 className="h-4 w-4" aria-hidden />
            Hapus Siswa
          </DialogTitle>
        </DialogHeader>

        <div className="space-y-4 py-2">
          {/* Preview siswa terpilih */}
          <div className="rounded-md border border-sipandu-border bg-gray-50 p-3">
            <div className="mb-1.5 flex items-center gap-1.5 text-sm font-medium text-foreground">
              <Users className="h-3.5 w-3.5" aria-hidden />
              {selectedStudentIds.length} siswa akan dihapus
            </div>
            <ul className="space-y-0.5 text-xs text-muted-foreground">
              {previewNames.map((name, i) => (
                <li key={i}>• {name}</li>
              ))}
              {extraCount > 0 && (
                <li className="italic">... dan {extraCount} siswa lainnya</li>
              )}
            </ul>
          </div>

          {/* Peringatan */}
          <div className="flex items-start gap-2.5 rounded-md border border-red-200 bg-red-50 p-3 text-sm text-red-700">
            <AlertTriangle className="mt-0.5 h-4 w-4 flex-shrink-0" aria-hidden />
            <p>
              Aksi ini <span className="font-semibold">tidak dapat dibatalkan</span>.
              Seluruh data siswa termasuk riwayat absensi, poin perilaku, dan
              peer assessment akan terhapus secara permanen.
            </p>
          </div>
        </div>

        <DialogFooter className="gap-2 sm:gap-2">
          <Button
            type="button"
            variant="outline"
            onClick={() => onOpenChange(false)}
            disabled={pending}
          >
            Batal
          </Button>
          <Button
            type="button"
            onClick={handleDelete}
            disabled={pending}
            className="bg-red-600 text-white hover:bg-red-700"
          >
            {pending ? (
              <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" aria-hidden />
            ) : (
              <Trash2 className="mr-1.5 h-3.5 w-3.5" aria-hidden />
            )}
            Hapus {selectedStudentIds.length} Siswa
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
