/**
 * @file dashboard/siswa/[id]/_components/AspectBreakdown.tsx
 * @description Visualisasi 5 aspek peer review sebagai horizontal bar.
 *              Skor per aspek 1-5 di-render sebagai % (×20).
 *
 *  Server component — pure presentational.
 */

import type { PeerReviewAspects } from '@/types';
import { ASPECT_LABELS } from '@/constants';

export interface AspectBreakdownProps {
  /** Rata-rata aspek (1-5). */
  aspects: PeerReviewAspects;
  reviewerCount: number;
}

const ASPECT_KEYS: Array<keyof PeerReviewAspects> = [
  'courtesy',
  'cooperation',
  'empathy',
  'honesty',
  'responsibility',
];

export function AspectBreakdown({
  aspects,
  reviewerCount,
}: AspectBreakdownProps) {
  // Total = average × 20 (skala 1-5 → 0-100)
  const total =
    ASPECT_KEYS.reduce((sum, k) => sum + aspects[k], 0) / 5 * 20;

  return (
    <div className="space-y-2">
      {ASPECT_KEYS.map((key) => {
        const value = aspects[key];
        // Hindari NaN / Infinity untuk skala 1-5
        const clamped = Number.isFinite(value)
          ? Math.max(0, Math.min(5, value))
          : 0;
        const percent = (clamped / 5) * 100;
        return (
          <div key={key} className="flex items-center gap-2">
            <div className="w-32 text-xs text-foreground">
              {ASPECT_LABELS[key]}
            </div>
            <div className="h-2.5 flex-1 overflow-hidden rounded-sm bg-gray-200">
              <div
                className="h-full rounded-sm bg-sipandu-blue transition-[width]"
                style={{ width: `${percent}%` }}
              />
            </div>
            <div className="w-14 text-right text-2xs text-muted-foreground">
              {clamped.toFixed(1)} / 5
            </div>
          </div>
        );
      })}

      <div className="mt-2.5 flex items-center justify-between border-t border-sipandu-border pt-2 text-sm">
        <span className="font-semibold text-foreground">
          Total X3 (rata-rata × 20)
        </span>
        <strong className="text-base text-sipandu-blue">
          {total.toFixed(1)}
        </strong>
      </div>

      <p className="text-2xs text-muted-foreground">
        Berdasarkan {reviewerCount} penilai. Identitas penilai dirahasiakan.
      </p>
    </div>
  );
}
