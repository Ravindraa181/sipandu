'use client';

/**
 * @file admin/guru/_components/ImportTeacherDialog.tsx
 * @description Dialog import guru massal via file Excel (.xlsx/.xls).
 *
 * Format kolom yang diharapkan (baris 1 = header, baris 2+ = data):
 *   A: NIP  |  B: Nama Lengkap  |  C: Email  |  D: Password (opsional, default "12345678")
 */

import { useRef, useState, useTransition } from 'react';
import { Upload, Download, AlertCircle, CheckCircle2, X } from 'lucide-react';
import * as XLSX from 'xlsx';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import { createTeacher } from '@/lib/actions/admin';

interface RowResult {
  nip: string;
  name: string;
  status: 'success' | 'error';
  message?: string;
}

export function ImportTeacherDialog() {
  const [open, setOpen] = useState(false);
  const [results, setResults] = useState<RowResult[]>([]);
  const [isParsed, setIsParsed] = useState(false);
  const [rows, setRows] = useState<{ nip: string; name: string; email: string; password: string }[]>([]);
  const [isPending, startTransition] = useTransition();
  const fileRef = useRef<HTMLInputElement>(null);

  function handleFileChange(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (evt) => {
      try {
        const data = new Uint8Array(evt.target!.result as ArrayBuffer);
        const workbook = XLSX.read(data, { type: 'array' });
        const sheet = workbook.Sheets[workbook.SheetNames[0]];
        const json = XLSX.utils.sheet_to_json<string[]>(sheet, { header: 1 });

        const parsed = (json as string[][])
          .slice(1) // skip header row
          .filter((r) => r.length >= 3 && r[0] && r[1] && r[2])
          .map((r) => ({
            nip: String(r[0]).trim(),
            name: String(r[1]).trim(),
            email: String(r[2]).trim(),
            password: r[3] ? String(r[3]).trim() : '12345678',
          }));

        if (parsed.length === 0) {
          toast.error('File tidak memiliki data valid. Pastikan format sesuai template.');
          return;
        }

        setRows(parsed);
        setResults([]);
        setIsParsed(true);
      } catch {
        toast.error('Gagal membaca file. Pastikan format file adalah .xlsx atau .xls');
      }
    };
    reader.readAsArrayBuffer(file);
  }

  function handleImport() {
    startTransition(async () => {
      const resultList: RowResult[] = [];
      for (const row of rows) {
        const res = await createTeacher({
          nip: row.nip,
          fullName: row.name,
          email: row.email,
          password: row.password,
        });
        resultList.push({
          nip: row.nip,
          name: row.name,
          status: res.ok ? 'success' : 'error',
          message: res.ok ? undefined : res.error,
        });
      }
      setResults(resultList);
      setIsParsed(false);
      setRows([]);
      if (fileRef.current) fileRef.current.value = '';

      const successCount = resultList.filter((r) => r.status === 'success').length;
      const failCount = resultList.filter((r) => r.status === 'error').length;
      if (successCount > 0)
        toast.success(`${successCount} guru berhasil diimport`);
      if (failCount > 0)
        toast.error(`${failCount} guru gagal diimport`);
    });
  }

  function handleDownloadTemplate() {
    const ws = XLSX.utils.aoa_to_sheet([
      ['NIP', 'Nama Lengkap', 'Email', 'Password (opsional)'],
      ['196501010001', 'Contoh Guru', 'contoh@sman13bdg.sch.id', '12345678'],
    ]);
    ws['!cols'] = [{ wch: 18 }, { wch: 28 }, { wch: 32 }, { wch: 20 }];
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Template Guru');
    XLSX.writeFile(wb, 'template_import_guru.xlsx');
  }

  function handleClose() {
    setOpen(false);
    setIsParsed(false);
    setRows([]);
    setResults([]);
    if (fileRef.current) fileRef.current.value = '';
  }

  const successCount = results.filter((r) => r.status === 'success').length;
  const failCount = results.filter((r) => r.status === 'error').length;

  return (
    <Dialog open={open} onOpenChange={(o) => { if (!o) handleClose(); else setOpen(true); }}>
      <DialogTrigger asChild>
        <Button variant="outline" className="gap-1.5">
          <Upload className="h-3.5 w-3.5" aria-hidden /> Import Excel
        </Button>
      </DialogTrigger>

      <DialogContent className="max-w-xl">
        <DialogHeader>
          <DialogTitle>Import Guru dari Excel</DialogTitle>
        </DialogHeader>

        <div className="space-y-4">
          {/* Template download */}
          <div className="flex items-center justify-between rounded-md border border-sipandu-border bg-blue-50 px-3 py-2.5">
            <p className="text-xs text-muted-foreground">
              Kolom: <strong>NIP · Nama Lengkap · Email · Password</strong> (opsional)
            </p>
            <Button variant="ghost" size="sm" className="h-7 gap-1 text-xs" onClick={handleDownloadTemplate}>
              <Download className="h-3 w-3" /> Template
            </Button>
          </div>

          {/* File input */}
          <div>
            <label className="mb-1.5 block text-xs font-semibold text-muted-foreground">
              Pilih File Excel
            </label>
            <input
              ref={fileRef}
              type="file"
              accept=".xlsx,.xls"
              onChange={handleFileChange}
              className="w-full rounded-md border border-sipandu-border px-3 py-2 text-sm file:mr-3 file:rounded file:border-0 file:bg-sipandu-navy file:px-2 file:py-1 file:text-xs file:font-medium file:text-white"
            />
          </div>

          {/* Preview sebelum import */}
          {isParsed && rows.length > 0 && (
            <div className="space-y-2">
              <p className="text-xs font-semibold text-muted-foreground">
                Preview: {rows.length} baris siap diimport
              </p>
              <div className="max-h-44 overflow-y-auto rounded-md border border-sipandu-border">
                <table className="w-full table-fixed border-collapse text-xs">
                  <thead className="sticky top-0 bg-gray-100">
                    <tr className="text-left">
                      <th className="w-[30%] px-2.5 py-2 font-semibold">NIP</th>
                      <th className="w-[32%] px-2.5 py-2 font-semibold">Nama</th>
                      <th className="w-[38%] px-2.5 py-2 font-semibold">Email</th>
                    </tr>
                  </thead>
                  <tbody>
                    {rows.map((r, i) => (
                      <tr key={i} className="border-t border-gray-100">
                        <td className="truncate px-2.5 py-1.5 font-mono" title={r.nip}>
                          {r.nip}
                        </td>
                        <td className="truncate px-2.5 py-1.5" title={r.name}>
                          {r.name}
                        </td>
                        <td
                          className="truncate px-2.5 py-1.5 text-muted-foreground"
                          title={r.email}
                        >
                          {r.email}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
              <Button className="w-full" onClick={handleImport} disabled={isPending}>
                {isPending ? 'Mengimport...' : `Import ${rows.length} Guru`}
              </Button>
            </div>
          )}

          {/* Hasil import */}
          {results.length > 0 && (
            <div className="space-y-2">
              <div className="flex items-center gap-3 text-xs">
                {successCount > 0 && (
                  <span className="flex items-center gap-1 text-green-700">
                    <CheckCircle2 className="h-3.5 w-3.5" /> {successCount} berhasil
                  </span>
                )}
                {failCount > 0 && (
                  <span className="flex items-center gap-1 text-red-600">
                    <X className="h-3.5 w-3.5" /> {failCount} gagal
                  </span>
                )}
              </div>
              {failCount > 0 && (
                <div className="max-h-40 overflow-y-auto rounded-md border border-red-200 bg-red-50">
                  {results.filter((r) => r.status === 'error').map((r, i) => (
                    <div key={i} className="flex items-start gap-2 border-b border-red-100 px-3 py-2 last:border-b-0">
                      <AlertCircle className="mt-0.5 h-3.5 w-3.5 flex-shrink-0 text-red-500" />
                      <div className="text-xs">
                        <span className="font-medium">{r.name}</span>
                        <span className="ml-1 text-muted-foreground">({r.nip})</span>
                        <p className="text-red-600">{r.message}</p>
                      </div>
                    </div>
                  ))}
                </div>
              )}
              <Button variant="outline" className="w-full" onClick={handleClose}>
                Selesai
              </Button>
            </div>
          )}
        </div>
      </DialogContent>
    </Dialog>
  );
}
