'use client';

/**
 * @file admin/siswa/_components/EditStudentDialog.tsx
 * @description Dialog untuk mengedit data profil siswa:
 *              nama lengkap, NISN, email, dan jenis kelamin.
 *              Perubahan email akan diperbarui di auth.users sekaligus.
 */

import { useEffect, useTransition } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { Loader2 } from 'lucide-react';
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
} from '@/components/ui/dialog';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { updateStudent } from '@/lib/actions/admin';
import type { StudentDetail } from './StudentDetailDialog';

const schema = z.object({
  fullName: z.string().min(2, 'Nama minimal 2 karakter'),
  nisn: z.string().regex(/^\d{10}$/, 'NISN harus 10 digit angka'),
  email: z.string().email('Format email tidak valid'),
  gender: z.enum(['L', 'P']).optional(),
});

type FormValues = z.infer<typeof schema>;

export interface EditStudentDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  student: StudentDetail;
}

export function EditStudentDialog({
  open,
  onOpenChange,
  student,
}: EditStudentDialogProps) {
  const [pending, startTransition] = useTransition();

  const {
    register,
    handleSubmit,
    reset,
    setValue,
    watch,
    formState: { errors },
  } = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: {
      fullName: student.fullName,
      nisn: student.nisn,
      email: student.email,
      gender: student.gender ?? undefined,
    },
  });

  // Sync nilai form saat student prop berubah atau dialog dibuka ulang
  useEffect(() => {
    if (open) {
      reset({
        fullName: student.fullName,
        nisn: student.nisn,
        email: student.email,
        gender: student.gender ?? undefined,
      });
    }
  }, [open, student, reset]);

  const genderValue = watch('gender');

  function onSubmit(values: FormValues) {
    startTransition(async () => {
      const result = await updateStudent({
        studentId: student.id,
        fullName: values.fullName,
        nisn: values.nisn,
        email: values.email,
        gender: values.gender,
      });

      if (result.ok) {
        toast.success(`Data ${values.fullName} berhasil diperbarui`);
        onOpenChange(false);
      } else {
        toast.error('Gagal memperbarui data', { description: result.error });
      }
    });
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-[460px]">
        <DialogHeader>
          <DialogTitle>Edit Data Siswa</DialogTitle>
        </DialogHeader>

        <form onSubmit={handleSubmit(onSubmit)} className="space-y-3">
          {/* Nama Lengkap */}
          <div className="space-y-1">
            <Label htmlFor="edit-fullName">
              Nama Lengkap <span className="text-status-err">*</span>
            </Label>
            <Input
              id="edit-fullName"
              placeholder="Nama lengkap siswa"
              {...register('fullName')}
              aria-invalid={Boolean(errors.fullName)}
            />
            {errors.fullName && (
              <p className="text-2xs text-status-err">
                {errors.fullName.message}
              </p>
            )}
          </div>

          {/* NISN */}
          <div className="space-y-1">
            <Label htmlFor="edit-nisn">
              NISN <span className="text-status-err">*</span>
            </Label>
            <Input
              id="edit-nisn"
              inputMode="numeric"
              maxLength={10}
              placeholder="Nomor Induk Siswa Nasional (10 digit)"
              {...register('nisn')}
              aria-invalid={Boolean(errors.nisn)}
            />
            {errors.nisn && (
              <p className="text-2xs text-status-err">{errors.nisn.message}</p>
            )}
          </div>

          {/* Email */}
          <div className="space-y-1">
            <Label htmlFor="edit-email">
              Email <span className="text-status-err">*</span>
            </Label>
            <Input
              id="edit-email"
              type="email"
              placeholder="email@domain.com"
              {...register('email')}
              aria-invalid={Boolean(errors.email)}
            />
            {errors.email && (
              <p className="text-2xs text-status-err">
                {errors.email.message}
              </p>
            )}
            <p className="text-2xs text-muted-foreground">
              Jika email diubah, siswa harus login dengan email baru.
            </p>
          </div>

          {/* Jenis Kelamin */}
          <div className="space-y-1">
            <Label>Jenis Kelamin</Label>
            <Select
              value={genderValue ?? ''}
              onValueChange={(v) =>
                setValue('gender', v as 'L' | 'P', { shouldValidate: true })
              }
            >
              <SelectTrigger>
                <SelectValue placeholder="— Pilih —" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="L">Laki-laki</SelectItem>
                <SelectItem value="P">Perempuan</SelectItem>
              </SelectContent>
            </Select>
          </div>

          <DialogFooter className="gap-2 pt-1">
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
              Simpan Perubahan
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
