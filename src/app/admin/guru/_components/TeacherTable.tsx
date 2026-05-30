'use client';

/**
 * @file admin/guru/_components/TeacherTable.tsx
 * @description Tabel guru dengan filter status + search di client side.
 * Aksi per baris: Lihat (assign kelas), Reset PW, Aktifkan/Nonaktifkan.
 */

import { useState, useTransition } from 'react';
import { Loader2, Search } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
// PERBAIKAN: Ganti setTeacherActive menjadi setUserActive
import { deleteTeacher, resetUserPassword, setUserActive } from '@/lib/actions/admin';
import { ConfirmDialog } from '@/components/shared/ConfirmDialog';
import {
  AssignClassDialog,
  type ClassOption,
  type PeriodOption,
} from './AssignClassDialog';

export interface TeacherRow {
  id: string;
  nip: string;
  fullName: string;
  email: string;
  isActive: boolean;
  currentAssignment: string | null;
}

export interface TeacherTableProps {
  rows: TeacherRow[];
  classes: ClassOption[];
  periods: PeriodOption[];
}

type StatusFilter = 'all' | 'active' | 'inactive';

export function TeacherTable({ rows, classes, periods }: TeacherTableProps) {
  const [statusFilter, setStatusFilter] = useState<StatusFilter>('all');
  const [searchQuery, setSearchQuery] = useState('');
  const [assignTarget, setAssignTarget] = useState<TeacherRow | null>(null);
  const [pending, startTransition] = useTransition();

  const filteredRows = rows.filter((r) => {
    if (statusFilter === 'active' && !r.isActive) return false;
    if (statusFilter === 'inactive' && r.isActive) return false;
    if (
      searchQuery &&
      !r.fullName.toLowerCase().includes(searchQuery.toLowerCase()) &&
      !r.nip.includes(searchQuery)
    ) {
      return false;
    }
    return true;
  });

  const handleToggleActive = (t: TeacherRow) => {
    startTransition(async () => {
      // PERBAIKAN: Memanggil setUserActive dengan struct objek yang benar
      const result = await setUserActive({
        userId: t.id,
        isActive: !t.isActive,
        role: 'teacher',
      });
      
      if (result.ok) {
        toast.success(`Guru berhasil di${t.isActive ? 'nonaktifkan' : 'aktifkan'}`);
      } else {
        toast.error('Gagal mengubah status', { description: result.error });
      }
    });
  };

  const handleDelete = (t: TeacherRow) => {
    startTransition(async () => {
      const result = await deleteTeacher(t.id);
      if (result.ok) {
        toast.success(`Guru ${t.fullName} berhasil dihapus`);
      } else {
        toast.error('Gagal menghapus guru', { description: result.error });
      }
    });
  };

  const handleResetPassword = (t: TeacherRow) => {
    startTransition(async () => {
      const result = await resetUserPassword(t.id, '12345678'); // default password
      if (result.ok) {
        toast.success(`Password ${t.fullName} berhasil direset ke "12345678"`);
      } else {
        toast.error('Gagal mereset password', { description: result.error });
      }
    });
  };

  return (
    <>
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <div className="relative w-full max-w-sm">
          <Search
            className="absolute left-2.5 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground"
            aria-hidden
          />
          <Input
            type="search"
            placeholder="Cari nama atau NIP..."
            className="pl-8"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
        </div>
        <div className="flex items-center gap-2">
          <Select
            value={statusFilter}
            onValueChange={(v) => setStatusFilter(v as StatusFilter)}
          >
            <SelectTrigger className="w-[140px]">
              <SelectValue placeholder="Status" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">Semua Status</SelectItem>
              <SelectItem value="active">Aktif</SelectItem>
              <SelectItem value="inactive">Nonaktif</SelectItem>
            </SelectContent>
          </Select>
        </div>
      </div>

      <div className="rounded-md border bg-white overflow-x-auto">
        <table className="w-full text-sm text-left">
          <thead className="border-b bg-gray-50 text-xs uppercase text-gray-500">
            <tr>
              <th className="px-4 py-3 font-medium">Nama Guru</th>
              <th className="px-4 py-3 font-medium">NIP / Email</th>
              <th className="px-4 py-3 font-medium">Tugas Saat Ini</th>
              <th className="px-4 py-3 font-medium text-center">Status</th>
              <th className="px-4 py-3 font-medium text-right">Aksi</th>
            </tr>
          </thead>
          <tbody className="divide-y">
            {filteredRows.length === 0 ? (
              <tr>
                <td colSpan={5} className="py-8 text-center text-muted-foreground">
                  Tidak ada data guru ditemukan.
                </td>
              </tr>
            ) : (
              filteredRows.map((t) => (
                <tr key={t.id} className="hover:bg-gray-50/50">
                  <td className="px-4 py-3 font-medium text-gray-900">
                    {t.fullName}
                  </td>
                  <td className="px-4 py-3">
                    <div className="text-gray-900">{t.nip}</div>
                    <div className="text-xs text-gray-500">{t.email}</div>
                  </td>
                  <td className="px-4 py-3 text-gray-600">
                    {t.currentAssignment || <span className="italic">Belum ada</span>}
                  </td>
                  <td className="px-4 py-3 text-center">
                    <span
                      className={`inline-flex items-center rounded-full px-2 py-0.5 text-2xs font-medium ${
                        t.isActive
                          ? 'bg-green-100 text-green-700'
                          : 'bg-gray-100 text-gray-600'
                      }`}
                    >
                      {t.isActive ? 'Aktif' : 'Nonaktif'}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-right">
                    <div className="flex items-center justify-end gap-2">
                      <Button
                        variant="outline"
                        size="sm"
                        className="h-8 px-2 text-xs"
                        onClick={() => setAssignTarget(t)}
                        disabled={!t.isActive}
                      >
                        Assign Kelas
                      </Button>

                      <ConfirmDialog
                        trigger={
                          <Button variant="ghost" size="sm" className="h-8 px-2 text-xs">
                            Reset PW
                          </Button>
                        }
                        title={`Reset Password ${t.fullName}?`}
                        description="Password akan direset menjadi '12345678'. Anda yakin?"
                        confirmLabel="Ya, Reset"
                        onConfirm={() => handleResetPassword(t)}
                      />

                      <ConfirmDialog
                        trigger={
                          <Button
                            variant={t.isActive ? 'ghost' : 'default'}
                            size="sm"
                            className={`h-8 px-2 text-xs ${
                              t.isActive ? 'text-status-err hover:text-status-err' : ''
                            }`}
                          >
                            {pending && (
                              <Loader2
                                className="mr-1 h-3 w-3 animate-spin"
                                aria-hidden
                              />
                            )}
                            {t.isActive ? 'Nonaktifkan' : 'Aktifkan'}
                          </Button>
                        }
                        title={
                          t.isActive
                            ? `Nonaktifkan ${t.fullName}?`
                            : `Aktifkan ${t.fullName}?`
                        }
                        description={
                          t.isActive
                            ? 'Akun guru ini akan dinonaktifkan dan tidak bisa login. Penugasan kelasnya tetap tersimpan.'
                            : 'Akun guru ini akan diaktifkan kembali dan bisa login.'
                        }
                        variant={t.isActive ? 'destructive' : 'default'}
                        confirmLabel={t.isActive ? 'Ya, Nonaktifkan' : 'Ya, Aktifkan'}
                        onConfirm={() => handleToggleActive(t)}
                      />

                      <ConfirmDialog
                        trigger={
                          <Button
                            variant="ghost"
                            size="sm"
                            className="h-8 px-2 text-xs text-red-600 hover:text-red-700 hover:bg-red-50"
                            disabled={pending}
                          >
                            Hapus
                          </Button>
                        }
                        title={`Hapus permanen ${t.fullName}?`}
                        description="Semua data akun guru ini akan dihapus secara permanen dan tidak dapat dikembalikan. Guru yang masih menjadi wali kelas aktif tidak bisa dihapus."
                        variant="destructive"
                        confirmLabel="Ya, Hapus Permanen"
                        onConfirm={() => handleDelete(t)}
                      />
                    </div>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {assignTarget && (
        <AssignClassDialog
          open={Boolean(assignTarget)}
          onOpenChange={(o) => !o && setAssignTarget(null)}
          teacher={assignTarget}
          classes={classes}
          periods={periods}
        />
      )}
    </>
  );
}