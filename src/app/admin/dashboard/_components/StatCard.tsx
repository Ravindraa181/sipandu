/**
 * @file app/admin/dashboard/_components/StatCard.tsx
 * @description Kartu statistik kecil untuk dashboard A1.
 *
 *  Pola visual: border-left 4px berwarna + label kecil di atas + angka
 *  besar di tengah + sub-label kecil di bawah + ikon Lucide opacity 18%
 *  di kanan.
 *
 *  Server component murni — tidak punya state, tidak butuh `'use client'`.
 */

import type { LucideIcon } from 'lucide-react';
import { cn } from '@/lib/utils/cn';

export type StatCardAccent = 'blue' | 'green' | 'amber' | 'navy';

export interface StatCardProps {
  /** Label atas (mis. "Total Siswa Aktif"). */
  label: string;
  /** Nilai utama (angka atau teks pendek). */
  value: string | number;
  /** Sub-label kecil di bawah angka. */
  subLabel?: string;
  /** Ikon Lucide yang ditampilkan di kanan dengan opacity rendah. */
  icon?: LucideIcon;
  /** Warna border-left & ikon. Default: blue. */
  accent?: StatCardAccent;
  /** Bila true, value akan dirender dengan ukuran font lebih kecil
   *  (untuk teks panjang seperti "Ganjil 24/25"). */
  smallValue?: boolean;
}

const ACCENT_MAP: Record<
  StatCardAccent,
  { borderClass: string; iconHex: string }
> = {
  blue: { borderClass: 'border-l-sipandu-blue', iconHex: '#2D7DD2' },
  green: { borderClass: 'border-l-status-on', iconHex: '#16A34A' },
  amber: { borderClass: 'border-l-status-warn', iconHex: '#D97706' },
  navy: { borderClass: 'border-l-sipandu-navy', iconHex: '#1E3A5F' },
};

export function StatCard({
  label,
  value,
  subLabel,
  icon: Icon,
  accent = 'blue',
  smallValue = false,
}: StatCardProps) {
  const a = ACCENT_MAP[accent];

  return (
    <div
      className={cn(
        'rounded-md border border-sipandu-border bg-white p-3.5',
        'border-l-4',
        a.borderClass,
      )}
    >
      <div className="flex items-start justify-between gap-2">
        <div className="min-w-0 flex-1">
          <div className="mb-1 text-xs text-muted-foreground">{label}</div>
          <div
            className={cn(
              'font-bold leading-tight text-foreground',
              smallValue ? 'text-md mt-1' : 'text-3xl',
            )}
          >
            {value}
          </div>
          {subLabel && (
            <div className="mt-1 text-2xs text-muted-foreground">{subLabel}</div>
          )}
        </div>

        {Icon && (
          <Icon
            className="h-7 w-7 flex-shrink-0 opacity-20"
            style={{ color: a.iconHex }}
            aria-hidden
          />
        )}
      </div>
    </div>
  );
}
