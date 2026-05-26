'use client';

/**
 * @file admin/konfigurasi-fuzzy/_components/FuzzySimulator.tsx
 * @description Simulator perhitungan fuzzy: 3 slider X1/X2/X3 → tombol
 *              "Hitung Sekarang" → tampilkan breakdown 4 tahap (fuzzifikasi,
 *              rule aktif, agregasi, defuzzifikasi) + Z* + kategori.
 */

import { useState } from 'react';
import { Calculator, RotateCcw } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { CategoryBadge } from '@/components/shared/CategoryBadge';
import { calculateFuzzy } from '@/lib/fuzzy/engine';
import type {
  FuzzyCalculationDetail,
  FuzzyConfig,
  CategoryType,
} from '@/lib/fuzzy/types';
import { formatScore } from '@/lib/utils/format';

const INPUT_LABEL: Record<'low' | 'medium' | 'high', string> = {
  low: 'Rendah',
  medium: 'Sedang',
  high: 'Tinggi',
};

const OUTPUT_LABEL: Record<CategoryType, string> = {
  perlu_pembinaan: 'Perlu Pembinaan',
  cukup: 'Cukup',
  baik: 'Baik',
  sangat_baik: 'Sangat Baik',
};

export interface FuzzySimulatorProps {
  config: FuzzyConfig;
}

export function FuzzySimulator({ config }: FuzzySimulatorProps) {
  const [x1, setX1] = useState(82);
  const [x2, setX2] = useState(70);
  const [x3, setX3] = useState(85);
  const [result, setResult] = useState<FuzzyCalculationDetail | null>(null);

  function handleCompute() {
    const r = calculateFuzzy(x1, x2, x3, config);
    setResult(r);
  }

  function handleReset() {
    setX1(82);
    setX2(70);
    setX3(85);
    setResult(null);
  }

  return (
    <div className="space-y-3">
      {/* Input sliders */}
      <div className="rounded-md border border-sipandu-border bg-white p-3.5">
        <div className="mb-2.5 text-base font-bold text-foreground">
          Input Variabel
        </div>

        {[
          { label: 'X1 — Kehadiran (%)', value: x1, set: setX1 },
          { label: 'X2 — Poin Perilaku', value: x2, set: setX2 },
          { label: 'X3 — Nilai Teman', value: x3, set: setX3 },
        ].map((slider, i) => (
          <div key={i} className="mb-3">
            <div className="mb-1 flex items-center justify-between text-sm font-medium text-foreground">
              <span>{slider.label}</span>
              <span className="font-bold text-sipandu-blue">
                {slider.value}
              </span>
            </div>
            <input
              type="range"
              min={0}
              max={100}
              step={1}
              value={slider.value}
              onChange={(e) => slider.set(Number(e.target.value))}
              className="w-full accent-sipandu-blue"
              aria-label={slider.label}
            />
          </div>
        ))}

        <div className="mt-3 flex flex-wrap gap-2">
          <Button
            type="button"
            onClick={handleCompute}
            className="gap-1.5 bg-sipandu-blue text-white hover:bg-sipandu-blue/90"
          >
            <Calculator className="h-3.5 w-3.5" aria-hidden /> Hitung Sekarang
          </Button>
          <Button
            type="button"
            variant="outline"
            onClick={handleReset}
            className="gap-1.5"
          >
            <RotateCcw className="h-3.5 w-3.5" aria-hidden /> Reset
          </Button>
        </div>
      </div>

      {/* Hasil */}
      {result && (
        <div className="rounded-md border border-sipandu-border bg-white p-3.5">
          <div className="mb-3 text-base font-bold text-foreground">
            Detail perhitungan
          </div>

          <div className="grid grid-cols-1 gap-3 lg:grid-cols-3">
            {/* Tahap 1: Fuzzifikasi */}
            <div className="rounded-md border border-sipandu-border bg-gray-50 p-2.5">
              <h3 className="mb-1.5 border-b border-sipandu-border pb-1 text-xs font-bold text-foreground">
                1. Fuzzifikasi
              </h3>
              <div className="space-y-1 font-mono text-xs leading-relaxed">
                {(['x1', 'x2', 'x3'] as const).map((v) => {
                  const f = result.fuzzification[v];
                  return (
                    <div key={v}>
                      <strong>{v.toUpperCase()}</strong> = {result.inputs[v]}
                      <div className="ml-3 text-muted-foreground">
                        μ_rendah = {f.low.toFixed(2)} <br />
                        μ_sedang = {f.medium.toFixed(2)} <br />
                        μ_tinggi = {f.high.toFixed(2)}
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>

            {/* Tahap 2: Rule aktif */}
            <div className="rounded-md border border-sipandu-border bg-gray-50 p-2.5">
              <h3 className="mb-1.5 border-b border-sipandu-border pb-1 text-xs font-bold text-foreground">
                2. Rule Aktif (α &gt; 0)
              </h3>
              {result.activeRules.length === 0 ? (
                <p className="text-xs italic text-muted-foreground">
                  Tidak ada rule aktif.
                </p>
              ) : (
                <div className="space-y-1 font-mono text-xs leading-relaxed">
                  {result.activeRules.slice(0, 8).map((ar) => (
                    <div key={ar.rule.ruleNumber}>
                      <strong>R{ar.rule.ruleNumber}</strong>: α ={' '}
                      {ar.alpha.toFixed(2)}
                      <span className="text-muted-foreground">
                        {' '}
                        → {OUTPUT_LABEL[ar.rule.outputSet]}
                      </span>
                    </div>
                  ))}
                  {result.activeRules.length > 8 && (
                    <div className="text-muted-foreground">
                      ... +{result.activeRules.length - 8} rule lainnya
                    </div>
                  )}
                </div>
              )}
            </div>

            {/* Tahap 3 & 4: Agregasi + Defuzzifikasi */}
            <div className="rounded-md border border-sipandu-border bg-gray-50 p-2.5">
              <h3 className="mb-1.5 border-b border-sipandu-border pb-1 text-xs font-bold text-foreground">
                3. Agregasi (MAX)
              </h3>
              <div className="space-y-0.5 font-mono text-xs leading-relaxed">
                <div>
                  μ_PP = {result.aggregation.perlu_pembinaan.toFixed(2)}
                </div>
                <div>μ_C = {result.aggregation.cukup.toFixed(2)}</div>
                <div>μ_B = {result.aggregation.baik.toFixed(2)}</div>
                <div>μ_SB = {result.aggregation.sangat_baik.toFixed(2)}</div>
              </div>

              <h3 className="mb-1.5 mt-2.5 border-b border-sipandu-border pb-1 text-xs font-bold text-foreground">
                4. Defuzzifikasi (Centroid)
              </h3>
              <div className="font-mono text-xs">
                z* = {formatScore(result.zStar, 2)}
              </div>
            </div>
          </div>

          {/* Z* hasil akhir */}
          <div className="mt-4 flex flex-col items-center gap-2 rounded-md bg-blue-50 p-4">
            <div className="text-xs uppercase tracking-wide text-muted-foreground">
              Skor Akhir Z*
            </div>
            <div className="text-4xl font-bold text-sipandu-blue-deep">
              {formatScore(result.zStar, 2)}
            </div>
            <CategoryBadge category={result.category} size="lg" />
            <div className="mt-1 text-2xs text-muted-foreground">
              Threshold: PP &lt; 55 ≤ C &lt; 70 ≤ B &lt; 85 ≤ SB
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
