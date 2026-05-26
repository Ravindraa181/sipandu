'use client';

/**
 * @file admin/kategori-poin/_components/CategoryFormDialog.tsx
 * @description Modal Tambah/Edit kategori (pelanggaran atau reward).
 *
 * Reuse 1 component untuk kedua jenis dengan prop `type`. Server action
 * yang berbeda (upsertViolationCategory / upsertRewardCategory) dipanggil
 * sesuai prop tersebut.
 */

import { useEffect, useState, useTransition } from 'react';
import { Loader2 } from 'lucide-react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import {
  upsertViolationCategory,
  upsertRewardCategory,
} from '@/lib/actions/admin';

// PERBAIKAN: Gunakan z.number() murni untuk menghindari error type literal dari Zod
const formSchema = z.object({
  name: z.string().min(3, 'Minimal 3 karakter').max(150),
  pointValue: z
    .number()
    .int('Poin harus bilangan bulat')
    .positive('Harus positif')
    .max(100, 'Poin maksimal 100'),
  reference: z.string().max(100).optional(),
  description: z.string().max(500).optional(),
});
type FormValues = z.infer<typeof formSchema>;

export type CategoryType = 'violation' | 'reward';

export interface CategoryFormDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  type: CategoryType;
  initialData: {
    id: string;
    name: string;
    pointValue: number;
    reference: string | null;
    description: string | null;
  } | null;
}

export function CategoryFormDialog({
  open,
  onOpenChange,
  type,
  initialData,
}: CategoryFormDialogProps) {
  const [pending, startTransition] = useTransition();

  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      name: '',
      pointValue: 5,
      reference: '',
      description: '',
    },
  });

  useEffect(() => {
    if (open) {
      form.reset({
        name: initialData?.name ?? '',
        pointValue: initialData?.pointValue ?? 5,
        reference: initialData?.reference ?? '',
        description: initialData?.description ?? '',
      });
    }
  }, [open, initialData, form]);

  function onSubmit(values: FormValues) {
    startTransition(async () => {
      const result =
        type === 'violation'
          ? await upsertViolationCategory({
              id: initialData?.id,
              name: values.name,
              pointValue: values.pointValue,
              sopReference: values.reference || null,
              description: values.description || null,
            })
          : await upsertRewardCategory({
              id: initialData?.id,
              name: values.name,
              pointValue: values.pointValue,
              categoryLabel: values.reference || null,
              description: values.description || null,
            });

      if (result.ok) {
        toast.success(
          initialData ? 'Kategori berhasil diperbarui' : 'Kategori berhasil ditambahkan',
        );
        onOpenChange(false);
      } else {
        toast.error('Gagal menyimpan', { description: result.error });
      }
    });
  }

  const isEdit = Boolean(initialData);
  const refLabel =
    type === 'violation' ? 'Referensi SOP' : 'Label Kategori';
  const refPlaceholder =
    type === 'violation' ? 'Pasal 3 ayat 1' : 'Akademik / Sosial / Olahraga';

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-[520px]">
        <DialogHeader>
          <DialogTitle>
            {isEdit ? 'Edit kategori' : 'Tambah kategori baru'} —{' '}
            {type === 'violation' ? 'Pelanggaran' : 'Reward'}
          </DialogTitle>
        </DialogHeader>

        <form
          onSubmit={form.handleSubmit(onSubmit)}
          className="space-y-3"
          noValidate
        >
          <div>
            <Label htmlFor="name">Nama Kategori</Label>
            <Input
              id="name"
              placeholder={
                type === 'violation'
                  ? 'Bolos tanpa keterangan'
                  : 'Juara olimpiade tingkat kota'
              }
              {...form.register('name')}
            />
            {form.formState.errors.name && (
              <p className="mt-1 text-2xs text-status-err">
                {form.formState.errors.name.message}
              </p>
            )}
          </div>

          <div className="grid grid-cols-2 gap-2.5">
            <div>
              <Label htmlFor="pointValue">
                Poin{' '}
                <span className="text-2xs font-normal text-muted-foreground">
                  (akan {type === 'violation' ? 'dikurangkan' : 'ditambahkan'})
                </span>
              </Label>
              <Input
                id="pointValue"
                type="number"
                min={1}
                max={100}
                {...form.register('pointValue', { valueAsNumber: true })}
              />
              {form.formState.errors.pointValue && (
                <p className="mt-1 text-2xs text-status-err">
                  {form.formState.errors.pointValue.message}
                </p>
              )}
            </div>
            <div>
              <Label htmlFor="reference">
                {refLabel}{' '}
                <span className="text-2xs font-normal text-muted-foreground">
                  (opsional)
                </span>
              </Label>
              <Input
                id="reference"
                placeholder={refPlaceholder}
                {...form.register('reference')}
              />
            </div>
          </div>

          <div>
            <Label htmlFor="description">
              Keterangan{' '}
              <span className="text-2xs font-normal text-muted-foreground">
                (opsional)
              </span>
            </Label>
            <Textarea
              id="description"
              rows={3}
              placeholder="Penjelasan tambahan untuk wali kelas..."
              {...form.register('description')}
            />
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
              type="submit"
              disabled={pending}
              className="bg-sipandu-blue text-white hover:bg-sipandu-blue/90"
            >
              {pending && (
                <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" aria-hidden />
              )}
              {isEdit ? 'Simpan Perubahan' : 'Tambahkan'}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}