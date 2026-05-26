'use client';

/**
 * @file dashboard/hasil-penilaian/_components/ResultsTable.tsx
 * @description Tabel ranking siswa untuk W6 — sortable + filter kategori.
 */

import { useMemo, useState } from 'react';
import Link from 'next/link';
import { ArrowUpDown, Eye } from 'lucide-react';

import { Button } from '@/components/ui/button';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { CategoryBadge } from '@/components/shared/CategoryBadge';
import { formatPercent, formatScore } from '@/lib/utils/format';
import { ROUTES } from '@/constants';
import type { CategoryType } from '@/types';

export interface ResultRow {
  enrollmentId: string;
  rank: number;
  fullName: string;
  x1: number | null;
  x2: number | null;
  x3: number | null;
  zScore: number | null;
  category: CategoryType | null;
}

type SortKey = 'rank' | 'fullName' | 'x1' | 'x2' | 'x3' | 'zScore';
type CategoryFilter = 'all' | CategoryType | 'unscored';

export interface ResultsTableProps {
  rows: ResultRow[];
}

const CATEGORY_FILTER_OPTIONS: Array<{
  value: CategoryFilter;
  label: string;
}> = [
  { value: 'all', label: 'Semua Kategori' },
  { value: 'sangat_baik', label: 'Sangat Baik' },
  { value: 'baik', label: 'Baik' },
  { value: 'cukup', label: 'Cukup' },
  { value: 'perlu_pembinaan', label: 'Perlu Pembinaan' },
  { value: 'unscored', label: 'Belum Dinilai' },
];

export function ResultsTable({ rows }: ResultsTableProps) {
  const [filter, setFilter] = useState<CategoryFilter>('all');
  const [sortBy, setSortBy] = useState<SortKey>('rank');
  const [sortDir, setSortDir] = useState<'asc' | 'desc'>('asc');

  const filtered = useMemo(() => {
    let result = rows;
    if (filter === 'unscored') {
      result = result.filter((r) => r.category === null);
    } else if (filter !== 'all') {
      result = result.filter((r) => r.category === filter);
    }
    result = [...result].sort((a, b) => {
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
    return result;
  }, [rows, filter, sortBy, sortDir]);

  function toggleSort(col: SortKey) {
    if (sortBy === col) setSortDir((d) => (d === 'asc' ? 'desc' : 'asc'));
    else {
      setSortBy(col);
      setSortDir('asc');
    }
  }

  return (
    <>
      <div className="mb-3 flex flex-wrap items-center gap-2 rounded-md border border-sipandu-border bg-white px-3 py-2.5">
        <Select
          value={filter}
          onValueChange={(v) => setFilter(v as CategoryFilter)}
        >
          <SelectTrigger className="w-[200px]">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            {CATEGORY_FILTER_OPTIONS.map((o) => (
              <SelectItem key={o.value} value={o.value}>
                {o.label}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>

        <span className="text-xs text-muted-foreground">
          Menampilkan {filtered.length} dari {rows.length} siswa
        </span>
      </div>

      <div className="overflow-hidden rounded-md border border-sipandu-border bg-white">
        <div className="overflow-x-auto">
          <table className="w-full border-collapse text-sm">
            <thead>
              <tr className="border-b border-sipandu-border bg-gray-100 text-left">
                <th className="w-12 px-3 py-2 text-center text-xs font-semibold">
                  <button
                    type="button"
                    onClick={() => toggleSort('rank')}
                    className="flex w-full items-center justify-center gap-1 hover:text-sipandu-blue"
                  >
                    # <ArrowUpDown className="h-3 w-3" aria-hidden />
                  </button>
                </th>
                <th className="px-3 py-2 text-xs font-semibold">
                  <button
                    type="button"
                    onClick={() => toggleSort('fullName')}
                    className="flex items-center gap-1 hover:text-sipandu-blue"
                  >
                    Nama <ArrowUpDown className="h-3 w-3" aria-hidden />
                  </button>
                </th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  <button
                    type="button"
                    onClick={() => toggleSort('x1')}
                    className="flex w-full items-center justify-center gap-1 hover:text-sipandu-blue"
                  >
                    Absensi (%) <ArrowUpDown className="h-3 w-3" aria-hidden />
                  </button>
                </th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  <button
                    type="button"
                    onClick={() => toggleSort('x2')}
                    className="flex w-full items-center justify-center gap-1 hover:text-sipandu-blue"
                  >
                    Poin Perilaku <ArrowUpDown className="h-3 w-3" aria-hidden />
                  </button>
                </th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  <button
                    type="button"
                    onClick={() => toggleSort('x3')}
                    className="flex w-full items-center justify-center gap-1 hover:text-sipandu-blue"
                  >
                    Nilai Sejawat <ArrowUpDown className="h-3 w-3" aria-hidden />
                  </button>
                </th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  <button
                    type="button"
                    onClick={() => toggleSort('zScore')}
                    className="flex w-full items-center justify-center gap-1 hover:text-sipandu-blue"
                  >
                    Nilai Akhir <ArrowUpDown className="h-3 w-3" aria-hidden />
                  </button>
                </th>
                <th className="px-3 py-2 text-xs font-semibold">Kategori</th>
                <th className="px-3 py-2 text-xs font-semibold">Aksi</th>
              </tr>
            </thead>
            <tbody>
              {filtered.length === 0 ? (
                <tr>
                  <td
                    colSpan={8}
                    className="px-3 py-10 text-center text-sm italic text-muted-foreground"
                  >
                    Tidak ada siswa pada filter ini.
                  </td>
                </tr>
              ) : (
                filtered.map((r) => (
                  <tr
                    key={r.enrollmentId}
                    className="border-b border-gray-100 hover:bg-blue-50/40"
                  >
                    <td className="px-3 py-1.5 text-center font-bold">
                      {r.rank}
                    </td>
                    <td className="px-3 py-1.5 font-medium text-foreground">
                      {r.fullName}
                    </td>
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
                    <td className="px-3 py-1.5">
                      <Button
                        asChild
                        size="sm"
                        variant="outline"
                        className="gap-1"
                      >
                        <Link
                          href={ROUTES.teacherStudentDetail(r.enrollmentId)}
                        >
                          <Eye className="h-3 w-3" aria-hidden /> Detail
                        </Link>
                      </Button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </>
  );
}
