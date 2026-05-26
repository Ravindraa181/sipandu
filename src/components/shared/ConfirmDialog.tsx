'use client';

/**
 * @file components/shared/ConfirmDialog.tsx
 * @description Wrapper konfirmasi untuk aksi kritis: kunci kehadiran,
 *              tutup sesi peer review, hapus kategori, nonaktifkan akun.
 *
 *  Memakai shadcn `<AlertDialog>`. Jangan dipakai untuk konfirmasi
 *  ringan — gunakan toast undoable saja untuk yang reversible.
 *
 * @example
 *   <ConfirmDialog
 *     trigger={<Button variant="destructive">Kunci Bulan Ini</Button>}
 *     title="Kunci data Oktober?"
 *     description="Setelah dikunci, data tidak dapat diubah lagi."
 *     confirmLabel="Ya, kunci"
 *     variant="destructive"
 *     onConfirm={async () => { await lockAttendance(); }}
 *   />
 */

import { useState, type ReactNode } from 'react';
import { Loader2, AlertTriangle, Lock, Trash2 } from 'lucide-react';

import { cn } from '@/lib/utils/cn';
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from '@/components/ui/alert-dialog';

export type ConfirmVariant = 'default' | 'destructive' | 'warning';

export interface ConfirmDialogProps {
  /** Element yang men-trigger dialog (mis. <Button>Hapus</Button>). */
  trigger: ReactNode;
  /** Judul singkat (10-50 karakter). */
  title: string;
  /** Deskripsi lengkap aksi & konsekuensi. */
  description: string;
  /** Label tombol konfirmasi. Default: "Konfirmasi". */
  confirmLabel?: string;
  /** Label tombol batal. Default: "Batal". */
  cancelLabel?: string;
  /** Handler ketika user mengonfirmasi. Boleh async. */
  onConfirm: () => void | Promise<void>;
  /** Varian visual.
   *   - destructive: ikon trash merah, button merah
   *   - warning: ikon segitiga amber, button biru
   *   - default: ikon lock, button biru
   */
  variant?: ConfirmVariant;
}

/** Pemetaan varian → ikon & class button. */
const VARIANT_MAP: Record<
  ConfirmVariant,
  { Icon: typeof Lock; iconClass: string; bgClass: string; confirmClass: string }
> = {
  default: {
    Icon: Lock,
    iconClass: 'text-sipandu-blue',
    bgClass: 'bg-blue-50',
    confirmClass:
      'bg-sipandu-blue text-white hover:bg-sipandu-blue/90 focus:ring-sipandu-blue',
  },
  destructive: {
    Icon: Trash2,
    iconClass: 'text-status-err',
    bgClass: 'bg-red-50',
    confirmClass:
      'bg-status-err text-white hover:bg-status-err/90 focus:ring-status-err',
  },
  warning: {
    Icon: AlertTriangle,
    iconClass: 'text-status-warn',
    bgClass: 'bg-amber-50',
    confirmClass:
      'bg-sipandu-blue text-white hover:bg-sipandu-blue/90 focus:ring-sipandu-blue',
  },
};

export function ConfirmDialog({
  trigger,
  title,
  description,
  confirmLabel = 'Konfirmasi',
  cancelLabel = 'Batal',
  onConfirm,
  variant = 'default',
}: ConfirmDialogProps) {
  const [open, setOpen] = useState(false);
  const [pending, setPending] = useState(false);
  const v = VARIANT_MAP[variant];

  async function handleConfirm() {
    setPending(true);
    try {
      await onConfirm();
      setOpen(false);
    } finally {
      setPending(false);
    }
  }

  return (
    <AlertDialog open={open} onOpenChange={setOpen}>
      <AlertDialogTrigger asChild>{trigger}</AlertDialogTrigger>
      <AlertDialogContent>
        {/* Ikon header */}
        <div
          className={cn(
            'mx-auto mb-2 flex h-12 w-12 items-center justify-center rounded-full',
            v.bgClass,
          )}
          aria-hidden
        >
          <v.Icon className={cn('h-6 w-6', v.iconClass)} />
        </div>

        <AlertDialogHeader>
          <AlertDialogTitle className="text-center">{title}</AlertDialogTitle>
          <AlertDialogDescription className="text-center">
            {description}
          </AlertDialogDescription>
        </AlertDialogHeader>

        <AlertDialogFooter>
          <AlertDialogCancel disabled={pending}>{cancelLabel}</AlertDialogCancel>
          <AlertDialogAction
            disabled={pending}
            onClick={(e) => {
              // Cegah AlertDialog menutup dialog otomatis sebelum onConfirm selesai.
              e.preventDefault();
              void handleConfirm();
            }}
            className={cn(v.confirmClass)}
          >
            {pending && (
              <Loader2 className="mr-2 h-4 w-4 animate-spin" aria-hidden />
            )}
            {confirmLabel}
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  );
}
