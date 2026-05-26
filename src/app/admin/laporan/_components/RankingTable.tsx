'use client';

/**
 * @file admin/laporan/_components/RankingTable.tsx
 * @description Tabel ranking siswa berdasarkan Z* (sortable).
 */

import { useMemo, useState } from 'react';
import { ArrowUpDown } from 'lucide-react';

import { CategoryBadge } from '@/components/shared/CategoryBadge';
import type { CategoryType } from '@/types';
import { formatPercent, formatScore } from '@/lib/utils/format';

export interface RankingRow {
  rank: number;
  studentId: string;
  nis: string;
  fullName: string;
  className: string;
  x1: number | null;
  x2: number | null;
  x3: number | null;
  zScore: number | null;
  category: CategoryType | null;
}

type SortKey = 'rank' | 'fullName' | 'className' | 'zScore';

export interface RankingTableProps {
  rows: RankingRow[];
}

export function RankingTable({ rows }: RankingTableProps) {
  const [sortBy, setSortBy] = useState<SortKey>('rank');
  const [sortDir, setSortDir] = useState<'asc' | 'desc'>('asc');

  const sorted = useMemo(() => {
    return [...rows].sort((a, b) => {
      const av = a[sortBy];
      const bv = b[sortBy];
      let cmp = 0;
      if (typeof av === 'string' && typeof bv === 'string') {
        cmp = av.localeCompare(bv);
      } else if (typeof av === 'number' && typeof bv === 'number') {
        cmp = av - bv;
      } else if (av === null && bv !== null) cmp = 1;
      else if (av !== null && bv === null) cmp = -1;
      return sortDir === 'asc' ? cmp : -cmp;
    });
  }, [rows, sortBy, sortDir]);

  function toggleSort(col: SortKey) {
    if (sortBy === col) setSortDir((d) => (d === 'asc' ? 'desc' : 'asc'));
    else {
      setSortBy(col);
      setSortDir('asc');
    }
  }

  return (
    <div className="overflow-hidden rounded-md border border-sipandu-border bg-white">
      <div className="overflow-x-auto">
        <table className="w-full border-collapse text-sm">
          <thead>
            <tr className="border-b border-sipandu-border bg-gray-100 text-left">
              <th className="w-12 px-3 py-2 text-center text-xs font-semibold">
                <button
                  type="button"
                  onClick={() => toggleSort('rank')}
                  className="flex items-center justify-center gap-1 hover:text-sipandu-blue"
                >
                  # <ArrowUpDown className="h-3 w-3" aria-hidden />
                </button>
              </th>
              <th className="px-3 py-2 text-xs font-semibold">NIS</th>
              <th className="px-3 py-2 text-xs font-semibold">
                <button
                  type="button"
                  onClick={() => toggleSort('fullName')}
                  className="flex items-center gap-1 hover:text-sipandu-blue"
                >
                  Nama Siswa <ArrowUpDown className="h-3 w-3" aria-hidden />
                </button>
              </th>
              <th className="px-3 py-2 text-xs font-semibold">
                <button
                  type="button"
                  onClick={() => toggleSort('className')}
                  className="flex items-center gap-1 hover:text-sipandu-blue"
                >
                  Kelas <ArrowUpDown className="h-3 w-3" aria-hidden />
                </button>
              </th>
              <th className="px-3 py-2 text-center text-xs font-semibold">
                Absensi (%)
              </th>
              <th className="px-3 py-2 text-center text-xs font-semibold">
                Poin Perilaku
              </th>
              <th className="px-3 py-2 text-center text-xs font-semibold">
                Nilai Sejawat
              </th>
              <th className="px-3 py-2 text-center text-xs font-semibold">
                <button
                  type="button"
                  onClick={() => toggleSort('zScore')}
                  className="flex items-center justify-center gap-1 hover:text-sipandu-blue"
                >
                  Nilai Akhir <ArrowUpDown className="h-3 w-3" aria-hidden />
                </button>
              </th>
              <th className="px-3 py-2 text-xs font-semibold">Kategori</th>
            </tr>
          </thead>
          <tbody>
            {sorted.length === 0 ? (
              <tr>
                <td
                  colSpan={9}
                  className="px-3 py-10 text-center text-sm italic text-muted-foreground"
                >
                  Belum ada data skor untuk filter ini.
                </td>
              </tr>
            ) : (
              sorted.map((r) => (
                <tr
                  key={r.studentId}
                  className="border-b border-gray-100 hover:bg-blue-50/60"
                >
                  <td className="px-3 py-1.5 text-center font-bold text-foreground">
                    {r.rank}
                  </td>
                  <td className="px-3 py-1.5 font-mono text-xs">{r.nis}</td>
                  <td className="px-3 py-1.5 font-medium text-foreground">
                    {r.fullName}
                  </td>
                  <td className="px-3 py-1.5">{r.className}</td>
                  <td className="px-3 py-1.5 text-center">
                    {formatPercent(r.x1, 0)}
                  </td>
                  <td className="px-3 py-1.5 text-center">
                    {formatScore(r.x2, 0)}
                  </td>
                  <td className="px-3 py-1.5 text-center">
                    {formatScore(r.x3, 0)}
                  </td>
                  <td className="px-3 py-1.5 text-center font-bold">
                    {formatScore(r.zScore, 1)}
                  </td>
                  <td className="px-3 py-1.5">
                    <CategoryBadge category={r.category} size="sm" />
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
