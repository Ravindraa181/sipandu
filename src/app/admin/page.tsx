/**
 * @file app/admin/page.tsx
 * @description L1 Login Administrator. Full-page navy background dengan
 *              card putih 420px di tengah. Form: username + password
 *              + checkbox + tombol Masuk. Submit via server action.
 *
 * URL: /admin
 *
 * Bila user sudah login sebagai admin, middleware akan redirect ke
 * /admin/dashboard sebelum halaman ini di-render.
 */

import Image from 'next/image';
import { LoginForm } from './_components/LoginForm';

export const metadata = {
  title: 'Login Admin — SiPandu',
  description: 'Portal administrator SiPandu, SMAN 13 Bandung.',
};

export default function AdminLoginPage() {
  return (
    <main
      className="flex min-h-screen items-center justify-center bg-sipandu-navy px-4 py-10"
      aria-label="Halaman Login Administrator"
    >
      <div className="w-full max-w-[420px] rounded-lg bg-white p-9 shadow-modal">
        {/* ── Brand header ────────────────────────────────────────── */}
        <div className="mb-4 text-center">
          <div className="mx-auto mb-3 flex h-16 w-16 items-center justify-center rounded-full bg-muted">
            <Image
              src="/logo-sman13.png"
              width={48}
              height={48}
              alt="Logo SMAN 13 Bandung Belum Ada"
              priority
              // Fallback: bila logo belum ada, browser tampilkan alt text.
            />
          </div>
          <h1 className="text-lg font-semibold text-foreground">
            SMAN 13 Bandung
          </h1>
          <p className="mt-0.5 text-sm text-muted-foreground">
            Portal Administrator SiPandu
          </p>
        </div>

        <hr className="my-3.5 border-sipandu-border" />

        {/* ── Form (Client Component dengan server action) ────────── */}
        <LoginForm />

        <p className="mt-3.5 text-center text-xs leading-relaxed text-muted-foreground">
          Halaman ini hanya untuk administrator sistem.
          <br />
          Akses tidak sah akan dicatat.
        </p>

        <div className="mt-3.5 border-t border-sipandu-border pt-3 text-center text-2xs text-muted-foreground">
          SiPandu v1.0 © 2026 SMAN 13 Bandung
        </div>
      </div>
    </main>
  );
}
