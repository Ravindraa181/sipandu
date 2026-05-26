'use client';

/**
 * @file dashboard/peer-review/_components/CloseSessionButton.tsx
 *
 * FIX TS2353 (line 26):
 *   closePeerSession menerima { sessionId: string }, bukan { assignmentId }.
 *   Ganti prop dari `assignmentId` → `sessionId` dan update call.
 *   Halaman pemanggil (peer-review/page.tsx) juga sudah diupdate
 *   untuk meneruskan sessionId.
 */

import { useTransition } from 'react';
import { Square } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import { ConfirmDialog } from '@/components/shared/ConfirmDialog';
import { closePeerSession } from '@/lib/actions/teacher';

export interface CloseSessionButtonProps {
  // FIX: sessionId (bukan assignmentId) — sesuai arg closePeerSession
  sessionId: string;
}

export function CloseSessionButton({ sessionId }: CloseSessionButtonProps) {
  const [pending, startTransition] = useTransition();

  function handleConfirm(): Promise<void> {
    return new Promise((resolve) => {
      startTransition(async () => {
        // FIX: { sessionId } bukan { assignmentId }
        const result = await closePeerSession({ sessionId });
        if (result.ok) {
          toast.success('Sesi Peer Review ditutup');
        } else {
          toast.error('Gagal menutup sesi', { description: result.error });
        }
        resolve();
      });
    });
  }

  return (
    <ConfirmDialog
      trigger={
        <Button
          type="button"
          variant="outline"
          size="sm"
          className="gap-1.5 border-status-err text-status-err hover:bg-red-50"
          disabled={pending}
        >
          <Square className="h-3 w-3" aria-hidden /> Tutup Sesi Lebih Awal
        </Button>
      }
      title="Tutup sesi Peer Review lebih awal?"
      description="Setelah ditutup, siswa tidak bisa lagi mengisi penilaian. Skor X3 akan dihitung final dari penilaian yang sudah masuk."
      confirmLabel="Ya, Tutup Sesi"
      variant="destructive"
      onConfirm={handleConfirm}
    />
  );
}
