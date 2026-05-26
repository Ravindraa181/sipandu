/**
 * @file app/admin/dashboard/_components/NotificationList.tsx
 * @description List notifikasi sistem otomatis di dashboard admin A1.
 *
 *  Menampilkan ikon berwarna sesuai level + pesan + opsional link.
 *  Notifikasi dibangkitkan oleh server (page.tsx) berdasarkan kondisi
 *  global (kelas belum buka peer review, dst).
 */

import Link from 'next/link';
import {
  AlertCircle,
  CircleCheck,
  CircleX,
  Info,
  type LucideIcon,
} from 'lucide-react';
import type { SystemNotification } from '@/types';
import { cn } from '@/lib/utils/cn';

const ICON_MAP: Record<
  SystemNotification['level'],
  { Icon: LucideIcon; colorClass: string }
> = {
  error: { Icon: CircleX, colorClass: 'text-status-err' },
  warning: { Icon: AlertCircle, colorClass: 'text-status-warn' },
  info: { Icon: Info, colorClass: 'text-sipandu-blue' },
  success: { Icon: CircleCheck, colorClass: 'text-status-on' },
};

export interface NotificationListProps {
  notifications: SystemNotification[];
}

export function NotificationList({ notifications }: NotificationListProps) {
  if (notifications.length === 0) {
    return (
      <p className="py-3 text-center text-sm italic text-muted-foreground">
        Tidak ada notifikasi sistem.
      </p>
    );
  }

  return (
    <ul className="divide-y divide-gray-100">
      {notifications.map((n) => {
        const { Icon, colorClass } = ICON_MAP[n.level];
        const content = (
          <div className="flex items-start gap-2 py-2 text-sm leading-snug">
            <Icon className={cn('mt-0.5 h-3.5 w-3.5 flex-shrink-0', colorClass)} aria-hidden />
            <span className="text-foreground">{n.message}</span>
          </div>
        );

        return (
          <li key={n.id}>
            {n.href ? (
              <Link
                href={n.href}
                className="block transition-colors hover:bg-blue-50/40"
              >
                {content}
              </Link>
            ) : (
              content
            )}
          </li>
        );
      })}
    </ul>
  );
}
