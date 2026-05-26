/**
 * @file siswa/_components/AttendanceSummary.tsx
 * @description Tabel ringkas kehadiran bulanan untuk dashboard siswa S1.
 */

import { cn } from '@/lib/utils/cn';
import { formatPercent } from '@/lib/utils/format';
import { MIN_ATTENDANCE_PERCENT, MONTHS } from '@/constants';

export interface MonthSummary {
  month: number;
  year: number;
  presentDays: number | null;
  effectiveDays: number;
  status: 'locked' | 'draft' | 'empty';
}

export interface AttendanceSummaryProps {
  months: MonthSummary[];
  /** X1 semester yang sudah dikunci. Null bila belum ada bulan locked. */
  semesterX1: number | null;
  lockedMonthCount: number;
}

const STATUS_BADGE = {
  locked: {
    label: '✓ Terkunci',
    bgClass: 'bg-status-on-soft',
    textClass: 'text-status-on-text',
  },
  draft: {
    label: '⏳ Draft',
    bgClass: 'bg-status-warn-soft',
    textClass: 'text-status-warn-text',
  },
  empty: {
    label: '○ Belum',
    bgClass: 'bg-status-off-soft',
    textClass: 'text-status-off-text',
  },
} as const;

export function AttendanceSummary({
  months,
  semesterX1,
  lockedMonthCount,
}: AttendanceSummaryProps) {
  return (
    <div className="rounded-md border border-sipandu-border bg-white p-3.5">
      <h2 className="mb-2.5 text-base font-bold text-foreground">
        Kehadiran Bulanan
      </h2>

      <div className="overflow-x-auto">
        <table className="w-full border-collapse text-sm">
          <thead>
            <tr className="border-b border-sipandu-border bg-gray-100 text-left">
              <th className="px-3 py-1.5 text-xs font-semibold">Bulan</th>
              <th className="px-3 py-1.5 text-center text-xs font-semibold">
                Hadir
              </th>
              <th className="px-3 py-1.5 text-center text-xs font-semibold">
                %
              </th>
              <th className="px-3 py-1.5 text-xs font-semibold">Status</th>
            </tr>
          </thead>
          <tbody>
            {months.length === 0 ? (
              <tr>
                <td
                  colSpan={4}
                  className="px-3 py-6 text-center text-xs italic text-muted-foreground"
                >
                  Belum ada bulan efektif terdaftar untuk periode ini.
                </td>
              </tr>
            ) : (
              months.map((m) => {
                const cfg = STATUS_BADGE[m.status];
                const pct =
                  m.presentDays !== null && m.effectiveDays > 0
                    ? (m.presentDays / m.effectiveDays) * 100
                    : null;
                const lowAtt =
                  pct !== null && pct < MIN_ATTENDANCE_PERCENT;
                return (
                  <tr
                    key={`${m.year}-${m.month}`}
                    className="border-b border-gray-100 last:border-b-0"
                  >
                    <td className="px-3 py-1.5">
                      {MONTHS[m.month - 1]}
                    </td>
                    <td
                      className={cn(
                        'px-3 py-1.5 text-center font-medium',
                        m.presentDays === null
                          ? 'text-muted-foreground'
                          : 'text-foreground',
                      )}
                    >
                      {m.presentDays ?? '—'}
                    </td>
                    <td
                      className={cn(
                        'px-3 py-1.5 text-center font-semibold',
                        pct === null && 'text-muted-foreground',
                        pct !== null && pct === 100 && 'text-status-on-text',
                        lowAtt && 'text-status-err',
                      )}
                    >
                      {pct !== null ? formatPercent(pct, 0) : '—'}
                    </td>
                    <td className="px-3 py-1.5">
                      <span
                        className={cn(
                          'inline-flex items-center rounded-full px-2 py-0.5 text-2xs font-semibold',
                          cfg.bgClass,
                          cfg.textClass,
                        )}
                      >
                        {cfg.label}
                      </span>
                    </td>
                  </tr>
                );
              })
            )}
          </tbody>
        </table>
      </div>

      <div className="mt-3 rounded-md bg-blue-50 px-3 py-2 text-xs">
        Absensi Semester:{' '}
        <strong className="text-sipandu-blue">
          {formatPercent(semesterX1, 1)}
        </strong>{' '}
        <span className="text-muted-foreground">
          (dari {lockedMonthCount} bulan terkunci)
        </span>
      </div>
    </div>
  );
}
