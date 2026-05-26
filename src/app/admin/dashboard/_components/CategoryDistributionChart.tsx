/**
 * @file app/admin/dashboard/_components/CategoryDistributionChart.tsx
 * @description Bar chart horizontal sederhana untuk distribusi kategori Z*
 *              global (Sangat Baik / Baik / Cukup / Perlu Pembinaan).
 *
 *  Pure SVG-free implementation — pakai div dengan width % agar ringan.
 *  Server component.
 */

import { CATEGORY_CONFIG, CATEGORY_ORDER } from '@/constants';
import type { CategoryType } from '@/types';

export interface CategoryDistributionChartProps {
  /** Jumlah siswa per kategori. */
  counts: Record<CategoryType, number>;
  /** Total siswa pada periode aktif. Digunakan untuk hitung %. */
  totalStudents: number;
  /** Bila true, sertakan kategori "Belum Dinilai" sebagai abu di bawah. */
  notScoredCount?: number;
}

export function CategoryDistributionChart({
  counts,
  totalStudents,
  notScoredCount = 0,
}: CategoryDistributionChartProps) {
  const total = totalStudents || 1; // hindari division by zero

  return (
    <div className="space-y-2">
      {CATEGORY_ORDER.slice()
        .reverse()
        .map((cat) => {
          const cfg = CATEGORY_CONFIG[cat];
          const count = counts[cat] ?? 0;
          const percent = (count / total) * 100;
          return (
            <div key={cat} className="flex items-center gap-2">
              <div className="w-32 text-right text-xs text-foreground">
                {cfg.label}
              </div>
              <div className="h-3 flex-1 overflow-hidden rounded-sm bg-gray-200">
                <div
                  className="h-full rounded-sm transition-[width]"
                  style={{
                    width: `${Math.min(percent, 100)}%`,
                    backgroundColor: cfg.color,
                  }}
                />
              </div>
              <div className="w-20 text-xs text-muted-foreground">
                {count} ({percent.toFixed(0)}%)
              </div>
            </div>
          );
        })}

      {notScoredCount > 0 && (
        <div className="flex items-center gap-2">
          <div className="w-32 text-right text-xs text-muted-foreground">
            Belum Dinilai
          </div>
          <div className="h-3 flex-1 overflow-hidden rounded-sm bg-gray-200">
            <div
              className="h-full rounded-sm bg-gray-400"
              style={{
                width: `${Math.min((notScoredCount / total) * 100, 100)}%`,
              }}
            />
          </div>
          <div className="w-20 text-xs text-muted-foreground">
            {notScoredCount} ({((notScoredCount / total) * 100).toFixed(0)}%)
          </div>
        </div>
      )}

      <div className="pt-2 text-right text-2xs text-muted-foreground">
        {totalStudents - notScoredCount} dari {totalStudents} siswa terhitung
      </div>
    </div>
  );
}
