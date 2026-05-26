'use client';

/**
 * @file components/shared/MobileLayoutShell.tsx
 * @description Shell layout responsif untuk semua role (admin, teacher, student).
 *
 * Perilaku:
 * - Desktop (≥md / 768px): sidebar statis di kiri, konten di kanan — sama
 *   seperti sebelumnya.
 * - Mobile (<md): sidebar tersembunyi sebagai drawer yang muncul dari kiri
 *   saat tombol hamburger di TopHeader ditekan. Overlay hitam semi-transparan
 *   menutup drawer saat diklik.
 *
 * Auto-close: drawer ditutup otomatis saat pathname berubah (navigasi).
 *
 * Gunakan h-[100dvh] agar tinggi halaman memperhitungkan address bar
 * browser mobile yang dinamis (bukan h-screen yang pakai 100vh statis).
 */

import { useEffect } from 'react';
import type { ReactNode } from 'react';
import { usePathname } from 'next/navigation';

import { cn } from '@/lib/utils/cn';
import { MobileSidebarProvider, useMobileSidebar } from './MobileSidebarContext';

interface Props {
  /** Komponen sidebar yang sudah diinstansiasi (mis. <AdminSidebar .../>). */
  sidebar: ReactNode;
  children: ReactNode;
}

/** Inner shell — perlu dipisah agar bisa mengakses context setelah di-provide. */
function ShellInner({ sidebar, children }: Props) {
  const { isOpen, close } = useMobileSidebar();
  const pathname = usePathname();

  // Tutup drawer saat navigasi agar tidak menghalangi konten halaman baru
  useEffect(() => {
    close();
    // ALASAN: hanya perlu re-run saat pathname berubah; 'close' stabil via useCallback
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [pathname]);

  return (
    <div className="flex h-[100dvh] overflow-hidden bg-sipandu-bg">
      {/* ── Sidebar: satu instance, mode berbeda tergantung viewport ──── */}
      <div
        className={cn(
          // Desktop: posisi normal dalam flex flow, selalu terlihat
          'md:relative md:flex md:translate-x-0 md:transition-none',
          // Mobile: fixed overlay dari kiri, toggle via transform
          'fixed inset-y-0 left-0 z-40 transition-transform duration-300 ease-in-out',
          isOpen ? 'translate-x-0' : '-translate-x-full md:translate-x-0',
        )}
      >
        {sidebar}
      </div>

      {/* ── Overlay backdrop — hanya muncul di mobile saat drawer terbuka ── */}
      {isOpen && (
        <div
          className="fixed inset-0 z-30 bg-black/50 md:hidden"
          onClick={close}
          aria-hidden
        />
      )}

      {/* ── Area konten utama (TopHeader + main) ────────────────────────── */}
      <div className="flex min-w-0 flex-1 flex-col overflow-hidden">
        {children}
      </div>
    </div>
  );
}

/** Shell layout responsif dengan provider context bawaan. */
export function MobileLayoutShell({ sidebar, children }: Props) {
  return (
    <MobileSidebarProvider>
      <ShellInner sidebar={sidebar}>{children}</ShellInner>
    </MobileSidebarProvider>
  );
}
