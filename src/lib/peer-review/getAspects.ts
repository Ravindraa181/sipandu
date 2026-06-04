/**
 * @file lib/peer-review/getAspects.ts
 * @description Helper server-side: muat label & deskripsi 5 aspek peer
 *              assessment dari tabel `peer_review_aspects`.
 *
 *  Bila tabel kosong / query gagal, fallback ke konstanta
 *  PEER_REVIEW_ASPECTS (pola sama dengan loadConfigFromDb pada fuzzy).
 *
 *  Kunci (`key`) & jumlah aspek TETAP — yang dinamis hanya label & deskripsi.
 */

import 'server-only';
import { createClient } from '@/lib/supabase/server';
import {
  PEER_REVIEW_ASPECTS,
  type PeerReviewAspectKey,
} from '@/constants';

export interface PeerReviewAspect {
  key: PeerReviewAspectKey;
  label: string;
  description: string;
}

/** Urutan & key kanonik 5 aspek (selaras kolom skor di DB). */
const ASPECT_ORDER: readonly PeerReviewAspectKey[] = [
  'courtesy',
  'cooperation',
  'empathy',
  'honesty',
  'responsibility',
];

/** Fallback dari konstanta hardcode. */
function defaultAspects(): PeerReviewAspect[] {
  return PEER_REVIEW_ASPECTS.map((a) => ({
    key: a.key,
    label: a.label,
    description: a.description,
  }));
}

/**
 * Ambil 5 aspek peer review (label + deskripsi) dari DB, terurut.
 * Selalu mengembalikan tepat 5 aspek dalam urutan kanonik; aspek yang
 * tidak ada di DB diisi dari konstanta default.
 */
export async function getPeerReviewAspects(): Promise<PeerReviewAspect[]> {
  const fallback = defaultAspects();

  try {
    const supabase = await createClient();
    const { data, error } = await supabase
      .from('peer_review_aspects')
      .select('aspect_key, label, description, display_order');

    if (error || !data || data.length === 0) return fallback;

    const byKey = new Map(
      data.map((r) => [
        r.aspect_key as PeerReviewAspectKey,
        { label: r.label as string, description: r.description as string },
      ]),
    );

    // Susun dalam urutan kanonik; isi dari DB bila ada, jika tidak pakai default.
    return ASPECT_ORDER.map((key) => {
      const fromDb = byKey.get(key);
      const def = fallback.find((f) => f.key === key)!;
      return {
        key,
        label: fromDb?.label ?? def.label,
        description: fromDb?.description ?? def.description,
      };
    });
  } catch {
    return fallback;
  }
}

/** Peta cepat key → label (untuk komponen yang hanya butuh label). */
export async function getAspectLabelMap(): Promise<
  Record<PeerReviewAspectKey, string>
> {
  const aspects = await getPeerReviewAspects();
  return aspects.reduce(
    (acc, a) => {
      acc[a.key] = a.label;
      return acc;
    },
    {} as Record<PeerReviewAspectKey, string>,
  );
}
