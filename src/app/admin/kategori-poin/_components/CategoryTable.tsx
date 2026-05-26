'use client';

/**
 * @file admin/kategori-poin/_components/CategoryTable.tsx
 * @description Tabel kategori (pelanggaran atau reward) dengan tombol
 *              Edit & Hapus per row + tombol "Tambah Kategori" di header.
 */

import { useState, useTransition } from 'react';
import { Loader2, Pencil, Plus, Trash2 } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import { ConfirmDialog } from '@/components/shared/ConfirmDialog';
import { deleteCategory } from '@/lib/actions/admin';
import { cn } from '@/lib/utils/cn';
import {
  CategoryFormDialog,
  type CategoryType,
} from './CategoryFormDialog';

export interface CategoryRow {
  id: string;
  name: string;
  pointValue: number;
  reference: string | null;
  description: string | null;
}

export interface CategoryTableProps {
  type: CategoryType;
  rows: CategoryRow[];
}

export function CategoryTable({ type, rows }: CategoryTableProps) {
  const [pending, startTransition] = useTransition();
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editTarget, setEditTarget] = useState<CategoryRow | null>(null);

  const isViolation = type === 'violation';
  const refColLabel = isViolation ? 'Referensi SOP' : 'Label Kategori';
  const sign = isViolation ? '−' : '+';
  const pointColorClass = isViolation
    ? 'text-status-err font-bold'
    : 'text-status-on-text font-bold';

  function openCreate() {
    setEditTarget(null);
    setDialogOpen(true);
  }
  function openEdit(row: CategoryRow) {
    setEditTarget(row);
    setDialogOpen(true);
  }

  function handleDelete(row: CategoryRow): Promise<void> {
    return new Promise((resolve) => {
      startTransition(async () => {
        const result = await deleteCategory(type, row.id);
        if (result.ok) {
          toast.success(`Kategori "${row.name}" berhasil dinonaktifkan`);
        } else {
          toast.error('Gagal menghapus', { description: result.error });
        }
        resolve();
      });
    });
  }

  return (
    <>
      <div className="mb-3 flex items-center justify-between">
        <p className="text-sm text-muted-foreground">
          {rows.length} kategori {isViolation ? 'pelanggaran' : 'reward'} aktif
        </p>
        <Button
          size="sm"
          onClick={openCreate}
          className="gap-1.5 bg-sipandu-blue text-white hover:bg-sipandu-blue/90"
        >
          <Plus className="h-3.5 w-3.5" aria-hidden /> Tambah Kategori
        </Button>
      </div>

      <div className="overflow-hidden rounded-md border border-sipandu-border bg-white">
        <div className="overflow-x-auto">
          <table className="w-full border-collapse text-sm">
            <thead>
              <tr className="border-b border-sipandu-border bg-gray-100 text-left">
                <th className="px-3 py-2 text-xs font-semibold">
                  Nama Kategori
                </th>
                <th className="w-24 px-3 py-2 text-center text-xs font-semibold">
                  Poin
                </th>
                <th className="px-3 py-2 text-xs font-semibold">
                  {refColLabel}
                </th>
                <th className="px-3 py-2 text-xs font-semibold">Keterangan</th>
                <th className="w-32 px-3 py-2 text-xs font-semibold">Aksi</th>
              </tr>
            </thead>
            <tbody>
              {rows.length === 0 ? (
                <tr>
                  <td
                    colSpan={5}
                    className="px-3 py-10 text-center text-sm italic text-muted-foreground"
                  >
                    Belum ada kategori. Klik &quot;Tambah Kategori&quot; untuk
                    mulai.
                  </td>
                </tr>
              ) : (
                rows.map((r) => (
                  <tr
                    key={r.id}
                    className="border-b border-gray-100 last:border-b-0 hover:bg-blue-50/60"
                  >
                    <td className="px-3 py-2 font-medium text-foreground">
                      {r.name}
                    </td>
                    <td
                      className={cn(
                        'px-3 py-2 text-center font-mono',
                        pointColorClass,
                      )}
                    >
                      {sign}
                      {r.pointValue}
                    </td>
                    <td className="px-3 py-2 text-xs text-muted-foreground">
                      {r.reference ?? '—'}
                    </td>
                    <td className="px-3 py-2 text-xs text-muted-foreground">
                      {r.description ?? (
                        <span className="italic">—</span>
                      )}
                    </td>
                    <td className="whitespace-nowrap px-3 py-2">
                      <div className="flex flex-wrap gap-1">
                        <Button
                          size="sm"
                          variant="outline"
                          onClick={() => openEdit(r)}
                          className="gap-1"
                        >
                          <Pencil className="h-3 w-3" aria-hidden /> Edit
                        </Button>
                        <ConfirmDialog
                          trigger={
                            <Button
                              size="sm"
                              variant="outline"
                              className="gap-1 border-status-err text-status-err hover:bg-red-50"
                              disabled={pending}
                            >
                              {pending ? (
                                <Loader2
                                  className="h-3 w-3 animate-spin"
                                  aria-hidden
                                />
                              ) : (
                                <Trash2 className="h-3 w-3" aria-hidden />
                              )}{' '}
                              Hapus
                            </Button>
                          }
                          title={`Hapus kategori "${r.name}"?`}
                          description="Kategori akan dinonaktifkan (soft delete). Riwayat transaksi yang sudah ada tetap tersimpan."
                          confirmLabel="Ya, Hapus"
                          variant="destructive"
                          onConfirm={() => handleDelete(r)}
                        />
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      <CategoryFormDialog
        open={dialogOpen}
        onOpenChange={setDialogOpen}
        type={type}
        initialData={editTarget}
      />
    </>
  );
}
