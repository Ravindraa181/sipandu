'use client';

/**
 * @file admin/siswa/_components/ImportStudentDialog.tsx
 * @description Import siswa massal via file Excel (.xlsx/.csv).
 *
 * Format kolom Excel yang diharapkan (baris 1 = header):
 *   NIS | Nama Lengkap | Email | Jenis Kelamin (L/P) | Password Awal
 */

import { useRef, useState, useTransition } from 'react';
import { Upload, FileSpreadsheet, X, AlertCircle, CheckCircle2, Loader2 } from 'lucide-react';
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
  nis: string;
  fullName: string;
  email: string;
  gender: 'L' | 'P';
  password: string;
  /** Error validasi sebelum dikirim */
  validationError?: string;
}

interface ImportResult {
  nis: string;
  fullName: string;
  status: 'success' | 'error';
  message?: string;
}

function parseCSV(text: string): ParsedRow[] {
  const lines = text.trim().split('\n');
  // Skip baris header
  return lines.slice(1).map((line) => {
    // Handle quoted fields
    const cols = line.split(/,(?=(?:[^"]*"[^"]*")*[^"]*$)/).map((c) =>
      c.trim().replace(/^"|"$/g, '')
    );
    const nis = cols[0] ?? '';
    const fullName = cols[1] ?? '';
    const email = cols[2] ?? '';
    const genderRaw = (cols[3] ?? '').toUpperCase();
    const password = cols[4] ?? '';

    const gender: 'L' | 'P' = genderRaw === 'P' ? 'P' : 'L';
    let validationError: string | undefined;

    if (!nis) validationError = 'NIS kosong';
    else if (!fullName || fullName.length < 3) validationError = 'Nama terlalu pendek';
    else if (!email.includes('@')) validationError = 'Email tidak valid';
    else if (genderRaw !== 'L' && genderRaw !== 'P') validationError = 'Gender harus L atau P';
    else if (!password || password.length < 8) validationError = 'Password minimal 8 karakter';

    return { nis, fullName, email, gender, password, validationError };
  }).filter((r) => r.nis || r.fullName); // Skip baris kosong
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
      const text = ev.target?.result as string;
      const rows = parseCSV(text);
      setParsedRows(rows);
      setResults([]);
      setIsDone(false);
    };
    reader.readAsText(file, 'UTF-8');
  }

  function handleImport() {
    const validRows = parsedRows.filter((r) => !r.validationError);
    if (validRows.length === 0) return;

    startTransition(async () => {
      const importResults: ImportResult[] = [];
      for (const row of validRows) {
        const result = await createUser({
          nis: row.nis,
          fullName: row.fullName,
          email: row.email,
          gender: row.gender,
          password: row.password,
          role: 'student',
        });
        importResults.push({
          nis: row.nis,
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
          <DialogTitle>Import Siswa dari File</DialogTitle>
        </DialogHeader>

        <div className="space-y-4">
          {/* Panduan format */}
          <div className="rounded-md border border-blue-200 bg-blue-50 p-3 text-xs text-blue-800">
            <p className="mb-1 font-semibold">Format file CSV (simpan Excel as CSV):</p>
            <p className="font-mono">NIS, Nama Lengkap, Email, Jenis Kelamin (L/P), Password Awal</p>
            <p className="mt-1 text-blue-600">Baris pertama = header (akan dilewati otomatis)</p>
          </div>

          {/* Upload area */}
          {!isDone && (
            <div
              className="flex cursor-pointer flex-col items-center justify-center gap-2 rounded-md border-2 border-dashed border-gray-300 p-6 hover:border-sipandu-blue hover:bg-blue-50/40 transition-colors"
              onClick={() => fileRef.current?.click()}
            >
              <FileSpreadsheet className="h-8 w-8 text-muted-foreground" aria-hidden />
              <p className="text-sm text-muted-foreground">
                {parsedRows.length > 0
                  ? `${parsedRows.length} baris terbaca dari file`
                  : 'Klik untuk pilih file .csv'}
              </p>
              <input
                ref={fileRef}
                type="file"
                accept=".csv,.txt"
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
                <table className="w-full border-collapse">
                  <thead className="sticky top-0 bg-gray-100">
                    <tr>
                      <th className="px-2 py-1.5 text-left font-semibold">NIS</th>
                      <th className="px-2 py-1.5 text-left font-semibold">Nama</th>
                      <th className="px-2 py-1.5 text-left font-semibold">Email</th>
                      <th className="px-2 py-1.5 text-left font-semibold">L/P</th>
                      <th className="px-2 py-1.5 text-left font-semibold">Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    {parsedRows.map((r, i) => (
                      <tr key={i} className={r.validationError ? 'bg-red-50' : ''}>
                        <td className="px-2 py-1 font-mono">{r.nis}</td>
                        <td className="px-2 py-1">{r.fullName}</td>
                        <td className="px-2 py-1">{r.email}</td>
                        <td className="px-2 py-1">{r.gender}</td>
                        <td className="px-2 py-1">
                          {r.validationError ? (
                            <span className="flex items-center gap-1 text-status-err">
                              <AlertCircle className="h-3 w-3" /> {r.validationError}
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
                <table className="w-full border-collapse">
                  <thead className="sticky top-0 bg-gray-100">
                    <tr>
                      <th className="px-2 py-1.5 text-left font-semibold">NIS</th>
                      <th className="px-2 py-1.5 text-left font-semibold">Nama</th>
                      <th className="px-2 py-1.5 text-left font-semibold">Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    {results.map((r, i) => (
                      <tr key={i} className={r.status === 'error' ? 'bg-red-50' : 'bg-green-50'}>
                        <td className="px-2 py-1 font-mono">{r.nis}</td>
                        <td className="px-2 py-1">{r.fullName}</td>
                        <td className="px-2 py-1">
                          {r.status === 'success' ? (
                            <span className="text-green-700">✓ Berhasil</span>
                          ) : (
                            <span className="text-status-err">✗ {r.message}</span>
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