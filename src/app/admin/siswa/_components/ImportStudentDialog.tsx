'use client';

/**
 * @file admin/siswa/_components/ImportStudentDialog.tsx
 * @description Import siswa massal via file Excel (.xlsx/.xls).
 *
 * Format kolom Excel yang diharapkan (baris 1 = header, baris 2+ = data):
 *   A: NISN  |  B: Nama Lengkap  |  C: Email  |  D: Jenis Kelamin (L/P)  |  E: Password Awal
 *
 * NISN = Nomor Induk Siswa Nasional (10 digit angka).
 */

import { useRef, useState, useTransition } from 'react';
import {
  Upload,
  Download,
  FileSpreadsheet,
  X,
  AlertCircle,
  CheckCircle2,
  Loader2,
} from 'lucide-react';
import * as XLSX from 'xlsx';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import { createUser } from '@/lib/actions/admin';

interface ParsedRow {
  nisn: string;
  fullName: string;
  email: string;
  gender: 'L' | 'P';
  password: string;
  /** Error validasi sebelum dikirim. */
  validationError?: string;
}

interface ImportResult {
  nisn: string;
  fullName: string;
  status: 'success' | 'error';
  message?: string;
}

/** Parse worksheet Excel (array-of-arrays) menjadi baris siswa tervalidasi. */
function parseRows(rows: unknown[][]): ParsedRow[] {
  return rows
    .slice(1) // lewati baris header
    .map((cols) => {
      const nisn = cols[0] != null ? String(cols[0]).trim() : '';
      const fullName = cols[1] != null ? String(cols[1]).trim() : '';
      const email = cols[2] != null ? String(cols[2]).trim() : '';
      const genderRaw = (cols[3] != null ? String(cols[3]).trim() : '').toUpperCase();
      const password = cols[4] != null ? String(cols[4]).trim() : '';

      const gender: 'L' | 'P' = genderRaw === 'P' ? 'P' : 'L';
      let validationError: string | undefined;

      if (!/^\d{10}$/.test(nisn)) validationError = 'NISN harus 10 digit angka';
      else if (!fullName || fullName.length < 3) validationError = 'Nama terlalu pendek';
      else if (!email.includes('@')) validationError = 'Email tidak valid';
      else if (genderRaw !== 'L' && genderRaw !== 'P') validationError = 'Gender harus L atau P';
      else if (!password || password.length < 8) validationError = 'Password minimal 8 karakter';

      return { nisn, fullName, email, gender, password, validationError };
    })
    .filter((r) => r.nisn || r.fullName); // buang baris kosong
}

