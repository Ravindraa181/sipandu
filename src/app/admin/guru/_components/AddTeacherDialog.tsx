'use client';

/**
 * @file admin/guru/_components/AddTeacherDialog.tsx
 * @description Modal "Tambah Guru Baru" — form NIP, nama, email, password.
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
// PERBAIKAN: Import createUser dari actions admin
import { createUser } from '@/lib/actions/admin';

const formSchema = z.object({
  nip: z.string().min(8, 'Minimal 8 karakter').max(20),
  fullName: z.string().min(3, 'Minimal 3 karakter').max(150),
  email: z.string().email('Format email tidak valid'),
  initialPassword: z.string().min(8, 'Password minimal 8 karakter'),
});
type FormValues = z.infer<typeof formSchema>;

export function AddTeacherDialog() {
  const [open, setOpen] = useState(false);
  const [pending, startTransition] = useTransition();

  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      nip: '',
      fullName: '',
      email: '',
      initialPassword: '',
    },
  });

  function onSubmit(values: FormValues) {
    startTransition(async () => {
      // PERBAIKAN: Memanggil createUser dan memberikan argumen role
      const result = await createUser({
        email: values.email,
        fullName: values.fullName,
        nip: values.nip,
        password: values.initialPassword,
        role: 'teacher',
      });

      if (result.ok) {
        toast.success('Guru berhasil ditambahkan');
        setOpen(false);
        form.reset();
      } else {
        toast.error('Gagal menambahkan guru', { description: result.error });
      }
    });
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button className="gap-1.5 bg-sipandu-blue text-white hover:bg-sipandu-blue/90">
          <Plus className="h-4 w-4" aria-hidden /> Tambah Guru
        </Button>
      </DialogTrigger>
      <DialogContent className="max-w-[425px]">
        <DialogHeader>
          <DialogTitle>Tambah Guru Baru</DialogTitle>
        </DialogHeader>

        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4" noValidate>
          <div className="space-y-3">
            <div>
              <Label htmlFor="nip">NIP</Label>
              <Input id="nip" placeholder="1980..." {...form.register('nip')} />
              {form.formState.errors.nip && (
                <p className="mt-1 text-2xs text-status-err">
                  {form.formState.errors.nip.message}
                </p>
              )}
            </div>
            <div>
              <Label htmlFor="fullName">Nama Lengkap</Label>
              <Input id="fullName" placeholder="Budi Santoso, S.Pd" {...form.register('fullName')} />
              {form.formState.errors.fullName && (
                <p className="mt-1 text-2xs text-status-err">
                  {form.formState.errors.fullName.message}
                </p>
              )}
            </div>
            <div>
              <Label htmlFor="email">Email</Label>
              <Input id="email" type="email" placeholder="budi@sekolah.id" {...form.register('email')} />
              {form.formState.errors.email && (
                <p className="mt-1 text-2xs text-status-err">
                  {form.formState.errors.email.message}
                </p>
              )}
            </div>
            <div>
              <Label htmlFor="initialPassword">Password Awal</Label>
              <Input id="initialPassword" type="password" placeholder="••••••••" {...form.register('initialPassword')} />
              {form.formState.errors.initialPassword && (
                <p className="mt-1 text-2xs text-status-err">
                  {form.formState.errors.initialPassword.message}
                </p>
              )}
            </div>
          </div>

          <DialogFooter className="gap-2 sm:gap-2">
            <Button type="button" variant="outline" onClick={() => setOpen(false)} disabled={pending}>
              Batal
            </Button>
            <Button type="submit" disabled={pending} className="bg-sipandu-blue text-white hover:bg-sipandu-blue/90">
              {pending && <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" aria-hidden />}
              Simpan
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}