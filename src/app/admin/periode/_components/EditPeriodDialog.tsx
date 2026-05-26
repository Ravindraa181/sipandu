'use client';

/**
 * @file admin/periode/_components/EditPeriodDialog.tsx
 * @description Dialog edit periode (nama, tanggal, hari efektif).
 *              Memanggil updatePeriod server action.
 */

import { useState, useTransition, useMemo, useEffect } from 'react';
import { useForm, useWatch } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { Loader2, Pencil } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { updatePeriod } from '@/lib/actions/admin';
import type { MonthlyDayRow } from './EditEffectiveDaysDialog';

const formSchema = z.object({
  name: z.string().min(3, 'Minimal 3 karakter').max(50),
  academicYear: z.string().regex(/^\d{4}\/\d{4}$/, 'Format: 2024/2025'),
  semester: z.enum(['ganjil', 'genap']),
  startDate: z.string().min(1, 'Wajib diisi'),
  endDate: z.string().min(1, 'Wajib diisi'),
  monthlyDays: z.array(
    z.object({
      month: z.number().int().min(1).max(12),
      year: z.number().int().min(2000).max(2100),
      effectiveDays: z.number().int().min(0).max(31),
    })
  ).min(1),
});

type FormValues = z.infer<typeof formSchema>;

const MONTH_LABELS = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];

function getMonthsFromRange(start: string, end: string, existing: MonthlyDayRow[]) {
  if (!start || !end) return [];
  const s = new Date(start);
  const e = new Date(end);
  if (isNaN(s.getTime()) || isNaN(e.getTime()) || e < s) return [];

  const result: Array<{ month: number; year: number; label: string; effectiveDays: number }> = [];
  const cursor = new Date(s.getFullYear(), s.getMonth(), 1);
  const last = new Date(e.getFullYear(), e.getMonth(), 1);
  let guard = 0;

  while (cursor <= last && guard < 18) {
    const m = cursor.getMonth() + 1;
    const y = cursor.getFullYear();
    // Pakai nilai existing kalau ada, fallback 20
    const found = existing.find((d) => d.month === m && d.year === y);
    result.push({ month: m, year: y, label: MONTH_LABELS[cursor.getMonth()] ?? '', effectiveDays: found?.effectiveDays ?? 20 });
    cursor.setMonth(cursor.getMonth() + 1);
    guard++;
  }
  return result;
}

export interface EditPeriodDialogProps {
  periodId: string;
  periodName: string;
  academicYear: string;
  semester: 'ganjil' | 'genap';
  startDate: string; // ISO date string: "2026-08-01"
  endDate: string;
  monthlyDays: MonthlyDayRow[];
}

export function EditPeriodDialog({
  periodId,
  periodName,
  academicYear,
  semester,
  startDate,
  endDate,
  monthlyDays,
}: EditPeriodDialogProps) {
  const [open, setOpen] = useState(false);
  const [pending, startTransition] = useTransition();

  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      name: periodName,
      academicYear,
      semester,
      startDate,
      endDate,
      monthlyDays,
    },
  });

  const watchedStart = useWatch({ control: form.control, name: 'startDate' });
  const watchedEnd = useWatch({ control: form.control, name: 'endDate' });

  const dynamicMonths = useMemo(
    () => getMonthsFromRange(watchedStart ?? '', watchedEnd ?? '', monthlyDays),
    [watchedStart, watchedEnd, monthlyDays],
  );

  useEffect(() => {
    form.setValue(
      'monthlyDays',
      dynamicMonths.map((m) => ({ month: m.month, year: m.year, effectiveDays: m.effectiveDays }))
    );
  }, [dynamicMonths, form]);

  // Reset form saat dialog dibuka ulang
  useEffect(() => {
    if (open) {
      form.reset({ name: periodName, academicYear, semester, startDate, endDate, monthlyDays });
    }
  }, [open]); // eslint-disable-line react-hooks/exhaustive-deps

  function onSubmit(values: FormValues) {
    startTransition(async () => {
      const result = await updatePeriod({ periodId, ...values });
      if (result.ok) {
        toast.success('Periode berhasil diperbarui');
        setOpen(false);
      } else {
        toast.error('Gagal memperbarui periode', { description: result.error });
      }
    });
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button variant="ghost" size="icon" className="h-7 w-7 hover:bg-blue-50" title="Edit periode">
          <Pencil className="h-3.5 w-3.5" aria-hidden />
        </Button>
      </DialogTrigger>

      <DialogContent className="max-w-[520px]">
        <DialogHeader>
          <DialogTitle>Edit periode — {periodName}</DialogTitle>
        </DialogHeader>

        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4" noValidate>
          <div className="grid grid-cols-2 gap-2.5">
            <div>
              <Label htmlFor="edit-name">Nama Periode</Label>
              <Input id="edit-name" {...form.register('name')} />
              {form.formState.errors.name && (
                <p className="mt-1 text-2xs text-status-err">{form.formState.errors.name.message}</p>
              )}
            </div>
            <div>
              <Label htmlFor="edit-academicYear">Tahun Ajaran</Label>
              <Input id="edit-academicYear" placeholder="2025/2026" {...form.register('academicYear')} />
              {form.formState.errors.academicYear && (
                <p className="mt-1 text-2xs text-status-err">{form.formState.errors.academicYear.message}</p>
              )}
            </div>
          </div>

          <div>
            <Label htmlFor="edit-semester">Semester</Label>
            <Select
              value={form.watch('semester')}
              onValueChange={(v) => form.setValue('semester', v as 'ganjil' | 'genap')}
            >
              <SelectTrigger id="edit-semester">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="ganjil">Ganjil</SelectItem>
                <SelectItem value="genap">Genap</SelectItem>
              </SelectContent>
            </Select>
          </div>

          <div className="grid grid-cols-2 gap-2.5">
            <div>
              <Label htmlFor="edit-startDate">Tanggal Mulai</Label>
              <Input id="edit-startDate" type="date" {...form.register('startDate')} />
            </div>
            <div>
              <Label htmlFor="edit-endDate">Tanggal Selesai</Label>
              <Input id="edit-endDate" type="date" {...form.register('endDate')} />
            </div>
          </div>

          <div>
            <Label className="mb-2 block">Hari efektif per bulan</Label>
            {dynamicMonths.length === 0 ? (
              <p className="rounded-md border border-dashed bg-muted p-3 text-center text-xs text-muted-foreground">
                Isi tanggal mulai &amp; selesai terlebih dahulu.
              </p>
            ) : (
              <div className="grid grid-cols-6 gap-2">
                {dynamicMonths.map((m, idx) => (
                  <div key={`${m.year}-${m.month}`} className="space-y-1">
                    <label className="block text-center text-2xs text-muted-foreground">
                      {m.label} {m.year.toString().slice(-2)}
                    </label>
                    <Input
                      type="number"
                      min={0}
                      max={31}
                      className="px-1 text-center"
                      {...form.register(`monthlyDays.${idx}.effectiveDays`, { valueAsNumber: true })}
                    />
                  </div>
                ))}
              </div>
            )}
          </div>

          <DialogFooter className="gap-2 pt-2 sm:gap-2">
            <Button type="button" variant="outline" onClick={() => setOpen(false)} disabled={pending}>
              Batal
            </Button>
            <Button type="submit" disabled={pending} className="bg-sipandu-blue text-white hover:bg-sipandu-blue/90">
              {pending && <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" aria-hidden />}
              Simpan Perubahan
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}