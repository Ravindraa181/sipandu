'use client';

/**
 * @file admin/siswa/_components/StudentDetailDialog.tsx
 *
 * FIX TS2305: 'setStudentActive' tidak diekspor dari admin.ts.
 *   admin.ts mengekspor setUserActive({ userId, isActive, role }),
 *   bukan setStudentActive(id, bool).
 *   Solusi: ubah import dan semua pemanggilan.
 *
 * UPDATE: Tambah fitur Edit Data (EditStudentDialog) dan Hapus Siswa (ConfirmDialog + deleteStudent).
 */

import { useState, useTransition } from 'react';
import { Loader2 } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { CategoryBadge } from '@/components/shared/CategoryBadge';
// FIX: setStudentActive → setUserActive
import { resetUserPassword, setUserActive, deleteStudent } from '@/lib/actions/admin';
import { ConfirmDialog } from '@/components/shared/ConfirmDialog';
import { formatScore, formatPercent } from '@/lib/utils/format';
import type { CategoryType } from '@/types';
import { AssignToClassDialog } from './AssignToClassDialog';
import { EditStudentDialog } from './EditStudentDialog';

export interface StudentScoreHistoryRow {
  periodLabel: string;
  className: string;
  x1: number | null;
  x2: number | null;
  x3: number | null;
  zScore: number | null;
  category: CategoryType | null;
}

export interface StudentDetail {
  id: string;
  nisn: string;
  fullName: string;
  email: string;
  gender: 'L' | 'P' | null;
  isActive: boolean;
  currentClassName: string | null;
  scoreHistory: StudentScoreHistoryRow[];
}

export interface StudentDetailDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  student: StudentDetail;
  classOptions: Array<{ id: string; name: string }>;
  activePeriodExists: boolean;
}

