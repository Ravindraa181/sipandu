/**
 * @file lib/utils/cn.ts
 * @description Helper className merger — gabungan `clsx` (conditional)
 *              dan `tailwind-merge` (deduplikasi Tailwind class).
 *
 * Hampir semua komponen pakai ini untuk menggabungkan className statis,
 * conditional, dan dari prop.
 *
 * @example
 *   <div className={cn('px-4 py-2', isActive && 'bg-sipandu-blue', className)} />
 */

import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

/**
 * Gabung beberapa class string/object/array secara aman, lalu
 * deduplikasi class Tailwind yang berkonflik (mis. `px-4 px-6` → `px-6`).
 */
export function cn(...inputs: ClassValue[]): string {
  return twMerge(clsx(inputs));
}
