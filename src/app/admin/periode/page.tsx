/**
 * @file app/admin/periode/page.tsx
 * @description A2 — Manajemen Periode Akademik.
 *
 *  Server Component: tampilkan periode aktif (card hijau) + grid hari
 *  efektif per bulan, lalu tabel riwayat periode (status arsip/closed).
 *  Aksi-aksi (buat baru, edit hari, tutup periode) di-handle Client
 *  Component anak yang memanggil server action.
 */

import { Calendar, Plus } from 'lucide-react';

import { createClient } from '@/lib/supabase/server';
import { PageHeader } from '@/components/shared/PageHeader';
import { MONTHS_SHORT } from '@/constants';
import { formatDate } from '@/lib/utils/format';
import { CreatePeriodDialog } from './_components/CreatePeriodDialog';
import {
  EditEffectiveDaysDialog,
  type MonthlyDayRow,
} from './_components/EditEffectiveDaysDialog';
import { ClosePeriodButton } from './_components/ClosePeriodButton';
import { EditPeriodDialog } from './_components/EditPeriodDialog';
import { DeletePeriodButton } from './_components/DeletePeriodButton';
import { ReactivatePeriodButton } from './_components/ReactivatePeriodButton';

export const metadata = {
  title: 'Manajemen Periode — Admin SiPandu',
};

interface PeriodRow {
  id: string;
  name: string;
  academicYear: string;
  semester: 'ganjil' | 'genap';
  startDate: string;
  endDate: string;
  status: 'active' | 'closed' | 'archived';
  /** Total kelas pada periode (count dari class_period_assignments). */
  totalClasses: number;
  /** Total siswa terdaftar pada periode. */
  totalStudents: number;
  monthlyDays: MonthlyDayRow[];
}

interface PageData {
  activePeriod: (PeriodRow & { monthlyDays: MonthlyDayRow[] }) | null;
  history: PeriodRow[];
}

async function loadData(): Promise<PageData> {
  const supabase = await createClient();

  const { data: periodsData } = await supabase
    .from('academic_periods')
    .select('id, name, academic_year, semester, start_date, end_date, status')
    .order('start_date', { ascending: false });

  const periods = (periodsData ?? []) as Array<{
    id: string;
    name: string;
    academic_year: string;
    semester: 'ganjil' | 'genap';
    start_date: string;
    end_date: string;
    status: 'active' | 'closed' | 'archived';
  }>;

  const enriched: PeriodRow[] = await Promise.all(
    periods.map(async (p) => {
      const { count: classCount } = await supabase
        .from('class_period_assignments')
        .select('id', { count: 'exact', head: true })
        .eq('period_id', p.id);

      const { data: assignments } = await supabase
        .from('class_period_assignments')
        .select('id')
        .eq('period_id', p.id);

      const assignmentIds = (assignments ?? []).map((a) => a.id as string);

      let studentCount = 0;
      if (assignmentIds.length > 0) {
        const { count } = await supabase
          .from('student_class_enrollments')
          .select('id', { count: 'exact', head: true })
          .in('class_period_assignment_id', assignmentIds)
          .eq('status', 'active');
        studentCount = count ?? 0;
      }

      const { data: monthsData } = await supabase
        .from('period_monthly_days')
        .select('month, year, effective_days')
        .eq('period_id', p.id)
        .order('year', { ascending: true })
        .order('month', { ascending: true });

      const monthlyDays: MonthlyDayRow[] = ((monthsData ?? []) as Array<{
        month: number; year: number; effective_days: number;
      }>).map((m) => ({ month: m.month, year: m.year, effectiveDays: m.effective_days }));

      return {
        id: p.id,
        name: p.name,
        academicYear: p.academic_year,
        semester: p.semester,
        startDate: p.start_date,
        endDate: p.end_date,
        status: p.status,
        totalClasses: classCount ?? 0,
        totalStudents: studentCount,
        monthlyDays,
      };
    }),
  );

  const activePeriodRaw = enriched.find((p) => p.status === 'active') ?? null;
  const activePeriod = activePeriodRaw ?? null;

  const history = enriched.filter((p) => p.status !== 'active');

  return { activePeriod, history };
}

