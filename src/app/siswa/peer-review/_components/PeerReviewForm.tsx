'use client';

/**
 * @file siswa/peer-review/_components/PeerReviewForm.tsx
 * @description Form utama Peer Review siswa.
 *
 *  State kritis:
 *   - currentRevieweeId    siswa yang sedang dinilai
 *   - ratings              Record<revieweeId, 5-tuple skor>
 *   - submittedSet         Set<revieweeId> yang sudah disubmit
 *
 *  Behavior:
 *   - Klik salah satu rating button → update state ratings di browser
 *   - Tombol "Kirim & Lanjut": validasi 5 aspek terisi → submit →
 *     pindah ke teman selanjutnya yang belum dinilai
 *   - Mode Edit: Klik "Ubah" di daftar teman yang sudah dinilai →
 *     pre-fill skor lama → tombol ganti menjadi "Perbarui Nilai"
 *   - Saat semua selesai → tampilkan completion screen (di-handle oleh page)
 *   - Akordion daftar teman dengan jump-to per teman
 *
 *  Catatan desain: fitur draft dihapus karena nilai sudah bisa dikoreksi
 *  kapan saja selama sesi aktif — menyimpan draft tidak lagi diperlukan.
 */

import { useMemo, useState, useTransition } from 'react';
import { useRouter } from 'next/navigation';
import {
  AlertCircle,
  ChevronUp,
  CircleCheck,
  Circle,
  Loader2,
  Send,
  Pencil,
} from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import { cn } from '@/lib/utils/cn';
import { ASPECT_LABELS, PEER_REVIEW_ASPECTS } from '@/constants';
import { submitPeerReviewRating } from '@/lib/actions/student';
import { AspectRatingButtons } from './AspectRatingButtons';

export interface PeerReviewFormProps {
  sessionId: string;
  /** Daftar teman terurut sesuai shuffle deterministic (server). */
  reviewees: Array<{ id: string; fullName: string }>;
  /** Set ID teman yang sudah disubmit. */
  initialSubmittedIds: string[];
  /**
   * Skor yang sudah pernah dikirim (per revieweeId → 5-tuple).
   * Digunakan untuk pre-fill form saat siswa ingin mengedit nilai.
   */
  initialSubmittedScores?: Record<string, [number, number, number, number, number]>;
}

/** Skor 5-tuple per reviewee. 0 = belum diisi. */
type RatingScores = [number, number, number, number, number];

function emptyRating(): RatingScores {
  return [0, 0, 0, 0, 0];
}

