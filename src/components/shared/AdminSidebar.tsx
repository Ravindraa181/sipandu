'use client';

/**
 * @file components/shared/AdminSidebar.tsx
 * @description Sidebar 220px untuk modul Admin (9 menu).
 *              Sesuai mockup `_context/sipandu_admin.html` — bg navy
 *              `#1E3A5F`, active state biru `#2D7DD2`.
 *
 *  Pakai di `app/admin/layout.tsx` sebagai komponen kiri.
 *  Memerlukan `'use client'` karena `usePathname()` dipakai untuk
 *  menentukan menu yang aktif.
 */

import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import {
  LayoutDashboard,
  Calendar,
  GraduationCap,
  Building2,
  Users,
  SlidersHorizontal,
  BarChart3,
  Tag,
  ClipboardList,
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

/** 9 menu admin. */
const NAV_ITEMS: readonly NavItem[] = [
  { label: 'Dashboard', href: ROUTES.adminHome, Icon: LayoutDashboard },
  { label: 'Manajemen Periode', href: ROUTES.adminPeriode, Icon: Calendar },
  { label: 'Manajemen Guru', href: ROUTES.adminGuru, Icon: GraduationCap },
  { label: 'Manajemen Kelas', href: ROUTES.adminKelas, Icon: Building2 },
  { label: 'Manajemen Siswa', href: ROUTES.adminSiswa, Icon: Users },
  { label: 'Konfigurasi Fuzzy', href: ROUTES.adminFuzzy, Icon: SlidersHorizontal },
  { label: 'Laporan Global', href: ROUTES.adminLaporan, Icon: BarChart3 },
  { label: 'Kategori Poin', href: ROUTES.adminKategori, Icon: Tag },
  { label: 'Aspek Peer Assessment', href: ROUTES.adminAspek, Icon: ClipboardList },
] as const;

export interface AdminSidebarProps {
  /** Nama lengkap admin yang sedang login. */
  userName?: string;
  /** Email admin. */
  userEmail?: string;
}

export function AdminSidebar({
  userName = 'Admin Sistem',
  userEmail = 'admin@sman13bdg.sch.id',
}: AdminSidebarProps) {
  const pathname = usePathname();
  const router = useRouter();

  async function handleLogout() {
    const supabase = createClient();
    await supabase.auth.signOut();
    router.push(ROUTES.adminLogin);
    router.refresh();
  }

  return (
    <aside
      className="flex h-full w-sidebar flex-shrink-0 flex-col overflow-y-auto bg-sipandu-navy"
      aria-label="Navigasi Admin"
    >
      {/* ── Brand ─────────────────────────────────────────────────── */}
      <div className="px-3.5 pb-2.5 pt-4">
        <div className="flex items-center gap-1.5 text-base font-bold text-white">
          <ChartArea className="h-3.5 w-3.5" aria-hidden />
          <span>{UI_STRINGS.appName}</span>
        </div>
        <div className="mt-0.5 text-2xs text-sipandu-blue-light">
          {UI_STRINGS.appTagline}
        </div>
        <div className="text-2xs text-sipandu-blue-light">
          {UI_STRINGS.schoolName}
        </div>
      </div>

      <hr className="mx-3.5 mb-1.5 border-white/15" />

      {/* ── Menu ──────────────────────────────────────────────────── */}
      <nav className="flex-1 px-2" aria-label="Menu Utama">
        {NAV_ITEMS.map((item) => {
          const isActive =
            pathname === item.href || pathname.startsWith(`${item.href}/`);
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
            <div className="truncate text-sm font-semibold text-white">
              {userName}
            </div>
            <div className="truncate text-2xs text-sipandu-blue-light">
              {userEmail}
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
