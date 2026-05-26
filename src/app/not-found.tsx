/**
 * @file app/not-found.tsx
 * @description Halaman 404 global (Server Component).
 *
 *  Di-render oleh Next.js saat:
 *   - URL tidak match route mana pun
 *   - notFound() dipanggil di Server Component / Page
 */

import Link from 'next/link';
import { Home, FileQuestion } from 'lucide-react';
import { ROUTES } from '@/constants';

export default function NotFound() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-sipandu-bg p-6">
      <div className="w-full max-w-md rounded-md border border-sipandu-border bg-white p-8 text-center shadow-card">
        <div className="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-sipandu-blue/10">
          <FileQuestion
            className="h-6 w-6 text-sipandu-blue"
            aria-hidden
          />
        </div>

        <h1 className="sipandu-page-title mb-2">404 — Halaman Tidak Ditemukan</h1>
        <p className="mb-6 text-sm text-muted-foreground">
          URL yang Anda akses tidak ada di sistem SiPandu. Mungkin link
          sudah pindah atau Anda salah ketik.
        </p>

        <Link
          href={ROUTES.login}
          className="inline-flex h-10 items-center justify-center gap-2 rounded-md bg-sipandu-blue px-5 text-sm font-semibold text-white transition hover:opacity-90 focus-visible:ring-2 focus-visible:ring-ring"
        >
          <Home className="h-4 w-4" aria-hidden />
          Kembali ke Login
        </Link>
      </div>
    </div>
  );
}
