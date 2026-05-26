/**
 * @file components/shared/PageHeader.tsx
 * @description Header tiap halaman: judul besar di kiri, slot aksi di kanan.
 *
 *  Server component — tidak perlu `'use client'`. Slot `actions` boleh
 *  berisi Client Component (mis. button yang trigger modal).
 *
 * @example
 *   <PageHeader
 *     title="Manajemen siswa"
 *     subtitle="Total 320 siswa aktif"
 *     actions={<><Button>Import Excel</Button><Button>Tambah</Button></>}
 *   />
 */

import type { ReactNode } from 'react';
import { cn } from '@/lib/utils/cn';

export interface PageHeaderProps {
  /** Judul halaman, ukuran 17px / bold (sesuai mockup). */
  title: string;
  /** Subjudul opsional di bawah judul. */
  subtitle?: string;
  /** Slot action: button-button di kanan. */
  actions?: ReactNode;
  /** Tambahan class. */
  className?: string;
}

export function PageHeader({
  title,
  subtitle,
  actions,
  className,
}: PageHeaderProps) {
  return (
    <div
      className={cn(
        'mb-4 flex flex-wrap items-start justify-between gap-3',
        className,
      )}
    >
      <div className="min-w-0 flex-1">
        <h1 className="text-xl font-bold leading-tight text-foreground">
          {title}
        </h1>
        {subtitle && (
          <p className="mt-1 text-sm text-muted-foreground">{subtitle}</p>
        )}
      </div>

      {actions && (
        <div className="flex flex-wrap items-center gap-2">{actions}</div>
      )}
    </div>
  );
}
