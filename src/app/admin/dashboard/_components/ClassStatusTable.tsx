/**
 * @file app/admin/dashboard/_components/ClassStatusTable.tsx
 * @description Tabel "Status input per kelas" untuk dashboard admin A1.
 *
 *  Menampilkan untuk setiap kelas pada periode aktif:
 *    - Nama kelas + tingkat
 *    - Nama wali kelas
 *    - Progress kehadiran (X/N bulan)
 *    - Status poin (✓/✗)
 *    - Status peer review (✓/✗)
 *    - Jumlah siswa yang sudah dapat Z* (X/total)
 *    - Badge status agregat (Lengkap / Proses / Belum)
 */

import { Check, X } from 'lucide-react';
import { cn } from '@/lib/utils/cn';

export interface ClassStatusRow {
  classId: string;
  className: string;
  homeroomTeacherName: string | null;
  /** Bulan yang sudah dikunci dari total bulan periode (mis. "2/5"). */
  attendanceProgress: string;
  /** Sudah ada minimal 1 transaksi poin? */
  hasPointTransactions: boolean;
  /** Sesi peer review sudah dibuka? */
  peerReviewActive: boolean;
  /** Berapa siswa sudah punya skor Z*. */
  scoredCount: number;
  /** Total siswa di kelas. */
  totalStudents: number;
  /** Status agregat. */
  status: 'lengkap' | 'proses' | 'belum';
}

const STATUS_CONFIG: Record<
  ClassStatusRow['status'],
  { label: string; bgClass: string; textClass: string }
> = {
  lengkap: {
    label: 'Lengkap',
    bgClass: 'bg-status-on-soft',
    textClass: 'text-status-on-text',
  },
  proses: {
    label: 'Proses',
    bgClass: 'bg-status-warn-soft',
    textClass: 'text-status-warn-text',
  },
  belum: {
    label: 'Belum',
    bgClass: 'bg-status-err-soft',
    textClass: 'text-status-err-text',
  },
};

export interface ClassStatusTableProps {
  rows: ClassStatusRow[];
}

export function ClassStatusTable({ rows }: ClassStatusTableProps) {
  if (rows.length === 0) {
    return (
      <div className="py-8 text-center text-sm text-muted-foreground">
        Belum ada kelas pada periode aktif.
      </div>
    );
  }

  return (
    <div className="overflow-x-auto">
      <table className="w-full border-collapse text-sm">
        <thead>
          <tr className="border-b border-sipandu-border bg-gray-100 text-left">
            <th className="px-3 py-2 text-xs font-semibold">Kelas</th>
            <th className="px-3 py-2 text-xs font-semibold">Wali Kelas</th>
            <th className="px-3 py-2 text-xs font-semibold">Kehadiran</th>
            <th className="px-3 py-2 text-center text-xs font-semibold">
              Poin
            </th>
            <th className="px-3 py-2 text-center text-xs font-semibold">
              Peer Review
            </th>
            <th className="px-3 py-2 text-xs font-semibold">Nilai Akhir</th>
            <th className="px-3 py-2 text-xs font-semibold">Status</th>
          </tr>
        </thead>
        <tbody>
          {rows.map((row) => {
            const stat = STATUS_CONFIG[row.status];
            return (
              <tr
                key={row.classId}
                className="border-b border-gray-100 transition-colors hover:bg-blue-50/60"
              >
                <td className="px-3 py-2 font-semibold text-foreground">
                  {row.className}
                </td>
                <td className="px-3 py-2 text-foreground">
                  {row.homeroomTeacherName ?? (
                    <span className="italic text-muted-foreground">
                      Belum ditugaskan
                    </span>
                  )}
                </td>
                <td className="px-3 py-2 text-foreground">
                  {row.attendanceProgress}
                </td>
                <td className="px-3 py-2 text-center">
                  {row.hasPointTransactions ? (
                    <Check
                      className="mx-auto h-3.5 w-3.5 text-status-on"
                      aria-label="Ada poin tercatat"
                    />
                  ) : (
                    <X
                      className="mx-auto h-3.5 w-3.5 text-status-err"
                      aria-label="Belum ada poin"
                    />
                  )}
                </td>
                <td className="px-3 py-2 text-center">
                  {row.peerReviewActive ? (
                    <Check
                      className="mx-auto h-3.5 w-3.5 text-status-on"
                      aria-label="Sesi peer review aktif"
                    />
                  ) : (
                    <X
                      className="mx-auto h-3.5 w-3.5 text-status-err"
                      aria-label="Sesi peer review belum dibuka"
                    />
                  )}
                </td>
                <td className="px-3 py-2 text-foreground">
                  {row.scoredCount}/{row.totalStudents}
                </td>
                <td className="px-3 py-2">
                  <span
                    className={cn(
                      'inline-flex items-center rounded-full px-2 py-0.5 text-xs font-semibold',
                      stat.bgClass,
                      stat.textClass,
                    )}
                  >
                    {stat.label}
                  </span>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
