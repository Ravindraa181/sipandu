'use client';

/**
 * @file dashboard/poin-perilaku/_components/TransactionDialog.tsx
 *
 * FIX TS2322 (line 106):
 *   notes: notes || null → notes: notes || undefined
 *   Schema addBehaviorTransaction: notes?: string | undefined (optional),
 *   bukan string | null. Nilai null tidak assignable.
 *
 * FIX tambahan:
 *   Hapus prop `pointAbsolute` dari call — tidak ada di schema action.
 *   Server action menghitung delta sendiri dari categoryId → DB.
 */

import { useEffect, useMemo, useState, useTransition } from 'react';
import { Loader2, Minus, Plus } from 'lucide-react';
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
import { addBehaviorTransaction } from '@/lib/actions/teacher';
import { cn } from '@/lib/utils/cn';

export interface TransactionCategory {
  id: string;
  name: string;
  pointValue: number;
}

export interface TransactionDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  type: 'violation' | 'reward';
  studentName: string;
  enrollmentId: string;
  assignmentId: string;
  currentRaw: number;
  categories: TransactionCategory[];
}

export function TransactionDialog({
  open,
  onOpenChange,
  type,
  studentName,
  enrollmentId,
  assignmentId,
  currentRaw,
  categories,
}: TransactionDialogProps) {
  const [pending, startTransition] = useTransition();
  const [categoryId, setCategoryId] = useState<string>('');
  const [transactionDate, setTransactionDate] = useState<string>(
    new Date().toISOString().slice(0, 10),
  );
  const [notes, setNotes] = useState<string>('');

  useEffect(() => {
    if (open) {
      setCategoryId(categories[0]?.id ?? '');
      setTransactionDate(new Date().toISOString().slice(0, 10));
      setNotes('');
    }
  }, [open, categories]);

  const selectedCategory = categories.find((c) => c.id === categoryId);
  const points = selectedCategory?.pointValue ?? 0;
  const sign = type === 'violation' ? -1 : 1;

  const preview = useMemo(() => {
    const newRaw = currentRaw + sign * points;
    const newX2 = Math.max(0, Math.min(100, newRaw));
    const hasBuffer = newRaw > 100;
    return { newRaw, newX2, hasBuffer };
  }, [currentRaw, points, sign]);

  function handleSubmit() {
    if (!categoryId) {
      toast.error('Pilih kategori terlebih dahulu');
      return;
    }
    startTransition(async () => {
      const result = await addBehaviorTransaction({
        enrollmentId,
        assignmentId,
        type,
        categoryId,
        transactionDate,
        // FIX TS2322: notes || undefined (bukan null) — schema memakai optional()
        notes: notes || undefined,
        // FIX: hapus pointAbsolute — tidak ada di schema action
      });
      if (result.ok) {
        toast.success(
          type === 'violation'
            ? `Pelanggaran tercatat untuk ${studentName}`
            : `Reward tercatat untuk ${studentName}`,
        );
        onOpenChange(false);
      } else {
        toast.error('Gagal menyimpan', { description: result.error });
      }
    });
  }

  const isViolation = type === 'violation';

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-[520px]">
        <DialogHeader>
          <DialogTitle>
            {isViolation ? 'Catat Pelanggaran' : 'Catat Reward'} — {studentName}
          </DialogTitle>
        </DialogHeader>

        <div className="space-y-3">
          <div>
            <Label htmlFor="category">
              Kategori {isViolation ? 'Pelanggaran' : 'Reward'}{' '}
              <span className="text-status-err">*</span>
            </Label>
            {categories.length === 0 ? (
              <p className="rounded-md border border-status-warn-soft bg-amber-50 p-2 text-xs text-status-warn-text">
                Belum ada kategori {isViolation ? 'pelanggaran' : 'reward'}{' '}
                tersedia. Hubungi admin untuk menambahkan.
              </p>
            ) : (
              <Select value={categoryId} onValueChange={setCategoryId}>
                <SelectTrigger id="category">
                  <SelectValue placeholder="— Pilih kategori —" />
                </SelectTrigger>
                <SelectContent>
                  {categories.map((c) => (
                    <SelectItem key={c.id} value={c.id}>
                      {c.name} ({isViolation ? '-' : '+'}
                      {c.pointValue} poin)
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            )}
          </div>

          <div className="grid grid-cols-2 gap-2.5">
            <div>
              <Label htmlFor="trxDate">
                Tanggal <span className="text-status-err">*</span>
              </Label>
              <Input
                id="trxDate"
                type="date"
                value={transactionDate}
                onChange={(e) => setTransactionDate(e.target.value)}
              />
            </div>
            <div>
              <Label htmlFor="notes">
                Keterangan{' '}
                <span className="text-2xs text-muted-foreground">(opsional)</span>
              </Label>
              <Input
                id="notes"
                value={notes}
                onChange={(e) => setNotes(e.target.value)}
                placeholder="Tambahkan catatan..."
              />
            </div>
          </div>

          {selectedCategory && (
            <div className="rounded-md border border-sipandu-border bg-gray-50 p-3 text-sm">
              <div className="flex items-center justify-between border-b border-gray-200 py-1">
                <span>Raw Score saat ini</span>
                <strong>{currentRaw}</strong>
              </div>
              <div className="flex items-center justify-between border-b border-gray-200 py-1">
                <span>{isViolation ? 'Pengurangan' : 'Penambahan'}</span>
                <strong
                  className={cn(
                    isViolation ? 'text-status-err' : 'text-status-on-text',
                  )}
                >
                  {isViolation ? '-' : '+'}
                  {points} poin
                </strong>
              </div>
              <div className="flex items-center justify-between border-b border-gray-200 py-1">
                <span>Raw Score baru</span>
                <strong>{preview.newRaw}</strong>
              </div>
              <div className="flex items-center justify-between py-1.5">
                <span className="text-sipandu-blue">X2 baru</span>
                <strong className="text-sipandu-blue">
                  {preview.newX2}
                  {preview.hasBuffer && (
                    <span className="ml-1.5 inline-flex items-center rounded-full bg-status-warn-soft px-1.5 py-0.5 text-2xs font-semibold text-status-warn-text">
                      ⚠ buffer
                    </span>
                  )}
                </strong>
              </div>
            </div>
          )}
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
            type="button"
            onClick={handleSubmit}
            disabled={pending || !categoryId}
            className={cn(
              'gap-1.5',
              isViolation
                ? 'border border-status-err bg-white text-status-err hover:bg-red-50'
                : 'bg-status-on text-white hover:bg-status-on/90',
            )}
          >
            {pending && (
              <Loader2 className="h-3.5 w-3.5 animate-spin" aria-hidden />
            )}
            {isViolation ? (
              <Minus className="h-3.5 w-3.5" aria-hidden />
            ) : (
              <Plus className="h-3.5 w-3.5" aria-hidden />
            )}
            Simpan {isViolation ? 'Pelanggaran' : 'Reward'}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
