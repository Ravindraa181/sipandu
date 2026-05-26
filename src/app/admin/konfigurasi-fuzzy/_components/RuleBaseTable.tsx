'use client';

/**
 * @file admin/konfigurasi-fuzzy/_components/RuleBaseTable.tsx
 * @description Tabel 27 rule editable. Setiap rule = IF X1 AND X2 AND X3
 * THEN Output. Hanya kolom Output yang editable (input set
 * di-lock karena 27 kombinasi unik).
 */

import { useState, useTransition } from 'react';
import { Loader2, RotateCcw } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { updateFuzzyRuleOutput } from '@/lib/actions/admin';
import { DEFAULT_RULES } from '@/lib/fuzzy/rules';
import type {
  CategoryType,
  FuzzyRule,
  InputSetName,
} from '@/lib/fuzzy/types';

export interface RuleBaseTableProps {
  initialRules: FuzzyRule[];
}

const INPUT_LABEL: Record<InputSetName, string> = {
  rendah: 'Rendah',
  sedang: 'Sedang',
  tinggi: 'Tinggi',
};

const OUTPUT_LABEL: Record<CategoryType, string> = {
  perlu_pembinaan: 'Perlu Pembinaan',
  cukup: 'Cukup',
  baik: 'Baik',
  sangat_baik: 'Sangat Baik',
};

const OUTPUT_OPTIONS: CategoryType[] = [
  'sangat_baik',
  'baik',
  'cukup',
  'perlu_pembinaan',
];

export function RuleBaseTable({ initialRules }: RuleBaseTableProps) {
  const [pending, startTransition] = useTransition();
  const [rules, setRules] = useState<FuzzyRule[]>(
    [...initialRules].sort((a, b) => a.ruleNumber - b.ruleNumber),
  );

  function updateRule(ruleNumber: number, output: CategoryType) {
    setRules((prev) =>
      prev.map((r) =>
        r.ruleNumber === ruleNumber ? { ...r, outputSet: output } : r,
      ),
    );
  }

  function handleSaveAll() {
    startTransition(async () => {
      let allOk = true;
      for (const r of rules) {
        const result = await updateFuzzyRuleOutput({
          ruleNumber: r.ruleNumber,
          outputSet: r.outputSet,
        });
        if (!result.ok) {
          allOk = false;
          toast.error(`Gagal menyimpan rule ${r.ruleNumber}`, {
            description: result.error,
          });
          break;
        }
      }
      if (allOk) toast.success('Semua rule berhasil disimpan');
    });
  }

  function handleResetDefault() {
    setRules([...DEFAULT_RULES] as FuzzyRule[]);
    toast.success('Rule direset ke default (belum disimpan)');
  }

  return (
    <div className="rounded-md border border-sipandu-border bg-white p-3.5">
      <div className="mb-2.5 flex flex-wrap items-start justify-between gap-2">
        <div>
          <div className="text-base font-bold text-foreground">
            27 aturan IF-THEN (3 input × 3 himpunan)
          </div>
          <p className="mt-0.5 text-xs text-muted-foreground">
            Perubahan rule akan memengaruhi semua perhitungan Z* berikutnya.
          </p>
        </div>
        <div className="flex flex-wrap gap-2">
          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={handleResetDefault}
            disabled={pending}
            className="gap-1.5"
          >
            <RotateCcw className="h-3 w-3" aria-hidden /> Reset Default
          </Button>
          <Button
            type="button"
            size="sm"
            onClick={handleSaveAll}
            disabled={pending}
            className="bg-sipandu-blue text-white hover:bg-sipandu-blue/90"
          >
            {pending && (
              <Loader2 className="mr-1.5 h-3 w-3 animate-spin" aria-hidden />
            )}
            Simpan Semua Rule
          </Button>
        </div>
      </div>

      <div className="max-h-[420px] overflow-y-auto">
        <table className="w-full border-collapse text-sm">
          <thead className="sticky top-0 z-10">
            <tr className="border-b border-sipandu-border bg-gray-100 text-left">
              <th className="w-9 px-3 py-2 text-xs font-semibold">No</th>
              <th className="px-3 py-2 text-xs font-semibold">
                IF Absensi (X₁)
              </th>
              <th className="px-3 py-2 text-xs font-semibold">
                AND Poin Perilaku (X₂)
              </th>
              <th className="px-3 py-2 text-xs font-semibold">
                AND Nilai Sejawat (X₃)
              </th>
              <th className="px-3 py-2 text-xs font-semibold">THEN Output</th>
            </tr>
          </thead>
          <tbody>
            {rules.map((r) => (
              <tr
                key={r.ruleNumber}
                className="border-b border-gray-100 last:border-b-0"
              >
                <td className="px-3 py-1.5 text-center font-semibold text-muted-foreground">
                  {r.ruleNumber}
                </td>
                <td className="px-3 py-1.5">
                  <span className="inline-block rounded bg-gray-50 px-2 py-0.5 text-xs">
                    {INPUT_LABEL[r.x1Set]}
                  </span>
                </td>
                <td className="px-3 py-1.5">
                  <span className="inline-block rounded bg-gray-50 px-2 py-0.5 text-xs">
                    {INPUT_LABEL[r.x2Set]}
                  </span>
                </td>
                <td className="px-3 py-1.5">
                  <span className="inline-block rounded bg-gray-50 px-2 py-0.5 text-xs">
                    {INPUT_LABEL[r.x3Set]}
                  </span>
                </td>
                <td className="px-3 py-1.5">
                  <Select
                    value={r.outputSet}
                    onValueChange={(v) =>
                      updateRule(r.ruleNumber, v as CategoryType)
                    }
                  >
                    <SelectTrigger className="h-7 w-[150px] text-xs">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      {OUTPUT_OPTIONS.map((o) => (
                        <SelectItem key={o} value={o}>
                          {OUTPUT_LABEL[o]}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}