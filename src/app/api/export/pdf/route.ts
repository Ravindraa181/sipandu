/**
 * @file app/api/export/pdf/route.ts
 * @description Export laporan kelas ke PDF (jspdf + jspdf-autotable).
 *
 *  Mendukung dua mode:
 *   - classId=<uuid>  → satu kelas: tabel siswa + distribusi + tanda tangan
 *   - classId=all     → semua kelas periode: per kelas satu section, tanda tangan di akhir
 *
 *  Nama & NIP kepala sekolah dibaca otomatis dari tabel school_settings.
 */

import { type NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { jsPDF } from 'jspdf';
import autoTable from 'jspdf-autotable';

import { fail, failFromUnknown } from '../../_lib/response';
import { assertTeacherOrAdmin } from '../../_lib/auth';
import { createServiceRoleClient } from '@/lib/supabase/server';
import { CATEGORY_CONFIG, CATEGORY_ORDER } from '@/constants';
import type { CategoryType } from '@/types';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

const querySchema = z.object({
  classId:  z.string().min(1),
  periodId: z.string().uuid(),
});

/* ────────────────────────────────────────────────────────────────────
 *  Helper: format tanggal Bahasa Indonesia
 * ──────────────────────────────────────────────────────────────────── */

const ID_MONTHS = ['Januari','Februari','Maret','April','Mei','Juni','Juli','Agustus','September','Oktober','November','Desember'];
function formatDateID(d = new Date()): string {
  return `${d.getDate()} ${ID_MONTHS[d.getMonth()]} ${d.getFullYear()}`;
}

/* ────────────────────────────────────────────────────────────────────
 *  Tipe shared
 * ──────────────────────────────────────────────────────────────────── */

type ScoreRow = {
  nis:         string;
  name:        string;
  x1:          string;
  x2:          string;
  x3:          string;
  zStar:       string;
  category:    string;
  categoryKey: CategoryType | null;
};

type ClassBlock = {
  className:    string;
  gradeLevel:   string | number;
  periodName:   string;
  academicYear: string;
  semester:     string;
  homeroomName: string;
  homeroomNip:  string;
  rows:         ScoreRow[];
};

/* ────────────────────────────────────────────────────────────────────
 *  Helper: ambil data satu kelas
 * ──────────────────────────────────────────────────────────────────── */

async function fetchClassBlock(
  admin: Awaited<ReturnType<typeof createServiceRoleClient>>,
  assignmentId: string,
  className: string,
  gradeLevel: string | number,
  periodName: string,
  academicYear: string,
  semester: string,
  homeroomName: string,
  homeroomNip:  string,
): Promise<ClassBlock> {
  const fmt = (n: number | null | undefined): string =>
    n === null || n === undefined ? '—' : Number(n).toFixed(2);

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

  type SR = { enrollment_id: string; x1: number|null; x2: number|null; x3: number|null; z_star: number|null; category: CategoryType|null };
  const scoreMap = new Map<string, SR>();
  for (const s of ((scoresData ?? []) as unknown as SR[])) scoreMap.set(s.enrollment_id, s);

  const rows: ScoreRow[] = enrollList
    .map((e) => {
      const s = scoreMap.get(e.id);
      return {
        nis:         e.student!.nis ?? '—',
        name:        e.student!.full_name,
        x1:          fmt(s?.x1),
        x2:          fmt(s?.x2),
        x3:          fmt(s?.x3),
        zStar:       fmt(s?.z_star),
        category:    s?.category ? CATEGORY_CONFIG[s.category].label : 'Belum Dinilai',
        categoryKey: s?.category ?? null,
      };
    })
    .sort((a, b) => Number(b.zStar) - Number(a.zStar));

  return { className, gradeLevel, periodName, academicYear, semester, homeroomName, homeroomNip, rows };
}

/* ────────────────────────────────────────────────────────────────────
 *  Helper: tulis section satu kelas ke dalam doc yang sudah ada
 *  Mengembalikan cursorY setelah section selesai.
 * ──────────────────────────────────────────────────────────────────── */

interface AutoTableDoc extends jsPDF { lastAutoTable?: { finalY: number } }

function appendClassSection(
  doc: jsPDF,
  block: ClassBlock,
  margin: number,
  /** Y awal: diteruskan dari caller agar tidak menimpa header yang sudah dicetak */
  startY: number,
  isFirstSection: boolean,
): number {
  const pageW  = doc.internal.pageSize.getWidth();
  // ALASAN: isFirstSection meneruskan posisi cursor dari header sekolah;
  // isFirstSection=false berarti halaman baru, mulai dari margin atas.
  let   cursor = isFirstSection ? startY : margin;

  if (!isFirstSection) {
    // Mulai halaman baru untuk setiap kelas tambahan
    doc.addPage();
  }

  // Sub-header nama kelas
  doc.setFont('helvetica', 'bold');
  doc.setFontSize(11);
  doc.text(`Kelas ${block.className}`, margin, cursor);
  cursor += 14;

  // Identitas kelas
  doc.setFontSize(9);
  const idLines: [string, string][] = [
    ['Kelas',        `${block.className} (Tingkat ${block.gradeLevel})`],
    ['Periode',      block.periodName],
    ['Tahun Ajaran', `${block.academicYear} — Semester ${block.semester}`],
    ['Wali Kelas',   block.homeroomName],
  ];
  for (const [label, value] of idLines) {
    doc.setFont('helvetica', 'bold');
    doc.text(label, margin, cursor);
    doc.setFont('helvetica', 'normal');
    doc.text(`: ${value}`, margin + 72, cursor);
    cursor += 11;
  }
  cursor += 6;

  // Tabel siswa
  autoTable(doc, {
    startY: cursor,
    head: [['No', 'NIS', 'Nama', 'Absensi (%)', 'Poin', 'Nilai Sejawat', 'Nilai Akhir', 'Kategori']],
    body: block.rows.map((r, i) => [i+1, r.nis, r.name, r.x1, r.x2, r.x3, r.zStar, r.category]),
    styles:            { fontSize: 8, cellPadding: 3 },
    headStyles:        { fillColor: [30, 58, 95], textColor: 255, halign: 'center' },
    alternateRowStyles:{ fillColor: [243, 244, 246] },
    columnStyles: {
      0: { halign: 'center', cellWidth: 20  },
      1: { halign: 'center', cellWidth: 50  },   // NIS
      2: { cellWidth: 'auto'               },   // Nama — mengisi sisa ruang
      3: { halign: 'right',  cellWidth: 48  },   // Absensi (%) — lebih lebar agar header muat 1 baris
      4: { halign: 'right',  cellWidth: 36  },   // Poin — dinaikkan dari 28 agar 100.00 tidak wrap
      5: { halign: 'right',  cellWidth: 46  },   // Nilai Sejawat
      6: { halign: 'right',  cellWidth: 42  },   // Nilai Akhir
      7: { halign: 'center', cellWidth: 68  },   // Kategori
    },
    margin: { left: margin, right: margin },
  });

  cursor = (doc as AutoTableDoc).lastAutoTable?.finalY ?? cursor + block.rows.length * 12;
  cursor += 14;

  // Distribusi kategori kelas
  const distrib: Record<CategoryType, number> = { perlu_pembinaan:0, cukup:0, baik:0, sangat_baik:0 };
  let notScored = 0;
  for (const r of block.rows) {
    if (r.categoryKey) distrib[r.categoryKey]++;
    else notScored++;
  }

  doc.setFont('helvetica', 'bold');
  doc.setFontSize(10);
  doc.text('Ringkasan Distribusi Kategori', margin, cursor);
  cursor += 8;
  doc.setFont('helvetica', 'normal');

  autoTable(doc, {
    startY: cursor,
    head: [['Kategori', 'Jumlah Siswa']],
    body: [
      ...CATEGORY_ORDER.map((cat) => [CATEGORY_CONFIG[cat].label, String(distrib[cat])]),
      ['Belum Dinilai', String(notScored)],
      ['Total', String(block.rows.length)],
    ],
    styles:     { fontSize: 8, cellPadding: 3 },
    headStyles: { fillColor: [45, 125, 210], textColor: 255 },
    margin:     { left: margin, right: margin },
    tableWidth: 220,
  });

  cursor = (doc as AutoTableDoc).lastAutoTable?.finalY ?? cursor + 60;

  // Tanda tangan wali kelas (hanya di mode satu kelas, di mode all di halaman terakhir)
  return cursor;
}

/* ────────────────────────────────────────────────────────────────────
 *  Helper: tulis blok tanda tangan
 * ──────────────────────────────────────────────────────────────────── */

function appendSignature(
  doc:           jsPDF,
  margin:        number,
  homeroomName:  string,
  homeroomNip:   string,
  principalName: string,
  principalNip:  string,
  startY:        number,
): void {
  const pageW = doc.internal.pageSize.getWidth();
  const colW  = (pageW - margin * 2) / 2;
  let   y     = startY + 28;

  // Jika terlalu dekat bawah halaman, buat halaman baru
  if (y > 720) {
    doc.addPage();
    y = margin + 20;
  }

  doc.setFontSize(9);
  doc.setFont('helvetica', 'normal');
  doc.text('Mengetahui,',            margin,        y);
  doc.text(`Bandung, ${formatDateID()}`, margin + colW, y);
  y += 11;
  doc.text('Kepala SMAN 13 Bandung', margin,        y);
  doc.text('Wali Kelas',             margin + colW, y);

  y += 52;
  doc.line(margin,        y, margin + 160,        y);
  doc.line(margin + colW, y, margin + colW + 160, y);
  y += 11;

  doc.setFont('helvetica', 'bold');
  const displayPrincipal = principalName || '(....................................)';
  const displayHomeroom  = homeroomName  || '(....................................)';
  doc.text(`(${displayPrincipal})`, margin,        y);
  doc.text(`(${displayHomeroom})`,  margin + colW, y);
  y += 11;

  doc.setFont('helvetica', 'normal');
  doc.text(`NIP. ${principalNip || '........................'}`, margin,        y);
  doc.text(`NIP. ${homeroomNip  || '........................'}`, margin + colW, y);
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

    // ── Periode ──────────────────────────────────────────────────
    const { data: period } = await admin
      .from('academic_periods')
      .select('id, name, academic_year, semester')
      .eq('id', parsed.data.periodId)
      .maybeSingle();
    if (!period) return fail('Periode tidak ditemukan', 404);

    // ── Kepala sekolah ───────────────────────────────────────────
    const { data: settingsRows } = await admin
      .from('school_settings' as any)
      .select('key, value');
    const sm = Object.fromEntries(
      ((settingsRows ?? []) as unknown as Array<{ key:string; value:string }>).map(
        (r) => [r.key, r.value],
      ),
    );
    const principalName = sm['principal_name'] ?? '';
    const principalNip  = sm['principal_nip']  ?? '';

    // ── Assignment(s) ────────────────────────────────────────────
    let assignQuery = admin
      .from('class_period_assignments')
      .select(`id, class:class_id (id, name, grade_level), homeroom:homeroom_teacher_id (full_name, nip)`)
      .eq('period_id', parsed.data.periodId);
    if (!isAll) assignQuery = assignQuery.eq('class_id', parsed.data.classId);

    const { data: assignments } = await assignQuery;
    if (!assignments || assignments.length === 0) {
      return fail('Tidak ada kelas untuk periode ini', 404);
    }

    type AssignRow = {
      id: string;
      class: { id: string; name: string; grade_level: string | number } | null;
      homeroom: { full_name: string; nip?: string } | null;
    };

    const sortedAssigns = (assignments as unknown as AssignRow[])
      .filter((a) => a.class)
      .sort((a, b) => a.class!.name.localeCompare(b.class!.name));

    // ── Ambil data semua kelas ───────────────────────────────────
    const blocks: ClassBlock[] = await Promise.all(
      sortedAssigns.map((a) =>
        fetchClassBlock(
          admin,
          a.id,
          a.class!.name,
          a.class!.grade_level,
          (period as any).name,
          (period as any).academic_year,
          (period as any).semester,
          a.homeroom?.full_name ?? '—',
          a.homeroom?.nip ?? '',
        ),
      ),
    );

    // ── Bangun PDF ───────────────────────────────────────────────
    const doc    = new jsPDF({ orientation: 'portrait', unit: 'pt', format: 'a4' });
    const pageW  = doc.internal.pageSize.getWidth();
    const margin = 36;
    let   cursor = margin;

    // Header sekolah (satu kali di awal)
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(14);
    doc.text('SMAN 13 BANDUNG', pageW / 2, cursor, { align: 'center' });
    cursor += 16;
    doc.setFontSize(10);
    doc.setFont('helvetica', 'normal');
    doc.text(
      'Sistem Penilaian Terpadu (SiPandu) — Laporan Perilaku Siswa',
      pageW / 2,
      cursor,
      { align: 'center' },
    );
    if (isAll) {
      cursor += 12;
      doc.setFont('helvetica', 'bold');
      doc.text(`Periode: ${(period as any).name}`, pageW / 2, cursor, { align: 'center' });
      doc.setFont('helvetica', 'normal');
    }
    cursor += 14;
    doc.setLineWidth(1.2);
    doc.line(margin, cursor, pageW - margin, cursor);
    cursor += 14;

    // Tanggal cetak
    doc.setFontSize(9);
    doc.text(`Tanggal Cetak: ${formatDateID()}`, margin, cursor);
    cursor += 16;

    // Section per kelas — cursor diteruskan agar section pertama
    // tidak menimpa header sekolah yang sudah dicetak di atas
    for (let i = 0; i < blocks.length; i++) {
      cursor = appendClassSection(doc, blocks[i], margin, cursor, i === 0);
    }

    // Tanda tangan — gunakan wali kelas terakhir jika all, atau satu kelas jika single
    const lastBlock = blocks[blocks.length - 1];
    appendSignature(
      doc,
      margin,
      isAll ? '' : lastBlock.homeroomName,
      isAll ? '' : lastBlock.homeroomNip,
      principalName,
      principalNip,
      cursor,
    );

    // ── Render ───────────────────────────────────────────────────
    const buffer   = Buffer.from(doc.output('arraybuffer'));
    const periodPart = `${(period as any).academic_year.replace('/', '-')}_${(period as any).semester}`;
    const classPart  = isAll
      ? 'Semua_Kelas'
      : (blocks[0]?.className ?? 'Kelas').replace(/\s+/g, '_');
    const filename = `Laporan_${classPart}_${periodPart}.pdf`;

    return new NextResponse(buffer, {
      status: 200,
      headers: {
        'Content-Type':        'application/pdf',
        'Content-Disposition': `attachment; filename="${filename}"`,
        'Cache-Control':       'no-store',
      },
    });
  } catch (err) {
    if (err instanceof Error && /akses|login/i.test(err.message)) {
      return fail(err.message, 403);
    }
    return failFromUnknown(err);
  }
}
