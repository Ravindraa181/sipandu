/**
 * @file components/shared/AchievementBadge.tsx
 * @description Komponen tampilan lencana (badge) gamifikasi siswa.
 *
 *  Komponen presentational murni — tidak butuh `'use client'`.
 *
 *  Penanda visual dua kelompok badge:
 *   - group 'hasil'       → ikon dalam LINGKARAN, warna mengikuti token
 *                           kategori Z* yang sudah dipakai sistem.
 *   - group 'partisipasi' → ikon dalam KOTAK MEMBULAT + garis putus-putus,
 *                           aksen amber (warna yang sudah dipakai di modul
 *                           peer review) agar terbaca berbeda sifatnya.
 *
 * @example
 *   <AchievementBadge id="teladan" />
 *   <BadgeShowcase earned={['prestasi', 'penilai_aktif']} />
 */

import {
  CalendarCheck,
  ClipboardCheck,
  Crown,
  Handshake,
  Star,
  TrendingUp,
  Trophy,
  type LucideIcon,
} from 'lucide-react';

import { cn } from '@/lib/utils/cn';
import {
  BADGE_BY_ID,
  BADGE_TIER_LABEL,
  sortBadgeIds,
  type BadgeIconKey,
  type BadgeId,
} from '@/lib/badges/definitions';

const ICON_MAP: Readonly<Record<BadgeIconKey, LucideIcon>> = {
  'calendar-check': CalendarCheck,
  trophy: Trophy,
  handshake: Handshake,
  star: Star,
  'trending-up': TrendingUp,
  crown: Crown,
  'clipboard-check': ClipboardCheck,
} as const;

export interface AchievementBadgeProps {
  id: BadgeId;
  /** Ukuran badge. Default `md`. */
  size?: 'sm' | 'md' | 'lg';
  /** Tampilkan nama badge di samping ikon. Default `true`. */
  showLabel?: boolean;
  className?: string;
}

const SIZE = {
  sm: { chip: 'gap-1.5 px-2 py-1', icon: 'h-6 w-6', glyph: 'h-3.5 w-3.5', text: 'text-2xs' },
  md: { chip: 'gap-2 px-2.5 py-1.5', icon: 'h-8 w-8', glyph: 'h-4 w-4', text: 'text-xs' },
  lg: { chip: 'gap-2.5 px-3 py-2', icon: 'h-11 w-11', glyph: 'h-5 w-5', text: 'text-sm' },
} as const;

export function AchievementBadge({
  id,
  size = 'md',
  showLabel = true,
  className,
}: AchievementBadgeProps) {
  const def = BADGE_BY_ID[id];
  const Icon = ICON_MAP[def.iconKey];
  const s = SIZE[size];
  const isParticipation = def.group === 'partisipasi';

  return (
    <div
      className={cn(
        'inline-flex items-center border',
        isParticipation ? 'rounded-lg border-dashed' : 'rounded-full',
        def.chipClass,
        s.chip,
        className,
      )}
      title={`${def.name} — ${def.requirement} (Tingkat: ${BADGE_TIER_LABEL[def.tier]})`}
      aria-label={`Lencana ${def.name}: ${def.requirement}`}
    >
      <span
        className={cn(
          'flex flex-shrink-0 items-center justify-center',
          isParticipation ? 'rounded-md' : 'rounded-full',
          def.iconClass,
          s.icon,
        )}
        aria-hidden
      >
        <Icon className={s.glyph} />
      </span>

      {showLabel && (
        <span className={cn('font-semibold whitespace-nowrap', s.text)}>
          {def.name}
        </span>
      )}
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════════
 *  Showcase — daftar badge + empty state
 * ═══════════════════════════════════════════════════════════════════ */

export interface BadgeShowcaseProps {
  earned: readonly BadgeId[];
  size?: AchievementBadgeProps['size'];
  /** Teks saat siswa belum meraih badge apa pun. */
  emptyText?: string;
  className?: string;
}

/**
 * Menampilkan sederet badge yang diraih. Bila kosong, menampilkan
 * keterangan wajar (bukan area kosong/rusak).
 */
export function BadgeShowcase({
  earned,
  size = 'md',
  emptyText = 'Belum ada lencana pada periode ini.',
  className,
}: BadgeShowcaseProps) {
  if (earned.length === 0) {
    return (
      <p
        className={cn(
          'rounded-md bg-gray-50 px-3 py-2.5 text-xs italic text-muted-foreground',
          className,
        )}
      >
        {emptyText}
      </p>
    );
  }

  return (
    <div className={cn('flex flex-wrap gap-2', className)}>
      {sortBadgeIds(earned).map((id) => (
        <AchievementBadge key={id} id={id} size={size} />
      ))}
    </div>
  );
}
