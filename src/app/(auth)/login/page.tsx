/**
 * @file app/(auth)/login/page.tsx
 * @description L2 — Login User (Guru & Siswa).
 *
 *  URL: /login
 *  Background: gradient navy → biru (sesuai mockup walikelas).
 *  Card putih 440px di tengah dengan logo + form email/password.
 *
 *  Logic redirect setelah login ditangani di `UserLoginForm` (client).
 *  Middleware menjaga agar route ini tidak diakses saat sudah login.
 */

import Link from 'next/link';
import { LOGO_SMAN13 } from '@/lib/logo-sman13';

import { UI_STRINGS } from '@/constants';
import { UserLoginForm } from './_components/UserLoginForm';

export const metadata = {
  title: 'Masuk',
  description: 'Portal Guru dan Siswa SiPandu, SMAN 13 Bandung.',
};

export default function LoginPage() {
  return (
    <main
      className="flex min-h-screen items-center justify-center bg-sipandu-login px-4 py-10"
      aria-label="Halaman Login Pengguna"
    >
      <div className="w-full max-w-[440px] rounded-lg bg-white p-10 shadow-modal">
        {/* ── Brand header ────────────────────────────────────────── */}
        <div className="mb-5 text-center">
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
          <h1 className="text-2xl font-bold text-sipandu-navy">
            {UI_STRINGS.appName}
          </h1>
          <p className="mt-0.5 text-md text-muted-foreground">
            {UI_STRINGS.schoolName}
          </p>
        </div>

        <h2 className="mb-3.5 text-md font-semibold text-foreground">
          Masuk ke Akun Anda
        </h2>

        {/* ── Form ────────────────────────────────────────────────── */}
        <UserLoginForm />

        <hr className="my-4 border-sipandu-border" />

        <p className="text-center text-sm leading-relaxed text-muted-foreground">
          Halaman ini untuk Guru dan Siswa.
          <br />
          Administrator masuk melalui{' '}
          <Link
            href="/admin"
            className="text-sipandu-blue hover:underline"
          >
            halaman khusus
          </Link>
          .
        </p>
      </div>
    </main>
  );
}
