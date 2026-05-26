/**
 * @file siswa/_components/PeerReviewBanner.tsx
 * @description Banner amber yang tampil di S1 saat sesi peer review aktif
 *              dan siswa belum 100% selesai mengisi.
 *
 *  Berisi: deadline + progress bar + tombol "Lanjutkan Peer Review".
 *  Server Component murni.
 */

import Link from 'next/link';
import { AlertCircle, ArrowRight } from 'lucide-react';

import { ROUTES } from '@/constants';
import { formatDate } from '@/lib/utils/format';

export interface PeerReviewBannerProps {
  deadline: string | null;
  totalReviewees: number;
  myReviewsSubmitted: number;
}

export function PeerReviewBanner({
  deadline,
  totalReviewees,
  myReviewsSubmitted,
}: PeerReviewBannerProps) {
  const percent =
    totalReviewees > 0
      ? Math.round((myReviewsSubmitted / totalReviewees) * 100)
      : 0;

  return (
    <div
      className="rounded-md border border-status-warn-soft bg-amber-50 p-3.5"
      style={{ borderLeftColor: '#D97706', borderLeftWidth: 4 }}
    >
      <div className="mb-1.5 flex items-center gap-2">
        <AlertCircle
          className="h-4 w-4 text-status-warn"
          aria-hidden
        />
        <strong className="text-sm text-status-warn-text">
          Sesi Peer Review sedang berlangsung!
        </strong>
      </div>

      <div className="mb-2 text-sm text-status-warn-text">
        {deadline && (
          <>
            Deadline: <strong>{formatDate(deadline)}</strong> ·{' '}
          </>
        )}
        Anda sudah menilai <strong>{myReviewsSubmitted}</strong> dari{' '}
        <strong>{totalReviewees}</strong> teman.
      </div>

      <div className="mb-3 h-2 overflow-hidden rounded-md bg-amber-200">
        <div
          className="h-full rounded-md bg-status-warn transition-[width]"
          style={{ width: `${percent}%` }}
        />
      </div>

      <Link
        href={ROUTES.studentPeerReview}
        className="inline-flex items-center gap-1.5 rounded-md bg-sipandu-blue px-3 py-1.5 text-xs font-medium text-white transition-opacity hover:opacity-85"
      >
        <ArrowRight className="h-3 w-3" aria-hidden /> Lanjutkan Peer Review
      </Link>
    </div>
  );
}