export function StudentDetailDialog({
  open,
  onOpenChange,
  student,
  classOptions,
  activePeriodExists,
}: StudentDetailDialogProps) {
  const [pending, startTransition] = useTransition();
  const [assignOpen, setAssignOpen] = useState(false);
  const [editOpen, setEditOpen] = useState(false);

  /** Hapus siswa: panggil deleteStudent lalu tutup semua dialog. */
  function handleDelete(): Promise<void> {
    return new Promise((resolve) => {
      startTransition(async () => {
        const result = await deleteStudent(student.id);
        if (result.ok) {
          toast.success(`Data ${student.fullName} berhasil dihapus`);
          onOpenChange(false);
        } else {
          toast.error('Gagal menghapus siswa', { description: result.error });
        }
        resolve();
      });
    });
  }

  // resetUserPassword(userId, newPassword) — 2 posisional, ✓ cocok dengan admin.ts
  function handleResetPassword() {
    const newPw = prompt(
      `Reset password untuk ${student.fullName}.\nMasukkan password baru (min 8 karakter):`,
    );
    if (!newPw) return;
    startTransition(async () => {
      const result = await resetUserPassword(student.id, newPw);
      if (result.ok) toast.success('Password berhasil direset');
      else toast.error('Gagal reset password', { description: result.error });
    });
  }

  // FIX: setUserActive({ userId, isActive, role }) — object arg sesuai admin.ts
  function handleToggleActive(): Promise<void> {
    return new Promise((resolve) => {
      startTransition(async () => {
        const result = await setUserActive({
          userId: student.id,
          isActive: !student.isActive,
          role: 'student',              // FIX: sertakan role agar revalidatePath benar
        });
        if (result.ok) {
          toast.success(
            student.isActive
              ? `${student.fullName} dinonaktifkan`
              : `${student.fullName} diaktifkan kembali`,
          );
          onOpenChange(false);
        } else {
          toast.error('Gagal mengubah status', { description: result.error });
        }
        resolve();
      });
    });
  }

  return (
    <>
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-[680px]">
        <DialogHeader>
          <DialogTitle>Detail siswa — {student.fullName}</DialogTitle>
        </DialogHeader>

        {/* Info siswa */}
        <div className="grid grid-cols-2 gap-1.5 rounded-md bg-gray-50 p-2.5 text-sm">
          <div>
            <span className="text-muted-foreground">NISN:</span>{' '}
            <span className="font-mono text-xs">{student.nisn}</span>
          </div>
          <div>
            <span className="text-muted-foreground">Status:</span>{' '}
            <span
              className={
                student.isActive
                  ? 'inline-flex items-center rounded-full bg-status-on-soft px-2 py-0.5 text-2xs font-semibold text-status-on-text'
                  : 'inline-flex items-center rounded-full bg-status-off-soft px-2 py-0.5 text-2xs font-semibold text-status-off-text'
              }
            >
              {student.isActive ? 'Aktif' : 'Nonaktif'}
            </span>
          </div>
          <div>
            <span className="text-muted-foreground">Kelas Aktif:</span>{' '}
            <span>{student.currentClassName ?? '—'}</span>
          </div>
          <div>
            <span className="text-muted-foreground">Email:</span>{' '}
            <span className="text-xs">{student.email}</span>
          </div>
        </div>

        {/* Riwayat skor */}
        <div>
          <div className="mb-2 text-sm font-bold text-foreground">
            Riwayat skor
          </div>
          {student.scoreHistory.length === 0 ? (
            <p className="rounded-md border border-sipandu-border bg-white py-6 text-center text-xs italic text-muted-foreground">
              Belum ada skor tercatat.
            </p>
          ) : (
            <div className="overflow-hidden rounded-md border border-sipandu-border bg-white">
              <table className="w-full border-collapse text-sm">
                <thead>
                  <tr className="border-b border-sipandu-border bg-gray-100 text-left">
                    <th className="px-3 py-1.5 text-xs font-semibold">Periode</th>
                    <th className="px-3 py-1.5 text-xs font-semibold">Kelas</th>
                    <th className="px-3 py-1.5 text-center text-xs font-semibold">Absensi (%)</th>
                    <th className="px-3 py-1.5 text-center text-xs font-semibold">Poin Perilaku</th>
                    <th className="px-3 py-1.5 text-center text-xs font-semibold">Nilai Sejawat</th>
                    <th className="px-3 py-1.5 text-center text-xs font-semibold">Nilai Akhir</th>
                    <th className="px-3 py-1.5 text-xs font-semibold">Kategori</th>
                  </tr>
                </thead>
                <tbody>
                  {student.scoreHistory.map((s, i) => (
                    <tr
                      key={`${s.periodLabel}-${i}`}
                      className="border-b border-gray-100 last:border-b-0"
                    >
                      <td className="px-3 py-1.5">{s.periodLabel}</td>
                      <td className="px-3 py-1.5">{s.className}</td>
                      <td className="px-3 py-1.5 text-center">{formatPercent(s.x1, 0)}</td>
                      <td className="px-3 py-1.5 text-center">{formatScore(s.x2, 0)}</td>
                      <td className="px-3 py-1.5 text-center">{formatScore(s.x3, 0)}</td>
                      <td className="px-3 py-1.5 text-center font-bold">
                        {formatScore(s.zScore, 1)}
                      </td>
                      <td className="px-3 py-1.5">
                        <CategoryBadge category={s.category} size="sm" />
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>

        {/*
          ALASAN: 6 tombol tidak muat dalam satu baris — gunakan dua baris eksplisit.
          Baris 1: aksi profil (Reset Password, Edit Data, Assign/Pindah Kelas).
          Baris 2: aksi kritis (Hapus Siswa, Nonaktifkan/Aktifkan) + Tutup.
        */}
        <DialogFooter className="flex-col gap-2 sm:flex-col">
          {/* Baris 1 — aksi profil */}
          <div className="flex w-full flex-wrap gap-2 border-t border-sipandu-border pt-3">
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={handleResetPassword}
              disabled={pending}
            >
              {pending && (
                <Loader2 className="mr-1.5 h-3 w-3 animate-spin" aria-hidden />
              )}
              Reset Password
            </Button>

            {/* Tombol Edit Data — buka EditStudentDialog */}
            <Button
              type="button"
              variant="outline"
              size="sm"
              className="border-sipandu-blue text-sipandu-blue hover:bg-blue-50"
              onClick={() => setEditOpen(true)}
              disabled={pending}
            >
              Edit Data
            </Button>

            {activePeriodExists && (
              <Button
                type="button"
                variant="outline"
                size="sm"
                className="border-sipandu-blue text-sipandu-blue hover:bg-blue-50"
                onClick={() => setAssignOpen(true)}
                disabled={pending}
              >
                {student.currentClassName ? 'Pindah Kelas' : 'Assign ke Kelas'}
              </Button>
            )}
          </div>

          {/* Baris 2 — aksi kritis + tutup */}
          <div className="flex w-full items-center justify-between gap-2">
            <div className="flex gap-2">
              {/* Tombol Hapus Siswa — destructive, memerlukan konfirmasi */}
              <ConfirmDialog
                trigger={
                  <Button
                    variant="outline"
                    size="sm"
                    className="border-status-err text-status-err hover:bg-red-50"
                    disabled={pending}
                  >
                    Hapus Siswa
                  </Button>
                }
                title={`Hapus ${student.fullName}?`}
                description="Akun dan seluruh data siswa ini akan dihapus permanen termasuk dari sistem autentikasi. Tindakan ini tidak dapat dibatalkan."
                variant="destructive"
                onConfirm={handleDelete}
              />
              <ConfirmDialog
                trigger={
                  <Button
                    variant="outline"
                    size="sm"
                    className={
                      student.isActive
                        ? 'border-status-err text-status-err hover:bg-red-50'
                        : 'border-status-on text-status-on-text hover:bg-green-50'
                    }
                  >
                    {student.isActive ? 'Nonaktifkan' : 'Aktifkan'}
                  </Button>
                }
                title={
                  student.isActive
                    ? `Nonaktifkan ${student.fullName}?`
                    : `Aktifkan ${student.fullName}?`
                }
                description={
                  student.isActive
                    ? 'Akun siswa ini akan dinonaktifkan dan tidak bisa login. Riwayat skornya tetap tersimpan.'
                    : 'Akun siswa ini akan diaktifkan kembali dan bisa login.'
                }
                variant={student.isActive ? 'destructive' : 'default'}
                onConfirm={handleToggleActive}
              />
            </div>
            <Button
              type="button"
              onClick={() => onOpenChange(false)}
              className="bg-sipandu-blue text-white hover:bg-sipandu-blue/90"
            >
              Tutup
            </Button>
          </div>
        </DialogFooter>
      </DialogContent>
    </Dialog>

    {assignOpen && (
      <AssignToClassDialog
        open={assignOpen}
        onOpenChange={(o) => {
          setAssignOpen(o);
          if (!o) onOpenChange(false);
        }}
        studentId={student.id}
        studentName={student.fullName}
        currentClassName={student.currentClassName}
        classOptions={classOptions}
      />
    )}

    {/* EditStudentDialog: menutup diri sendiri tanpa menutup detail dialog */}
    <EditStudentDialog
      open={editOpen}
      onOpenChange={setEditOpen}
      student={student}
    />
  </>
  );
}
