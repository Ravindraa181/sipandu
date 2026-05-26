'use client';

/**
 * @file components/shared/StudentSidebar.tsx
 * @description Sidebar 220px untuk modul Siswa (3 menu).
 *              Sesuai mockup `_context/sipandu_siswa.html`.
 *
 *  Menu Peer Review menampilkan badge "AKTIF" merah saat sesi peer
 *  review sedang berlangsung dan siswa belum menyelesaikan semua.
 */

import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import {
  LayoutDashboard,
  UsersRound,
  History,
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
  /** ID untuk mencocokkan badge tertentu. */
  id: 'dashboard' | 'peer' | 'riwayat';
}

const NAV_ITEMS: readonly NavItem[] = [
  { id: 'dashboard', label: 'Dashboard Saya', href: ROUTES.studentHome, Icon: LayoutDashboard },
  { id: 'peer', label: 'Peer Review', href: ROUTES.studentPeerReview, Icon: UsersRound },
  { id: 'riwayat', label: 'Riwayat Saya', href: ROUTES.studentRiwayat, Icon: History },
] as const;

export interface StudentSidebarProps {
  /** Nama lengkap siswa. */
  userName?: string;
  /** NIS siswa. */
  nis?: string;
  /** Nama kelas, mis. "XI-A". */
  className?: string;
  /** Label periode aktif. */
  periodLabel?: string;
  /** True bila ada sesi peer review aktif & siswa belum selesai. */
  hasPeerReviewActive: boolean;
}

export function StudentSidebar({
  userName = 'Siswa',
  nis,
  className: classNameProp,
  periodLabel,
  hasPeerReviewActive,
}: StudentSidebarProps) {
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
      aria-label="Navigasi Siswa"
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

      {/* ── Context card: kelas siswa ─────────────────────────────── */}
      {classNameProp && (
        <div className="mx-2.5 mb-2 rounded-md bg-sipandu-navy-dark px-3 py-2.5">
          <div className="text-sm font-bold text-white">
            Kelas {classNameProp}
          </div>
          {periodLabel && (
            <div className="mt-1 text-2xs text-sipandu-blue-light">
              Semester {periodLabel}
            </div>
          )}
        </div>
      )}

      <hr className="mx-3.5 mb-1.5 border-white/15" />

      {/* ── Menu ──────────────────────────────────────────────────── */}
      <nav className="flex-1 px-2" aria-label="Menu Utama">
        {NAV_ITEMS.map((item) => {
          // ALASAN: '/siswa' (root dashboard) harus exact match saja.
          // Jika pakai startsWith('/siswa/'), halaman peer-review dan riwayat
          // juga akan men-trigger active state untuk item Dashboard Saya.
          const isActive =
            item.href === ROUTES.studentHome
              ? pathname === item.href
              : pathname === item.href || pathname.startsWith(`${item.href}/`);
          const showActiveBadge = item.id === 'peer' && hasPeerReviewActive;

          return (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                'mb-0.5 flex items-center gap-2.5 rounded-md px-2.5 py-2.5 text-sm transition-colors',
                isActive
                  ? 'bg-sipandu-blue font-semibold text-white'
                  : 'text-white/80 hover:bg-white/5',
              )}
              aria-current={isActive ? 'page' : undefined}
            >
              <item.Icon className="h-3.5 w-3.5 flex-shrink-0" aria-hidden />
              <span className="flex-1 truncate">{item.label}</span>

              {showActiveBadge && (
                <span
                  className="rounded-full bg-status-err px-1.5 py-0.5 text-[9px] font-bold leading-tight text-white"
                  aria-label="Sesi peer review aktif"
                >
                  AKTIF
                </span>
              )}
            </Link>
          );
        })}
      </nav>

      {/* ── User & logout ─────────────────────────────────────────── */}
      <div className="border-t border-white/15 px-3.5 py-3">
        <div className="mb-2 flex items-center gap-2.5">
          <div
            className="flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-full bg-sipandu-blue text-sm font-bold text-white"
            aria-hidden
          >
            {getInitials(userName)}
          </div>
          <div className="min-w-0 flex-1">
            <div className="truncate text-xs font-semibold text-white">
              {userName}
            </div>
            {nis && (
              <div className="truncate text-2xs text-sipandu-blue-light">
                NIS: {nis}
              </div>
            )}
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
