'use client';

/**
 * @file admin/kelas/_components/ClassRow.tsx
 * @description Row tabel kelas + panel "Lihat Siswa" yang slide down
 *              di bawah row saat tombol diklik.
 */

import { useState } from 'react';
import { ChevronDown, Users } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { cn } from '@/lib/utils/cn';
import { TransferStudentDialog } from './TransferStudentDialog';

export interface ClassStudent {
  id: string;
  nis: string;
  fullName: string;
  gender: 'L' | 'P' | null;
}

export interface ClassRowProps {
  classId: string;
  className: string;
  gradeLevel: 'X' | 'XI' | 'XII';
  homeroomTeacherName: string | null;
  studentCount: number;
  /** Assignment ID di periode aktif (untuk pindahkan siswa). */
  activeAssignmentId: string | null;
  /** Assignment lain pada periode aktif (untuk dropdown pindahkan). */
  otherAssignments: Array<{ assignmentId: string; className: string }>;
  /** Daftar siswa kelas (lazy loadable; di sini langsung server-rendered). */
  students: ClassStudent[];
}

export function ClassRow({
  classId,
  className,
  gradeLevel,
  homeroomTeacherName,
  studentCount,
  activeAssignmentId,
  otherAssignments,
  students,
}: ClassRowProps) {
  const [expanded, setExpanded] = useState(false);
  const [transferTarget, setTransferTarget] = useState<ClassStudent | null>(
    null,
  );

  return (
    <>
      <tr
        className={cn(
          'border-b border-gray-100 transition-colors',
          expanded ? 'bg-blue-50/40' : 'hover:bg-blue-50/60',
        )}
      >
        <td className="px-3 py-2 font-semibold text-foreground">{className}</td>
        <td className="px-3 py-2">
          <span className="inline-flex items-center rounded-full bg-blue-50 px-2 py-0.5 text-2xs font-semibold text-sipandu-blue-deep">
            Kelas {gradeLevel}
          </span>
        </td>
        <td className="px-3 py-2 text-foreground">
          {homeroomTeacherName ?? (
            <span className="italic text-muted-foreground">
              Belum ditugaskan
            </span>
          )}
        </td>
        <td className="px-3 py-2 text-foreground">{studentCount} siswa</td>
        <td className="whitespace-nowrap px-3 py-2">
          <div className="flex flex-wrap gap-1">
            <Button
              size="sm"
              variant="outline"
              onClick={() => setExpanded((v) => !v)}
              className="gap-1"
            >
              <Users className="h-3 w-3" aria-hidden />
              Lihat Siswa
              <ChevronDown
                className={cn(
                  'h-3 w-3 transition-transform',
                  expanded && 'rotate-180',
                )}
                aria-hidden
              />
            </Button>
          </div>
        </td>
      </tr>

      {expanded && (
        <tr>
          <td colSpan={5} className="bg-gray-50 p-0">
            <div className="px-3.5 py-3">
              <div className="mb-2 flex items-center justify-between">
                <strong className="text-sm">
                  Siswa Kelas {className} — {studentCount} siswa
                </strong>
              </div>

              {students.length === 0 ? (
                <p className="rounded-md border border-sipandu-border bg-white py-6 text-center text-xs italic text-muted-foreground">
                  Belum ada siswa di kelas ini pada periode aktif.
                </p>
              ) : (
                <div className="overflow-hidden rounded-md border border-sipandu-border bg-white">
                  <table className="w-full border-collapse text-sm">
                    <thead>
                      <tr className="border-b border-sipandu-border bg-gray-100 text-left">
                        <th className="w-10 px-3 py-1.5 text-center text-xs font-semibold">
                          No
                        </th>
                        <th className="px-3 py-1.5 text-xs font-semibold">
                          NIS
                        </th>
                        <th className="px-3 py-1.5 text-xs font-semibold">
                          Nama Siswa
                        </th>
                        <th className="px-3 py-1.5 text-xs font-semibold">
                          J.K.
                        </th>
                        <th className="px-3 py-1.5 text-xs font-semibold">
                          Aksi
                        </th>
                      </tr>
                    </thead>
                    <tbody>
                      {students.slice(0, 8).map((s, i) => (
                        <tr
                          key={s.id}
                          className="border-b border-gray-100 last:border-b-0"
                        >
                          <td className="px-3 py-1.5 text-center text-xs text-muted-foreground">
                            {i + 1}
                          </td>
                          <td className="px-3 py-1.5 font-mono text-xs">
                            {s.nis}
                          </td>
                          <td className="px-3 py-1.5">{s.fullName}</td>
                          <td className="px-3 py-1.5 text-xs">
                            {s.gender === 'L'
                              ? 'Laki-laki'
                              : s.gender === 'P'
                                ? 'Perempuan'
                                : '—'}
                          </td>
                          <td className="px-3 py-1.5">
                            <Button
                              size="sm"
                              variant="outline"
                              disabled={!activeAssignmentId}
                              onClick={() => setTransferTarget(s)}
                            >
                              Pindahkan
                            </Button>
                          </td>
                        </tr>
                      ))}
                      {students.length > 8 && (
                        <tr>
                          <td
                            colSpan={5}
                            className="px-3 py-1.5 text-xs italic text-muted-foreground"
                          >
                            ... {students.length - 8} siswa lainnya
                          </td>
                        </tr>
                      )}
                    </tbody>
                  </table>
                </div>
              )}
            </div>
          </td>
        </tr>
      )}

      {transferTarget && activeAssignmentId && (
        <TransferStudentDialog
          open={Boolean(transferTarget)}
          onOpenChange={(o) => !o && setTransferTarget(null)}
          studentId={transferTarget.id}
          studentName={transferTarget.fullName}
          fromAssignmentId={activeAssignmentId}
          fromClassName={className}
          targetAssignments={otherAssignments}
        />
      )}
    </>
  );
}
