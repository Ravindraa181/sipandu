'use client';

/**
 * @file admin/periode/_components/EditEffectiveDaysDialog.tsx
 *
 * FIX TS2353: `monthlyDays` tidak ada di tipe updateEffectiveDays.
 *   updateEffectiveDays menerima satu entri per pemanggilan
 *   { periodId, month, year, effectiveDays }.
 *   Solusi: loop melalui setiap bulan dan panggil action satu per satu.
 */

import { useState, useTransition } from 'react';
import { Loader2, Pencil } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import { updateEffectiveDays } from '@/lib/actions/admin';
import { MONTHS_SHORT } from '@/constants';

export interface MonthlyDayRow {
  month: number;
  year: number;
  effectiveDays: number;
}

export interface EditEffectiveDaysDialogProps {
  periodId: string;
  periodName: string;
  initialDays: MonthlyDayRow[];
}

export function EditEffectiveDaysDialog({
  periodId,
  periodName,
  initialDays,
}: EditEffectiveDaysDialogProps) {
  const [open, setOpen] = useState(false);
  const [pending, startTransition] = useTransition();
  const [days, setDays] = useState<MonthlyDayRow[]>(initialDays);

  function setDay(idx: number, value: number) {
    setDays((prev) =>
      prev.map((d, i) => (i === idx ? { ...d, effectiveDays: value } : d)),
    );
  }

  // FIX: panggil updateEffectiveDays per-bulan (action hanya terima 1 entri)
  function handleSubmit() {
    startTransition(async () => {
      for (const d of days) {
        const result = await updateEffectiveDays({
          periodId,
          month: d.month,
          year: d.year,
          effectiveDays: d.effectiveDays,
        });
        if (!result.ok) {
          toast.error('Gagal menyimpan', { description: result.error });
          return;
        }
      }
      toast.success('Hari efektif berhasil diperbarui');
      setOpen(false);
    });
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button variant="outline" size="sm" className="gap-1.5">
          <Pencil className="h-3 w-3" aria-hidden /> Edit Hari Efektif
        </Button>
      </DialogTrigger>

      <DialogContent className="max-w-[520px]">
        <DialogHeader>
          <DialogTitle>Edit hari efektif — {periodName}</DialogTitle>
        </DialogHeader>

        <div className="grid grid-cols-6 gap-2 py-2">
          {days.map((d, idx) => (
            <div key={`${d.year}-${d.month}`} className="text-center">
              <div className="mb-1 text-2xs text-muted-foreground">
                {MONTHS_SHORT[d.month - 1]}
              </div>
              <Input
                type="number"
                min={1}
                max={31}
                value={d.effectiveDays}
                onChange={(e) => setDay(idx, Number(e.target.value))}
                className="text-center"
              />
            </div>
          ))}
        </div>

        <DialogFooter className="gap-2 sm:gap-2">
          <Button
            type="button"
            variant="outline"
            onClick={() => setOpen(false)}
            disabled={pending}
          >
            Batal
          </Button>
          <Button
            type="button"
            onClick={handleSubmit}
            disabled={pending}
            className="bg-sipandu-blue text-white hover:bg-sipandu-blue/90"
          >
            {pending && (
              <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" aria-hidden />
            )}
            Simpan Perubahan
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
