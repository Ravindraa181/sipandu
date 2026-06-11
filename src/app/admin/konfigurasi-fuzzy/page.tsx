/**
 * @file app/admin/konfigurasi-fuzzy/page.tsx
 * @description A6 — Konfigurasi Sistem Fuzzy + Pengaturan Sekolah.
 *
 *  Server Component yang load konfigurasi fuzzy dari Supabase
 *  (atau fallback ke DEFAULT_FUZZY_CONFIG bila tabel kosong),
 *  lalu kirim sebagai prop ke client tabs.
 *  Tab "Pengaturan Sekolah" memuat nama & NIP kepala sekolah untuk dokumen ekspor.
 */

import { Info } from 'lucide-react';

import { createClient, createServiceRoleClient } from '@/lib/supabase/server';
import { PageHeader } from '@/components/shared/PageHeader';
import { loadConfigFromDb, DEFAULT_FUZZY_CONFIG } from '@/lib/fuzzy/engine';
import type { FuzzyConfig } from '@/lib/fuzzy/types';
import { FuzzyTabs } from './_components/FuzzyTabs';
import { InputVariableEditor } from './_components/InputVariableEditor';
import { OutputVariableEditor } from './_components/OutputVariableEditor';
import { RuleBaseTable } from './_components/RuleBaseTable';
import { FuzzySimulator } from './_components/FuzzySimulator';
import { SchoolSettingsForm } from './_components/SchoolSettingsForm';

export const metadata = {
  title: 'Konfigurasi Fuzzy',
};

async function loadFuzzy(): Promise<FuzzyConfig> {
  try {
    const supabase = await createClient();
    return await loadConfigFromDb(
      supabase as unknown as Parameters<typeof loadConfigFromDb>[0],
    );
  } catch {
    return DEFAULT_FUZZY_CONFIG;
  }
}

/** Ambil pengaturan sekolah dari tabel school_settings. */
async function loadSchoolSettings(): Promise<{
  principalName: string;
  principalNip: string;
}> {
  try {
    // ALASAN: service role agar tidak terpengaruh RLS saat server-side fetch
    const admin = await createServiceRoleClient();
    const { data } = await admin
      .from('school_settings' as any)
      .select('key, value');
    const rows = (data ?? []) as unknown as Array<{ key: string; value: string }>;
    const map = Object.fromEntries(rows.map((r) => [r.key, r.value]));
    return {
      principalName: map['principal_name'] ?? '',
      principalNip:  map['principal_nip']  ?? '',
    };
  } catch {
    // Jika tabel belum dibuat, kembalikan nilai kosong
    return { principalName: '', principalNip: '' };
  }
}

export default async function AdminFuzzyPage() {
  const [config, schoolSettings] = await Promise.all([
    loadFuzzy(),
    loadSchoolSettings(),
  ]);

  return (
    <div className="space-y-3">
      <PageHeader title="Konfigurasi sistem Fuzzy" />

      {/* Info banner */}
      <div className="flex items-start gap-2 rounded-md border-l-4 border-sipandu-blue bg-blue-50 px-3 py-2.5 text-sm text-sipandu-blue-deep">
        <Info className="mt-0.5 h-3.5 w-3.5 flex-shrink-0" aria-hidden />
        <p>
          Perubahan konfigurasi hanya berlaku untuk perhitungan berikutnya.
          Skor yang sudah dihitung tidak otomatis diperbarui.
        </p>
      </div>

      <FuzzyTabs
        inputContent={
          <div className="space-y-2.5">
            <InputVariableEditor
              variable="x1"
              title="X1 — Kehadiran / Absensi"
              subtitle="Semesta: 0–100 (%)"
              defaultOpen
              initialSets={config.x1}
            />
            <InputVariableEditor
              variable="x2"
              title="X2 — Poin Perilaku"
              subtitle="Semesta: 0–100"
              initialSets={config.x2}
            />
            <InputVariableEditor
              variable="x3"
              title="X3 — Nilai Teman (Peer Review)"
              subtitle="Semesta: 0–100"
              initialSets={config.x3}
            />
          </div>
        }
        outputContent={<OutputVariableEditor initialSets={config.output} />}
        ruleContent={<RuleBaseTable initialRules={[...config.rules]} />}
        simContent={<FuzzySimulator config={config} />}
        settingsContent={
          <SchoolSettingsForm
            initialPrincipalName={schoolSettings.principalName}
            initialPrincipalNip={schoolSettings.principalNip}
          />
        }
      />
    </div>
  );
}
