'use client';

/**
 * @file dashboard/siswa/[id]/_components/FuzzyDetailAccordion.tsx
 * @description Accordion yang menampilkan detail perhitungan fuzzy untuk
 *              siswa: fuzzifikasi 3 input + rule aktif + agregasi + z*.
 *
 *  Data berasal dari kolom `active_rules` JSONB di behavior_final_scores.
 */

import { useState } from 'react';
import { Calculator, ChevronUp } from 'lucide-react';
import { cn } from '@/lib/utils/cn';
import { formatScore } from '@/lib/utils/format';
import type { CategoryType } from '@/types';

const OUTPUT_LABEL: Record<CategoryType, string> = {
  perlu_pembinaan: 'Perlu Pembinaan',
  cukup: 'Cukup',
  baik: 'Baik',
  sangat_baik: 'Sangat Baik',
};

export interface FuzzyDetailAccordionProps {
  /** Skor X1, X2, X3, Z*. */
  inputs: { x1: number | null; x2: number | null; x3: number | null };
  zScore: number | null;
  /** Hasil fuzzifikasi yang di-cache. */
  fuzzification: {
    x1: { low: number; medium: number; high: number };
    x2: { low: number; medium: number; high: number };
    x3: { low: number; medium: number; high: number };
  } | null;
  /** Rule yang aktif (alpha > 0). */
  activeRules: Array<{
    ruleNumber: number;
    alpha: number;
    output: CategoryType;
  }>;
  /** Agregasi MAX per kategori. */
  aggregation: {
    perlu_pembinaan: number;
    cukup: number;
    baik: number;
    sangat_baik: number;
  } | null;
}

export function FuzzyDetailAccordion({
  inputs,
  zScore,
  fuzzification,
  activeRules,
  aggregation,
}: FuzzyDetailAccordionProps) {
  const [open, setOpen] = useState(false);

  const hasData = fuzzification !== null && aggregation !== null;

  return (
    <div className="overflow-hidden rounded-md border border-sipandu-border bg-white">
      <button
        type="button"
        onClick={() => setOpen((v) => !v)}
        className="flex w-full items-center justify-between px-3.5 py-3 text-left transition-colors hover:bg-gray-50"
      >
        <span className="flex items-center gap-1.5 text-sm font-semibold text-foreground">
          <Calculator className="h-3.5 w-3.5" aria-hidden />
          Lihat detail perhitungan Fuzzy
        </span>
        <ChevronUp
          className={cn(
            'h-3.5 w-3.5 transition-transform',
            !open && 'rotate-180',
          )}
          aria-hidden
        />
      </button>

      {open && (
        <div className="border-t border-sipandu-border p-3.5 font-mono text-xs leading-relaxed">
          {!hasData ? (
            <p className="italic text-muted-foreground">
              Detail perhitungan belum tersedia. Z* belum dihitung untuk siswa
              ini.
            </p>
          ) : (
            <div className="space-y-3">
              {/* Tahap 1: Fuzzifikasi */}
              <div className="rounded-md border border-sipandu-border bg-gray-50 p-2.5">
                <h3 className="mb-1.5 border-b border-sipandu-border pb-1 font-bold text-foreground">
                  1. Fuzzifikasi
                </h3>
                {(['x1', 'x2', 'x3'] as const).map((v) => {
                  const f = fuzzification![v];
                  const inp = inputs[v];
                  const varLabel: Record<string, string> = {
                    x1: 'Absensi (X1)',
                    x2: 'Poin Perilaku (X2)',
                    x3: 'Nilai Sejawat (X3)',
                  };
                  return (
                    <div key={v} className="mb-1.5 last:mb-0">
                      <strong>{varLabel[v]}</strong> ={' '}
                      {inp !== null ? formatScore(inp, 1) : '—'}
                      <div className="ml-3 text-muted-foreground">
                        μ_rendah = {f.low.toFixed(2)} <br />
                        μ_sedang = {f.medium.toFixed(2)} <br />
                        μ_tinggi = {f.high.toFixed(2)}
                      </div>
                    </div>
                  );
                })}
              </div>

              {/* Tahap 2: Rule aktif */}
              <div className="rounded-md border border-sipandu-border bg-gray-50 p-2.5">
                <h3 className="mb-1.5 border-b border-sipandu-border pb-1 font-bold text-foreground">
                  2. Rule Aktif (α &gt; 0)
                </h3>
                {activeRules.length === 0 ? (
                  <p className="italic text-muted-foreground">
                    Tidak ada rule aktif.
                  </p>
                ) : (
                  <ul className="space-y-0.5">
                    {activeRules.map((ar) => (
                      <li key={ar.ruleNumber}>
                        <strong>R{ar.ruleNumber}</strong>: α ={' '}
                        {ar.alpha.toFixed(2)}
                        <span className="text-muted-foreground">
                          {' '}
                          → {OUTPUT_LABEL[ar.output]}
                        </span>
                      </li>
                    ))}
                  </ul>
                )}
              </div>

              {/* Tahap 3 & 4: Agregasi + Defuzz */}
              <div className="rounded-md border border-sipandu-border bg-gray-50 p-2.5">
                <h3 className="mb-1.5 border-b border-sipandu-border pb-1 font-bold text-foreground">
                  3. Agregasi (MAX)
                </h3>
                <div className="space-y-0.5">
                  <div>
                    μ_PP = {aggregation!.perlu_pembinaan.toFixed(2)}
                  </div>
                  <div>μ_C = {aggregation!.cukup.toFixed(2)}</div>
                  <div>μ_B = {aggregation!.baik.toFixed(2)}</div>
                  <div>μ_SB = {aggregation!.sangat_baik.toFixed(2)}</div>
                </div>

                <h3 className="mb-1.5 mt-2.5 border-b border-sipandu-border pb-1 font-bold text-foreground">
                  4. Defuzzifikasi (Centroid)
                </h3>
                <div>Nilai Akhir (Z) = {formatScore(zScore, 2)}</div>
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
}
