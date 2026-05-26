'use client';

/**
 * @file dashboard/_components/ClassStudentsTable.tsx
 * @description Tabel siswa kelas dengan sorting client-side.
 *              Klik kolom Nilai Akhir / Nama / Absensi / Poin Perilaku untuk sort.
 */

import { useMemo, useState } from 'react';
import Link from 'next/link';
import { ArrowUpDown, Eye } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { CategoryBadge } from '@/components/shared/CategoryBadge';
import { formatPercent, formatScore } from '@/lib/utils/format';
import { ROUTES } from '@/constants';
import type { CategoryType } from '@/types';

export interface ClassStudentRow {
  /** Enrollment ID — dipakai sebagai param untuk halaman detail. */
  enrollmentId: string;
  rank: number;
  studentId: string;
  fullName: string;
  x1: number | null;
  x2: number | null;
  x3: number | null;
  zScore: number | null;
  category: CategoryType | null;
}

type SortKey = 'rank' | 'fullName' | 'x1' | 'x2' | 'zScore';

export interface ClassStudentsTableProps {
  rows: ClassStudentRow[];
}

export function ClassStudentsTable({ rows }: ClassStudentsTableProps) {
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
      <div className="border-b border-sipandu-border px-3.5 py-2.5">
        <h2 className="text-base font-bold text-foreground">
          Daftar siswa kelas
        </h2>
      </div>

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
                  No <ArrowUpDown className="h-3 w-3" aria-hidden />
                </button>
              </th>
              <th className="px-3 py-2 text-xs font-semibold">
                <button
                  type="button"
                  onClick={() => toggleSort('fullName')}
                  className="flex items-center gap-1 hover:text-sipandu-blue"
                >
                  Nama Siswa <ArrowUpDown className="h-3 w-3" aria-hidden />
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
                Nilai Sejawat
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
            {sorted.length === 0 ? (
              <tr>
                <td
                  colSpan={8}
                  className="px-3 py-10 text-center text-sm italic text-muted-foreground"
                >
                  Belum ada siswa terdaftar di kelas ini.
                </td>
              </tr>
            ) : (
              sorted.map((s) => (
                <tr
                  key={s.enrollmentId}
                  className="border-b border-gray-100 hover:bg-blue-50/60"
                >
                  <td className="px-3 py-1.5 text-center text-muted-foreground">
                    {s.rank}
                  </td>
                  <td className="px-3 py-1.5 font-medium text-foreground">
                    {s.fullName}
                  </td>
                  <td className="px-3 py-1.5 text-center">
                    {formatPercent(s.x1, 0)}
                  </td>
                  <td className="px-3 py-1.5 text-center">
                    {formatScore(s.x2, 0)}
                  </td>
                  <td className="px-3 py-1.5 text-center">
                    {formatScore(s.x3, 0)}
                  </td>
                  <td className="px-3 py-1.5 text-center font-bold">
                    {formatScore(s.zScore, 1)}
                  </td>
                  <td className="px-3 py-1.5">
                    <CategoryBadge category={s.category} size="sm" />
                  </td>
                  <td className="px-3 py-1.5">
                    <Button
                      asChild
                      size="sm"
                      variant="outline"
                      className="gap-1"
                    >
                      <Link
                        href={ROUTES.teacherStudentDetail(s.enrollmentId)}
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
  );
}
