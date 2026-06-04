'use client';

/**
 * @file admin/siswa/_components/StudentTable.tsx
 * @description Tabel siswa dengan filter kelas + status + search,
 *              pagination 10/halaman client-side, sortable kolom.
 */

import { useMemo, useState } from 'react';
import { ArrowUpDown, ChevronLeft, ChevronRight, Search, UserPlus } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { CategoryBadge } from '@/components/shared/CategoryBadge';
import { formatScore } from '@/lib/utils/format';
import type { CategoryType } from '@/types';
import {
  StudentDetailDialog,
  type StudentDetail,
} from './StudentDetailDialog';
import { BulkAssignDialog } from './BulkAssignDialog';
import { DEFAULT_PAGE_SIZE } from '@/constants';

export interface StudentTableRow {
  id: string;
  nisn: string;
  fullName: string;
  className: string | null;
  isActive: boolean;
  zScore: number | null;
  category: CategoryType | null;
  periodLabel: string | null;
  /** Detail untuk modal — fetched bersama row. */
  detail: StudentDetail;
}

type SortKey = 'nisn' | 'fullName' | 'zScore';
type StatusFilter = 'all' | 'active' | 'inactive';

export interface StudentTableProps {
  rows: StudentTableRow[];
  classOptions: Array<{ id: string; name: string }>;
  activePeriodExists: boolean;
}

