/**
 * @file app/layout.tsx
 * @description Root layout SiPandu — wrapper HTML/body, metadata, font.
 *
 *  Layout ini dijalankan untuk SEMUA halaman (admin, dashboard, siswa,
 *  login, waiting, dll). Tidak boleh ada sidebar/header di sini —
 *  shell modul berada di layout.tsx masing-masing.
 *
 *  Sistem font: stack `system-ui` (sesuai mockup) — tidak load Google Fonts
 *  agar performa first-paint optimal di koneksi sekolah.
 */

import type { Metadata, Viewport } from 'next';
import { Toaster } from 'sonner';
import './globals.css';

export const metadata: Metadata = {
  title: {
    default: 'SiPandu — SMAN 13 Bandung',
    template: '%s · SiPandu',
  },
  description:
    'Sistem Penilaian Terpadu (SiPandu) — Penilaian Perilaku Siswa Adaptif Menggunakan Fuzzy Logic. SMAN 13 Bandung.',
  applicationName: 'SiPandu',
  authors: [{ name: 'Ravindra Maulana Sahman' }],
  generator: 'Next.js',
  referrer: 'strict-origin-when-cross-origin',
  // Block crawler default — sekolah tidak butuh public indexing.
  robots: {
    index: false,
    follow: false,
    nocache: true,
  },
  icons: {
    icon: '/favicon.ico',
  },
};

export const viewport: Viewport = {
  width: 'device-width',
  initialScale: 1,
  maximumScale: 1,
  themeColor: '#1E3A5F',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="id" className="h-full" suppressHydrationWarning>
      <body
        className="h-full overflow-hidden bg-sipandu-bg font-sans text-foreground antialiased"
        suppressHydrationWarning>
        {children}
        {/*
         * Global Toaster — modul-level layouts (admin/dashboard/siswa)
         * juga merender Toaster sendiri untuk redundansi. Boleh dobel,
         * sonner mendetect & merge.
         */}
        <Toaster position="top-right" richColors closeButton />
      </body>
    </html>
  );
}
