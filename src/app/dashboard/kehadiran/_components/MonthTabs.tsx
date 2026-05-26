'use client';

/**
 * @file dashboard/kehadiran/_components/MonthTabs.tsx
 * @description Pill tabs untuk navigasi antar bulan dalam periode aktif.
 *              4 state visual: active (sedang dibuka), locked (terkunci),
 *              upcoming (default), future (belum waktunya, disabled).
 */

import { useRouter, useSearchParams } from 'next/navigation';
import { useTransition } from 'react';
import { Check, Circle, Loader2 } from 'lucide-react';
import { cn } from '@/lib/utils/cn';
import { MONTHS } from '@/constants';

export interface MonthTab {
  month: number; // 1-12
  year: number;
  effectiveDays: number;
  uiState: 'locked' | 'active' | 'upcoming' | 'future';
}

export interface MonthTabsProps {
  tabs: MonthTab[];
  activeMonth: number;
  activeYear: number;
}

export function MonthTabs({
  tabs,
  activeMonth,
  activeYear,
}: MonthTabsProps) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [pending, startTransition] = useTransition();

  function selectMonth(t: MonthTab) {
    if (t.uiState === 'future') return;
    const params = new URLSearchParams(searchParams.toString());
    params.set('month', String(t.month));
    params.set('year', String(t.year));
    startTransition(() => {
      router.push(`?${params.toString()}`);
    });
  }

  return (
    <div className="flex flex-wrap items-center gap-2">
      {tabs.map((t) => {
        const isActive = t.month === activeMonth && t.year === activeYear;
        const baseClass =
          'inline-flex items-center gap-1.5 rounded-md border px-3 py-1.5 text-sm font-medium transition-colors';

        let variantClass = '';
        if (isActive) {
          variantClass =
            'border-sipandu-blue bg-sipandu-blue text-white';
        } else if (t.uiState === 'locked') {
          variantClass =
            'border-status-on bg-green-50 text-status-on-text hover:bg-green-100';
        } else if (t.uiState === 'future') {
          variantClass =
            'border-sipandu-border bg-gray-100 text-muted-foreground cursor-not-allowed';
        } else {
          variantClass =
            'border-gray-300 bg-white text-foreground hover:bg-gray-50';
        }

        return (
          <button
            key={`${t.year}-${t.month}`}
            type="button"
            onClick={() => selectMonth(t)}
            disabled={t.uiState === 'future' || pending}
            className={cn(baseClass, variantClass)}
          >
            {MONTHS[t.month - 1]}
            {t.uiState === 'locked' && (
              <Check className="h-3 w-3" aria-hidden />
            )}
            {t.uiState === 'future' && (
              <Circle className="h-3 w-3" aria-hidden />
            )}
          </button>
        );
      })}
      {pending && (
        <Loader2
          className="h-3.5 w-3.5 animate-spin text-muted-foreground"
          aria-hidden
        />
      )}
    </div>
  );
}
