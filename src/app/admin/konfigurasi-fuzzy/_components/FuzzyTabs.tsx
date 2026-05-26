'use client';

/**
 * @file admin/konfigurasi-fuzzy/_components/FuzzyTabs.tsx
 * @description Tab switcher untuk konfigurasi fuzzy:
 *              Variabel Input | Variabel Output | Rule Base | Simulasi | Pengaturan Sekolah.
 */

import { useState, type ReactNode } from 'react';
import { cn } from '@/lib/utils/cn';

export type FuzzyTabKey = 'input' | 'output' | 'rule' | 'sim' | 'settings';

export interface FuzzyTabsProps {
  inputContent:    ReactNode;
  outputContent:   ReactNode;
  ruleContent:     ReactNode;
  simContent:      ReactNode;
  /** Konten tab Pengaturan Sekolah (nama & NIP kepala sekolah). */
  settingsContent: ReactNode;
}

const TABS: Array<{ key: FuzzyTabKey; label: string }> = [
  { key: 'input',    label: 'Variabel Input'     },
  { key: 'output',   label: 'Variabel Output'    },
  { key: 'rule',     label: 'Rule Base'          },
  { key: 'sim',      label: 'Simulasi'           },
  { key: 'settings', label: 'Pengaturan Sekolah' },
];

export function FuzzyTabs({
  inputContent,
  outputContent,
  ruleContent,
  simContent,
  settingsContent,
}: FuzzyTabsProps) {
  const [active, setActive] = useState<FuzzyTabKey>('input');

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
        {active === 'input'    && inputContent}
        {active === 'output'   && outputContent}
        {active === 'rule'     && ruleContent}
        {active === 'sim'      && simContent}
        {active === 'settings' && settingsContent}
      </div>
    </div>
  );
}
