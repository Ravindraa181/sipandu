'use client';

/**
 * @file admin/kategori-poin/_components/CategoryTabs.tsx
 * @description Tab switcher: Pelanggaran | Reward.
 */

import { useState } from 'react';
import { cn } from '@/lib/utils/cn';
import { CategoryTable, type CategoryRow } from './CategoryTable';

export interface CategoryTabsProps {
  violations: CategoryRow[];
  rewards: CategoryRow[];
}

type TabKey = 'violation' | 'reward';

export function CategoryTabs({ violations, rewards }: CategoryTabsProps) {
  const [active, setActive] = useState<TabKey>('violation');

  return (
    <div>
      <div className="mb-4 flex border-b-2 border-sipandu-border">
        <button
          type="button"
          onClick={() => setActive('violation')}
          className={cn(
            '-mb-0.5 border-b-2 px-3.5 py-2 text-sm font-medium transition-colors',
            active === 'violation'
              ? 'border-sipandu-blue font-semibold text-sipandu-blue'
              : 'border-transparent text-muted-foreground hover:text-foreground',
          )}
        >
          Pelanggaran ({violations.length})
        </button>
        <button
          type="button"
          onClick={() => setActive('reward')}
          className={cn(
            '-mb-0.5 border-b-2 px-3.5 py-2 text-sm font-medium transition-colors',
            active === 'reward'
              ? 'border-sipandu-blue font-semibold text-sipandu-blue'
              : 'border-transparent text-muted-foreground hover:text-foreground',
          )}
        >
          Reward ({rewards.length})
        </button>
      </div>

      {active === 'violation' && (
        <CategoryTable type="violation" rows={violations} />
      )}
      {active === 'reward' && <CategoryTable type="reward" rows={rewards} />}
    </div>
  );
}
