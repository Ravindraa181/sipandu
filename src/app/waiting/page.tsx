/**
 * @file app/waiting/page.tsx
 * @description L3 — Halaman Menunggu Penugasan Kelas.
 *
 *  Ditampilkan untuk akun guru yang sudah login tapi belum di-assign
 *  ke kelas mana pun pada periode aktif. Tidak punya sidebar — hanya
 *  header tipis + card centered.
 *
 *  Server Component:
 *   - Verifikasi session
 *   - Bila bukan guru → redirect /login
 *   - Bila sudah punya assignment di periode aktif → redirect /dashboard
 *   - Bila admin → redirect /admin
 *   - Bila student → redirect /siswa/dashboard
 */

import { redirect } from 'next/navigation';
import { ChartArea, CircleDot, Clock } from 'lucide-react';

import { createClient } from '@/lib/supabase/server';
import { ROUTES, UI_STRINGS } from '@/constants';
import { formatDate } from '@/lib/utils/format';
import { RefreshStatusButton } from './_components/RefreshStatusButton';
import { LogoutButton } from './_components/LogoutButton';

export const metadata = {
  title: 'Menunggu Penugasan',
};

interface WaitingData {
  teacherName: string;
  activePeriodLabel: string;
  activePeriodDateRange: string;
  adminEmail: string;
}

async function loadData(): Promise<WaitingData> {
  const supabase = await createClient();

  // ── 1. Verifikasi session ───────────────────────────────────────
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    redirect(ROUTES.login);
  }

  // ── 2. Cek role ──────────────────────────────────────────────────
  const { data: profile } = await supabase
    .from('profiles')
    .select('role, full_name, is_active')
    .eq('id', user.id)
    .single();

  if (!profile || !profile.is_active) {
    await supabase.auth.signOut();
    redirect(ROUTES.login);
  }
  if (profile.role === 'admin') redirect(ROUTES.adminHome);
  if (profile.role === 'student') redirect(ROUTES.studentHome);

  // ── 3. Periode aktif ─────────────────────────────────────────────
  const { data: period } = await supabase
    .from('academic_periods')
    .select('id, name, start_date, end_date')
    .eq('status', 'active')
    .maybeSingle();

  // ── 4. Cek assignment guru di periode aktif ─────────────────────
  if (period?.id) {
    const { data: assignment } = await supabase
      .from('class_period_assignments')
      .select('id')
      .eq('period_id', period.id)
      .eq('homeroom_teacher_id', user.id)
      .maybeSingle();

    if (assignment) {
      // Sudah di-assign → langsung ke dashboard
      redirect(ROUTES.teacherHome);
    }
  }

  return {
    teacherName: (profile.full_name as string) ?? 'Wali Kelas',
    activePeriodLabel:
      (period?.name as string | undefined) ?? 'Belum ada periode aktif',
    activePeriodDateRange: period
      ? `${formatDate(period.start_date as string)} – ${formatDate(period.end_date as string)}`
      : '—',
    adminEmail: 'admin@sman13bdg.sch.id',
  };
}

export default async function WaitingPage() {
  const data = await loadData();

  return (
    <div className="min-h-screen bg-sipandu-bg">
      {/* ── Header ───────────────────────────────────────────────── */}
      <header className="flex h-header items-center justify-between border-b border-sipandu-border bg-white px-6">
        <div className="flex items-center gap-2">
          <ChartArea className="h-4 w-4 text-sipandu-navy" aria-hidden />
          <span className="text-md font-bold text-sipandu-navy">
            {UI_STRINGS.appName}
          </span>
        </div>

        <div className="flex items-center gap-3">
          <span className="text-sm text-foreground">{data.teacherName}</span>
          <LogoutButton />
        </div>
      </header>

      {/* ── Konten ───────────────────────────────────────────────── */}
      <main className="flex min-h-[calc(100vh-60px)] items-center justify-center px-6 py-10">
        <div className="w-full max-w-[520px] rounded-lg border border-sipandu-border bg-white p-10 text-center">
          <div className="mx-auto mb-5 flex h-20 w-20 items-center justify-center rounded-full bg-gray-100">
            <Clock className="h-9 w-9 text-muted-foreground" aria-hidden />
          </div>

          <h1 className="mb-2.5 text-2xl font-bold text-foreground">
            Menunggu Penugasan Kelas
          </h1>

          <p className="mb-1.5 text-base leading-relaxed text-foreground">
            Akun Anda aktif, namun Anda belum ditugaskan sebagai wali kelas
            pada periode yang sedang berjalan.
          </p>

          <p className="mb-5 text-sm text-muted-foreground">
            Periode aktif: <strong>{data.activePeriodLabel}</strong>
            {data.activePeriodDateRange !== '—' && (
              <>
                <br />
                <span className="text-2xs">{data.activePeriodDateRange}</span>
              </>
            )}
          </p>

          {/* Instruksi */}
          <div className="mb-5 rounded-md border border-sipandu-border bg-gray-50 p-3.5 text-left">
            <div className="mb-2 text-sm font-semibold text-foreground">
              Apa yang perlu dilakukan?
            </div>
            <ul className="space-y-1.5 text-sm leading-relaxed text-muted-foreground">
              <li className="flex items-start gap-2">
                <CircleDot
                  className="mt-1 h-2.5 w-2.5 flex-shrink-0"
                  aria-hidden
                />
                <span>
                  Hubungi administrator sistem untuk meminta penugasan kelas.
                </span>
              </li>
              <li className="flex items-start gap-2">
                <CircleDot
                  className="mt-1 h-2.5 w-2.5 flex-shrink-0"
                  aria-hidden
                />
                <span>
                  Atau tunggu hingga admin meng-assign Anda ke kelas, lalu klik
                  tombol &quot;Refresh Status&quot; di bawah.
                </span>
              </li>
            </ul>
          </div>

          <RefreshStatusButton />

          <p className="mt-4 text-xs text-muted-foreground">
            Jika ada kesalahan, hubungi:{' '}
            <a
              href={`mailto:${data.adminEmail}`}
              className="text-sipandu-blue hover:underline"
            >
              {data.adminEmail}
            </a>
          </p>
        </div>
      </main>
    </div>
  );
}