export function StudentTable({ rows, classOptions, activePeriodExists }: StudentTableProps) {
  const [classFilter, setClassFilter] = useState<string>('all');
  const [statusFilter, setStatusFilter] = useState<StatusFilter>('all');
  const [search, setSearch] = useState('');
  const [sortBy, setSortBy] = useState<SortKey>('fullName');
  const [sortDir, setSortDir] = useState<'asc' | 'desc'>('asc');
  const [pageIndex, setPageIndex] = useState(0);
  const [detailTarget, setDetailTarget] = useState<StudentDetail | null>(null);
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());
  const [bulkAssignOpen, setBulkAssignOpen] = useState(false);

  const filtered = useMemo(() => {
    let result = rows;
    if (classFilter !== 'all') {
      result = result.filter((r) => r.className === classFilter);
    }
    if (statusFilter === 'active') {
      result = result.filter((r) => r.isActive);
    } else if (statusFilter === 'inactive') {
      result = result.filter((r) => !r.isActive);
    }
    if (search.trim()) {
      const q = search.toLowerCase();
      result = result.filter(
        (r) =>
          r.fullName.toLowerCase().includes(q) ||
          r.nisn.toLowerCase().includes(q),
      );
    }
    result = [...result].sort((a, b) => {
      const av = a[sortBy];
      const bv = b[sortBy];
      let cmp = 0;
      if (typeof av === 'string' && typeof bv === 'string') {
        cmp = av.localeCompare(bv);
      } else if (typeof av === 'number' && typeof bv === 'number') {
        cmp = av - bv;
      } else if (av === null && bv !== null) {
        cmp = 1;
      } else if (av !== null && bv === null) {
        cmp = -1;
      }
      return sortDir === 'asc' ? cmp : -cmp;
    });
    return result;
  }, [rows, classFilter, statusFilter, search, sortBy, sortDir]);

  const pageCount = Math.max(
    1,
    Math.ceil(filtered.length / DEFAULT_PAGE_SIZE),
  );
  const paginated = filtered.slice(
    pageIndex * DEFAULT_PAGE_SIZE,
    (pageIndex + 1) * DEFAULT_PAGE_SIZE,
  );

  function toggleSort(col: SortKey) {
    if (sortBy === col) {
      setSortDir((d) => (d === 'asc' ? 'desc' : 'asc'));
    } else {
      setSortBy(col);
      setSortDir('asc');
    }
  }

  function toggleSelect(id: string) {
    setSelectedIds((prev) => {
      const next = new Set(prev);
      next.has(id) ? next.delete(id) : next.add(id);
      return next;
    });
  }

  function toggleSelectAll() {
    if (selectedIds.size === paginated.length && paginated.length > 0) {
      setSelectedIds(new Set());
    } else {
      setSelectedIds(new Set(paginated.map((r) => r.id)));
    }
  }

  const selectedStudentNames = rows
    .filter((r) => selectedIds.has(r.id))
    .map((r) => r.fullName);

  return (
    <>
      {/* Bulk action bar */}
      {activePeriodExists && selectedIds.size > 0 && (
        <div className="mb-2 flex items-center gap-3 rounded-md border border-sipandu-blue bg-blue-50 px-3 py-2">
          <span className="text-sm font-medium text-sipandu-blue-deep">
            {selectedIds.size} siswa dipilih
          </span>
          <Button
            size="sm"
            className="gap-1.5 bg-sipandu-blue text-white hover:bg-sipandu-blue/90"
            onClick={() => setBulkAssignOpen(true)}
          >
            <UserPlus className="h-3.5 w-3.5" aria-hidden />
            Assign ke Kelas
          </Button>
          <Button
            size="sm"
            variant="ghost"
            className="text-muted-foreground"
            onClick={() => setSelectedIds(new Set())}
          >
            Batalkan Pilihan
          </Button>
        </div>
      )}

      {/* Filter bar */}
      <div className="mb-3 flex flex-wrap items-center gap-2 rounded-md border border-sipandu-border bg-white px-3 py-2.5">
        {/* ALASAN: setiap filter/search harus reset pageIndex ke 0 agar
            hasil filter selalu dimulai dari halaman pertama. Tanpa reset ini,
            user yang berada di halaman 3 lalu mengetik search akan tetap di
            pageIndex=2 → slice(20,30) pada array kecil → hasil kosong. */}
        <Select
          value={classFilter}
          onValueChange={(v) => { setClassFilter(v); setPageIndex(0); }}
        >
          <SelectTrigger className="w-[160px]">
            <SelectValue placeholder="Kelas" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Semua Kelas</SelectItem>
            {classOptions.map((c) => (
              <SelectItem key={c.id} value={c.name}>
                {c.name}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>

        <Select
          value={statusFilter}
          onValueChange={(v) => { setStatusFilter(v as StatusFilter); setPageIndex(0); }}
        >
          <SelectTrigger className="w-[160px]">
            <SelectValue placeholder="Status" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Semua Status</SelectItem>
            <SelectItem value="active">Aktif</SelectItem>
            <SelectItem value="inactive">Nonaktif</SelectItem>
          </SelectContent>
        </Select>

        <div className="relative min-w-[220px] flex-1">
          <Search
            className="absolute left-2.5 top-1/2 h-3.5 w-3.5 -translate-y-1/2 text-muted-foreground"
            aria-hidden
          />
          <Input
            placeholder="Cari nama atau NISN..."
            value={search}
            onChange={(e) => { setSearch(e.target.value); setPageIndex(0); }}
            className="pl-8"
            suppressHydrationWarning
          />
        </div>
      </div>

      {/* Tabel */}
      <div className="overflow-hidden rounded-md border border-sipandu-border bg-white">
        <div className="overflow-x-auto">
          <table className="w-full border-collapse text-sm">
            <thead>
              <tr className="border-b border-sipandu-border bg-gray-100 text-left">
                {activePeriodExists && (
                  <th className="w-8 px-3 py-2">
                    <input
                      type="checkbox"
                      className="h-3.5 w-3.5 cursor-pointer accent-sipandu-blue"
                      checked={paginated.length > 0 && selectedIds.size === paginated.length}
                      onChange={toggleSelectAll}
                      title="Pilih semua"
                      suppressHydrationWarning
                    />
                  </th>
                )}
                <th className="px-3 py-2 text-xs font-semibold">
                  <button
                    type="button"
                    onClick={() => toggleSort('nisn')}
                    className="flex items-center gap-1 hover:text-sipandu-blue"
                  >
                    NISN <ArrowUpDown className="h-3 w-3" aria-hidden />
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
                <th className="px-3 py-2 text-xs font-semibold">Kelas</th>
                <th className="px-3 py-2 text-xs font-semibold">Status</th>
                <th className="px-3 py-2 text-center text-xs font-semibold">
                  <button
                    type="button"
                    onClick={() => toggleSort('zScore')}
                    className="flex items-center gap-1 hover:text-sipandu-blue"
                  >
                    Z* <ArrowUpDown className="h-3 w-3" aria-hidden />
                  </button>
                </th>
                <th className="px-3 py-2 text-xs font-semibold">Kategori</th>
                <th className="px-3 py-2 text-xs font-semibold">Periode</th>
                <th className="px-3 py-2 text-xs font-semibold">Aksi</th>
              </tr>
            </thead>
            <tbody>
              {paginated.length === 0 ? (
                <tr>
                  <td
                    colSpan={activePeriodExists ? 9 : 8}
                    className="px-3 py-10 text-center text-sm italic text-muted-foreground"
                  >
                    {rows.length === 0
                      ? 'Belum ada data siswa'
                      : 'Tidak ada hasil untuk filter ini'}
                  </td>
                </tr>
              ) : (
                paginated.map((s) => (
                  <tr
                    key={s.id}
                    className="border-b border-gray-100 hover:bg-blue-50/60"
                  >
                    {activePeriodExists && (
                      <td className="px-3 py-2">
                        <input
                          type="checkbox"
                          className="h-3.5 w-3.5 cursor-pointer accent-sipandu-blue"
                          checked={selectedIds.has(s.id)}
                          onChange={() => toggleSelect(s.id)}
                          suppressHydrationWarning
                        />
                      </td>
                    )}
                    <td className="px-3 py-2 font-mono text-xs">{s.nisn}</td>
                    <td className="px-3 py-2 font-medium text-foreground">
                      {s.fullName}
                    </td>
                    <td className="px-3 py-2">{s.className ?? '—'}</td>
                    <td className="px-3 py-2">
                      <span
                        className={
                          s.isActive
                            ? 'inline-flex items-center rounded-full bg-status-on-soft px-2 py-0.5 text-2xs font-semibold text-status-on-text'
                            : 'inline-flex items-center rounded-full bg-status-off-soft px-2 py-0.5 text-2xs font-semibold text-status-off-text'
                        }
                      >
                        {s.isActive ? 'Aktif' : 'Nonaktif'}
                      </span>
                    </td>
                    <td className="px-3 py-2 text-center font-bold">
                      {formatScore(s.zScore, 1)}
                    </td>
                    <td className="px-3 py-2">
                      <CategoryBadge category={s.category} size="sm" />
                    </td>
                    <td className="px-3 py-2 text-xs text-muted-foreground">
                      {s.periodLabel ?? '—'}
                    </td>
                    <td className="whitespace-nowrap px-3 py-2">
                      <Button
                        size="sm"
                        variant="outline"
                        onClick={() => setDetailTarget(s.detail)}
                      >
                        Detail
                      </Button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>

        {/* Pagination */}
        {filtered.length > 0 && (
          <div className="flex items-center justify-between border-t border-sipandu-border px-3 py-2 text-xs">
            <span className="text-muted-foreground">
              Menampilkan {pageIndex * DEFAULT_PAGE_SIZE + 1}–
              {Math.min((pageIndex + 1) * DEFAULT_PAGE_SIZE, filtered.length)}{' '}
              dari {filtered.length} siswa
            </span>

            <div className="flex items-center gap-1">
              <Button
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
                size="sm"
                variant="outline"
                disabled={pageIndex >= pageCount - 1}
                onClick={() =>
                  setPageIndex((p) => Math.min(pageCount - 1, p + 1))
                }
                aria-label="Halaman berikutnya"
              >
                <ChevronRight className="h-3.5 w-3.5" aria-hidden />
              </Button>
            </div>
          </div>
        )}
      </div>

      {/* Modal detail */}
      {detailTarget && (
        <StudentDetailDialog
          open={Boolean(detailTarget)}
          onOpenChange={(o) => !o && setDetailTarget(null)}
          student={detailTarget}
          classOptions={classOptions}
          activePeriodExists={activePeriodExists}
        />
      )}

      {/* Modal bulk assign */}
      {bulkAssignOpen && (
        <BulkAssignDialog
          open={bulkAssignOpen}
          onOpenChange={(o) => {
            setBulkAssignOpen(o);
            if (!o) setSelectedIds(new Set());
          }}
          selectedStudentIds={Array.from(selectedIds)}
          selectedStudentNames={selectedStudentNames}
          classOptions={classOptions}
        />
      )}
    </>
  );
}
