/**
 * @file app/admin/login/page.tsx
 * @description L1 Login Administrator.
 */

import { LoginForm } from '../_components/LoginForm';
import { LOGO_SMAN13 } from '@/lib/logo-sman13';

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
        <div className="mb-4 text-center">
          {/* ALASAN: pakai <img> biasa — file statis lokal tidak perlu
              optimisasi Next.js Image, dan lebih reliable di dev mode */}
          <div className="mx-auto mb-3 flex h-20 w-20 items-center justify-center rounded-full bg-white shadow-sm ring-1 ring-sipandu-border">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src={LOGO_SMAN13}
              width={68}
              height={68}
              alt="Logo SMAN 13 Bandung"
              className="rounded-full object-contain"
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

        <LoginForm />

        <p className="mt-3.5 text-center text-xs leading-relaxed text-muted-foreground">
          Halaman ini hanya untuk administrator sistem.
          <br />
          Akses tidak sah akan dicatat.
        </p>
      </div>
    </main>
  );
}