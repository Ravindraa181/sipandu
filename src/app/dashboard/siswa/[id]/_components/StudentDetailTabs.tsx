'use client';

/**
 * @file dashboard/siswa/[id]/_components/StudentDetailTabs.tsx
 * @description Tab switcher untuk halaman detail siswa W5.
 *              5 tab: Ringkasan | Kehadiran | Poin Perilaku | Peer Review | Histori.
 *              Container saja — konten masing-masing tab disuntik via prop.
 */

import { useState, type ReactNode } from 'react';
import { cn } from '@/lib/utils/cn';

export type DetailTabKey =
  | 'ringkasan'
  | 'kehadiran'
  | 'poin'
  | 'peer'
  | 'histori';

const TABS: Array<{ key: DetailTabKey; label: string }> = [
  { key: 'ringkasan', label: 'Ringkasan' },
  { key: 'kehadiran', label: 'Kehadiran' },
  { key: 'poin', label: 'Poin Perilaku' },
  { key: 'peer', label: 'Peer Review' },
  { key: 'histori', label: 'Histori' },
];

export interface StudentDetailTabsProps {
  ringkasanContent: ReactNode;
  kehadiranContent: ReactNode;
  poinContent: ReactNode;
  peerContent: ReactNode;
  historiContent: ReactNode;
}

export function StudentDetailTabs({
  ringkasanContent,
  kehadiranContent,
  poinContent,
  peerContent,
  historiContent,
}: StudentDetailTabsProps) {
  const [active, setActive] = useState<DetailTabKey>('ringkasan');

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
        {active === 'ringkasan' && ringkasanContent}
        {active === 'kehadiran' && kehadiranContent}
        {active === 'poin' && poinContent}
        {active === 'peer' && peerContent}
        {active === 'histori' && historiContent}
      </div>
    </div>
  );
}
