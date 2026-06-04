'use client';

/**
 * @file admin/kategori-poin/_components/AspectEditorList.tsx
 * @description Editor 5 aspek peer assessment (tab di halaman Kategori Poin).
 *              Tiap aspek dapat diedit nama & deskripsinya, disimpan per kartu.
 *
 *  Peer assessment = sejenis poin, namun diinput oleh siswa terhadap
 *  teman sekelasnya (skala 1–5 per aspek).
 */

import { useState, useTransition } from 'react';
import { Info, Loader2, Save, RotateCcw } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { updatePeerReviewAspect } from '@/lib/actions/admin';
import type { PeerReviewAspectKey } from '@/constants';

export interface AspectItem {
  key: PeerReviewAspectKey;
  label: string;
  description: string;
}

export interface AspectEditorListProps {
  aspects: AspectItem[];
}

export function AspectEditorList({ aspects }: AspectEditorListProps) {
  return (
    <div className="space-y-3">
      <div className="flex items-start gap-2 rounded-md border-l-4 border-sipandu-blue bg-blue-50 px-3 py-2.5 text-sm text-sipandu-blue-deep">
        <Info className="mt-0.5 h-3.5 w-3.5 flex-shrink-0" aria-hidden />
        <p>
          Setiap siswa menilai teman sekelasnya pada <strong>5 aspek</strong>{' '}
          berikut (skala 1–5). Ubah <strong>nama</strong> dan{' '}
          <strong>deskripsi</strong> tiap aspek agar sesuai kebutuhan sekolah.
        </p>
      </div>

      {aspects.map((aspect, i) => (
        <AspectCard key={aspect.key} index={i + 1} aspect={aspect} />
      ))}
    </div>
  );
}

function AspectCard({ index, aspect }: { index: number; aspect: AspectItem }) {
  const [label, setLabel] = useState(aspect.label);
  const [description, setDescription] = useState(aspect.description);
  // Baseline tersimpan — diperbarui setelah simpan berhasil.
  const [saved, setSaved] = useState({
    label: aspect.label,
    description: aspect.description,
  });
  const [pending, startTransition] = useTransition();

  const dirty =
    label.trim() !== saved.label || description.trim() !== saved.description;

  function handleReset() {
    setLabel(saved.label);
    setDescription(saved.description);
  }

  function handleSave() {
    if (label.trim().length < 3) {
      toast.error('Label minimal 3 karakter');
      return;
    }
    if (description.trim().length < 5) {
      toast.error('Deskripsi minimal 5 karakter');
      return;
    }

    startTransition(async () => {
      const result = await updatePeerReviewAspect({
        aspectKey: aspect.key,
        label: label.trim(),
        description: description.trim(),
      });

      if (result.ok) {
        toast.success(`Aspek "${label.trim()}" berhasil diperbarui`);
        setSaved({ label: label.trim(), description: description.trim() });
      } else {
        toast.error('Gagal menyimpan', { description: result.error });
      }
    });
  }

  return (
    <div className="rounded-md border border-sipandu-border bg-white p-4">
      <div className="mb-3 flex items-center gap-2">
        <span className="flex h-6 w-6 flex-shrink-0 items-center justify-center rounded-full bg-sipandu-blue text-xs font-bold text-white">
          {index}
        </span>
        <span className="text-sm font-semibold text-foreground">
          Aspek {index}
        </span>
      </div>

      <div className="space-y-3">
        <div className="space-y-1">
          <Label htmlFor={`label-${aspect.key}`}>Nama aspek</Label>
          <Input
            id={`label-${aspect.key}`}
            value={label}
            maxLength={100}
            onChange={(e) => setLabel(e.target.value)}
            placeholder="Mis. Kesantunan & Sopan Santun"
          />
        </div>

        <div className="space-y-1">
          <Label htmlFor={`desc-${aspect.key}`}>
            Deskripsi (pertanyaan yang dilihat siswa)
          </Label>
          <Textarea
            id={`desc-${aspect.key}`}
            value={description}
            maxLength={500}
            rows={2}
            onChange={(e) => setDescription(e.target.value)}
            placeholder="Mis. Seberapa sopan siswa ini kepada guru dan teman?"
          />
        </div>

        <div className="flex items-center justify-end gap-2">
          {dirty && (
            <Button
              type="button"
              variant="ghost"
              size="sm"
              onClick={handleReset}
              disabled={pending}
              className="gap-1.5 text-muted-foreground"
            >
              <RotateCcw className="h-3.5 w-3.5" aria-hidden /> Batalkan
            </Button>
          )}
          <Button
            type="button"
            size="sm"
            onClick={handleSave}
            disabled={pending || !dirty}
            className="gap-1.5 bg-sipandu-blue text-white hover:bg-sipandu-blue/90"
          >
            {pending ? (
              <Loader2 className="h-3.5 w-3.5 animate-spin" aria-hidden />
            ) : (
              <Save className="h-3.5 w-3.5" aria-hidden />
            )}
            Simpan
          </Button>
        </div>
      </div>
    </div>
  );
}
