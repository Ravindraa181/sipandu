'use client';

/**
 * @file siswa/riwayat/_components/PeriodSelector.tsx
 * @description Dropdown selector periode untuk halaman Riwayat Siswa.
 *              Saat berubah, push ke URL `?period=...` sehingga halaman
 *              re-render dengan data periode tsb.
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

export interface PeriodOption {
  id: string;
  label: string;
  isActive: boolean;
}

export interface PeriodSelectorProps {
  options: PeriodOption[];
  selectedId: string;
}

export function PeriodSelector({
  options,
  selectedId,
}: PeriodSelectorProps) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [pending, startTransition] = useTransition();

  function handleChange(v: string) {
    const params = new URLSearchParams(searchParams.toString());
    params.set('period', v);
    startTransition(() => {
      router.push(`?${params.toString()}`);
    });
  }

  return (
    <div className="flex items-center gap-2">
      <Select value={selectedId} onValueChange={handleChange} disabled={pending}>
        <SelectTrigger className="w-[220px]">
          <SelectValue placeholder="Pilih Periode" />
        </SelectTrigger>
        <SelectContent>
          {options.map((p) => (
            <SelectItem key={p.id} value={p.id}>
              {p.label}
              {p.isActive ? ' (Aktif)' : ''}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>
      {pending && (
        <Loader2
          className="h-3.5 w-3.5 animate-spin text-muted-foreground"
          aria-hidden
        />
      )}
    </div>
  );
}
