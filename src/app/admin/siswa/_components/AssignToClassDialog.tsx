'use client';

/**
 * @file admin/siswa/_components/AssignToClassDialog.tsx
 * @description Modal assign satu siswa ke kelas pada periode aktif.
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
import { assignStudentsToClass } from '@/lib/actions/admin';

export interface AssignToClassDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  studentId: string;
  studentName: string;
  currentClassName: string | null;
  classOptions: Array<{ id: string; name: string }>;
}

export function AssignToClassDialog({
  open,
  onOpenChange,
  studentId,
  studentName,
  currentClassName,
  classOptions,
}: AssignToClassDialogProps) {
  const [pending, startTransition] = useTransition();
  const [classId, setClassId] = useState('');

  function handleSubmit() {
    if (!classId) {
      toast.error('Pilih kelas tujuan');
      return;
    }
    startTransition(async () => {
      const result = await assignStudentsToClass({ studentIds: [studentId], classId });
      if (result.ok) {
        toast.success(`${studentName} berhasil di-assign ke kelas`);
        onOpenChange(false);
      } else {
        toast.error('Gagal assign ke kelas', { description: result.error });
      }
    });
  }

  const isReassign = Boolean(currentClassName);

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-[425px]">
        <DialogHeader>
          <DialogTitle>
            {isReassign ? 'Pindahkan Kelas Siswa' : 'Assign Siswa ke Kelas'}
          </DialogTitle>
        </DialogHeader>

        <div className="space-y-4 py-2">
          <div className="rounded-md border p-3 text-sm">
            <p className="font-medium">{studentName}</p>
            {currentClassName && (
              <p className="text-muted-foreground">Kelas saat ini: {currentClassName}</p>
            )}
          </div>

          <div className="grid gap-1.5">
            <Label htmlFor="classSelect">
              {isReassign ? 'Pindah ke Kelas' : 'Pilih Kelas'}
            </Label>
            <Select value={classId} onValueChange={setClassId}>
              <SelectTrigger id="classSelect">
                <SelectValue placeholder="— Pilih kelas —" />
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
            {isReassign
              ? 'Riwayat skor di kelas lama tetap tersimpan. Poin perilaku di-reset ke nilai awal di kelas baru.'
              : 'Siswa akan didaftarkan ke kelas yang dipilih pada periode aktif saat ini.'}
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
            {isReassign ? 'Pindahkan' : 'Assign'}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
