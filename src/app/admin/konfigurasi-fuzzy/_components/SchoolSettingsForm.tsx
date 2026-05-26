'use client';

/**
 * @file admin/konfigurasi-fuzzy/_components/SchoolSettingsForm.tsx
 * @description Form pengaturan sekolah: nama kepala sekolah dan NIP.
 *              Data ini digunakan otomatis di semua ekspor PDF dan Excel.
 */

import { useState, useTransition } from 'react';
import { Loader2, Save } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { updateSchoolSettings } from '@/lib/actions/admin';

export interface SchoolSettingsFormProps {
  /** Nama kepala sekolah yang sudah tersimpan (bisa kosong). */
  initialPrincipalName: string;
  /** NIP kepala sekolah yang sudah tersimpan (bisa kosong). */
  initialPrincipalNip: string;
}

export function SchoolSettingsForm({
  initialPrincipalName,
  initialPrincipalNip,
}: SchoolSettingsFormProps) {
  const [pending, startTransition] = useTransition();
  const [principalName, setPrincipalName] = useState(initialPrincipalName);
  const [principalNip, setPrincipalNip]   = useState(initialPrincipalNip);

  function handleSave() {
    startTransition(async () => {
      const result = await updateSchoolSettings({
        principalName: principalName.trim(),
        principalNip:  principalNip.trim(),
      });
      if (result.ok) {
        toast.success('Pengaturan sekolah berhasil disimpan');
      } else {
        toast.error('Gagal menyimpan', { description: result.error });
      }
    });
  }

  return (
    <div className="rounded-md border border-sipandu-border bg-white p-3.5">
      <div className="mb-3">
        <div className="text-base font-bold text-foreground">
          Pengaturan Sekolah
        </div>
        <p className="mt-0.5 text-xs text-muted-foreground">
          Data ini akan muncul otomatis pada dokumen PDF dan Excel yang diekspor
          dari halaman Laporan Global maupun Hasil Penilaian.
        </p>
      </div>

      <div className="space-y-4 max-w-md">
        <div className="space-y-1.5">
          <Label htmlFor="principal-name" className="text-sm font-medium">
            Nama Kepala Sekolah
          </Label>
          <Input
            id="principal-name"
            value={principalName}
            onChange={(e) => setPrincipalName(e.target.value)}
            placeholder="Contoh: Drs. Ahmad Fauzi, M.Pd."
            disabled={pending}
          />
        </div>

        <div className="space-y-1.5">
          <Label htmlFor="principal-nip" className="text-sm font-medium">
            NIP Kepala Sekolah
          </Label>
          <Input
            id="principal-nip"
            value={principalNip}
            onChange={(e) => setPrincipalNip(e.target.value)}
            placeholder="Contoh: 196501011990031002"
            disabled={pending}
          />
          <p className="text-xs text-muted-foreground">
            Masukkan NIP lengkap tanpa spasi atau tanda pemisah.
          </p>
        </div>

        <Button
          type="button"
          size="sm"
          onClick={handleSave}
          disabled={pending}
          className="gap-1.5 bg-sipandu-blue text-white hover:bg-sipandu-blue/90"
        >
          {pending ? (
            <Loader2 className="h-3 w-3 animate-spin" aria-hidden />
          ) : (
            <Save className="h-3 w-3" aria-hidden />
          )}
          Simpan Pengaturan
        </Button>
      </div>
    </div>
  );
}
