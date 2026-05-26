'use client';

/**
 * @file app/error.tsx
 * @description Global error boundary Next.js (root segment).
 *
 *  Komponen ini di-render OTOMATIS oleh Next.js bila ada throw error
 *  yang tidak ter-handle di Server / Client Component manapun.
 *
 *  Wajib `'use client'` (per dokumentasi Next.js). `reset()` dipanggil
 *  untuk re-render route tree dari root.
 */

import { useEffect } from 'react';
import { AlertTriangle, RefreshCw, Home } from 'lucide-react';
import Link from 'next/link';
import { ROUTES } from '@/constants';

interface ErrorProps {
  error: Error & { digest?: string };
  reset: () => void;
}

export default function GlobalError({ error, reset }: ErrorProps) {
  useEffect(() => {
    // Catat error ke server log Vercel — supaya bisa dianalisis
    // tanpa expose detail ke user.
    console.error('[sipandu] error boundary:', error);
  }, [error]);

  return (
    <div className="flex min-h-screen items-center justify-center bg-sipandu-bg p-6">
      <div className="w-full max-w-md rounded-md border border-sipandu-border bg-white p-8 shadow-card">
        <div className="mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-status-err-soft">
          <AlertTriangle className="h-6 w-6 text-status-err" aria-hidden />
        </div>

        <h1 className="sipandu-page-title mb-2">Terjadi Kesalahan</h1>
        <p className="mb-1 text-sm text-muted-foreground">
          Sistem mengalami kendala saat memuat halaman. Tim pengembang
          sudah dapat catatan otomatis.
        </p>

        {error.digest && (
          <p className="sipandu-caption mb-4 sipandu-mono">
            Kode referensi: {error.digest}
          </p>
        )}

        <div className="mt-6 flex flex-col gap-2 sm:flex-row">
          <button
            type="button"
            onClick={() => reset()}
            className="inline-flex h-10 items-center justify-center gap-2 rounded-md bg-sipandu-blue px-4 text-sm font-semibold text-white transition hover:opacity-90 focus-visible:ring-2 focus-visible:ring-ring"
          >
            <RefreshCw className="h-4 w-4" aria-hidden />
            Coba Lagi
          </button>

          <Link
            href={ROUTES.login}
            className="inline-flex h-10 items-center justify-center gap-2 rounded-md border border-sipandu-border bg-white px-4 text-sm font-semibold text-foreground transition hover:bg-sipandu-bg focus-visible:ring-2 focus-visible:ring-ring"
          >
            <Home className="h-4 w-4" aria-hidden />
            Ke Halaman Login
          </Link>
        </div>
      </div>
    </div>
  );
}