export function ImportStudentDialog() {
  const [open, setOpen] = useState(false);
  const [pending, startTransition] = useTransition();
  const [parsedRows, setParsedRows] = useState<ParsedRow[]>([]);
  const [results, setResults] = useState<ImportResult[]>([]);
  const [isDone, setIsDone] = useState(false);
  const fileRef = useRef<HTMLInputElement>(null);

  function handleFileChange(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (ev) => {
      try {
        const data = new Uint8Array(ev.target!.result as ArrayBuffer);
        const workbook = XLSX.read(data, { type: 'array' });
        const sheet = workbook.Sheets[workbook.SheetNames[0]];
        const json = XLSX.utils.sheet_to_json<unknown[]>(sheet, { header: 1 });

        const rows = parseRows(json as unknown[][]);
        if (rows.length === 0) {
          toast.error('File tidak memiliki data valid. Pastikan format sesuai template.');
          return;
        }

        setParsedRows(rows);
        setResults([]);
        setIsDone(false);
      } catch {
        toast.error('Gagal membaca file. Pastikan format file adalah .xlsx atau .xls');
      }
    };
    reader.readAsArrayBuffer(file);
  }

  function handleImport() {
    const validRows = parsedRows.filter((r) => !r.validationError);
    if (validRows.length === 0) return;

    startTransition(async () => {
      const importResults: ImportResult[] = [];
      for (const row of validRows) {
        const result = await createUser({
          nisn: row.nisn,
          fullName: row.fullName,
          email: row.email,
          gender: row.gender,
          password: row.password,
          role: 'student',
        });
        importResults.push({
          nisn: row.nisn,
          fullName: row.fullName,
          status: result.ok ? 'success' : 'error',
          message: result.ok ? undefined : result.error,
        });
      }
      setResults(importResults);
      setIsDone(true);

      const successCount = importResults.filter((r) => r.status === 'success').length;
      const failCount = importResults.filter((r) => r.status === 'error').length;
      if (failCount === 0) {
        toast.success(`${successCount} siswa berhasil diimpor`);
      } else {
        toast.warning(`${successCount} berhasil, ${failCount} gagal`);
      }
    });
  }

  function handleDownloadTemplate() {
    const ws = XLSX.utils.aoa_to_sheet([
      ['NISN', 'Nama Lengkap', 'Email', 'Jenis Kelamin (L/P)', 'Password Awal'],
      ['0012345678', 'Contoh Siswa', 'siswa@sman13bdg.sch.id', 'L', 'password123'],
    ]);
    ws['!cols'] = [{ wch: 14 }, { wch: 28 }, { wch: 32 }, { wch: 18 }, { wch: 16 }];
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Template Siswa');
    XLSX.writeFile(wb, 'template_import_siswa.xlsx');
  }

  function handleClose(o: boolean) {
    if (!o) {
      setParsedRows([]);
      setResults([]);
      setIsDone(false);
      if (fileRef.current) fileRef.current.value = '';
    }
    setOpen(o);
  }

  const validCount = parsedRows.filter((r) => !r.validationError).length;
  const invalidCount = parsedRows.filter((r) => r.validationError).length;

  return (
    <Dialog open={open} onOpenChange={handleClose}>
      <DialogTrigger asChild>
        <Button variant="outline" className="gap-1.5">
          <Upload className="h-3.5 w-3.5" aria-hidden /> Import Excel
        </Button>
      </DialogTrigger>

      <DialogContent className="max-w-[600px]">
        <DialogHeader>
          <DialogTitle>Import Siswa dari Excel</DialogTitle>
        </DialogHeader>

        <div className="space-y-4">
          {/* Panduan format + unduh template */}
          <div className="flex items-center justify-between gap-3 rounded-md border border-blue-200 bg-blue-50 p-3 text-xs text-blue-800">
            <div>
              <p className="mb-1 font-semibold">Format kolom file Excel (.xlsx):</p>
              <p className="font-mono">
                NISN · Nama Lengkap · Email · Jenis Kelamin (L/P) · Password Awal
              </p>
              <p className="mt-1 text-blue-600">
                Baris pertama = header (dilewati otomatis). NISN = 10 digit angka.
              </p>
            </div>
            <Button
              variant="ghost"
              size="sm"
              className="h-7 shrink-0 gap-1 text-xs"
              onClick={handleDownloadTemplate}
            >
              <Download className="h-3 w-3" /> Template
            </Button>
          </div>

          {/* Upload area */}
          {!isDone && (
            <div
              className="flex cursor-pointer flex-col items-center justify-center gap-2 rounded-md border-2 border-dashed border-gray-300 p-6 transition-colors hover:border-sipandu-blue hover:bg-blue-50/40"
              onClick={() => fileRef.current?.click()}
            >
              <FileSpreadsheet className="h-8 w-8 text-muted-foreground" aria-hidden />
              <p className="text-sm text-muted-foreground">
                {parsedRows.length > 0
                  ? `${parsedRows.length} baris terbaca dari file`
                  : 'Klik untuk pilih file .xlsx / .xls'}
              </p>
              <input
                ref={fileRef}
                type="file"
                accept=".xlsx,.xls"
                className="hidden"
                onChange={handleFileChange}
              />
            </div>
          )}

          {/* Preview validasi */}
          {parsedRows.length > 0 && !isDone && (
            <div className="space-y-1.5">
              <div className="flex gap-3 text-xs">
                <span className="flex items-center gap-1 text-green-700">
                  <CheckCircle2 className="h-3.5 w-3.5" /> {validCount} valid
                </span>
                {invalidCount > 0 && (
                  <span className="flex items-center gap-1 text-status-err">
                    <X className="h-3.5 w-3.5" /> {invalidCount} ada error
                  </span>
                )}
              </div>
              <div className="max-h-48 overflow-y-auto rounded-md border border-sipandu-border text-xs">
                <table className="w-full table-fixed border-collapse">
                  <thead className="sticky top-0 bg-gray-100">
                    <tr className="text-left">
                      <th className="w-[18%] px-2.5 py-2 font-semibold">NISN</th>
                      <th className="w-[22%] px-2.5 py-2 font-semibold">Nama</th>
                      <th className="w-[30%] px-2.5 py-2 font-semibold">Email</th>
                      <th className="w-[8%] px-2.5 py-2 text-center font-semibold">L/P</th>
                      <th className="w-[22%] px-2.5 py-2 font-semibold">Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    {parsedRows.map((r, i) => (
                      <tr
                        key={i}
                        className={`border-t border-gray-100 align-top ${r.validationError ? 'bg-red-50' : ''}`}
                      >
                        <td className="truncate px-2.5 py-1.5 font-mono" title={r.nisn}>
                          {r.nisn}
                        </td>
                        <td className="truncate px-2.5 py-1.5" title={r.fullName}>
                          {r.fullName}
                        </td>
                        <td
                          className="truncate px-2.5 py-1.5 text-muted-foreground"
                          title={r.email}
                        >
                          {r.email}
                        </td>
                        <td className="px-2.5 py-1.5 text-center">{r.gender}</td>
                        <td className="px-2.5 py-1.5">
                          {r.validationError ? (
                            <span className="flex items-start gap-1 leading-tight text-status-err">
                              <AlertCircle className="mt-0.5 h-3 w-3 shrink-0" />
                              <span>{r.validationError}</span>
                            </span>
                          ) : (
                            <span className="text-green-700">✓ OK</span>
                          )}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* Hasil import */}
          {isDone && results.length > 0 && (
            <div className="space-y-1.5">
              <p className="text-xs font-semibold text-foreground">Hasil import:</p>
              <div className="max-h-56 overflow-y-auto rounded-md border border-sipandu-border text-xs">
                <table className="w-full table-fixed border-collapse">
                  <thead className="sticky top-0 bg-gray-100">
                    <tr className="text-left">
                      <th className="w-[24%] px-2.5 py-2 font-semibold">NISN</th>
                      <th className="w-[30%] px-2.5 py-2 font-semibold">Nama</th>
                      <th className="w-[46%] px-2.5 py-2 font-semibold">Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    {results.map((r, i) => (
                      <tr
                        key={i}
                        className={`border-t border-gray-100 align-top ${r.status === 'error' ? 'bg-red-50' : 'bg-green-50'}`}
                      >
                        <td className="truncate px-2.5 py-1.5 font-mono" title={r.nisn}>
                          {r.nisn}
                        </td>
                        <td className="truncate px-2.5 py-1.5" title={r.fullName}>
                          {r.fullName}
                        </td>
                        <td className="px-2.5 py-1.5">
                          {r.status === 'success' ? (
                            <span className="text-green-700">✓ Berhasil</span>
                          ) : (
                            <span className="leading-tight text-status-err">✗ {r.message}</span>
                          )}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}
        </div>

        <DialogFooter className="gap-2 sm:gap-2">
          <Button type="button" variant="outline" onClick={() => handleClose(false)}>
            {isDone ? 'Tutup' : 'Batal'}
          </Button>
          {!isDone && (
            <Button
              type="button"
              onClick={handleImport}
              disabled={pending || validCount === 0}
              className="bg-sipandu-blue text-white hover:bg-sipandu-blue/90"
            >
              {pending && <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" aria-hidden />}
              Import {validCount > 0 ? `${validCount} Siswa` : ''}
            </Button>
          )}
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
