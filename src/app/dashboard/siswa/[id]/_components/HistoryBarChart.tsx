/**
 * @file dashboard/siswa/[id]/_components/HistoryBarChart.tsx
 * @description SVG bar chart Z* per semester (lintas periode).
 *              Server component — pure presentational.
 *
 *  Layout: bar berwarna gradient (lebih pekat = lebih baru).
 *  Setiap bar punya label kategori di bawah dan angka di atas.
 */

import type { CategoryType } from '@/types';

export interface HistoryBar {
  label: string; // mis. "Ganjil 24/25"
  zScore: number | null;
  category: CategoryType | null;
}

const BAR_COLORS = ['#93C5FD', '#60A5FA', '#2D7DD2', '#1D4ED8'];

export interface HistoryBarChartProps {
  bars: HistoryBar[];
}

export function HistoryBarChart({ bars }: HistoryBarChartProps) {
  if (bars.length === 0) {
    return (
      <p className="rounded-md border border-sipandu-border bg-white py-6 text-center text-sm italic text-muted-foreground">
        Belum ada riwayat skor lintas semester.
      </p>
    );
  }

  const W = 360;
  const H = 200;
  const padX = 40;
  const padY = 30;
  const innerW = W - padX * 2;
  const innerH = H - padY * 2;

  const barWidth = Math.max(20, (innerW / bars.length) * 0.7);
  const gap = (innerW - barWidth * bars.length) / Math.max(1, bars.length - 1);

  // Domain Y: 0–100
  const yMax = 100;

  return (
    <svg
      viewBox={`0 0 ${W} ${H}`}
      width="100%"
      height={H}
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="Histori Z* per semester"
    >
      {/* Grid lines */}
      {[0, 25, 50, 75, 100].map((tick) => {
        const y = padY + (1 - tick / yMax) * innerH;
        return (
          <g key={tick}>
            <line
              x1={padX}
              y1={y}
              x2={padX + innerW}
              y2={y}
              stroke="#F3F4F6"
              strokeWidth={0.5}
            />
            <text
              x={padX - 6}
              y={y + 3}
              textAnchor="end"
              fontSize={9}
              fill="#9CA3AF"
            >
              {tick}
            </text>
          </g>
        );
      })}

      {/* Sumbu X */}
      <line
        x1={padX}
        y1={padY + innerH}
        x2={padX + innerW}
        y2={padY + innerH}
        stroke="#E5E7EB"
        strokeWidth={1}
      />

      {/* Bars */}
      {bars.map((b, i) => {
        const z = b.zScore ?? 0;
        const heightFrac = Math.max(0, Math.min(1, z / yMax));
        const barHeight = heightFrac * innerH;
        const barX =
          padX + i * (barWidth + (gap > 0 ? gap : 0));
        const barY = padY + innerH - barHeight;
        const color =
          BAR_COLORS[
            Math.min(BAR_COLORS.length - 1, BAR_COLORS.length - 1 - (bars.length - 1 - i))
          ] ?? '#2D7DD2';

        return (
          <g key={`${b.label}-${i}`}>
            <rect
              x={barX}
              y={barY}
              width={barWidth}
              height={barHeight}
              fill={color}
              rx={2}
            />
            {b.zScore !== null && (
              <text
                x={barX + barWidth / 2}
                y={barY - 4}
                textAnchor="middle"
                fontSize={10}
                fontWeight={700}
                fill="#111827"
              >
                {b.zScore.toFixed(1)}
              </text>
            )}
            <text
              x={barX + barWidth / 2}
              y={padY + innerH + 14}
              textAnchor="middle"
              fontSize={9}
              fill="#6B7280"
            >
              {b.label}
            </text>
          </g>
        );
      })}
    </svg>
  );
}
