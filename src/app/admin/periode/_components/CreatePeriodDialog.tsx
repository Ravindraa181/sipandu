'use client';

/**
 * @file admin/periode/_components/CreatePeriodDialog.tsx
 */

import { useState, useTransition, useMemo, useEffect } from 'react';
import { useForm, useWatch } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { Loader2, Plus } from 'lucide-react';
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
import { createPeriod } from '@/lib/actions/admin';

const monthEntrySchema = z.object({
  month: z.number().int().min(1).max(12),
  year: z.number().int().min(2020).max(2100),
  effectiveDays: z.number().int().min(0).max(31), // Diubah min 0 agar lebih fleksibel
});

const formSchema = z.object({
  name: z.string().min(3, 'Minimal 3 karakter').max(50),
  academicYear: z
    .string()
    .regex(/^\d{4}\/\d{4}$/, 'Format: 2024/2025'),
  semester: z.enum(['ganjil', 'genap']),
  startDate: z.string().min(1, 'Wajib diisi'),
  endDate: z.string().min(1, 'Wajib diisi'),
  monthlyDays: z.array(monthEntrySchema).min(1, 'Minimal 1 bulan'),
  setActive: z.boolean(),
});

type FormValues = z.infer<typeof formSchema>;

/** Generate daftar bulan dari rentang tanggal mulai–selesai periode. */
function getDefaultMonthsFromRange(
  start: string,
  end: string,
): Array<{ month: number; year: number; label: string; effectiveDays: number }> {
  if (!start || !end) return [];
  const startDate = new Date(start);
  const endDate = new Date(end);
  if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) return [];
  if (endDate < startDate) return [];

  const labels = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];
  const result: Array<{ month: number; year: number; label: string; effectiveDays: number }> = [];
  const cursor = new Date(startDate.getFullYear(), startDate.getMonth(), 1);
  const last = new Date(endDate.getFullYear(), endDate.getMonth(), 1);

  // Guard: maksimal 18 bulan untuk hindari infinite loop
  let guard = 0;
  while (cursor <= last && guard < 18) {
    result.push({
      month: cursor.getMonth() + 1,
      year: cursor.getFullYear(),
      label: labels[cursor.getMonth()] ?? '',
      effectiveDays: 20, // default; admin bisa edit
    });
    cursor.setMonth(cursor.getMonth() + 1);
    guard++;
  }
  return result;
}

