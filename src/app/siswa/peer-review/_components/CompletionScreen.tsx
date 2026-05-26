/**
 * @file siswa/peer-review/_components/CompletionScreen.tsx
 * @description Screen sukses ketika siswa sudah menilai semua teman.
 *              Server Component murni.
 */

import Link from 'next/link';
import { CircleCheck, Home } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { ROUTES } from '@/constants';

export interface CompletionScreenProps {
  totalReviewees: number;
}

export function CompletionScreen({ totalReviewees }: CompletionScreenProps) {
  return (
    <div className="rounded-md border border-sipandu-border bg-white px-6 py-16 text-center">
      <div className="mx-auto mb-5 flex h-20 w-20 items-center justify-center rounded-full bg-status-on-soft">
        <CircleCheck className="h-10 w-10 text-status-on" aria-hidden />
      </div>

      <h2 className="mb-2 text-2xl font-bold text-foreground">
        Semua penilaian selesai!
      </h2>
      <p className="mb-1 text-sm text-foreground">
        Anda telah menilai semua <strong>{totalReviewees}</strong> teman
        sekelas.
      </p>
      <p className="mb-6 text-xs text-muted-foreground">
        Terima kasih atas partisipasi jujur Anda dalam Peer Review.
      </p>

      <Button
        asChild
        className="gap-1.5 bg-sipandu-blue text-white hover:bg-sipandu-blue/90"
      >
        <Link href={ROUTES.studentHome}>
          <Home className="h-3.5 w-3.5" aria-hidden /> Kembali ke Dashboard
        </Link>
      </Button>
    </div>
  );
}
