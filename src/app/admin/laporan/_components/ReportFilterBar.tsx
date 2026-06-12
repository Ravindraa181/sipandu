'use client';

/**
 * @file admin/laporan/_components/ReportFilterBar.tsx
 * @description Filter bar: periode, kelas, dan kategori penilaian.
 */

import { useTransition } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { Loader2 } from 'lucide-react';

import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';

export interface ReportFilterBarProps {
  periods: Array<{ id: string; label: string; isActive: boolean }>;
  classes: Array<{ id: string; name: string }>;
  selectedPeriodId: string;
  selectedClassId: string;
  selectedCategory: string;
}

export function ReportFilterBar({
  periods,
  classes,
  selectedPeriodId,
  selectedClassId,
  selectedCategory,
}: ReportFilterBarProps) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [pending, startTransition] = useTransition();

  function setParam(key: 'period' | 'class' | 'category', value: string) {
    const params = new URLSearchParams(searchParams.toString());
    // Reset ke halaman 1 setiap kali filter berubah
    params.delete('page');
    if (value === 'all') params.delete(key);
    else params.set(key, value);
    startTransition(() => router.push(`?${params.toString()}`));
  }

  return (
    <div className="flex flex-wrap items-center gap-2 rounded-md border border-sipandu-border bg-white px-3 py-2.5">
      <Select
        value={selectedPeriodId}
        onValueChange={(v) => setParam('period', v)}
        disabled={pending}
      >
        <SelectTrigger className="w-[200px]">
          <SelectValue placeholder="Pilih Periode" />
        </SelectTrigger>
        <SelectContent>
          {periods.map((p) => (
            <SelectItem key={p.id} value={p.id}>
              {p.label}
              {p.isActive ? ' (Aktif)' : ''}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>

      <Select
        value={selectedClassId}
        onValueChange={(v) => setParam('class', v)}
        disabled={pending}
      >
        <SelectTrigger className="w-[150px]">
          <SelectValue placeholder="Semua Kelas" />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value="all">Semua Kelas</SelectItem>
          {classes.map((c) => (
            <SelectItem key={c.id} value={c.id}>
              {c.name}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>

      <Select
        value={selectedCategory}
        onValueChange={(v) => setParam('category', v)}
        disabled={pending}
      >
        <SelectTrigger className="w-[170px]">
          <SelectValue placeholder="Semua Kategori" />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value="all">Semua Kategori</SelectItem>
          <SelectItem value="sangat_baik">Sangat Baik</SelectItem>
          <SelectItem value="baik">Baik</SelectItem>
          <SelectItem value="cukup">Cukup</SelectItem>
          <SelectItem value="perlu_pembinaan">Perlu Pembinaan</SelectItem>
        </SelectContent>
      </Select>

      {pending && (
        <Loader2 className="h-3.5 w-3.5 animate-spin text-muted-foreground" aria-hidden />
      )}
    </div>
  );
}
