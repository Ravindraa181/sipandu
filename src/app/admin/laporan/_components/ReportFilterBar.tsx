'use client';

/**
 * @file admin/laporan/_components/ReportFilterBar.tsx
 * @description Filter bar untuk laporan global: dropdown periode + kelas.
 *
 *  Saat user mengubah filter, halaman di-refresh via router.push dengan
 *  query string baru — server component mengambil ulang data sesuai filter.
 *  Tombol Export dipindah ke PageHeader (ExportReportButtons) agar tidak duplikat.
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
}

export function ReportFilterBar({
  periods,
  classes,
  selectedPeriodId,
  selectedClassId,
}: ReportFilterBarProps) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [pending, startTransition] = useTransition();

  /** Perbarui query string dan reload server component. */
  function setParam(key: 'period' | 'class', value: string) {
    const params = new URLSearchParams(searchParams.toString());
    if (value === 'all') params.delete(key);
    else params.set(key, value);
    startTransition(() => {
      router.push(`?${params.toString()}`);
    });
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
        <SelectTrigger className="w-[160px]">
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

      {/* Indikator loading saat filter sedang diterapkan */}
      {pending && (
        <Loader2 className="h-3.5 w-3.5 animate-spin text-muted-foreground" aria-hidden />
      )}
    </div>
  );
}
