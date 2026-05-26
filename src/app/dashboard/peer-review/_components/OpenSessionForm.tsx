'use client';

/**
 * @file dashboard/peer-review/_components/OpenSessionForm.tsx
 * @description Form untuk membuka sesi peer review baru.
 *              Berisi date picker untuk deadline + tombol "Buka Sesi".
 */

import { useState, useTransition } from 'react';
import { Loader2, Play } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { openPeerSession } from '@/lib/actions/teacher';

export interface OpenSessionFormProps {
  assignmentId: string;
}

/** Default deadline = hari ini + 14 hari. */
function getDefaultDeadline(): string {
  const d = new Date();
  d.setDate(d.getDate() + 14);
  return d.toISOString().slice(0, 10);
}

export function OpenSessionForm({ assignmentId }: OpenSessionFormProps) {
  const [pending, startTransition] = useTransition();
  const [deadline, setDeadline] = useState<string>(getDefaultDeadline());

  function handleOpen() {
    if (!deadline) {
      toast.error('Tetapkan deadline terlebih dahulu');
      return;
    }
    startTransition(async () => {
      const result = await openPeerSession({ assignmentId, deadline });
      if (result.ok) toast.success('Sesi Peer Review berhasil dibuka');
      else toast.error('Gagal membuka sesi', { description: result.error });
    });
  }

  return (
    <div className="flex flex-wrap items-end gap-2.5">
      <div className="flex-1">
        <Label htmlFor="deadline">Deadline pengisian</Label>
        <Input
          id="deadline"
          type="date"
          value={deadline}
          onChange={(e) => setDeadline(e.target.value)}
          min={new Date().toISOString().slice(0, 10)}
          className="max-w-[220px]"
        />
      </div>
      <Button
        type="button"
        onClick={handleOpen}
        disabled={pending}
        className="gap-1.5 bg-sipandu-blue text-white hover:bg-sipandu-blue/90"
      >
        {pending ? (
          <Loader2 className="h-3.5 w-3.5 animate-spin" aria-hidden />
        ) : (
          <Play className="h-3.5 w-3.5" aria-hidden />
        )}
        Buka Sesi Peer Review
      </Button>
    </div>
  );
}
