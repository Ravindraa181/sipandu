'use client';

/**
 * @file admin/laporan/_components/ExportReportButtons.tsx
 * @description Tombol Export Excel & PDF untuk halaman Laporan Global admin.
 *              Mendukung dua mode:
 *               - classId spesifik → ekspor satu kelas
 *               - classId = 'all'  → ekspor semua kelas periode (multi-sheet / multi-section)
 *
 *              API route yang dipanggil:
 *                GET /api/export/excel?classId=...&periodId=...
 *                GET /api/export/pdf?classId=...&periodId=...
 */

import { useState } from 'react';
import { FileSpreadsheet, FileText } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';

export interface ExportReportButtonsProps {
  /** UUID kelas atau 'all' untuk semua kelas. */
  classId: string;
  /** UUID periode yang dipilih. */
  periodId: string;
}

/**
 * Download file via fetch → blob → trigger anchor click.
 * Nama file diambil dari header Content-Disposition response
 * agar sesuai dengan konvensi API (mis. SiPandu_X-A_2025-2026_ganjil.xlsx).
 */
async function downloadFile(
  url: string,
  fallbackFilename: string,
  onError: (msg: string) => void,
): Promise<boolean> {
  const res = await fetch(url);
  if (!res.ok) {
    const body = await res.json().catch(() => ({}));
    onError((body as { error?: string }).error ?? `HTTP ${res.status}`);
    return false;
  }
  const disposition = res.headers.get('content-disposition') ?? '';
  const match = disposition.match(/filename="([^"]+)"/);
  const filename = match?.[1] ?? fallbackFilename;
  const blob = await res.blob();
  const objectUrl = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = objectUrl;
  a.download = filename;
  a.click();
  URL.revokeObjectURL(objectUrl);
  return true;
}

export function ExportReportButtons({ classId, periodId }: ExportReportButtonsProps) {
  const [loadingExcel, setLoadingExcel] = useState(false);
  const [loadingPdf,   setLoadingPdf]   = useState(false);

  /** Tidak bisa export jika periode belum dipilih. */
  const canExport = Boolean(periodId);

  async function handleExportExcel() {
    if (!canExport) {
      toast.info('Pilih periode terlebih dahulu untuk mengekspor');
      return;
    }
    setLoadingExcel(true);
    try {
      const ok = await downloadFile(
        `/api/export/excel?classId=${classId}&periodId=${periodId}`,
        'laporan.xlsx',
        (msg) => toast.error('Gagal mengekspor Excel', { description: msg }),
      );
      if (ok) toast.success('File Excel berhasil diunduh');
    } catch {
      toast.error('Terjadi kesalahan saat mengekspor Excel');
    } finally {
      setLoadingExcel(false);
    }
  }

  async function handleExportPdf() {
    if (!canExport) {
      toast.info('Pilih periode terlebih dahulu untuk mengekspor');
      return;
    }
    setLoadingPdf(true);
    try {
      const ok = await downloadFile(
        `/api/export/pdf?classId=${classId}&periodId=${periodId}`,
        'laporan.pdf',
        (msg) => toast.error('Gagal mengekspor PDF', { description: msg }),
      );
      if (ok) toast.success('File PDF berhasil diunduh');
    } catch {
      toast.error('Terjadi kesalahan saat mengekspor PDF');
    } finally {
      setLoadingPdf(false);
    }
  }

  return (
    <div className="flex flex-wrap gap-2">
      <Button
        type="button"
        variant="outline"
        size="sm"
        onClick={handleExportExcel}
        disabled={loadingExcel || loadingPdf || !canExport}
        className="gap-1.5"
      >
        <FileSpreadsheet className="h-3.5 w-3.5" aria-hidden />
        {loadingExcel ? 'Mengekspor...' : 'Export Excel'}
      </Button>
      <Button
        type="button"
        variant="outline"
        size="sm"
        onClick={handleExportPdf}
        disabled={loadingExcel || loadingPdf || !canExport}
        className="gap-1.5"
      >
        <FileText className="h-3.5 w-3.5" aria-hidden />
        {loadingPdf ? 'Mengekspor...' : 'Export PDF'}
      </Button>
    </div>
  );
}
