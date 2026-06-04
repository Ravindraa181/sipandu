/**
 * @file app/siswa/layout.tsx
 * @description Layout untuk semua halaman portal Siswa.
 *
 * Server Component:
 * - Verifikasi session + role 'student'
 * - Bila tidak login → redirect /login
 * - Bila admin/teacher → redirect ke portal masing-masing
 * - Bila tidak terdaftar di kelas pada periode aktif → tampilkan card
 * informasi minimal tanpa sidebar (tidak punya halaman khusus L4)
 * - Render StudentSidebar (dengan prop `hasPeerReviewActive`) +
 * TopHeader + main content area.
 */

import type { ReactNode } from 'react';
import { redirect } from 'next/navigation';
import { Toaster } from 'sonner';

import { createClient } from '@/lib/supabase/server';
import { StudentSidebar } from '@/components/shared/StudentSidebar';
import { TopHeader } from '@/components/shared/TopHeader';
import { MobileLayoutShell } from '@/components/shared/MobileLayoutShell';
import { ROUTES } from '@/constants';
import { getStudentContext } from '@/lib/student/getStudentContext';

export default async function SiswaLayout({
  children,
}: {
  children: ReactNode;
}) {
  const supabase = await createClient();

  // ── 1. Cek session ─────────────────────────────────────────────
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect(ROUTES.login);

  // ── 2. Cek role dan ambil identitas ────────────────────────────
  // PERBAIKAN: Fetch langsung nisn & full_name dari tabel profiles
  const { data: profile } = await supabase
    .from('profiles')
    .select('role, full_name, nisn, is_active')
    .eq('id', user.id)
    .single();

  if (!profile || profile.role !== 'student' || !profile.is_active) {
    if (profile?.role === 'teacher') redirect(ROUTES.teacherHome);
    else if (profile?.role === 'admin') redirect(ROUTES.adminHome);
    else redirect(ROUTES.login);
  }

  const fullName = profile.full_name;
  const nisn = profile.nisn ?? '—';

  const ctx = await getStudentContext();

  if (!ctx) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-sipandu-bg p-6">
        <div className="w-full max-w-md rounded-md border border-sipandu-border bg-white p-8 text-center">
          <h1 className="mb-2 text-xl font-bold text-foreground">
            Belum terdaftar di kelas
          </h1>
          <p className="text-sm text-muted-foreground">
            Akun Anda aktif, namun belum terdaftar pada kelas di periode
            akademik yang sedang berjalan.
          </p>
          <p className="mt-2 text-xs text-muted-foreground">
            Hubungi administrator sekolah untuk pendaftaran.
          </p>
        </div>
        <Toaster position="top-right" richColors />
      </div>
    );
  }

  // ── 3. Cek Status Peer Review ──────────────────────────────────
  // PERBAIKAN: Kueri ke tabel peer_review_sessions untuk parameter notif/sidebar
  let hasPeerReviewActive = false;
  if (ctx.assignmentId) {
    const { data: pr } = await supabase
      .from('peer_review_sessions')
      .select('id')
      .eq('class_period_assignment_id', ctx.assignmentId)
      .eq('status', 'active')
      .maybeSingle();

    if (pr) hasPeerReviewActive = true;
  }

  // ── 4. Render shell ────────────────────────────────────────────
  return (
    <MobileLayoutShell
      sidebar={
        <StudentSidebar
          userName={fullName}
          nisn={nisn}
          className={ctx.className}
          periodLabel={ctx.periodLabel}
          hasPeerReviewActive={hasPeerReviewActive}
        />
      }
    >
      <TopHeader
        breadcrumb={[]}
        userName={fullName}
        role="student"
        notifCount={hasPeerReviewActive ? 1 : 0}
        notifHref={hasPeerReviewActive ? '/siswa/peer-review' : undefined}
      />
      <main className="flex-1 overflow-y-auto p-3 md:p-5">{children}</main>
      <Toaster position="top-right" richColors />
    </MobileLayoutShell>
  );
}