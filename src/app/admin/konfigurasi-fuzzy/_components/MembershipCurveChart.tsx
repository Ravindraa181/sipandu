/**
 * @file admin/konfigurasi-fuzzy/_components/MembershipCurveChart.tsx
 * @description SVG kurva fungsi keanggotaan untuk variabel fuzzy.
 *              Render sumbu X (0–100) + sumbu Y (μ 0–1) + N polyline
 *              berwarna untuk setiap himpunan.
 *
 *  Pure presentational. Bisa server-rendered.
 */

import type { MembershipFunction } from '@/lib/fuzzy/types';
import { calculateMembership } from '@/lib/fuzzy/membership';

export interface MembershipCurveSet {
  /** Label tampil (Rendah / Sedang / Tinggi / PP / C / B / SB). */
  label: string;
  /** Warna garis polyline. */
  color: string;
  /** Definisi fungsi keanggotaan. */
  fn: MembershipFunction;
}

export interface MembershipCurveChartProps {
  sets: MembershipCurveSet[];
  /** Lebar SVG. Default 270. */
  width?: number;
  /** Tinggi SVG. Default 145. */
  height?: number;
  /** Domain X. Default [0, 100]. */
  domain?: [number, number];
}

export function MembershipCurveChart({
  sets,
  width = 270,
  height = 145,
  domain = [0, 100],
}: MembershipCurveChartProps) {
  const padX = 28;
  const padY = 18;
  const innerW = width - padX * 2;
  const innerH = height - padY * 2;

  const sx = (v: number): number =>
    padX + ((v - domain[0]) / (domain[1] - domain[0])) * innerW;
  const sy = (v: number): number => padY + (1 - Math.max(0, Math.min(1, v))) * innerH;

  // Sample 101 titik di domain agar kurva mulus
  const sampleCount = 101;
  const step = (domain[1] - domain[0]) / (sampleCount - 1);

  // Tick X
  const xTicks = [0, 20, 40, 60, 80, 100].filter(
    (v) => v >= domain[0] && v <= domain[1],
  );
  // Tick Y
  const yTicks: Array<[string, number]> = [
    ['1.0', 1],
    ['0.5', 0.5],
    ['0.0', 0],
  ];

  return (
    <svg
      viewBox={`0 0 ${width} ${height}`}
      width="100%"
      height={height}
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="Kurva fungsi keanggotaan"
    >
      {/* Sumbu */}
      <line
        x1={padX}
        y1={padY + innerH}
        x2={padX + innerW}
        y2={padY + innerH}
        stroke="#E5E7EB"
        strokeWidth={1}
      />
      <line
        x1={padX}
        y1={padY}
        x2={padX}
        y2={padY + innerH}
        stroke="#E5E7EB"
        strokeWidth={1}
      />

      {/* Tick X */}
      {xTicks.map((v) => (
        <text
          key={`xt-${v}`}
          x={sx(v)}
          y={padY + innerH + 11}
          textAnchor="middle"
          fontSize={9}
          fill="#9CA3AF"
        >
          {v}
        </text>
      ))}

      {/* Tick Y + grid */}
      {yTicks.map(([lb, val]) => {
        const yy = sy(val);
        return (
          <g key={`yt-${lb}`}>
            <text
              x={padX - 3}
              y={yy + 3}
              textAnchor="end"
              fontSize={9}
              fill="#9CA3AF"
            >
              {lb}
            </text>
            <line
              x1={padX}
              y1={yy}
              x2={padX + innerW}
              y2={yy}
              stroke="#F3F4F6"
              strokeWidth={0.5}
            />
          </g>
        );
      })}

      {/* Polyline tiap set */}
      {sets.map((s) => {
        const points: string[] = [];
        for (let i = 0; i < sampleCount; i++) {
          const x = domain[0] + i * step;
          const mu = calculateMembership(x, s.fn);
          points.push(`${sx(x)},${sy(mu)}`);
        }
        return (
          <polyline
            key={s.label}
            points={points.join(' ')}
            fill="none"
            stroke={s.color}
            strokeWidth={1.5}
          />
        );
      })}

      {/* Legend */}
      {sets.map((s, i) => (
        <g key={`lg-${s.label}`}>
          <rect
            x={padX + i * 65}
            y={padY + 2}
            width={8}
            height={2}
            fill={s.color}
          />
          <text
            x={padX + i * 65 + 10}
            y={padY + 7}
            fontSize={9}
            fill="#374151"
          >
            {s.label}
          </text>
        </g>
      ))}
    </svg>
  );
}