export default async function AdminPeriodePage() {
  const { activePeriod, history } = await loadData();

  return (
    <div className="space-y-4">
      <PageHeader
        title="Manajemen periode akademik"
        actions={<CreatePeriodDialog />}
      />

      {/* ── Card Periode Aktif ────────────────────────────────────── */}
      {activePeriod ? (
        <div
          className="rounded-md border border-status-on-soft bg-green-50 p-4"
          style={{ borderLeftColor: '#16A34A', borderLeftWidth: 4 }}
        >
          <div className="mb-1.5 flex items-center gap-2">
            <span className="inline-flex items-center rounded-full bg-status-on-soft px-2 py-0.5 text-2xs font-semibold text-status-on-text">
              ● AKTIF
            </span>
            <strong className="text-md text-foreground">
              Semester {activePeriod.name}
            </strong>
          </div>
          <div className="mb-2.5 flex items-center gap-1.5 text-sm text-foreground">
            <Calendar className="h-3.5 w-3.5" aria-hidden />
            {formatDate(activePeriod.startDate)} —{' '}
            {formatDate(activePeriod.endDate)}
          </div>

          <div className="mb-1.5 text-xs text-muted-foreground">
            Hari efektif per bulan:
          </div>
          <div className="mb-3 flex flex-wrap gap-1.5">
            {activePeriod.monthlyDays.length === 0 ? (
              <p className="text-xs italic text-muted-foreground">
                Belum diatur — klik &quot;Edit Hari Efektif&quot; untuk
                menambahkan.
              </p>
            ) : (
              activePeriod.monthlyDays.map((m) => (
                <div
                  key={`${m.year}-${m.month}`}
                  className="rounded-md border border-gray-300 bg-white px-2.5 py-1.5 text-center"
                >
                  <div className="text-2xs text-muted-foreground">
                    {MONTHS_SHORT[m.month - 1]}
                  </div>
                  <div className="text-lg font-bold text-foreground">
                    {m.effectiveDays}
                  </div>
                  <div className="text-2xs text-muted-foreground">hari</div>
                </div>
              ))
            )}
          </div>

          <div className="flex flex-wrap gap-2">
            <EditEffectiveDaysDialog
              periodId={activePeriod.id}
              periodName={activePeriod.name}
              initialDays={
                activePeriod.monthlyDays.length > 0
                  ? activePeriod.monthlyDays
                  : [
                      // default 6 bulan kalau belum ada
                      { month: 8, year: 2024, effectiveDays: 22 },
                      { month: 9, year: 2024, effectiveDays: 22 },
                      { month: 10, year: 2024, effectiveDays: 23 },
                      { month: 11, year: 2024, effectiveDays: 20 },
                      { month: 12, year: 2024, effectiveDays: 18 },
                      { month: 1, year: 2025, effectiveDays: 14 },
                    ]
              }
            />
            <ClosePeriodButton
              periodId={activePeriod.id}
              periodName={activePeriod.name}
            />
          </div>
        </div>
      ) : (
        <div className="rounded-md border border-status-warn-soft bg-amber-50 p-4 text-sm text-status-warn-text">
          <strong>Belum ada periode aktif.</strong> Klik tombol &quot;Buat
          Periode Baru&quot; di kanan atas untuk memulai.
        </div>
      )}

      {/* ── Riwayat Periode ──────────────────────────────────────── */}
      <div className="rounded-md border border-sipandu-border bg-white">
        <div className="border-b border-sipandu-border px-3.5 py-2.5">
          <h2 className="text-base font-bold text-foreground">
            Riwayat periode
          </h2>
        </div>

        {history.length === 0 ? (
          <p className="px-3.5 py-8 text-center text-sm italic text-muted-foreground">
            Belum ada riwayat periode.
          </p>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full border-collapse text-sm">
              <thead>
                <tr className="border-b border-sipandu-border bg-gray-100 text-left">
                  <th className="px-3 py-2 text-xs font-semibold">Periode</th>
                  <th className="px-3 py-2 text-xs font-semibold">Mulai</th>
                  <th className="px-3 py-2 text-xs font-semibold">Selesai</th>
                  <th className="px-3 py-2 text-center text-xs font-semibold">
                    Total Kelas
                  </th>
                  <th className="px-3 py-2 text-center text-xs font-semibold">
                    Siswa Dinilai
                  </th>
                  <th className="px-3 py-2 text-xs font-semibold">Status</th>
                  <th className="px-3 py-2 text-xs font-semibold">Aksi</th>
                </tr>
              </thead>
              <tbody>
                {history.map((p) => (
                  <tr
                    key={p.id}
                    className="border-b border-gray-100 hover:bg-blue-50/60"
                  >
                    <td className="px-3 py-2 font-medium text-foreground">
                      {p.name}
                    </td>
                    <td className="px-3 py-2 text-foreground">
                      {formatDate(p.startDate)}
                    </td>
                    <td className="px-3 py-2 text-foreground">
                      {formatDate(p.endDate)}
                    </td>
                    <td className="px-3 py-2 text-center text-foreground">
                      {p.totalClasses}
                    </td>
                    <td className="px-3 py-2 text-center text-foreground">
                      {p.totalStudents}
                    </td>
                    <td className="px-3 py-2">
                      <span className="inline-flex items-center rounded-full bg-gray-200 px-2 py-0.5 text-2xs font-semibold text-muted-foreground">
                        {p.status === 'archived' ? 'Arsip' : 'Tutup'}
                      </span>
                    </td>
                    <td className="px-3 py-2">
                      <div className="flex items-center gap-1">
                        <EditPeriodDialog
                          periodId={p.id}
                          periodName={p.name}
                          academicYear={p.academicYear}
                          semester={p.semester}
                          startDate={p.startDate}
                          endDate={p.endDate}
                          monthlyDays={p.monthlyDays}
                        />
                        <ReactivatePeriodButton
                          periodId={p.id}
                          periodName={p.name}
                          activePeriodName={activePeriod?.name}
                        />
                        <DeletePeriodButton
                          periodId={p.id}
                          periodName={p.name}
                          hasData={p.totalClasses > 0}
                        />
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}