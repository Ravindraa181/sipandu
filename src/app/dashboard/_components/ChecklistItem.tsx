/**
 * @file dashboard/_components/ChecklistItem.tsx
 * @description Item checklist progres pengisian (1 baris dengan ikon
 *              berwarna + label + status text + optional CTA).
 */

import Link from 'next/link';
import {
  AlertCircle,
  Circle,
  CircleCheck,
  CircleX,
  type LucideIcon,
} from 'lucide-react';
import type { ChecklistStatus } from '@/types';
import { cn } from '@/lib/utils/cn';

const ICON_MAP: Record<
  ChecklistStatus['status'],
  { Icon: LucideIcon; color: string; bgColor: string }
> = {
  done: { Icon: CircleCheck, color: '#16A34A', bgColor: '#F0FDF4' },
  in_progress: { Icon: AlertCircle, color: '#D97706', bgColor: '#FFFBEB' },
  pending: { Icon: Circle, color: '#9CA3AF', bgColor: '#F9FAFB' },
  overdue: { Icon: CircleX, color: '#DC2626', bgColor: '#FEF2F2' },
};

export interface ChecklistItemProps {
  item: ChecklistStatus;
}

export function ChecklistItem({ item }: ChecklistItemProps) {
  const cfg = ICON_MAP[item.status];

  return (
    <div
      className={cn(
        'mb-1.5 flex items-center justify-between gap-2 rounded-md border-l-4 px-3 py-2',
      )}
      style={{ background: cfg.bgColor, borderLeftColor: cfg.color }}
    >
      <div className="flex flex-1 items-center gap-1.5">
        <cfg.Icon
          className="h-3.5 w-3.5 flex-shrink-0"
          style={{ color: cfg.color }}
          aria-hidden
        />
        <span className="text-sm text-foreground">{item.label}</span>
      </div>

      <div className="flex items-center gap-2">
        <span
          className="text-xs"
          style={{ color: cfg.color }}
        >
          {item.helperText}
        </span>
        {item.actionLabel && item.actionHref && (
          <Link
            href={item.actionHref}
            className="rounded-md bg-sipandu-blue px-2 py-1 text-xs font-medium text-white hover:opacity-85"
          >
            {item.actionLabel}
          </Link>
        )}
      </div>
    </div>
  );
}
