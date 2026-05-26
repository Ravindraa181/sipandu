/**
 * @file components/shared/ScoreCard.tsx
 * @description Kartu ringkasan skor siswa: 4 tile (X1/X2/X3/Z*) + badge kategori.
 *
 * Komponen presentational. Bisa dipakai di:
 *   - W5 Detail Siswa (Ringkasan)
 *   - S1 Dashboard Saya
 *   - Modal detail Admin A5
 *
 * Tile yang nilainya null/undefined ditampilkan sebagai "—" abu.
 *
 * @example
 *   <ScoreCard x1={91} x2={85} x3={80} zScore={88.2} category="baik" />
 *   <ScoreCard x1={null} x2={70} x3={null} category={null} />
 */

import type { CategoryType } from '@/types';
import { formatPercent, formatScore } from '@/lib/utils/format';
import { CategoryBadge } from './CategoryBadge';
import { cn } from '@/lib/utils/cn';

export interface ScoreCardProps {
  /** Persentase kehadiran (0-100). */
  x1?: number | null;
  /** Skor poin perilaku (0-100, sudah min(raw, 100)). */
  x2?: number | null;
  /** Skor peer review (0-100). */
  x3?: number | null;
  /** Skor akhir defuzzifikasi. */
  zScore?: number | null;
  /** Kategori final (dari z*). */
  category?: CategoryType | null;
  /** Tambahan class Tailwind. */
  className?: string;
}

/** Tile tunggal: label + nilai besar dengan background pastel. */
function ScoreTile(props: {
  label: string;
  value: string;
  bgClass: string;
  textClass: string;
  emphasized?: boolean;
}) {
  const { label, value, bgClass, textClass, emphasized } = props;
  const isEmpty = value === '—';

  return (
    <div
      className={cn(
        'rounded-lg p-3.5 text-center',
        bgClass,
      )}
    >
      <div
        className={cn(
          'font-bold leading-tight',
          emphasized ? 'text-3xl' : 'text-2xl',
          isEmpty ? 'text-status-off' : textClass,
        )}
      >
        {value}
      </div>
      <div className="mt-1.5 text-2xs leading-tight text-muted-foreground">
        {label}
      </div>
    </div>
  );
}

export function ScoreCard({
  x1,
  x2,
  x3,
  zScore,
  category,
  className,
}: ScoreCardProps) {
  return (
    <div
      className={cn(
        'rounded-lg border border-sipandu-border bg-white p-4',
        className,
      )}
    >
      <div className="grid grid-cols-2 gap-3 md:grid-cols-4">
        <ScoreTile
          label="Absensi"
          value={formatPercent(x1, 0)}
          bgClass="bg-tile-x1"
          textClass="text-sky-700"
        />
        <ScoreTile
          label="Poin Perilaku"
          value={formatScore(x2, 0)}
          bgClass="bg-tile-x2"
          textClass="text-violet-700"
        />
        <ScoreTile
          label="Nilai Sejawat"
          value={formatScore(x3, 0)}
          bgClass="bg-tile-x3"
          textClass="text-green-700"
        />
        <ScoreTile
          label="Nilai Akhir"
          value={formatScore(zScore, 1)}
          bgClass="bg-tile-z"
          textClass="text-sipandu-blue-deep"
          emphasized
        />
      </div>

      {/* Kategori final */}
      <div className="mt-4 flex items-center justify-center">
        <CategoryBadge category={category ?? null} size="lg" />
      </div>
    </div>
  );
}