export function PeerReviewForm({
  sessionId,
  reviewees,
  initialSubmittedIds,
  initialSubmittedScores = {},
}: PeerReviewFormProps) {
  const router = useRouter();
  const totalReviewees = reviewees.length;

  // ── State utama ──────────────────────────────────────────────────
  const [submittedSet, setSubmittedSet] = useState<Set<string>>(
    () => new Set(initialSubmittedIds),
  );

  const [ratings, setRatings] = useState<Record<string, RatingScores>>(() => {
    const init: Record<string, RatingScores> = {};
    for (const r of reviewees) {
      // Pre-fill dengan skor yang sudah pernah dikirim, atau kosong
      init[r.id] = initialSubmittedScores[r.id] ?? emptyRating();
    }
    return init;
  });

  // Tentukan reviewee aktif: yang pertama belum di-submit
  const initialIndex = useMemo(() => {
    const idx = reviewees.findIndex((r) => !submittedSet.has(r.id));
    return idx === -1 ? 0 : idx;
  }, [reviewees, submittedSet]);

  const [currentIndex, setCurrentIndex] = useState<number>(initialIndex);
  const [showError, setShowError] = useState(false);
  const [submitPending, startSubmitTransition] = useTransition();

  const currentReviewee = reviewees[currentIndex];
  const currentScores =
    currentReviewee && ratings[currentReviewee.id]
      ? ratings[currentReviewee.id]!
      : emptyRating();

  /** true jika teman yang sedang ditampilkan sudah pernah dinilai (mode edit). */
  const isEditMode = currentReviewee ? submittedSet.has(currentReviewee.id) : false;

  const submittedCount = submittedSet.size;
  const progressPercent =
    totalReviewees > 0
      ? Math.round((submittedCount / totalReviewees) * 100)
      : 0;

  // ── Update rating untuk aspek tertentu ───────────────────────────
  function updateRating(aspectIdx: number, value: number) {
    if (!currentReviewee) return;
    setRatings((prev) => {
      const cur = prev[currentReviewee.id] ?? emptyRating();
      const next: RatingScores = [...cur];
      next[aspectIdx] = value;
      return { ...prev, [currentReviewee.id]: next };
    });
    setShowError(false);
  }

  // ── Pindah ke teman tertentu (jump-to) ──────────────────────────
  // PATCH edit: teman yang sudah dinilai sekarang boleh dikunjungi kembali
  // untuk mode edit — tidak diblokir lagi.
  function jumpToReviewee(idx: number) {
    if (idx < 0 || idx >= reviewees.length) return;
    setCurrentIndex(idx);
    setShowError(false);
  }

  // ── Submit ───────────────────────────────────────────────────────
  function handleSubmit() {
    if (!currentReviewee) return;
    const scores = ratings[currentReviewee.id] ?? emptyRating();
    if (scores.some((s) => s < 1 || s > 5)) {
      setShowError(true);
      setTimeout(() => setShowError(false), 3000);
      return;
    }

    startSubmitTransition(async () => {
      const result = await submitPeerReviewRating({
        sessionId,
        revieweeId: currentReviewee.id,
        scores: {
          courtesy: scores[0],
          cooperation: scores[1],
          empathy: scores[2],
          honesty: scores[3],
          responsibility: scores[4],
        },
      });

      if (!result.ok) {
        toast.error(isEditMode ? 'Gagal memperbarui penilaian' : 'Gagal mengirim penilaian', {
          description: result.error,
        });
        return;
      }

      if (isEditMode) {
        // Mode edit: tetap di reviewee yang sama, tampilkan toast berbeda
        toast.success(`Nilai untuk ${currentReviewee.fullName} diperbarui`);
        // submittedSet tidak berubah — reviewee sudah ada di set
        return;
      }

      toast.success(`Penilaian untuk ${currentReviewee.fullName} terkirim`);

      // Update local state: tandai reviewee ini sebagai selesai
      setSubmittedSet((prev) => {
        const next = new Set(prev);
        next.add(currentReviewee.id);
        return next;
      });

      // Pindah ke reviewee berikutnya
      if (result.data?.nextRevieweeId) {
        const nextId = result.data.nextRevieweeId;
        const nextIdx = reviewees.findIndex((r) => r.id === nextId);
        if (nextIdx !== -1) setCurrentIndex(nextIdx);
      } else {
        // Semua selesai — refresh agar page menampilkan completion screen
        router.refresh();
      }
    });
  }

  // ── Akordion daftar teman ───────────────────────────────────────
  const [friendListOpen, setFriendListOpen] = useState(false);

  // ── Preview rata-rata ────────────────────────────────────────────
  const filledCount = currentScores.filter((s) => s > 0).length;
  const previewAvg =
    filledCount === 5
      ? currentScores.reduce((a, b) => a + b, 0) / 5
      : null;
  const previewScore100 = previewAvg !== null ? previewAvg * 20 : null;

  if (!currentReviewee) {
    return (
      <div className="rounded-md border border-sipandu-border bg-white p-8 text-center">
        <p className="text-sm italic text-muted-foreground">
          Tidak ada teman yang perlu dinilai.
        </p>
      </div>
    );
  }

  return (
    <div className="space-y-3.5">
      {/* Card progress */}
      <div className="rounded-md border border-sipandu-border bg-white p-3.5">
        <div className="mb-2 flex items-center justify-between text-sm">
          <span className="text-foreground">
            Anda sudah menilai <strong>{submittedCount}</strong> dari{' '}
            <strong>{totalReviewees}</strong> teman
          </span>
          <span className="font-semibold text-muted-foreground">
            {progressPercent}%
          </span>
        </div>
        <div className="h-3 overflow-hidden rounded-md bg-gray-200">
          <div
            className={cn(
              'h-full rounded-md transition-[width]',
              progressPercent >= 100 ? 'bg-status-on' : 'bg-status-warn',
            )}
            style={{ width: `${progressPercent}%` }}
          />
        </div>
      </div>

      {/* Banner anonimitas */}
      <div className="rounded-md border-l-4 border-gray-300 bg-gray-50 px-3 py-2.5 text-sm text-muted-foreground">
        ℹ Identitas Anda sebagai penilai tidak akan diketahui oleh teman yang
        Anda nilai.
      </div>

      {/* Card utama menilai teman */}
      <div className="rounded-md border border-sipandu-border bg-white p-3.5">
        {/* Header reviewee */}
        <div
          className={cn(
            'mb-4 flex items-center gap-3 rounded-md p-3',
            isEditMode ? 'bg-amber-50' : 'bg-sky-50',
          )}
        >
          <div
            className={cn(
              'flex h-10 w-10 flex-shrink-0 items-center justify-center rounded-full text-base font-bold text-white',
              isEditMode ? 'bg-amber-500' : 'bg-sipandu-blue',
            )}
            aria-hidden
          >
            {currentReviewee.fullName.charAt(0)}
          </div>
          <div>
            <div className="flex items-center gap-2 text-md font-bold text-foreground">
              {isEditMode && (
                <span className="inline-flex items-center gap-1 rounded bg-amber-100 px-1.5 py-0.5 text-xs font-semibold text-amber-700">
                  <Pencil className="h-3 w-3" aria-hidden />
                  Mode Edit
                </span>
              )}
              {isEditMode ? 'Mengedit nilai: ' : 'Menilai: '}
              {currentReviewee.fullName}
            </div>
            <div className="text-xs text-muted-foreground">
              {isEditMode
                ? 'Nilai sebelumnya sudah ditampilkan — ubah yang perlu dikoreksi'
                : `Teman ke-${currentIndex + 1} dari ${totalReviewees} · Urutan diacak secara otomatis`}
            </div>
          </div>
        </div>

        {/* 5 aspek */}
        {PEER_REVIEW_ASPECTS.map((aspect, idx) => (
          <div
            key={aspect.key}
            className="mb-3 rounded-lg border border-sipandu-border p-4"
          >
            <h3
              id={`aspect-${idx}-${currentReviewee.id}-label`}
              className="mb-1 text-md font-bold text-foreground"
            >
              {idx + 1}. {aspect.label}
            </h3>
            <p className="mb-3 text-sm leading-relaxed text-muted-foreground">
              {aspect.description}
            </p>
            <AspectRatingButtons
              aspectIndex={idx}
              value={currentScores[idx] ?? 0}
              onChange={(v) => updateRating(idx, v)}
              inputId={`aspect-${idx}-${currentReviewee.id}`}
            />
          </div>
        ))}
      </div>

      {/* Preview nilai */}
      <div className="rounded-md border border-sipandu-border bg-gray-50 p-3.5">
        <div className="mb-1.5 text-xs font-bold text-foreground">
          Nilai yang akan dikirim untuk {currentReviewee.fullName}:
        </div>
        <div className="mb-1 text-sm leading-relaxed text-foreground">
          {currentScores.every((s) => s === 0) ? (
            <span className="italic text-muted-foreground">
              Belum ada aspek yang diisi
            </span>
          ) : (
            currentScores.map((s, i) => {
              const aspectKey =
                PEER_REVIEW_ASPECTS[i]?.key ?? 'courtesy';
              return (
                <span key={i}>
                  {i > 0 && (
                    <span className="text-muted-foreground"> | </span>
                  )}
                  <strong>{ASPECT_LABELS[aspectKey]}:</strong>{' '}
                  {s > 0 ? s : '—'}
                </span>
              );
            })
          )}
        </div>
        <div className="text-sm text-muted-foreground">
          {filledCount === 5 && previewAvg !== null && previewScore100 !== null ? (
            <>
              Rata-rata: ({currentScores.join('+')})/5 = {previewAvg.toFixed(1)}{' '}
              → Skor: {previewScore100.toFixed(1)}/100
            </>
          ) : (
            <>{filledCount} dari 5 aspek sudah terisi</>
          )}
        </div>
      </div>

      {/* Error banner */}
      {showError && (
        <div className="flex items-center gap-2 rounded-md border-l-4 border-status-err bg-red-50 px-3 py-2 text-sm text-status-err-text">
          <AlertCircle className="h-3.5 w-3.5 flex-shrink-0" aria-hidden />
          Harap isi semua 5 aspek penilaian sebelum mengirim.
        </div>
      )}

      {/* Tombol aksi */}
      <div className="flex flex-wrap gap-2">
        <Button
          type="button"
          onClick={handleSubmit}
          disabled={submitPending}
          className={cn(
            'flex-1 justify-center gap-1.5 py-2.5 text-white',
            isEditMode
              ? 'bg-amber-500 hover:bg-amber-500/90'
              : 'bg-sipandu-blue hover:bg-sipandu-blue/90',
          )}
        >
          {submitPending ? (
            <Loader2 className="h-4 w-4 animate-spin" aria-hidden />
          ) : isEditMode ? (
            <Pencil className="h-4 w-4" aria-hidden />
          ) : (
            <Send className="h-4 w-4" aria-hidden />
          )}
          {isEditMode ? 'Perbarui Nilai' : 'Kirim & Lanjut ke Teman Berikutnya →'}
        </Button>
      </div>

      {/* Catatan: hanya tampil saat bukan mode edit */}
      {!isEditMode && (
        <p className="text-2xs text-muted-foreground">
          Penilaian yang sudah dikirim masih dapat diubah selama sesi masih aktif.
        </p>
      )}

      {/* Akordion daftar teman */}
      <div className="overflow-hidden rounded-md border border-sipandu-border bg-white">
        <button
          type="button"
          onClick={() => setFriendListOpen((v) => !v)}
          className="flex w-full items-center justify-between px-3.5 py-2.5 text-left transition-colors hover:bg-gray-50"
        >
          <span className="text-sm font-semibold text-foreground">
            Daftar pengisian ({submittedCount} selesai,{' '}
            {totalReviewees - submittedCount} belum)
          </span>
          <ChevronUp
            className={cn(
              'h-3.5 w-3.5 transition-transform',
              !friendListOpen && 'rotate-180',
            )}
            aria-hidden
          />
        </button>

        {friendListOpen && (
          <div className="max-h-[260px] overflow-y-auto border-t border-sipandu-border px-3.5 py-2">
            {reviewees.map((r, i) => {
              const done = submittedSet.has(r.id);
              const isCurrent = i === currentIndex;
              const isNext = i === currentIndex + 1;
              return (
                <div
                  key={r.id}
                  className={cn(
                    'flex items-center justify-between border-b border-gray-100 py-1.5 last:border-b-0',
                    isCurrent && 'bg-blue-50',
                    isNext && !done && 'bg-amber-50',
                  )}
                >
                  <div className="flex items-center gap-2.5">
                    {done ? (
                      <CircleCheck
                        className="h-3.5 w-3.5 text-status-on"
                        aria-hidden
                      />
                    ) : isCurrent ? (
                      <Loader2
                        className="h-3.5 w-3.5 text-sipandu-blue"
                        aria-hidden
                      />
                    ) : (
                      <Circle
                        className="h-3.5 w-3.5 text-gray-400"
                        aria-hidden
                      />
                    )}
                    <span
                      className={cn(
                        'text-sm',
                        done && 'text-foreground',
                        isCurrent && 'font-semibold text-sipandu-blue',
                        isNext && !done && 'font-semibold text-amber-700',
                        !done && !isCurrent && !isNext && 'text-muted-foreground',
                      )}
                    >
                      {r.fullName}
                    </span>
                  </div>

                  <div className="flex items-center gap-2">
                    <span
                      className={cn(
                        'text-xs',
                        done && !isCurrent && 'text-status-on-text',
                        isCurrent && isEditMode && 'text-amber-600',
                        isCurrent && !isEditMode && 'text-sipandu-blue',
                        !done && !isCurrent && 'text-muted-foreground',
                      )}
                    >
                      {done && isCurrent && isEditMode
                        ? 'Sedang diedit'
                        : done
                          ? 'Selesai'
                          : isCurrent
                            ? 'Sedang dinilai'
                            : 'Belum dinilai'}
                    </span>
                    {/* Tombol "Nilai" untuk yang belum selesai */}
                    {!done && !isCurrent && (
                      <Button
                        type="button"
                        size="sm"
                        onClick={() => jumpToReviewee(i)}
                        className="h-6 px-2 text-2xs"
                      >
                        Nilai
                      </Button>
                    )}
                    {/* Tombol "Ubah" untuk yang sudah selesai dan bukan sedang aktif */}
                    {done && !isCurrent && (
                      <Button
                        type="button"
                        size="sm"
                        variant="outline"
                        onClick={() => jumpToReviewee(i)}
                        className="h-6 gap-1 px-2 text-2xs text-amber-600 hover:bg-amber-50 hover:text-amber-700"
                      >
                        <Pencil className="h-2.5 w-2.5" aria-hidden />
                        Ubah
                      </Button>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}
