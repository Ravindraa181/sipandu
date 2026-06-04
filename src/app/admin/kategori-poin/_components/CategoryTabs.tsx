'use client';

/**
 * @file admin/kategori-poin/_components/CategoryTabs.tsx
 * @description Tab switcher: Pelanggaran | Reward | Peer Assessment.
 *
 *  Peer Assessment adalah "poin" yang diinput oleh siswa (penilaian antar
 *  teman), sehingga dikelola bersama kategori poin lainnya.
 */

import { useState } from 'react';
import { Info } from 'lucide-react';

import { cn } from '@/lib/utils/cn';
import { CategoryTable, type CategoryRow } from './CategoryTable';
import { AspectEditorList, type AspectItem } from './AspectEditorList';

export interface CategoryTabsProps {
  violations: CategoryRow[];
  rewards: CategoryRow[];
  aspects: AspectItem[];
}

type TabKey = 'violation' | 'reward' | 'aspect';

export function CategoryTabs({
  violations,
  rewards,
  aspects,
}: CategoryTabsProps) {
  const [active, setActive] = useState<TabKey>('violation');

  const tabClass = (key: TabKey) =>
    cn(
      '-mb-0.5 border-b-2 px-3.5 py-2 text-sm font-medium transition-colors',
      active === key
        ? 'border-sipandu-blue font-semibold text-sipandu-blue'
        : 'border-transparent text-muted-foreground hover:text-foreground',
    );

  return (
    <div>
      <div className="mb-4 flex border-b-2 border-sipandu-border">
        <button
          type="button"
          onClick={() => setActive('violation')}
          className={tabClass('violation')}
        >
          Pelanggaran ({violations.length})
        </button>
        <button
          type="button"
          onClick={() => setActive('reward')}
          className={tabClass('reward')}
        >
          Reward ({rewards.length})
        </button>
        <button
          type="button"
          onClick={() => setActive('aspect')}
          className={tabClass('aspect')}
        >
          Peer Assessment ({aspects.length})
        </button>
      </div>

      {/* Catatan soft-delete hanya relevan untuk Pelanggaran & Reward */}
      {active !== 'aspect' && (
        <div className="mb-3 flex items-start gap-2 rounded-md border-l-4 border-sipandu-blue bg-blue-50 px-3 py-2.5 text-sm text-sipandu-blue-deep">
          <Info className="mt-0.5 h-3.5 w-3.5 flex-shrink-0" aria-hidden />
          <p>
            Kategori yang dihapus akan dinonaktifkan (soft delete). Riwayat
            transaksi yang sudah ada tetap tersimpan untuk audit trail.
          </p>
        </div>
      )}

      {active === 'violation' && (
        <CategoryTable type="violation" rows={violations} />
      )}
      {active === 'reward' && <CategoryTable type="reward" rows={rewards} />}
      {active === 'aspect' && <AspectEditorList aspects={aspects} />}
    </div>
  );
}
