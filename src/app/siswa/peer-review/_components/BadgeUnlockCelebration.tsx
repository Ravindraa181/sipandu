'use client';

/**
 * @file siswa/peer-review/_components/BadgeUnlockCelebration.tsx
 * @description Umpan balik LANGSUNG saat siswa menuntaskan penilaian teman
 *              terakhir yang ditugaskan — lencana "Penilai Aktif" muncul
 *              dengan animasi singkat sebelum siswa kembali ke dashboard.
 *
 *  Pemicu (lihat PeerReviewForm): dirender HANYA pada momen submission
 *  terakhir berhasil, karena state pemicunya lokal di form dan di-set di
 *  dalam handler submit. Membuka ulang halaman TIDAK memicu animasi ini —
 *  siswa akan melihat CompletionScreen (showcase pasif) sebagai gantinya.
 *
 *  Penguatan (reinforcement) paling efektif bila muncul segera setelah
 *  perilaku yang diinginkan dilakukan — karena itu badge partisipasi ini
 *  tidak menunggu siswa membuka dashboard.
 */

import Link from 'next/link';
import { Home, Sparkles } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { AchievementBadge } from '@/components/shared/AchievementBadge';
import { BADGE_BY_ID } from '@/lib/badges/definitions';
import { ROUTES } from '@/constants';

export interface BadgeUnlockCelebrationProps {
  /** Jumlah teman yang ditugaskan & berhasil dinilai. */
  totalReviewees: number;
}

export function BadgeUnlockCelebration({
  totalReviewees,
}: BadgeUnlockCelebrationProps) {
  const def = BADGE_BY_ID.penilai_aktif;

  return (
    <div className="animate-fade-in rounded-md border border-amber-300 bg-white px-6 py-12 text-center">
      {/* Lencana yang baru diraih */}
      <div className="relative mx-auto mb-5 w-fit">
        <span
          className="absolute -inset-3 animate-ping rounded-full bg-amber-200/50"
          aria-hidden
        />
        <div className="animate-badge-pop relative">
          <AchievementBadge id="penilai_aktif" size="lg" showLabel={false} />
        </div>
        <Sparkles
          className="absolute -right-3 -top-2 h-5 w-5 animate-pulse text-amber-500"
          aria-hidden
        />
      </div>

      <p className="mb-1 inline-flex items-center gap-1.5 rounded-full bg-amber-50 px-3 py-1 text-xs font-bold uppercase tracking-wide text-amber-700">
        Lencana baru diraih
      </p>

      <h2 className="mb-1.5 mt-3 text-2xl font-bold text-foreground">
        {def.name}
      </h2>
      <p className="mx-auto mb-1 max-w-md text-sm text-foreground">
        Kamu sudah menyelesaikan seluruh <strong>{totalReviewees}</strong>{' '}
        penilaian teman yang ditugaskan. Kerja bagus!
      </p>
      <p className="mx-auto mb-6 max-w-md text-xs text-muted-foreground">
        Penilaianmu membantu sistem menghitung nilai sejawat (X3) teman-teman
        sekelas dengan lebih akurat. Terima kasih atas partisipasi jujurmu.
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
