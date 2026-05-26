'use client';

/**
 * @file dashboard/siswa/[id]/_components/TeacherNoteForm.tsx
 * @description Textarea catatan wali kelas dengan auto-save (debounce 1.5s).
 *              Dipakai di tab Ringkasan W5 dan tab catatan W6.
 */

import { useEffect, useRef, useState, useTransition } from 'react';
import { Check, Loader2 } from 'lucide-react';
import { toast } from 'sonner';

import { Textarea } from '@/components/ui/textarea';
import { Label } from '@/components/ui/label';
import { saveTeacherNote } from '@/lib/actions/teacher';

export interface TeacherNoteFormProps {
  enrollmentId: string;
  initialNote: string;
  studentName: string;
  /** Label custom (default: "Catatan wali kelas"). */
  label?: string;
}

const DEBOUNCE_MS = 1500;

export function TeacherNoteForm({
  enrollmentId,
  initialNote,
  studentName,
  label = 'Catatan wali kelas',
}: TeacherNoteFormProps) {
  const [note, setNote] = useState(initialNote);
  const [pending, startTransition] = useTransition();
  const [savedAt, setSavedAt] = useState<number | null>(null);
  const timerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const lastSavedRef = useRef<string>(initialNote);

  // Auto-save dengan debounce. Hanya simpan bila benar-benar berubah.
  useEffect(() => {
    if (note === lastSavedRef.current) return;

    if (timerRef.current) clearTimeout(timerRef.current);
    timerRef.current = setTimeout(() => {
      startTransition(async () => {
        const result = await saveTeacherNote({
          enrollmentId,
          note,
        });
        if (result.ok) {
          lastSavedRef.current = note;
          setSavedAt(Date.now());
        } else {
          toast.error('Gagal menyimpan catatan', {
            description: result.error,
          });
        }
      });
    }, DEBOUNCE_MS);

    return () => {
      if (timerRef.current) clearTimeout(timerRef.current);
    };
  }, [note, enrollmentId]);

  const isDirty = note !== lastSavedRef.current;

  return (
    <div className="space-y-1.5">
      <div className="flex items-center justify-between">
        <Label htmlFor={`note-${enrollmentId}`} className="text-xs font-semibold">
          {label}
        </Label>
        <span className="text-2xs text-muted-foreground">
          {pending ? (
            <span className="inline-flex items-center gap-1">
              <Loader2 className="h-2.5 w-2.5 animate-spin" aria-hidden />{' '}
              Menyimpan...
            </span>
          ) : isDirty ? (
            'Akan disimpan otomatis'
          ) : savedAt !== null ? (
            <span className="inline-flex items-center gap-1 text-status-on-text">
              <Check className="h-2.5 w-2.5" aria-hidden /> Tersimpan
            </span>
          ) : (
            ''
          )}
        </span>
      </div>
      <Textarea
        id={`note-${enrollmentId}`}
        value={note}
        onChange={(e) => setNote(e.target.value)}
        rows={4}
        placeholder={`Tulis catatan naratif untuk ${studentName}...`}
        className="text-sm"
      />
    </div>
  );
}
