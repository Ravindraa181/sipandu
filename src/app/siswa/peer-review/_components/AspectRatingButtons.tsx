'use client';

/**
 * @file siswa/peer-review/_components/AspectRatingButtons.tsx
 * @description 5 tombol rating skala 1-5 untuk satu aspek peer review.
 *              Label di bawah nomor: Sangat Buruk, Buruk, Cukup, Baik,
 *              Sangat Baik (sesuai SYSTEM_CONTEXT §7.8).
 */

import { cn } from '@/lib/utils/cn';
import { ASPECT_SCALE_LABELS } from '@/constants';

export interface AspectRatingButtonsProps {
  aspectIndex: number;
  /** Skala 1-5, atau 0 = belum dipilih. */
  value: number;
  onChange: (value: number) => void;
  /** ID untuk a11y. */
  inputId: string;
}

export function AspectRatingButtons({
  aspectIndex,
  value,
  onChange,
  inputId,
}: AspectRatingButtonsProps) {
  return (
    <div
      className="flex flex-wrap gap-2.5"
      role="radiogroup"
      aria-labelledby={`${inputId}-label`}
    >
      {[1, 2, 3, 4, 5].map((v) => {
        const selected = value === v;
        return (
          <button
            key={`${inputId}-${v}`}
            type="button"
            role="radio"
            aria-checked={selected}
            onClick={() => onChange(v)}
            className={cn(
              'flex min-w-[68px] flex-col items-center gap-1 rounded-lg border-2 px-4 py-2.5 transition-colors',
              selected
                ? 'border-sipandu-blue bg-blue-50'
                : 'border-sipandu-border bg-white hover:border-gray-300',
            )}
          >
            <span
              className={cn(
                'text-2xl font-bold',
                selected ? 'text-sipandu-blue-deep' : 'text-foreground',
              )}
            >
              {v}
            </span>
            <span
              className={cn(
                'text-2xs',
                selected ? 'text-sipandu-blue-deep' : 'text-muted-foreground',
              )}
            >
              {ASPECT_SCALE_LABELS[v - 1]}
            </span>
          </button>
        );
      })}
      {/* Hidden index untuk debugging — tidak dirender */}
      <span className="sr-only">Aspek {aspectIndex + 1}</span>
    </div>
  );
}
