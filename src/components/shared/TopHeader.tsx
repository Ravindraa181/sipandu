'use client';

/**
 * @file components/shared/TopHeader.tsx
 * @description Header 60px di atas konten utama: breadcrumb di kiri,
 *              tanggal hari ini + bell + nama user di kanan.
 *
 *  Memerlukan `'use client'` karena tanggal di-render dari client agar
 *  konsisten dengan timezone pengguna (locale `id-ID`).
 *
 *  PATCH: bell notification sekarang punya dropdown — klik bell saat ada
 *  notif menampilkan pesan + link ke halaman terkait (peer review siswa).
 */

import { useEffect, useRef, useState } from 'react';
import Link from 'next/link';
import { Bell, Menu, X, ClipboardList } from 'lucide-react';

import { useMobileSidebar } from './MobileSidebarContext';

import { cn } from '@/lib/utils/cn';
import { formatDateWithDay } from '@/lib/utils/format';
import type { UserRole } from '@/types';

export interface BreadcrumbItem {
  label: string;
  href?: string;
}

export interface TopHeaderProps {
  /**
   * Breadcrumb path. Item terakhir biasanya halaman saat ini (tanpa href).
   * Contoh: [{ label: 'Wali Kelas' }, { label: 'Detail Siswa' }]
   */
  breadcrumb: BreadcrumbItem[];
  /** Nama user yang ditampilkan di kanan. */
  userName: string;
  /** Peran user. Dipakai untuk warna prefix breadcrumb. */
  role: UserRole;
  /** Jumlah notifikasi belum dibaca (badge merah di bell). */
  notifCount?: number;
  /**
   * URL tujuan saat notifikasi diklik.
   * Jika tidak diisi, dropdown hanya menampilkan pesan tanpa link.
   */
  notifHref?: string;
  /** Tambahan class. */
  className?: string;
}

const ROLE_LABEL: Record<UserRole, string> = {
  admin: 'Admin',
  teacher: 'Wali Kelas',
  student: 'Siswa',
};

export function TopHeader({
  breadcrumb,
  userName,
  role,
  notifCount = 0,
  notifHref,
  className,
}: TopHeaderProps) {
  const [today, setToday] = useState<string>('');
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  // Akses context mobile sidebar — no-op bila di luar MobileLayoutShell
  const { open: openSidebar } = useMobileSidebar();

  useEffect(() => {
    setToday(formatDateWithDay(new Date()));
  }, []);

  // Tutup dropdown saat klik di luar
  useEffect(() => {
    function handleClickOutside(e: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(e.target as Node)) {
        setDropdownOpen(false);
      }
    }
    if (dropdownOpen) {
      document.addEventListener('mousedown', handleClickOutside);
    }
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, [dropdownOpen]);

  return (
    <header
      className={cn(
        'flex h-header flex-shrink-0 items-center justify-between',
        'border-b border-sipandu-border bg-white px-5',
        className,
      )}
    >
      {/* ── Tombol hamburger — hanya tampil di mobile ────────────── */}
      <button
        type="button"
        aria-label="Buka menu navigasi"
        onClick={openSidebar}
        className="mr-2 rounded-md p-1.5 text-foreground transition-colors hover:bg-muted md:hidden"
      >
        <Menu className="h-4 w-4" aria-hidden />
      </button>

      {/* ── Breadcrumb ────────────────────────────────────────────── */}
      <nav aria-label="Breadcrumb" className="flex min-w-0 flex-1 items-center text-sm">
        <span className="text-muted-foreground">{ROLE_LABEL[role]}</span>
        {breadcrumb.map((item, idx) => (
          <span key={`${item.label}-${idx}`} className="flex items-center">
            <span className="mx-2 text-muted-foreground" aria-hidden>
              ›
            </span>
            <span
              className={cn(
                idx === breadcrumb.length - 1
                  ? 'font-semibold text-sipandu-navy'
                  : 'text-muted-foreground',
              )}
            >
              {item.label}
            </span>
          </span>
        ))}
      </nav>

      {/* ── Kanan: tanggal + bell + user ──────────────────────────── */}
      <div className="flex items-center gap-4">
        <span
          className="hidden text-xs text-muted-foreground md:inline"
          suppressHydrationWarning
        >
          {today}
        </span>

        {/* Bell dengan dropdown notifikasi */}
        <div ref={dropdownRef} className="relative">
          <button
            type="button"
            aria-label={`Notifikasi${notifCount > 0 ? `, ${notifCount} belum dibaca` : ''}`}
            aria-expanded={dropdownOpen}
            onClick={() => setDropdownOpen((prev) => !prev)}
            className="relative rounded-md p-1.5 text-foreground transition-colors hover:bg-muted"
          >
            <Bell className="h-4 w-4" aria-hidden />
            {notifCount > 0 && (
              <span
                className="absolute -right-0.5 -top-0.5 flex h-4 min-w-[16px] items-center justify-center rounded-full bg-status-err px-1 text-[9px] font-bold leading-none text-white"
                aria-hidden
              >
                {notifCount > 99 ? '99+' : notifCount}
              </span>
            )}
          </button>

          {/* Dropdown panel notifikasi */}
          {dropdownOpen && (
            <div className="absolute right-0 top-full z-50 mt-1.5 w-72 overflow-hidden rounded-md border border-sipandu-border bg-white shadow-lg">
              {/* Header dropdown */}
              <div className="flex items-center justify-between border-b border-sipandu-border px-3.5 py-2.5">
                <span className="text-xs font-semibold text-foreground">Notifikasi</span>
                <button
                  type="button"
                  onClick={() => setDropdownOpen(false)}
                  className="rounded p-0.5 text-muted-foreground hover:bg-muted"
                  aria-label="Tutup notifikasi"
                >
                  <X className="h-3.5 w-3.5" />
                </button>
              </div>

              {/* Isi notifikasi */}
              {notifCount === 0 ? (
                <div className="px-3.5 py-5 text-center text-xs text-muted-foreground">
                  Tidak ada notifikasi baru.
                </div>
              ) : notifHref ? (
                <Link
                  href={notifHref}
                  onClick={() => setDropdownOpen(false)}
                  className="flex items-start gap-3 px-3.5 py-3.5 transition-colors hover:bg-blue-50"
                >
                  <div className="mt-0.5 flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-sipandu-blue/10">
                    <ClipboardList className="h-4 w-4 text-sipandu-blue" aria-hidden />
                  </div>
                  <div className="min-w-0">
                    <p className="text-xs font-semibold text-foreground">
                      Sesi Peer Review Aktif
                    </p>
                    <p className="mt-0.5 text-xs text-muted-foreground">
                      Guru telah membuka sesi penilaian. Segera berikan penilaian kepada teman sekelasmu.
                    </p>
                    <p className="mt-1.5 text-xs font-medium text-sipandu-blue">
                      Buka halaman peer review →
                    </p>
                  </div>
                </Link>
              ) : (
                <div className="flex items-start gap-3 px-3.5 py-3.5">
                  <div className="mt-0.5 flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-sipandu-blue/10">
                    <ClipboardList className="h-4 w-4 text-sipandu-blue" aria-hidden />
                  </div>
                  <div>
                    <p className="text-xs font-semibold text-foreground">
                      Sesi Peer Review Aktif
                    </p>
                    <p className="mt-0.5 text-xs text-muted-foreground">
                      Ada sesi peer review yang sedang berjalan.
                    </p>
                  </div>
                </div>
              )}
            </div>
          )}
        </div>

        <strong className="text-sm font-semibold text-sipandu-navy">
          {userName}
        </strong>
      </div>
    </header>
  );
}
