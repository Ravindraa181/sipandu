'use client';

/**
 * @file dashboard/hasil-penilaian/_components/RecalculateButton.tsx
 * @description Tombol "Hitung / Perbarui Nilai Akhir" yang memanggil
 *              /api/fuzzy/recalculate-class untuk menjalankan engine fuzzy
 *              Mamdani atas semua siswa di kelas.
 *
 *  Prasyarat agar kalkulasi berhasil per-siswa:
 *   - Minimal satu bulan kehadiran sudah dikunci (X1)
 *   - student_behavior_scores sudah ada (X2 — otomatis saat transaksi diinput)
 *   - student_x3_scores sudah ada (X3 — dari seed dummy atau setelah sesi ditutup)
 *
 *  Setelah berhasil halaman di-reload penuh agar data terbaru muncul.
 */

import { useState } from 'react';
import { RefreshCw } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import { cn } from '@/lib/utils/cn';

export interface RecalculateButtonProps {
  classId: string;
  periodId: string;
}

export function RecalculateButton({ classId, periodId }: RecalculateButtonProps) {
  const [loading, setLoading] = useState(false);

  async function handleRecalculate() {
    setLoading(true);
    try {
      const res = await fetch('/api/fuzzy/recalculate-class', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ classId, periodId }),
      });

      const json = await res.json().catch(() => null);

      if (!res.ok || !json?.ok) {
        toast.error('Gagal menghitung nilai', {
          description: json?.error ?? `HTTP ${res.status}`,
        });
        return;
      }

      const { processed, success, failed } = json.data as {
        processed: number;
        success: number;
        failed: number;
      };

      if (success === 0 && processed > 0) {
        toast.warning('Tidak ada siswa yang berhasil dihitung', {
          description:
            `${failed} siswa gagal. Pastikan minimal 1 bulan kehadiran sudah dikunci ` +
            'dan sesi peer review sudah ditutup.',
          duration: 6000,
        });
        return;
      }

      toast.success(
        `Nilai berhasil dihitung untuk ${success} dari ${processed} siswa`,
        {
          description:
            failed > 0
              ? `${failed} siswa belum bisa dihitung (data belum lengkap).`
              : 'Semua siswa berhasil dihitung.',
        },
      );

      // ALASAN: reload penuh agar Server Component mengambil data terbaru
      // dari behavior_final_scores yang baru saja diupdate.
      window.location.reload();
    } catch (err) {
      toast.error('Terjadi kesalahan jaringan', {
        description: err instanceof Error ? err.message : String(err),
      });
    } finally {
      setLoading(false);
    }
  }

  return (
    <Button
      type="button"
      onClick={handleRecalculate}
      disabled={loading}
      size="sm"
      className="gap-1.5 bg-sipandu-blue text-white hover:bg-sipandu-blue/90"
    >
      <RefreshCw
        className={cn('h-3.5 w-3.5', loading && 'animate-spin')}
        aria-hidden
      />
      {loading ? 'Menghitung...' : 'Hitung / Perbarui Nilai Akhir'}
    </Button>
  );
}