export function CreatePeriodDialog() {
  const [open, setOpen] = useState(false);
  const [pending, startTransition] = useTransition();
  const currentYear = new Date().getFullYear();

  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      name: '',
      academicYear: `${currentYear}/${currentYear + 1}`,
      semester: 'ganjil',
      startDate: '',
      endDate: '',
      monthlyDays: [], // Kosongkan di awal, akan diisi dinamis oleh useEffect
      setActive: true,
    },
  });

  // Pantau input tanggal mulai dan selesai
  const startDate = useWatch({ control: form.control, name: 'startDate' });
  const endDate = useWatch({ control: form.control, name: 'endDate' });

  // Hitung ulang daftar bulan setiap kali tanggal berubah
  const dynamicMonths = useMemo(
    () => getDefaultMonthsFromRange(startDate ?? '', endDate ?? ''),
    [startDate, endDate],
  );

  // Sinkronisasi ke form state `monthlyDays`
  useEffect(() => {
    form.setValue(
      'monthlyDays',
      dynamicMonths.map((m) => ({
        month: m.month,
        year: m.year,
        effectiveDays: m.effectiveDays,
      }))
    );
  }, [dynamicMonths, form]);

  function onSubmit(values: FormValues) {
    startTransition(async () => {
      const result = await createPeriod(values);
      if (result.ok) {
        toast.success('Periode berhasil dibuat');
        setOpen(false);
        form.reset();
      } else {
        toast.error('Gagal membuat periode', { description: result.error });
      }
    });
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button className="gap-1.5 bg-sipandu-blue text-white hover:bg-sipandu-blue/90">
          <Plus className="h-3.5 w-3.5" aria-hidden /> Buat Periode Baru
        </Button>
      </DialogTrigger>

      <DialogContent className="max-w-[520px]">
        <DialogHeader>
          <DialogTitle>Buat periode baru</DialogTitle>
        </DialogHeader>

        <form
          onSubmit={form.handleSubmit(onSubmit)}
          className="space-y-4"
          noValidate
        >
          <div className="grid grid-cols-2 gap-2.5">
            <div>
              <Label htmlFor="name">Nama Periode</Label>
              <Input
                id="name"
                placeholder="Ganjil 2025/2026"
                {...form.register('name')}
              />
              {form.formState.errors.name && (
                <p className="mt-1 text-2xs text-status-err">
                  {form.formState.errors.name.message}
                </p>
              )}
            </div>
            <div>
              <Label htmlFor="academicYear">Tahun Ajaran</Label>
              <Input
                id="academicYear"
                placeholder="2025/2026"
                {...form.register('academicYear')}
              />
              {form.formState.errors.academicYear && (
                <p className="mt-1 text-2xs text-status-err">
                  {form.formState.errors.academicYear.message}
                </p>
              )}
            </div>
          </div>

          <div className="grid grid-cols-2 gap-2.5">
            <div>
              <Label htmlFor="semester">Semester</Label>
              <Select
                value={form.watch('semester')}
                onValueChange={(v) =>
                  form.setValue('semester', v as 'ganjil' | 'genap')
                }
              >
                <SelectTrigger id="semester">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="ganjil">Ganjil</SelectItem>
                  <SelectItem value="genap">Genap</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="flex items-end gap-1.5 pb-1.5">
              <input
                id="setActive"
                type="checkbox"
                {...form.register('setActive')}
                className="h-3.5 w-3.5 cursor-pointer accent-sipandu-blue"
              />
              <Label
                htmlFor="setActive"
                className="cursor-pointer text-xs font-normal"
              >
                Jadikan periode aktif
              </Label>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-2.5">
            <div>
              <Label htmlFor="startDate">Tanggal Mulai</Label>
              <Input
                id="startDate"
                type="date"
                {...form.register('startDate')}
              />
              {form.formState.errors.startDate && (
                <p className="mt-1 text-2xs text-status-err">
                  {form.formState.errors.startDate.message}
                </p>
              )}
            </div>
            <div>
              <Label htmlFor="endDate">Tanggal Selesai</Label>
              <Input
                id="endDate"
                type="date"
                {...form.register('endDate')}
              />
              {form.formState.errors.endDate && (
                <p className="mt-1 text-2xs text-status-err">
                  {form.formState.errors.endDate.message}
                </p>
              )}
            </div>
          </div>

          <div>
            <Label className="mb-2 block">Hari efektif per bulan</Label>
            {dynamicMonths.length === 0 ? (
              <p className="text-xs text-muted-foreground bg-muted p-3 rounded-md text-center border border-dashed">
                Isi Tanggal Mulai & Selesai terlebih dahulu untuk menampilkan bulan.
              </p>
            ) : (
              <div className="grid grid-cols-6 gap-2">
                {dynamicMonths.map((m, idx) => (
                  <div key={`${m.year}-${m.month}`} className="space-y-1">
                    <label className="text-2xs text-muted-foreground block text-center">
                      {m.label} {m.year.toString().slice(-2)}
                    </label>
                    <Input
                      type="number"
                      min={0}
                      max={31}
                      className="text-center px-1"
                      {...form.register(`monthlyDays.${idx}.effectiveDays`, {
                        valueAsNumber: true,
                      })}
                    />
                  </div>
                ))}
              </div>
            )}
            {form.formState.errors.monthlyDays && (
              <p className="mt-1 text-2xs text-status-err">
                {form.formState.errors.monthlyDays.message}
              </p>
            )}
          </div>

          <DialogFooter className="gap-2 sm:gap-2 pt-2">
            <Button
              type="button"
              variant="outline"
              onClick={() => setOpen(false)}
              disabled={pending}
            >
              Batal
            </Button>
            <Button
              type="submit"
              disabled={pending}
              className="bg-sipandu-blue text-white hover:bg-sipandu-blue/90"
            >
              {pending && (
                <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" aria-hidden />
              )}
              Simpan
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}