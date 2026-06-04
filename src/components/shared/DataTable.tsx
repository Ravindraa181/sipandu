'use client';

/**
 * @file components/shared/DataTable.tsx
 * @description Tabel data generic untuk SiPandu. Mendukung:
 *               - kolom typed (generic <TRow>)
 *               - loading skeleton (saat isLoading=true)
 *               - empty state dengan pesan custom
 *               - pagination opsional client-side (pageSize)
 *
 *  Untuk fitur lebih lanjut (sorting server-side, multi-select, dll.)
 *  pakai langsung `@tanstack/react-table` di halaman terkait. Komponen
 *  ini sengaja dibuat ringan agar gampang dipakai untuk tabel sederhana
 *  seperti Daftar Guru, Riwayat Transaksi, dll.
 *
 * @example
 *   const columns: ColumnDef<Student>[] = [
 *     { id: 'nisn', header: 'NISN', cell: (s) => <span>{s.nisn}</span> },
 *     { id: 'nm', header: 'Nama', cell: (s) => <strong>{s.fullName}</strong> },
 *   ];
 *   <DataTable columns={columns} data={rows} isLoading={loading} pageSize={10} />
 */

import { useMemo, useState, type ReactNode } from 'react';
import { ChevronLeft, ChevronRight } from 'lucide-react';

import { cn } from '@/lib/utils/cn';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { Skeleton } from '@/components/ui/skeleton';
import { Button } from '@/components/ui/button';
import { UI_STRINGS } from '@/constants';

/* ────────────────────────────────────────────────────────────────────
 *  Definisi kolom
 * ──────────────────────────────────────────────────────────────────── */

export interface ColumnDef<TRow> {
  /** ID unik kolom (key React + identifier sort). */
  id: string;
  /** Header tampil. */
  header: ReactNode;
  /** Render cell untuk satu baris. */
  cell: (row: TRow, rowIndex: number) => ReactNode;
  /** Lebar custom (mis. "60px", "20%"). */
  width?: string;
  /** Alignment teks. Default: left. */
  align?: 'left' | 'center' | 'right';
  /** Class tambahan untuk header. */
  headerClassName?: string;
  /** Class tambahan untuk semua cell di kolom ini. */
  cellClassName?: string;
}

/* ────────────────────────────────────────────────────────────────────
 *  Props
 * ──────────────────────────────────────────────────────────────────── */

export interface DataTableProps<TRow> {
  /** Definisi kolom. */
  columns: ColumnDef<TRow>[];
  /** Data baris. */
  data: TRow[];
  /** Tampilkan skeleton saat true. */
  isLoading?: boolean;
  /** Pesan saat data kosong. */
  emptyMessage?: string;
  /** Aktifkan pagination client-side. Bila omitted, semua row ditampilkan. */
  pageSize?: number;
  /** Generator key unik per row. Bila omitted, pakai index. */
  getRowId?: (row: TRow, index: number) => string;
  /** Callback saat baris diklik. Cell menjadi cursor-pointer bila ada. */
  onRowClick?: (row: TRow, rowIndex: number) => void;
  /** Tambahan class container. */
  className?: string;
}

/* ────────────────────────────────────────────────────────────────────
 *  Component
 * ──────────────────────────────────────────────────────────────────── */

