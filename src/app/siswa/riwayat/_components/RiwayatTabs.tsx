'use client';

/**
 * @file siswa/riwayat/_components/RiwayatTabs.tsx
 * @description Tab switcher untuk halaman riwayat siswa.
 *              3 tab: Kehadiran | Poin Perilaku | Nilai dari Teman.
 */

import { useState, type ReactNode } from 'react';
import { cn } from '@/lib/utils/cn';

type TabKey = 'kehadiran' | 'poin' | 'teman';

const TABS: Array<{ key: TabKey; label: string }> = [
  { key: 'kehadiran', label: 'Kehadiran' },
  { key: 'poin', label: 'Poin Perilaku' },
  { key: 'teman', label: 'Nilai dari Teman' },
];

export interface RiwayatTabsProps {
  kehadiranContent: ReactNode;
  poinContent: ReactNode;
  temanContent: ReactNode;
}

export function RiwayatTabs({
  kehadiranContent,
  poinContent,
  temanContent,
}: RiwayatTabsProps) {
  const [active, setActive] = useState<TabKey>('kehadiran');

  return (
    <div>
      <div className="mb-4 flex flex-wrap border-b-2 border-sipandu-border">
        {TABS.map((t) => (
          <button
            key={t.key}
            type="button"
            onClick={() => setActive(t.key)}
            className={cn(
              '-mb-0.5 border-b-2 px-3.5 py-2 text-sm font-medium transition-colors',
              active === t.key
                ? 'border-sipandu-blue font-semibold text-sipandu-blue'
                : 'border-transparent text-muted-foreground hover:text-foreground',
            )}
          >
            {t.label}
          </button>
        ))}
      </div>

      <div>
        {active === 'kehadiran' && kehadiranContent}
        {active === 'poin' && poinContent}
        {active === 'teman' && temanContent}
      </div>
    </div>
  );
}
