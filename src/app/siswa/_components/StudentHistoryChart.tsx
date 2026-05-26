/**
 * @file siswa/_components/StudentHistoryChart.tsx
 * @description SVG bar chart histori Z* per semester untuk siswa.
 *              Maksimal 6 semester. Lebih pekat = lebih baru.
 *
 *  Server Component murni.
 */

import type { CategoryType } from '@/types';
import { CATEGORY_CONFIG } from '@/constants';
import { TrendingDown, TrendingUp } from 'lucide-react';

const BAR_COLORS = [
  '#BFDBFE',
  '#93C5FD',
  '#60A5FA',
  '#3B82F6',
  '#2D7DD2',
  '#1D4ED8',
];

export interface HistoryItem {
  label: string;
  zScore: number | null;
  category: CategoryType | null;
}

export interface StudentHistoryChartProps {
  bars: HistoryItem[];
  maxBars?: number;
}

export function StudentHistoryChart({
  bars,
  maxBars = 6,
}: StudentHistoryChartProps) {
  // Ambil maksimal 6 semester paling baru
  const items = bars.slice(-maxBars);
  const validValues = items
    .map((b) => b.zScore)
    .filter((z): z is number => typeof z === 'number');

  // Indikator tren: bandingkan 2 semester terakhir
  let trend: 'up' | 'down' | null = null;
  if (validValues.length >= 2) {
    const last = validValues[validValues.length - 1]!;
    const prev = validValues[validValues.length - 2]!;
    if (last > prev) trend = 'up';
    else if (last < prev) trend = 'down';
  }

  if (items.length === 0) {
    return (
      <div className="rounded-md border border-sipandu-border bg-white p-3.5">
        <h2 className="mb-2.5 text-base font-bold text-foreground">
          Histori Skor Z*
        </h2>
        <p className="rounded-md bg-gray-50 py-6 text-center text-sm italic text-muted-foreground">
          Belum ada riwayat skor di semester sebelumnya.
        </p>
      </div>
    );
  }

  // SVG layout
  const W = 320;
  const H = 180;
  const padX = 28;
  const padY = 24;
  const innerW = W - padX * 2;
  const innerH = H - padY * 2 - 28;
  const barWidth = Math.min(48, (innerW / items.length) * 0.65);
  const slot = innerW / items.length;

  return (
    <div className="rounded-md border border-sipandu-border bg-white p-3.5">
      <h2 className="mb-2.5 text-base font-bold text-foreground">
        Histori Skor Z*
      </h2>

      <svg
        viewBox={`0 0 ${W} ${H}`}
        width="100%"
        height={H}
        xmlns="http://www.w3.org/2000/svg"
        role="img"
        aria-label="Histori skor Z* per semester"
      >
        {/* Grid + sumbu Y */}
        {[0, 50, 100].map((tick) => {
          const yy = padY + (1 - tick / 100) * innerH;
          return (
            <g key={tick}>
              <line
                x1={padX}
                y1={yy}
                x2={padX + innerW}
                y2={yy}
                stroke="#F3F4F6"
                strokeWidth={0.5}
              />
              <text
                x={padX - 3}
                y={yy + 3}
                textAnchor="end"
                fontSize={9}
                fill="#9CA3AF"
              >
                {tick}
              </text>
            </g>
          );
        })}
        <line
          x1={padX}
          y1={padY + innerH}
          x2={padX + innerW}
          y2={padY + innerH}
          stroke="#E5E7EB"
          strokeWidth={1}
        />

        {/* Bars */}
        {items.map((b, i) => {
          const z = b.zScore ?? 0;
          const heightFrac = Math.max(0, Math.min(1, z / 100));
          const barHeight = heightFrac * innerH;
          const cx = padX + i * slot + slot / 2;
          const barX = cx - barWidth / 2;
          const barY = padY + innerH - barHeight;
          const colorIdx = Math.min(
            BAR_COLORS.length - 1,
            BAR_COLORS.length - items.length + i,
          );
          const color = BAR_COLORS[Math.max(0, colorIdx)] ?? '#2D7DD2';
          const labelColor = b.category
            ? CATEGORY_CONFIG[b.category].textColor
            : '#6B7280';
          return (
            <g key={`${b.label}-${i}`}>
              {b.zScore !== null && (
                <rect
                  x={barX}
                  y={barY}
                  width={barWidth}
                  height={barHeight}
                  fill={color}
                  rx={2}
                />
              )}
              {b.zScore !== null && (
                <text
                  x={cx}
                  y={barY - 4}
                  textAnchor="middle"
                  fontSize={11}
                  fontWeight={700}
                  fill="#111827"
                >
                  {b.zScore.toFixed(1)}
                </text>
              )}
              <text
                x={cx}
                y={padY + innerH + 14}
                textAnchor="middle"
                fontSize={9}
                fill="#6B7280"
              >
                {b.label}
              </text>
              {b.category && (
                <text
                  x={cx}
                  y={padY + innerH + 25}
                  textAnchor="middle"
                  fontSize={9}
                  fill={labelColor}
                >
                  {CATEGORY_CONFIG[b.category].label}
                </text>
              )}
            </g>
          );
        })}
      </svg>

      {trend !== null && (
        <div
          className={
            trend === 'up'
              ? 'mt-1 flex items-center justify-center gap-1.5 text-xs font-medium text-status-on-text'
              : 'mt-1 flex items-center justify-center gap-1.5 text-xs font-medium text-status-err-text'
          }
        >
          {trend === 'up' ? (
            <>
              <TrendingUp className="h-3.5 w-3.5" aria-hidden />
              Skor Anda meningkat dari semester sebelumnya!
            </>
          ) : (
            <>
              <TrendingDown className="h-3.5 w-3.5" aria-hidden />
              Skor Anda turun dari semester sebelumnya. Tetap semangat!
            </>
          )}
        </div>
      )}
    </div>
  );
}