export function DataTable<TRow>({
  columns,
  data,
  isLoading = false,
  emptyMessage = UI_STRINGS.emptyState,
  pageSize,
  getRowId,
  onRowClick,
  className,
}: DataTableProps<TRow>) {
  const [pageIndex, setPageIndex] = useState(0);

  // ── Slice paginasi (client-side) ──────────────────────────────────
  const { paginatedData, pageCount } = useMemo(() => {
    if (!pageSize || pageSize <= 0) {
      return { paginatedData: data, pageCount: 1 };
    }
    const total = Math.ceil(data.length / pageSize);
    const start = pageIndex * pageSize;
    return {
      paginatedData: data.slice(start, start + pageSize),
      pageCount: Math.max(total, 1),
    };
  }, [data, pageIndex, pageSize]);

  // ── Klamp pageIndex bila data berubah ─────────────────────────────
  if (pageIndex > pageCount - 1 && pageIndex !== 0) {
    setPageIndex(0);
  }

  // ── Helper alignment ──────────────────────────────────────────────
  const alignClass = (a?: ColumnDef<TRow>['align']) =>
    a === 'right' ? 'text-right' : a === 'center' ? 'text-center' : 'text-left';

  return (
    <div className={cn('rounded-md border border-sipandu-border bg-white', className)}>
      <div className="overflow-x-auto">
        <Table>
          <TableHeader>
            <TableRow>
              {columns.map((col) => (
                <TableHead
                  key={col.id}
                  style={col.width ? { width: col.width } : undefined}
                  className={cn(
                    alignClass(col.align),
                    'whitespace-nowrap text-xs font-semibold uppercase tracking-wide',
                    col.headerClassName,
                  )}
                >
                  {col.header}
                </TableHead>
              ))}
            </TableRow>
          </TableHeader>

          <TableBody>
            {isLoading ? (
              // ── Loading skeleton: 5 baris × jumlah kolom ─────────────
              Array.from({ length: 5 }).map((_, i) => (
                <TableRow key={`skeleton-${i}`}>
                  {columns.map((col) => (
                    <TableCell key={`${col.id}-${i}`} className={alignClass(col.align)}>
                      <Skeleton className="h-4 w-3/4" />
                    </TableCell>
                  ))}
                </TableRow>
              ))
            ) : paginatedData.length === 0 ? (
              // ── Empty state ───────────────────────────────────────────
              <TableRow>
                <TableCell
                  colSpan={columns.length}
                  className="py-10 text-center text-sm text-muted-foreground"
                >
                  {emptyMessage}
                </TableCell>
              </TableRow>
            ) : (
              // ── Render rows ───────────────────────────────────────────
              paginatedData.map((row, idx) => {
                const rowKey = getRowId
                  ? getRowId(row, pageIndex * (pageSize ?? 0) + idx)
                  : String(pageIndex * (pageSize ?? 0) + idx);
                return (
                  <TableRow
                    key={rowKey}
                    onClick={onRowClick ? () => onRowClick(row, idx) : undefined}
                    className={cn(
                      onRowClick && 'cursor-pointer hover:bg-blue-50',
                    )}
                  >
                    {columns.map((col) => (
                      <TableCell
                        key={col.id}
                        className={cn(
                          alignClass(col.align),
                          col.cellClassName,
                        )}
                      >
                        {col.cell(row, idx)}
                      </TableCell>
                    ))}
                  </TableRow>
                );
              })
            )}
          </TableBody>
        </Table>
      </div>

      {/* ── Pagination ────────────────────────────────────────────── */}
      {pageSize && data.length > pageSize && (
        <div className="flex items-center justify-between border-t border-sipandu-border px-3.5 py-2.5 text-xs">
          <span className="text-muted-foreground">
            Menampilkan {pageIndex * pageSize + 1}–
            {Math.min((pageIndex + 1) * pageSize, data.length)} dari {data.length}
          </span>

          <div className="flex items-center gap-1">
            <Button
              type="button"
              size="sm"
              variant="outline"
              disabled={pageIndex === 0}
              onClick={() => setPageIndex((p) => Math.max(0, p - 1))}
              aria-label="Halaman sebelumnya"
            >
              <ChevronLeft className="h-3.5 w-3.5" aria-hidden />
            </Button>

            <span className="px-2 font-medium tabular-nums">
              {pageIndex + 1} / {pageCount}
            </span>

            <Button
              type="button"
              size="sm"
              variant="outline"
              disabled={pageIndex >= pageCount - 1}
              onClick={() => setPageIndex((p) => Math.min(pageCount - 1, p + 1))}
              aria-label="Halaman berikutnya"
            >
              <ChevronRight className="h-3.5 w-3.5" aria-hidden />
            </Button>
          </div>
        </div>
      )}
    </div>
  );
}
