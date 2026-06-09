'use client';

/**
 * @file admin/kelas/_components/EditClassDialog.tsx
 * @description Modal edit nama & tingkat kelas.
 */

import { useTransition } from 'react';
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
import { updateClassName } from '@/lib/actions/admin';

const formSchema = z.object({
  name: z
    .string()
    .min(2, 'Minimal 2 karakter')
    .max(10, 'Maks 10 karakter')
    .regex(/^(X|XI|XII)-[A-Z0-9]+$/, 'Format: X-1, XI-2, XII-A, X-IPA, dst.'),
  gradeLevel: z.enum(['X', 'XI', 'XII']),
});

type FormValues = z.infer<typeof formSchema>;

export interface EditClassDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  classId: string;
  currentName: string;
  currentGradeLevel: 'X' | 'XI' | 'XII';
}

export function EditClassDialog({
  open,
  onOpenChange,
  classId,
  currentName,
  currentGradeLevel,
}: EditClassDialogProps) {
  const [pending, startTransition] = useTransition();

  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      name: currentName,
      gradeLevel: currentGradeLevel,
    },
  });

  function onSubmit(values: FormValues) {
    startTransition(async () => {
      const result = await updateClassName({
        classId,
        name: values.name,
        gradeLevel: values.gradeLevel,
      });

      if (result.ok) {
        toast.success(`Kelas berhasil diubah menjadi ${values.name}`);
        onOpenChange(false);
      } else {
        toast.error('Gagal mengubah kelas', { description: result.error });
      }
    });
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-[400px]">
        <DialogHeader>
          <DialogTitle>Edit Kelas — {currentName}</DialogTitle>
        </DialogHeader>

        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4" noValidate>
          <div className="grid gap-3">
            <div>
              <Label htmlFor="edit-class-name">Nama Kelas</Label>
              <Input
                id="edit-class-name"
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
              <Label htmlFor="edit-grade-level">Tingkat</Label>
              <Select
                value={form.watch('gradeLevel')}
                onValueChange={(v) =>
                  form.setValue('gradeLevel', v as 'X' | 'XI' | 'XII')
                }
              >
                <SelectTrigger id="edit-grade-level">
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
              Simpan
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
