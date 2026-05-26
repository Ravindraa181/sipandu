'use client';

/**
 * @file admin/siswa/_components/BulkAssignDialog.tsx
 * @description Modal assign banyak siswa ke satu kelas sekaligus pada periode aktif.
 */

import { useState, useTransition } from 'react';
import { Loader2, Users } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import { Label } from '@/components/ui/label';
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { assignStudentsToClass } from '@/lib/actions/admin';

export interface BulkAssignDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  /** ID siswa yang dipilih. */
  selectedStudentIds: string[];
  /** Nama singkat untuk preview (maks 5 tampil). */
  selectedStudentNames: string[];
  classOptions: Array<{ id: string; name: string }>;
}

export function BulkAssignDialog({
  open,
  onOpenChange,
  selectedStudentIds,
  selectedStudentNames,
  classOptions,
}: BulkAssignDialogProps) {
  const [pending, startTransition] = useTransition();
  const [classId, setClassId] = useState('');

  const previewNames = selectedStudentNames.slice(0, 5);
  const extraCount = selectedStudentNames.length - previewNames.length;

  function handleSubmit() {
    if (!classId) {
      toast.error('Pilih kelas tujuan');
      return;
    }
    startTransition(async () => {
      const result = await assignStudentsToClass({
        studentIds: selectedStudentIds,
        classId,
      });
      if (result.ok) {
        toast.success(`${result.data?.enrolled} siswa berhasil di-assign ke kelas`);
        onOpenChange(false);
      } else {
        toast.error('Gagal assign ke kelas', { description: result.error });
      }
    });
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-[480px]">
        <DialogHeader>
          <DialogTitle>Assign Siswa ke Kelas</DialogTitle>
        </DialogHeader>

        <div className="space-y-4 py-2">
          {/* Preview siswa terpilih */}
          <div className="rounded-md border border-sipandu-border bg-gray-50 p-3">
            <div className="mb-1.5 flex items-center gap-1.5 text-sm font-medium text-foreground">
              <Users className="h-3.5 w-3.5" aria-hidden />
              {selectedStudentIds.length} siswa dipilih
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

          <div className="grid gap-1.5">
            <Label htmlFor="bulkClassSelect">Assign ke Kelas</Label>
            <Select value={classId} onValueChange={setClassId}>
              <SelectTrigger id="bulkClassSelect">
                <SelectValue placeholder="— Pilih kelas tujuan —" />
              </SelectTrigger>
              <SelectContent>
                {classOptions.map((c) => (
                  <SelectItem key={c.id} value={c.id}>
                    {c.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          <p className="rounded-md bg-blue-50 p-2.5 text-xs text-sipandu-blue-deep">
            Siswa yang sudah terdaftar di kelas lain akan dipindahkan ke kelas baru.
            Riwayat skor lama tetap tersimpan.
          </p>
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
            onClick={handleSubmit}
            disabled={pending || !classId}
            className="bg-sipandu-blue text-white hover:bg-sipandu-blue/90"
          >
            {pending && (
              <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" aria-hidden />
            )}
            Assign {selectedStudentIds.length} Siswa
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
