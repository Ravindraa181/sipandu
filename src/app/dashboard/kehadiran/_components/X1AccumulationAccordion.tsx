'use client';

/**
 * @file dashboard/kehadiran/_components/X1AccumulationAccordion.tsx
 * @description Accordion untuk melihat akumulasi X1 (rata-rata persentase
 *              kehadiran lintas bulan dalam semester) per siswa.
 *
 *  Sumber data: bulan-bulan yang sudah `locked` di assignment ini.
 */

import { useState } from 'react';
import { ChevronUp, Table as TableIcon } from 'lucide-react';
import { cn } from '@/lib/utils/cn';
import { formatPercent } from '@/lib/utils/format';
import { MONTHS_SHORT } from '@/constants';

export interface X1MonthCell {
  month: number;
  year: number;
  /** Persentase kehadiran di bulan tsb, atau null bila belum locked. */
  percent: number | null;
}

export interface X1Row {
  enrollmentId: string;
  fullName: string;
  /** Per bulan dalam periode. */
  cells: X1MonthCell[];
  /** Rata-rata X1 dari bulan-bulan yang locked. Null bila belum ada. */
  averageX1: number | null;
}

export interface X1AccumulationAccordionProps {
  rows: X1Row[];
  monthOrder: Array<{ month: number; year: number }>;
}

export function X1AccumulationAccordion({
  rows,
  monthOrder,
}: X1AccumulationAccordionProps) {
  const [open, setOpen] = useState(false);

  return (
    <div className="overflow-hidden rounded-md border border-sipandu-border bg-white">
      <button
        type="button"
        onClick={() => setOpen((v) => !v)}
        className="flex w-full items-center justify-between px-3.5 py-3 text-left transition-colors hover:bg-gray-50"
      >
        <span className="flex items-center gap-1.5 text-sm font-semibold text-foreground">
          <TableIcon className="h-3.5 w-3.5" aria-hidden />
          Lihat akumulasi absensi semester
        </span>
        <ChevronUp
          className={cn(
            'h-3.5 w-3.5 transition-transform',
            !open && 'rotate-180',
          )}
          aria-hidden
        />
      </button>

      {open && (
        <div className="border-t border-sipandu-border p-3.5">
          <div className="overflow-x-auto">
            <table className="w-full border-collapse text-sm">
              <thead>
                <tr className="border-b border-sipandu-border bg-gray-100 text-left">
                  <th className="px-3 py-1.5 text-xs font-semibold">
                    Nama Siswa
                  </th>
                  {monthOrder.map((m) => (
                    <th
                      key={`${m.year}-${m.month}`}
                      className="px-3 py-1.5 text-center text-xs font-semibold"
                    >
                      {MONTHS_SHORT[m.month - 1]}
                    </th>
                  ))}
                  <th className="px-3 py-1.5 text-center text-xs font-semibold text-sipandu-blue">
                    Absensi Sem.
                  </th>
                </tr>
              </thead>
              <tbody>
                {rows.length === 0 ? (
                  <tr>
                    <td
                      colSpan={monthOrder.length + 2}
                      className="px-3 py-6 text-center text-xs italic text-muted-foreground"
                    >
                      Belum ada data kehadiran terkunci.
                    </td>
                  </tr>
                ) : (
                  rows.map((r) => (
                    <tr
                      key={r.enrollmentId}
                      className="border-b border-gray-100 last:border-b-0"
                    >
                      <td className="px-3 py-1.5 font-medium text-foreground">
                        {r.fullName}
                      </td>
                      {monthOrder.map((m) => {
                        const cell = r.cells.find(
                          (c) => c.month === m.month && c.year === m.year,
                        );
                        return (
                          <td
                            key={`${m.year}-${m.month}`}
                            className={cn(
                              'px-3 py-1.5 text-center',
                              cell?.percent === null && 'text-muted-foreground',
                            )}
                          >
                            {cell?.percent === null || cell === undefined
                              ? '—'
                              : `${cell.percent}%`}
                          </td>
                        );
                      })}
                      <td className="px-3 py-1.5 text-center font-bold text-sipandu-blue">
                        {formatPercent(r.averageX1, 1)}
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  );
}
