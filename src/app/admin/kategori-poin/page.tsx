/**
 * @file app/admin/kategori-poin/page.tsx
 * @description A8 — Kategori Poin (Pelanggaran & Reward).
 *
 * Server Component. Tampilkan 2 tab:
 * - Pelanggaran (violation_categories)
 * - Reward (reward_categories)
 *
 * Per tab: tabel CRUD dengan modal tambah/edit + konfirmasi hapus.
 */

import { createClient } from '@/lib/supabase/server';
import { PageHeader } from '@/components/shared/PageHeader';
import { getPeerReviewAspects } from '@/lib/peer-review/getAspects';
import { CategoryTabs } from './_components/CategoryTabs';
import type { CategoryRow } from './_components/CategoryTable';
import type { AspectItem } from './_components/AspectEditorList';

export const metadata = {
  title: 'Kategori Poin',
};

interface PageData {
  violations: CategoryRow[];
  rewards: CategoryRow[];
  aspects: AspectItem[];
}

async function loadData(): Promise<PageData> {
  const supabase = await createClient();

  // PERBAIKAN: Gunakan nama kolom yang benar sesuai database (point_deduction)
  const { data: violationData } = await supabase
    .from('violation_categories')
    .select('id, name, point_deduction, sop_reference, description, is_active')
    .order('name');

  // PERBAIKAN: Gunakan nama kolom yang benar sesuai database (point_addition)
  const { data: rewardData } = await supabase
    .from('reward_categories')
    .select('id, name, point_addition, category_label, description, is_active')
    .order('name');

  const violations: CategoryRow[] = (
    (violationData ?? []) as Array<{
      id: string;
      name: string;
      point_deduction: number;
      sop_reference: string | null;
      description: string | null;
      is_active: boolean;
    }>
  )
    .filter((v) => v.is_active !== false)
    .map((v) => ({
      id: v.id,
      name: v.name,
      pointValue: v.point_deduction,
      reference: v.sop_reference,
      description: v.description,
    }));

  const rewards: CategoryRow[] = (
    (rewardData ?? []) as Array<{
      id: string;
      name: string;
      point_addition: number;
      category_label: string | null;
      description: string | null;
      is_active: boolean;
    }>
  )
    .filter((r) => r.is_active !== false)
    .map((r) => ({
      id: r.id,
      name: r.name,
      pointValue: r.point_addition,
      reference: r.category_label,
      description: r.description,
    }));

  const aspects = await getPeerReviewAspects();

  return { violations, rewards, aspects };
}

export default async function AdminKategoriPoinPage() {
  const { violations, rewards, aspects } = await loadData();

  return (
    <div className="space-y-3">
      <PageHeader title="Kategori poin (Pelanggaran, Reward & Peer Assessment)" />

      <CategoryTabs
        violations={violations}
        rewards={rewards}
        aspects={aspects}
      />
    </div>
  );
}