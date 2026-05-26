'use client';

/**
 * @file admin/kelas/_components/TransferStudentDialog.tsx
 * @description Modal pindahkan satu siswa ke kelas lain pada periode aktif.
 */

import { useState, useTransition } from 'react';
import { Loader2 } from 'lucide-react';
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
// PERBAIKAN: Gunakan fungsi enrollStudent yang diekspor oleh admin.ts
import { enrollStudent } from '@/lib/actions/admin';

export interface TransferStudentDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  studentId: string;
  studentName: string;
  fromAssignmentId: string;
  fromClassName: string;
  /** Daftar assignment lain di periode aktif untuk dipilih. */
  targetAssignments: Array<{ assignmentId: string; className: string }>;
}

export function TransferStudentDialog({
  open,
  onOpenChange,
  studentId,
  studentName,
  fromAssignmentId,
  fromClassName,
  targetAssignments,
}: TransferStudentDialogProps) {
  const [pending, startTransition] = useTransition();
  const [toAssignmentId, setToAssignmentId] = useState('');

  function handleSubmit() {
    if (!toAssignmentId) {
      toast.error('Pilih kelas tujuan');
      return;
    }

    startTransition(async () => {
      // PERBAIKAN: Panggil enrollStudent dan sesuaikan argumen assignmentId
      const result = await enrollStudent({
        studentId,
        assignmentId: toAssignmentId,
      });

      if (result.ok) {
        toast.success(`Siswa ${studentName} berhasil dipindahkan`);
        onOpenChange(false);
      } else {
        toast.error('Gagal memindahkan siswa', { description: result.error });
      }
    });
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-[425px]">
        <DialogHeader>
          <DialogTitle>Pindahkan Kelas Siswa</DialogTitle>
        </DialogHeader>

        <div className="space-y-4 py-2">
          <div className="rounded-md border p-3 text-sm">
            <p className="font-medium">{studentName}</p>
            <p className="text-muted-foreground">Dari: {fromClassName}</p>
          </div>

          <div className="grid gap-1.5">
            <Label htmlFor="toAssignment">Pindah ke Kelas Tujuan</Label>
            <Select value={toAssignmentId} onValueChange={setToAssignmentId}>
              <SelectTrigger id="toAssignment">
                <SelectValue placeholder="— Pilih kelas tujuan —" />
              </SelectTrigger>
              <SelectContent>
                {targetAssignments.map((a) => (
                  <SelectItem key={a.assignmentId} value={a.assignmentId}>
                    {a.className}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          <p className="rounded-md bg-blue-50 p-2.5 text-xs text-sipandu-blue-deep">
            Riwayat skor di kelas lama tetap tersimpan. Skor poin perilaku
            di-reset ke nilai awal di kelas baru.
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
            disabled={pending || !toAssignmentId}
            className="bg-sipandu-blue text-white hover:bg-sipandu-blue/90"
          >
            {pending && (
              <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" aria-hidden />
            )}
            Pindahkan
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}