'use client';

/**
 * @file admin/kelas/_components/AddClassDialog.tsx
 * @description Modal "Tambah Kelas Baru". Form: nama, tingkat.
 */

import { useState, useTransition } from 'react';
import { useForm } from 'react-hook-form';
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
// PERBAIKAN: Gunakan import createClass
import { createClass } from '@/lib/actions/admin';

const formSchema = z.object({
  name: z
    .string()
    .min(2, 'Minimal 2 karakter')
    .max(10, 'Maks 10 karakter')
    .regex(/^(X|XI|XII)-[A-Z0-9]+$/, 'Format: X-1, XI-2, XII-A, X-IPA, dst.'),
  gradeLevel: z.enum(['X', 'XI', 'XII']),
});

type FormValues = z.infer<typeof formSchema>;

export function AddClassDialog() {
  const [open, setOpen] = useState(false);
  const [pending, startTransition] = useTransition();

  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      name: '',
      gradeLevel: 'X',
    },
  });

  function onSubmit(values: FormValues) {
    startTransition(async () => {
      // PERBAIKAN: Panggil createClass
      const result = await createClass(values);

      if (result.ok) {
        toast.success(`Kelas ${values.name} berhasil ditambahkan`);
        setOpen(false);
        form.reset();
      } else {
        toast.error('Gagal menambahkan kelas', { description: result.error });
      }
    });
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button className="gap-1.5 bg-sipandu-blue text-white hover:bg-sipandu-blue/90">
          <Plus className="h-4 w-4" aria-hidden /> Tambah Kelas
        </Button>
      </DialogTrigger>
      <DialogContent className="max-w-[400px]">
        <DialogHeader>
          <DialogTitle>Tambah Kelas Baru</DialogTitle>
        </DialogHeader>

        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4" noValidate>
          <div className="grid gap-3">
            <div>
              <Label htmlFor="name">Nama Kelas</Label>
              <Input
                id="name"
                placeholder="Mis. X-1, XI-2, XII-IPA"
                {...form.register('name')}
              />
              {form.formState.errors.name && (
                <p className="mt-1 text-2xs text-status-err">
                  {form.formState.errors.name.message}
                </p>
              )}
            </div>
            <div>
              <Label htmlFor="gradeLevel">Tingkat</Label>
              <Select
                value={form.watch('gradeLevel')}
                onValueChange={(v) =>
                  form.setValue('gradeLevel', v as 'X' | 'XI' | 'XII')
                }
              >
                <SelectTrigger id="gradeLevel">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="X">X</SelectItem>
                  <SelectItem value="XI">XI</SelectItem>
                  <SelectItem value="XII">XII</SelectItem>
                </SelectContent>
              </Select>
            </div>
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