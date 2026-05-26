/**
 * @file components/shared/CategoryBadge.tsx
 * @description Badge yang menampilkan kategori akhir Z* (4 varian warna)
 *              + state "Belum Dinilai" untuk skor yang belum dihitung.
 *
 * Komponen presentational murni — tidak butuh `'use client'`.
 *
 * @example
 *   <CategoryBadge category="baik" />
 *   <CategoryBadge category={null} size="sm" />
 *   <CategoryBadge category="sangat_baik" size="lg" />
 */

import { CATEGORY_CONFIG } from '@/constants';
import type { CategoryType } from '@/types';
import { cn } from '@/lib/utils/cn';

export interface CategoryBadgeProps {
  /** Kategori akhir Z*. `null` → tampilkan "Belum Dinilai". */
  category: CategoryType | null | undefined;
  /** Ukuran badge. Default `md`. */
  size?: 'sm' | 'md' | 'lg';
  /** Tambahan class Tailwind. */
  className?: string;
}

const SIZE_CLASS: Record<NonNullable<CategoryBadgeProps['size']>, string> = {
  sm: 'px-2 py-0.5 text-2xs',
  md: 'px-2.5 py-0.5 text-xs',
  lg: 'px-4 py-1 text-base font-semibold',
};

export function CategoryBadge({
  category,
  size = 'md',
  className,
}: CategoryBadgeProps) {
  // ── State: belum dinilai ──────────────────────────────────────────
  if (!category) {
    return (
      <span
        className={cn(
          'inline-flex items-center rounded-full font-semibold whitespace-nowrap',
          'bg-status-off-soft text-status-off-text',
          SIZE_CLASS[size],
          className,
        )}
        aria-label="Skor belum dinilai"
      >
        Belum Dinilai
      </span>
    );
  }

  const cfg = CATEGORY_CONFIG[category];

  return (
    <span
      className={cn(
        'inline-flex items-center rounded-full font-semibold whitespace-nowrap',
        cfg.badgeClass,
        SIZE_CLASS[size],
        className,
      )}
      aria-label={`Kategori ${cfg.label}`}
    >
      {cfg.label}
    </span>
  );
}
