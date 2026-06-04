/**
 * @file app/admin/aspek-peer-review/page.tsx
 * @description A9 — Aspek Peer Assessment.
 *
 *  Server Component. Menampilkan 5 aspek penilaian antar-teman (peer
 *  assessment) yang label & deskripsinya dapat diedit admin.
 *
 *  Catatan: jumlah & kunci aspek TETAP 5 (terikat ke kolom skor di
 *  peer_review_submissions dan trigger X3). Hanya label & deskripsi yang
 *  dapat diubah — tidak mengubah cara X3 dihitung.
 */

import { Info } from 'lucide-react';

import { PageHeader } from '@/components/shared/PageHeader';
import { getPeerReviewAspects } from '@/lib/peer-review/getAspects';
import { AspectEditorList } from './_components/AspectEditorList';

export const metadata = {
  title: 'Aspek Peer Assessment — Admin SiPandu',
};

export default async function AdminAspekPeerReviewPage() {
  const aspects = await getPeerReviewAspects();

  return (
    <div className="space-y-3">
      <PageHeader title="Aspek Peer Assessment" />

      <div className="flex items-start gap-2 rounded-md border-l-4 border-sipandu-blue bg-blue-50 px-3 py-2.5 text-sm text-sipandu-blue-deep">
        <Info className="mt-0.5 h-3.5 w-3.5 flex-shrink-0" aria-hidden />
        <p>
          Setiap siswa menilai teman sekelasnya pada <strong>5 aspek</strong>{' '}
          berikut (skala 1–5). Anda dapat mengubah <strong>nama</strong> dan{' '}
          <strong>deskripsi</strong> tiap aspek agar sesuai kebutuhan sekolah.
          Jumlah aspek tetap 5 dan tidak memengaruhi cara nilai sejawat (X3)
          dihitung.
        </p>
      </div>

      <AspectEditorList aspects={aspects} />
    </div>
  );
}
