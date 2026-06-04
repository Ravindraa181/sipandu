'use client';

/**
 * @file admin/siswa/_components/AddStudentDialog.tsx
 * @description Modal "Tambah Siswa Baru" — form NISN, nama, email, gender, password.
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
import { createUser } from '@/lib/actions/admin';

const formSchema = z.object({
  nisn: z.string().regex(/^\d{10}$/, 'NISN harus 10 digit angka'),
  fullName: z.string().min(3, 'Minimal 3 karakter').max(150),
  email: z.string().email('Format email tidak valid'),
  gender: z.enum(['L', 'P'], { error: 'Pilih jenis kelamin' }),
  initialPassword: z.string().min(8, 'Password minimal 8 karakter'),
});
type FormValues = z.infer<typeof formSchema>;

export function AddStudentDialog() {
  const [open, setOpen] = useState(false);
  const [pending, startTransition] = useTransition();

  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    defaultValues: { nisn: '', fullName: '', email: '', initialPassword: '' },
  });

  function onSubmit(values: FormValues) {
    startTransition(async () => {
      const result = await createUser({
        email: values.email,
        fullName: values.fullName,
        nisn: values.nisn,
        gender: values.gender,
        password: values.initialPassword,
        role: 'student',
      });

      if (result.ok) {
        toast.success('Siswa berhasil ditambahkan');
        setOpen(false);
        form.reset();
      } else {
        toast.error('Gagal menambahkan siswa', { description: result.error });
      }
    });
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button className="gap-1.5 bg-sipandu-blue text-white hover:bg-sipandu-blue/90">
          <Plus className="h-4 w-4" aria-hidden /> Tambah Siswa
        </Button>
      </DialogTrigger>
      <DialogContent className="max-w-[425px]">
        <DialogHeader>
          <DialogTitle>Tambah Siswa Baru</DialogTitle>
        </DialogHeader>

        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-3" noValidate>
          <div>
            <Label htmlFor="nisn">NISN</Label>
            <Input
              id="nisn"
              inputMode="numeric"
              maxLength={10}
              placeholder="0012345678 (10 digit)"
              {...form.register('nisn')}
            />
            {form.formState.errors.nisn && (
              <p className="mt-1 text-2xs text-status-err">{form.formState.errors.nisn.message}</p>
            )}
          </div>
          <div>
            <Label htmlFor="fullName">Nama Lengkap</Label>
            <Input id="fullName" placeholder="Budi Santoso" {...form.register('fullName')} />
            {form.formState.errors.fullName && (
              <p className="mt-1 text-2xs text-status-err">{form.formState.errors.fullName.message}</p>
            )}
          </div>
          <div className="grid grid-cols-2 gap-2.5">
            <div>
              <Label htmlFor="email">Email</Label>
              <Input id="email" type="email" placeholder="budi@sekolah.id" {...form.register('email')} />
              {form.formState.errors.email && (
                <p className="mt-1 text-2xs text-status-err">{form.formState.errors.email.message}</p>
              )}
            </div>
            <div>
              <Label htmlFor="gender">Jenis Kelamin</Label>
              <Select onValueChange={(v) => form.setValue('gender', v as 'L' | 'P')}>
                <SelectTrigger id="gender">
                  <SelectValue placeholder="Pilih..." />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="L">Laki-laki</SelectItem>
                  <SelectItem value="P">Perempuan</SelectItem>
                </SelectContent>
              </Select>
              {form.formState.errors.gender && (
                <p className="mt-1 text-2xs text-status-err">{form.formState.errors.gender.message}</p>
              )}
            </div>
          </div>
          <div>
            <Label htmlFor="initialPassword">Password Awal</Label>
            <Input id="initialPassword" type="password" placeholder="••••••••" {...form.register('initialPassword')} />
            {form.formState.errors.initialPassword && (
              <p className="mt-1 text-2xs text-status-err">{form.formState.errors.initialPassword.message}</p>
            )}
          </div>

          <DialogFooter className="gap-2 pt-1 sm:gap-2">
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