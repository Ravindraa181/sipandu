'use client';

/**
 * @file components/shared/TeacherSidebar.tsx
 * @description Sidebar 220px untuk modul Wali Kelas (5 menu).
 *              Sesuai mockup `_context/sipandu_walikelas.html`.
 *
 *  Memiliki "context card" di bagian atas yang menampilkan kelas yang
 *  diampu, periode aktif, dan jumlah siswa — sesuai mockup.
 */

import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import {
  LayoutDashboard,
  CalendarCheck,
  ClipboardList,
  UsersRound,
  BarChart3,
  LogOut,
  ChartArea,
} from 'lucide-react';

import { cn } from '@/lib/utils/cn';
import { ROUTES, UI_STRINGS } from '@/constants';
import { createClient } from '@/lib/supabase/client';
import { getInitials } from '@/lib/utils/format';

interface NavItem {
  label: string;
  href: string;
  Icon: typeof LayoutDashboard;
}

const NAV_ITEMS: readonly NavItem[] = [
  { label: 'Dashboard', href: ROUTES.teacherHome, Icon: LayoutDashboard },
  { label: 'Input Kehadiran', href: ROUTES.teacherKehadiran, Icon: CalendarCheck },
  { label: 'Input Poin Perilaku', href: ROUTES.teacherPoin, Icon: ClipboardList },
  { label: 'Kelola Peer Review', href: ROUTES.teacherPeerReview, Icon: UsersRound },
  { label: 'Hasil Penilaian', href: ROUTES.teacherHasil, Icon: BarChart3 },
] as const;

export interface TeacherSidebarProps {
  /** Nama wali kelas. */
  userName?: string;
  /** Nama kelas yang diampu, mis. "XI-A". */
  className?: string;
  /** Label periode aktif, mis. "Ganjil 2024/2025". */
  periodLabel?: string;
  /** Jumlah siswa di kelas. */
  studentCount?: number;
}

export function TeacherSidebar({
  userName = 'Wali Kelas',
  className: classNameProp,
  periodLabel,
  studentCount,
}: TeacherSidebarProps) {
  const pathname = usePathname();
  const router = useRouter();

  async function handleLogout() {
    const supabase = createClient();
    await supabase.auth.signOut();
    router.push(ROUTES.login);
    router.refresh();
  }

  return (
    <aside
      className="flex h-full w-sidebar flex-shrink-0 flex-col overflow-y-auto bg-sipandu-navy"
      aria-label="Navigasi Wali Kelas"
    >
      {/* ── Brand ─────────────────────────────────────────────────── */}
      <div className="px-3.5 pb-2.5 pt-4">
        <div className="flex items-center gap-1.5 text-base font-bold text-white">
          <ChartArea className="h-3.5 w-3.5" aria-hidden />
          <span>{UI_STRINGS.appName}</span>
        </div>
        <div className="mt-0.5 text-2xs text-sipandu-blue-light">
          {UI_STRINGS.schoolName}
        </div>
      </div>

      <hr className="mx-3.5 mb-2 border-white/15" />

      {/* ── Context card: kelas yang diampu ───────────────────────── */}
      {classNameProp && (
        <div className="mx-2.5 mb-2 rounded-md bg-sipandu-navy-dark px-3 py-2.5">
          <div className="text-2xs text-sipandu-blue-light">Kelas Anda:</div>
          <div className="text-sm font-bold text-white">
            {classNameProp}
            {periodLabel && (
              <>
                <span className="text-sipandu-blue-light"> · </span>
                {periodLabel}
              </>
            )}
          </div>
          {typeof studentCount === 'number' && (
            <div className="mt-0.5 text-2xs text-sipandu-blue-light">
              {studentCount} siswa
            </div>
          )}
        </div>
      )}

      <hr className="mx-3.5 mb-1.5 border-white/15" />

      {/* ── Menu ──────────────────────────────────────────────────── */}
      <nav className="flex-1 px-2" aria-label="Menu Utama">
        {NAV_ITEMS.map((item) => {
          const isActive =
            pathname === item.href ||
            (item.href !== ROUTES.teacherHome &&
              pathname.startsWith(`${item.href}/`));
          return (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                'mb-0.5 flex items-center gap-2.5 rounded-md px-2.5 py-2 text-sm transition-colors',
                isActive
                  ? 'bg-sipandu-blue font-semibold text-white'
                  : 'text-white/80 hover:bg-white/5',
              )}
              aria-current={isActive ? 'page' : undefined}
            >
              <item.Icon className="h-3.5 w-3.5 flex-shrink-0" aria-hidden />
              <span className="truncate">{item.label}</span>
            </Link>
          );
        })}
      </nav>

      {/* ── User & logout ─────────────────────────────────────────── */}
      <div className="border-t border-white/15 px-3.5 py-3">
        <div className="mb-2 flex items-center gap-2.5">
          <div
            className="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-full bg-sipandu-blue text-sm font-bold text-white"
            aria-hidden
          >
            {getInitials(userName)}
          </div>
          <div className="min-w-0 flex-1">
            <div className="truncate text-xs font-semibold text-white">
              {userName}
            </div>
            <div className="truncate text-2xs text-sipandu-blue-light">
              {classNameProp ? `Wali Kelas ${classNameProp}` : 'Wali Kelas'}
            </div>
          </div>
        </div>

        <button
          type="button"
          onClick={handleLogout}
          className="flex w-full items-center justify-center gap-1.5 rounded-md border border-white/20 bg-white/5 px-2 py-1.5 text-xs text-white/80 transition-colors hover:bg-white/10"
        >
          <LogOut className="h-3.5 w-3.5" aria-hidden />
          Keluar
        </button>
      </div>
    </aside>
  );
}
