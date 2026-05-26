/**
 * @file app/api/export/excel/route.ts
 * @description Export laporan kelas ke file Excel (.xlsx).
 *
 *  Mendukung dua mode:
 *   - classId=<uuid>  → ekspor satu kelas (sheet: Data Siswa + Distribusi)
 *   - classId=all     → ekspor semua kelas periode (sheet per kelas + Ringkasan)
 *
 *  Nama kepala sekolah diambil dari tabel school_settings.
 */

import { type NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import * as XLSX from 'xlsx';

import { fail, failFromUnknown } from '../../_lib/response';
import { assertTeacherOrAdmin } from '../../_lib/auth';
import { createServiceRoleClient } from '@/lib/supabase/server';
import { CATEGORY_CONFIG, CATEGORY_ORDER } from '@/constants';
import type { CategoryType } from '@/types';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

const querySchema = z.object({
  classId:  z.string().min(1),
  periodId: z.string().uuid('periodId harus UUID'),
});

/* ────────────────────────────────────────────────────────────────────
 *  Tipe shared
 * ──────────────────────────────────────────────────────────────────── */

type Row = {
  nis:      string;
  name:     string;
  x1:       number | null;
  x2:       number | null;
  x3:       number | null;
  zStar:    number | null;
  category: CategoryType | null;
};

type ClassBlock = {
  className:    string;
  gradeLevel:   string | number;
  homeroomName: string;
  rows:         Row[];
};

/* ────────────────────────────────────────────────────────────────────
 *  Helper: ambil data satu kelas (enrollment + skor)
 * ──────────────────────────────────────────────────────────────────── */

async function fetchClassBlock(
  admin: Awaited<ReturnType<typeof createServiceRoleClient>>,
  assignmentId: string,
  className: string,
  gradeLevel: string | number,
  homeroomName: string,
): Promise<ClassBlock> {
  const { data: enrolls } = await admin
    .from('student_class_enrollments')
    .select('id, student:student_id (nis, full_name)')
    .eq('class_period_assignment_id', assignmentId)
    .eq('status', 'active');

  type EnrollRow = { id: string; student: { nis: string | null; full_name: string } | null };
  const enrollList = ((enrolls ?? []) as unknown as EnrollRow[]).filter((e) => e.student);
  const enrollmentIds = enrollList.map((e) => e.id);

  const { data: scoresData } =
    enrollmentIds.length > 0
      ? await admin
          .from('behavior_final_scores')
          .select('enrollment_id, x1, x2, x3, z_star, category')
          .in('enrollment_id', enrollmentIds)
      : { data: [] };

  type ScoreRow = { enrollment_id: string; x1: number|null; x2: number|null; x3: number|null; z_star: number|null; category: CategoryType|null };
  const scoreMap = new Map<string, ScoreRow>();
  for (const s of ((scoresData ?? []) as unknown as ScoreRow[])) scoreMap.set(s.enrollment_id, s);

  const rows: Row[] = enrollList
    .map((e) => {
      const s = scoreMap.get(e.id);
      return {
        nis:      e.student!.nis ?? '—',
        name:     e.student!.full_name,
        x1:       s?.x1    ?? null,
        x2:       s?.x2    ?? null,
        x3:       s?.x3    ?? null,
        zStar:    s?.z_star ?? null,
        category: s?.category ?? null,
      };
    })
    .sort((a, b) => (b.zStar ?? -1) - (a.zStar ?? -1));

  return { className, gradeLevel, homeroomName, rows };
}

/* ────────────────────────────────────────────────────────────────────
 *  Helper: buat worksheet satu kelas
 * ──────────────────────────────────────────────────────────────────── */

function buildClassSheet(
  block: ClassBlock,
  periodName: string,
  principalName: string,
  schoolName: string,
): XLSX.WorkSheet {
  const header: (string | number)[][] = [
    [`${schoolName} — Sistem Penilaian Terpadu (SiPandu)`],
    [`Kelas: ${block.className} (Tingkat ${block.gradeLevel})`],
    [`Periode: ${periodName}`],
    [`Wali Kelas: ${block.homeroomName}`],
    [],
    ['NIS', 'Nama', 'Absensi (%)', 'Poin Perilaku', 'Nilai Sejawat', 'Nilai Akhir', 'Kategori'],
  ];
  const dataRows: (string | number)[][] = block.rows.map((r) => [
    r.nis,
    r.name,
    r.x1   !== null ? Number(r.x1.toFixed(2))   : '',
    r.x2   !== null ? Number(r.x2.toFixed(2))   : '',
    r.x3   !== null ? Number(r.x3.toFixed(2))   : '',
    r.zStar !== null ? Number(r.zStar.toFixed(2)) : '',
    r.category ? CATEGORY_CONFIG[r.category].label : 'Belum Dinilai',
  ]);

  const ws = XLSX.utils.aoa_to_sheet([...header, ...dataRows]);
  ws['!cols'] = [{ wch:12 },{ wch:32 },{ wch:12 },{ wch:13 },{ wch:14 },{ wch:12 },{ wch:18 }];
  ws['!merges'] = [
    { s:{r:0,c:0}, e:{r:0,c:6} },
    { s:{r:1,c:0}, e:{r:1,c:6} },
    { s:{r:2,c:0}, e:{r:2,c:6} },
    { s:{r:3,c:0}, e:{r:3,c:6} },
  ];
  return ws;
}

/* ────────────────────────────────────────────────────────────────────
 *  Helper: buat worksheet distribusi
 * ──────────────────────────────────────────────────────────────────── */

function buildDistribSheet(block: ClassBlock, periodName: string): XLSX.WorkSheet {
  const counts: Record<CategoryType, number> = { perlu_pembinaan:0, cukup:0, baik:0, sangat_baik:0 };
  let notScored = 0;
  for (const r of block.rows) {
    if (r.category) counts[r.category]++;
    else notScored++;
  }
  const ws = XLSX.utils.aoa_to_sheet([
    [`Distribusi Kategori — ${block.className}`],
    [`Periode: ${periodName}`],
    [],
    ['Kategori', 'Jumlah'],
    ...CATEGORY_ORDER.map((cat) => [CATEGORY_CONFIG[cat].label, counts[cat]]),
    ['Belum Dinilai', notScored],
    ['Total', block.rows.length],
  ]);
  ws['!cols'] = [{ wch:25 },{ wch:10 }];
  return ws;
}

/* ────────────────────────────────────────────────────────────────────
 *  Handler GET
 * ──────────────────────────────────────────────────────────────────── */

export async function GET(req: NextRequest) {
  try {
    await assertTeacherOrAdmin();

    const { searchParams } = new URL(req.url);
    const parsed = querySchema.safeParse({
      classId:  searchParams.get('classId'),
      periodId: searchParams.get('periodId'),
    });
    if (!parsed.success) return failFromUnknown(parsed.error);

    const admin = await createServiceRoleClient();
    const isAll = parsed.data.classId === 'all';

    // ── Ambil data periode ───────────────────────────────────────
    const { data: period } = await admin
      .from('academic_periods')
      .select('id, name, academic_year, semester')
      .eq('id', parsed.data.periodId)
      .maybeSingle();
    if (!period) return fail('Periode tidak ditemukan', 404);

    // ── Ambil data kepala sekolah ────────────────────────────────
    const { data: settingsRows } = await admin
      .from('school_settings' as any)
      .select('key, value');
    const settingsMap = Object.fromEntries(
      ((settingsRows ?? []) as unknown as Array<{ key: string; value: string }>).map(
        (r) => [r.key, r.value],
      ),
    );
    const principalName = settingsMap['principal_name'] || '(Kepala Sekolah)';
    const schoolName    = 'SMAN 13 BANDUNG';

    // ── Ambil semua assignment untuk periode (filter per kelas jika bukan all) ──
    let assignQuery = admin
      .from('class_period_assignments')
      .select(`
        id,
        class:class_id (id, name, grade_level),
        homeroom:homeroom_teacher_id (full_name)
      `)
      .eq('period_id', parsed.data.periodId);

    if (!isAll) {
      assignQuery = assignQuery.eq('class_id', parsed.data.classId);
    }

    const { data: assignments } = await assignQuery;
    if (!assignments || assignments.length === 0) {
      return fail('Tidak ada kelas untuk periode ini', 404);
    }

    // ── Ambil data per kelas ─────────────────────────────────────
    type AssignRow = {
      id: string;
      class: { id: string; name: string; grade_level: string | number } | null;
      homeroom: { full_name: string } | null;
    };

    const blocks: ClassBlock[] = await Promise.all(
      (assignments as unknown as AssignRow[])
        .filter((a) => a.class)
        .sort((a, b) => (a.class!.name).localeCompare(b.class!.name))
        .map((a) =>
          fetchClassBlock(
            admin,
            a.id,
            a.class!.name,
            a.class!.grade_level,
            a.homeroom?.full_name ?? '—',
          ),
        ),
    );

    // ── Bangun workbook ──────────────────────────────────────────
    const wb = XLSX.utils.book_new();

    if (isAll) {
      // Mode: semua kelas — sheet per kelas + sheet Ringkasan lintas kelas
      for (const block of blocks) {
        // Batasi nama sheet ≤ 31 karakter (limit Excel)
        const sheetName = block.className.slice(0, 31);
        XLSX.utils.book_append_sheet(
          wb,
          buildClassSheet(block, (period as any).name, principalName, schoolName),
          sheetName,
        );
      }

      // Sheet Ringkasan: semua siswa lintas kelas diurutkan Z* desc
      const allRows: (string | number)[][] = [
        [`${schoolName} — Ringkasan Lintas Kelas`],
        [`Periode: ${(period as any).name}`],
        [`Kepala Sekolah: ${principalName}`],
        [],
        ['No', 'NIS', 'Nama', 'Kelas', 'Absensi (%)', 'Poin Perilaku', 'Nilai Sejawat', 'Nilai Akhir', 'Kategori'],
      ];
      const allStudents = blocks
        .flatMap((b) => b.rows.map((r) => ({ ...r, className: b.className })))
        .sort((a, b) => (b.zStar ?? -1) - (a.zStar ?? -1));

      allStudents.forEach((r, i) => {
        allRows.push([
          i + 1,
          r.nis,
          r.name,
          r.className,
          r.x1   !== null ? Number(r.x1.toFixed(2))    : '',
          r.x2   !== null ? Number(r.x2.toFixed(2))    : '',
          r.x3   !== null ? Number(r.x3.toFixed(2))    : '',
          r.zStar !== null ? Number(r.zStar.toFixed(2)) : '',
          r.category ? CATEGORY_CONFIG[r.category].label : 'Belum Dinilai',
        ]);
      });

      const wsAll = XLSX.utils.aoa_to_sheet(allRows);
      wsAll['!cols'] = [{ wch:5 },{ wch:12 },{ wch:28 },{ wch:10 },{ wch:12 },{ wch:13 },{ wch:14 },{ wch:12 },{ wch:18 }];
      wsAll['!merges'] = [
        { s:{r:0,c:0}, e:{r:0,c:8} },
        { s:{r:1,c:0}, e:{r:1,c:8} },
        { s:{r:2,c:0}, e:{r:2,c:8} },
      ];
      XLSX.utils.book_append_sheet(wb, wsAll, 'Ringkasan');
    } else {
      // Mode: satu kelas
      const block = blocks[0];
      XLSX.utils.book_append_sheet(
        wb,
        buildClassSheet(block, (period as any).name, principalName, schoolName),
        'Data Siswa',
      );
      XLSX.utils.book_append_sheet(
        wb,
        buildDistribSheet(block, (period as any).name),
        'Distribusi',
      );
    }

    // ── Render buffer ────────────────────────────────────────────
    const rawBuffer = XLSX.write(wb, { type: 'buffer', bookType: 'xlsx' }) as Buffer;
    const body = new Uint8Array(rawBuffer);

    const periodPart = `${(period as any).academic_year.replace('/', '-')}_${(period as any).semester}`;
    const classPart  = isAll
      ? 'Semua_Kelas'
      : blocks[0]?.className.replace(/\s+/g, '_') ?? 'Kelas';
    const filename = `SiPandu_${classPart}_${periodPart}.xlsx`;

    return new NextResponse(body, {
      status: 200,
      headers: {
        'Content-Type': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'Content-Disposition': `attachment; filename="${filename}"`,
        'Cache-Control': 'no-store',
      },
    });
  } catch (err) {
    if (err instanceof Error && /akses|login/i.test(err.message)) {
      return fail(err.message, 403);
    }
    return failFromUnknown(err);
  }
}
