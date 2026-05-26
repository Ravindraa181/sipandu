/**
 * @file siswa/_components/StudentScoreCard.tsx
 * @description Kartu besar yang menampilkan 4 tile pastel
 *              (X1/X2/X3/Z*) + interpretasi naratif positif.
 *
 *  Server Component. Tidak overlap dengan @/components/shared/ScoreCard
 *  karena yang ini lebih besar dan punya kolom interpretasi.
 */

import { MessageCircle } from 'lucide-react';

import { CategoryBadge } from '@/components/shared/CategoryBadge';
import {
  formatPercent,
  formatScore,
  getInterpretationText,
} from '@/lib/utils/format';
import type { CategoryType } from '@/types';

export interface StudentScoreCardProps {
  periodLabel: string;
  x1: number | null;
  x2: number | null;
  x3: number | null;
  zScore: number | null;
  category: CategoryType | null;
}

export function StudentScoreCard({
  periodLabel,
  x1,
  x2,
  x3,
  zScore,
  category,
}: StudentScoreCardProps) {
  const interpretation = getInterpretationText(category, { x1, x2, x3 });

  const tiles: Array<{
    label: string;
    value: string;
    bgClass: string;
    textClass: string;
    showBadge?: boolean;
  }> = [
    {
      label: 'Absensi',
      value: formatPercent(x1, 0),
      bgClass: 'bg-tile-x1',
      textClass: 'text-sky-700',
    },
    {
      label: 'Poin Perilaku',
      value: formatScore(x2, 0),
      bgClass: 'bg-tile-x2',
      textClass: 'text-violet-700',
    },
    {
      label: 'Nilai Sejawat',
      value: formatScore(x3, 0),
      bgClass: 'bg-tile-x3',
      textClass: 'text-green-700',
    },
    {
      label: 'Nilai Akhir',
      value: formatScore(zScore, 1),
      bgClass: 'bg-tile-z',
      textClass: 'text-sipandu-blue-deep',
      showBadge: true,
    },
  ];

  return (
    <div className="rounded-md border border-sipandu-border bg-white p-4">
      <h2 className="mb-3 text-base font-bold text-foreground">
        Penilaian Perilaku Anda — {periodLabel}
      </h2>

      <div className="mb-3 grid grid-cols-2 gap-3 lg:grid-cols-4">
        {tiles.map((t) => (
          <div
            key={t.label}
            className={`rounded-lg p-3.5 text-center ${t.bgClass}`}
          >
            <div
              className={`text-3xl font-bold leading-tight ${t.textClass} ${t.value === '—' ? 'text-status-off' : ''}`}
            >
              {t.value}
            </div>
            <div className="mt-1.5 text-2xs leading-tight text-muted-foreground">
              {t.label}
            </div>
            {t.showBadge && (
              <div className="mt-2">
                <CategoryBadge category={category} size="sm" />
              </div>
            )}
          </div>
        ))}
      </div>

      <div className="flex items-start gap-2 rounded-md border-l-4 border-sipandu-blue bg-blue-50 px-3 py-2.5 text-sm text-sipandu-blue-deep">
        <MessageCircle
          className="mt-0.5 h-3.5 w-3.5 flex-shrink-0"
          aria-hidden
        />
        <p className="leading-relaxed">{interpretation}</p>
      </div>
    </div>
  );
}
