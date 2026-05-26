'use client';

/**
 * @file dashboard/hasil-penilaian/_components/ExportButtons.tsx
 * @description Tombol Export Excel & PDF yang memanggil API route nyata:
 *              GET /api/export/excel?classId=&periodId=  → file XLSX
 *              GET /api/export/pdf?classId=&periodId=   → file PDF
 */

import { useState } from 'react';
import { FileSpreadsheet, FileText } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';

export interface ExportButtonsProps {
  /** UUID kelas — diperlukan oleh API export. */
  classId: string;
  /** UUID periode — diperlukan oleh API export. */
  periodId: string;
}

/**
 * Memulai download file dengan membuka URL di tab yang sama.
 * Browser akan menangani header Content-Disposition: attachment secara otomatis.
 */
export function ExportButtons({ classId, periodId }: ExportButtonsProps) {
  const [loadingExcel, setLoadingExcel] = useState(false);
  const [loadingPdf, setLoadingPdf] = useState(false);

  /**
   * Helper download: fetch → blob → trigger klik.
   * Nama file diambil dari Content-Disposition response (nama dari API)
   * agar sesuai dengan format SiPandu_NamaKelas_TahunAjaran_Semester.
   */
  async function triggerDownload(
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

  /** Download file Excel (.xlsx) via API route. */
  async function handleExportExcel() {
    if (!classId || !periodId) {
      toast.error('Data kelas atau periode tidak tersedia');
      return;
    }
    setLoadingExcel(true);
    try {
      const ok = await triggerDownload(
        `/api/export/excel?classId=${classId}&periodId=${periodId}`,
        'laporan_kelas.xlsx',
        (msg) => toast.error('Gagal mengekspor Excel', { description: msg }),
      );
      if (ok) toast.success('File Excel berhasil diunduh');
    } catch {
      toast.error('Terjadi kesalahan saat mengekspor Excel');
    } finally {
      setLoadingExcel(false);
    }
  }

  /** Download file PDF via API route. */
  async function handleExportPdf() {
    if (!classId || !periodId) {
      toast.error('Data kelas atau periode tidak tersedia');
      return;
    }
    setLoadingPdf(true);
    try {
      const ok = await triggerDownload(
        `/api/export/pdf?classId=${classId}&periodId=${periodId}`,
        'laporan_kelas.pdf',
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
        disabled={loadingExcel || loadingPdf}
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
        disabled={loadingExcel || loadingPdf}
        className="gap-1.5"
      >
        <FileText className="h-3.5 w-3.5" aria-hidden />
        {loadingPdf ? 'Mengekspor...' : 'Export PDF'}
      </Button>
    </div>
  );
}
