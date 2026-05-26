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

import { Info } from 'lucide-react';

import { createClient } from '@/lib/supabase/server';
import { PageHeader } from '@/components/shared/PageHeader';
import { CategoryTabs } from './_components/CategoryTabs';
import type { CategoryRow } from './_components/CategoryTable';

export const metadata = {
  title: 'Kategori Poin — Admin SiPandu',
};

interface PageData {
  violations: CategoryRow[];
  rewards: CategoryRow[];
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

  return { violations, rewards };
}

export default async function AdminKategoriPoinPage() {
  const { violations, rewards } = await loadData();

  return (
    <div className="space-y-3">
      <PageHeader title="Kategori poin (Pelanggaran & Reward)" />

      <div className="flex items-start gap-2 rounded-md border-l-4 border-sipandu-blue bg-blue-50 px-3 py-2.5 text-sm text-sipandu-blue-deep">
        <Info className="mt-0.5 h-3.5 w-3.5 flex-shrink-0" aria-hidden />
        <p>
          Kategori yang dihapus akan dinonaktifkan (soft delete). Riwayat
          transaksi yang sudah ada tetap tersimpan untuk audit trail.
        </p>
      </div>

      <CategoryTabs violations={violations} rewards={rewards} />
    </div>
  );
}