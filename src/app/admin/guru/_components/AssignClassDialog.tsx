/**
 *  Fungsi:
 *   - Menampilkan info guru (NIP, status, email, penugasan saat ini)
 *   - Pilih kelas + periode untuk di-assign
 *   - Deteksi konflik: bila kelas sudah punya wali lain → tampil banner amber
 *     dan minta user centang "Ganti wali" sebelum bisa simpan.
 */

'use client';

/**
 * @file admin/guru/_components/AssignClassDialog.tsx
 * @description Modal "Detail & Assign Wali Kelas" untuk satu guru.
 */

import { useState, useTransition } from 'react';
import { AlertTriangle, Loader2 } from 'lucide-react';
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
// PERBAIKAN: Gunakan import dari fungsi yang tersedia yaitu assignHomeroomTeacher
import { assignHomeroomTeacher } from '@/lib/actions/admin';

export interface ClassOption {
  id: string;
  name: string;
  currentTeacherName: string | null;
}

export interface PeriodOption {
  id: string;
  name: string;
  isActive: boolean;
}

export interface AssignClassDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  teacher: {
    id: string;
    fullName: string;
    nip: string;
    currentAssignment: string | null;
  };
  classes: ClassOption[];
  periods: PeriodOption[];
}

export function AssignClassDialog({
  open,
  onOpenChange,
  teacher,
  classes,
  periods,
}: AssignClassDialogProps) {
  const activePeriodId = periods.find((p) => p.isActive)?.id ?? '';
  
  const [classId, setClassId] = useState<string>('');
  const [periodId, setPeriodId] = useState<string>(activePeriodId);
  const [forceReplace, setForceReplace] = useState(false);
  const [pending, startTransition] = useTransition();

  const selectedClass = classes.find((c) => c.id === classId);
  const hasConflict = selectedClass?.currentTeacherName != null;
  
  const canSubmit = classId && periodId && (!hasConflict || forceReplace);

  function handleSubmit() {
    if (!canSubmit) return;
    
    startTransition(async () => {
      // PERBAIKAN: Pemanggilan berupa object sesuai skema admin.ts
      const result = await assignHomeroomTeacher({
        classId,
        periodId,
        teacherId: teacher.id,
      });

      if (result.ok) {
        toast.success('Wali kelas berhasil ditugaskan');
        onOpenChange(false);
        setClassId('');
        setForceReplace(false);
      } else {
        toast.error('Gagal menugaskan wali kelas', { description: result.error });
      }
    });
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-[450px]">
        <DialogHeader>
          <DialogTitle>Tugaskan Wali Kelas</DialogTitle>
        </DialogHeader>

        <div className="space-y-4 py-2">
          <div className="rounded-md border p-3 text-sm">
            <p className="font-medium">{teacher.fullName}</p>
            <p className="text-muted-foreground">NIP: {teacher.nip}</p>
            {teacher.currentAssignment && (
              <p className="mt-1 text-xs text-sipandu-blue">
                Tugas saat ini: {teacher.currentAssignment}
              </p>
            )}
          </div>

          <div className="grid gap-3">
            <div className="grid gap-1.5">
              <Label>Periode Akademik</Label>
              <Select value={periodId} onValueChange={setPeriodId}>
                <SelectTrigger>
                  <SelectValue placeholder="Pilih periode..." />
                </SelectTrigger>
                <SelectContent>
                  {periods.map((p) => (
                    <SelectItem key={p.id} value={p.id}>
                      {p.name} {p.isActive && '(Aktif)'}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            <div className="grid gap-1.5">
              <Label>Pilih Kelas</Label>
              <Select value={classId} onValueChange={(val) => {
                setClassId(val);
                setForceReplace(false);
              }}>
                <SelectTrigger>
                  <SelectValue placeholder="Pilih kelas..." />
                </SelectTrigger>
                <SelectContent>
                  {classes.map((c) => (
                    <SelectItem key={c.id} value={c.id}>
                      {c.name} {c.currentTeacherName ? `(Diampu: ${c.currentTeacherName})` : ''}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>

          {hasConflict && (
            <div className="flex gap-2.5 rounded-md border border-amber-200 bg-amber-50 p-2.5 text-xs text-amber-800">
              <AlertTriangle className="h-4 w-4 flex-shrink-0" aria-hidden />
              <div>
                Kelas {selectedClass?.name} sudah diampu oleh{' '}
                <strong>{selectedClass?.currentTeacherName}</strong>. Assign ini
                akan memindahkan tugas tersebut.
                <label className="mt-2 flex cursor-pointer items-center gap-1.5 text-xs font-medium">
                  <input
                    type="checkbox"
                    checked={forceReplace}
                    onChange={(e) => setForceReplace(e.target.checked)}
                    className="h-3.5 w-3.5 accent-amber-600"
                  />
                  Ya, ganti wali kelas
                </label>
              </div>
            </div>
          )}
        </div>

        <DialogFooter>
          <Button variant="outline" onClick={() => onOpenChange(false)} disabled={pending}>
            Batal
          </Button>
          <Button 
            onClick={handleSubmit} 
            disabled={pending || !canSubmit}
            className="bg-sipandu-blue text-white hover:bg-sipandu-blue/90"
          >
            {pending && <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" aria-hidden />}
            Simpan Assign
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}