/**
 * @file app/admin/layout.tsx
 * @description Layout admin: cek session via Supabase. Bila user belum
 *              login, render `children` apa adanya (mis. login page).
 *              Bila user terautentikasi sebagai admin, render shell:
 *              AdminSidebar di kiri + TopHeader di atas + main content.
 *
 *  Logika rute pelengkap di-handle oleh `middleware.ts`:
 *   - Akses `/admin/dashboard` tanpa login → redirect ke `/admin`
 *   - Akses `/admin` saat sudah login → redirect ke `/admin/dashboard`
 *
 *  Layout ini dipanggil ulang tiap navigasi karena merupakan
 *  Server Component (default Next.js App Router).
 */

import type { ReactNode } from 'react';
import { redirect } from 'next/navigation';
import { Toaster } from 'sonner';

import { createClient } from '@/lib/supabase/server';
import { AdminSidebar } from '@/components/shared/AdminSidebar';
import { TopHeader } from '@/components/shared/TopHeader';
import { MobileLayoutShell } from '@/components/shared/MobileLayoutShell';

export default async function AdminLayout({
  children,
}: {
  children: ReactNode;
}) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  // ── Belum login → render children apa adanya (login page) ─────────
  if (!user) {
    return (
      <>
        {children}
        <Toaster position="top-right" richColors />
      </>
    );
  }

  // ── Verifikasi role admin ────────────────────────────────────────
  const { data: profile } = await supabase
    .from('profiles')
    .select('id, role, full_name, email, is_active')
    .eq('id', user.id)
    .single();

  if (!profile || profile.role !== 'admin' || !profile.is_active) {
    // Bukan admin → sign out paksa lalu redirect ke login
    await supabase.auth.signOut();
    redirect('/admin');
  }

  // ── Render shell admin ───────────────────────────────────────────
  return (
    <MobileLayoutShell
      sidebar={
        <AdminSidebar
          userName={profile.full_name as string}
          userEmail={profile.email as string}
        />
      }
    >
      <TopHeader
        breadcrumb={[]}
        userName={profile.full_name as string}
        role="admin"
        notifCount={0}
      />
      <main className="flex-1 overflow-y-auto p-3 md:p-5">{children}</main>
      <Toaster position="top-right" richColors />
    </MobileLayoutShell>
  );
}
