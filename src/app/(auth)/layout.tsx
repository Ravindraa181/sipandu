/**
 * @file app/(auth)/layout.tsx
 * @description Layout untuk route group `(auth)` — halaman login
 *              guru/siswa (L2).
 *
 *  Route group `(auth)` tidak menambah segmen URL. Halaman child:
 *    - /login → app/(auth)/login/page.tsx
 *
 *  Background gradient navy → biru sesuai mockup `sipandu_walikelas.html`
 *  & `sipandu_siswa.html` (lihat UI_DESIGN_REFERENCE §1.2).
 *
 *  Tidak ada sidebar / header — hanya wrapper centered untuk card login.
 */

import type { ReactNode } from 'react';

export default function AuthLayout({ children }: { children: ReactNode }) {
  return (
    <div className="flex min-h-screen items-center justify-center bg-sipandu-login p-6">
      {children}
    </div>
  );
}
