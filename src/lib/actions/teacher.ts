/**
 * @file lib/actions/teacher.ts
 * @description Server Actions untuk role Wali Kelas (Teacher) SiPandu.
 *
 *  Patch 7.7.2 sudah diterapkan — nama kolom DB yang benar:
 *   - monthly_attendance   → permit_days   (bukan permit_days)
 *   - monthly_attendance   → is_locked     (bukan status: 'locked')
 *   - peer_review_sessions → class_period_assignment_id (bukan class_period_assignment_id)
 *   - student_class_enrollments → class_period_assignment_id
 *   - student_teacher_notes → note_text    (bukan note)
 *   - behavior_point_transactions → violation_category_id / reward_category_id
 *     (bukan category_id + category_type)
 */

'use server';

import { revalidatePath } from 'next/cache';
import { z } from 'zod';

import { createClient, createServiceRoleClient } from '@/lib/supabase/server';
import { getAssignmentContext } from '@/lib/teacher/getAssignment';
// import { getTeacherAssignment } from '@/lib/teacher/getAssignment';

/* ─────────────────────────────────────────────────────────────────────
 *  Tipe kembalian standar
 * ───────────────────────────────────────────────────────────────────── */

type ActionResult<T = undefined> =
  | { ok: true; data?: T }
  | { ok: false; error: string };

/* ═══════════════════════════════════════════════════════════════════
 *  KEHADIRAN
 * ═══════════════════════════════════════════════════════════════════ */

const attendanceDraftSchema = z.object({
  assignmentId: z.string().uuid(),
  month: z.number().int().min(1).max(12),
  year: z.number().int(),
  // ALASAN: effective_days NOT NULL di DB — wajib disertakan saat upsert pertama kali
  effectiveDays: z.number().int().min(0),
  rows: z.array(
    z.object({
      enrollmentId: z.string().uuid(),
      presentDays: z.number().int().min(0),
      sickDays: z.number().int().min(0),
      permittedDays: z.number().int().min(0),
      absentDays: z.number().int().min(0),
    }),
  ),
});

/**
 * Simpan draft kehadiran bulanan.
 * Patch: kolom `permit_days` (bukan permit_days).
 *        Hapus `class_period_assignment_id` & `status: 'draft'` — kolom tidak ada.
 */
export async function saveAttendanceDraft(
  input: z.infer<typeof attendanceDraftSchema>,
): Promise<ActionResult> {
  try {
    const parsed = attendanceDraftSchema.parse(input);
    const supabase = await createClient();

    const upsertRows = parsed.rows.map((row) => ({
      enrollment_id: row.enrollmentId,
      month: parsed.month,
      year: parsed.year,
      present_days: row.presentDays,
      sick_days: row.sickDays,
      permit_days: row.permittedDays,
      absent_days: row.absentDays,
      // ALASAN: effective_days NOT NULL di DB — harus disertakan agar INSERT pertama tidak gagal
      effective_days: parsed.effectiveDays,
    }));

    const { error } = await supabase
      .from('monthly_attendance')
      .upsert(upsertRows as any, { onConflict: 'enrollment_id,month,year' });
    
    if (error) return { ok: false, error: error.message };
    return { ok: true };
  } catch (err) {
    return { ok: false, error: err instanceof Error ? err.message : 'Error tidak diketahui' };
  }
}

/* ── Kunci bulan kehadiran ─────────────────────────────────────────── */

const lockAttendanceSchema = z.object({
  assignmentId: z.string().uuid(),
  month: z.number().int().min(1).max(12),
  year: z.number().int(),
  effectiveDays: z.number().int().min(1),
});

/**
 * Kunci bulan kehadiran — set is_locked = true.
 * Patch: pakai `is_locked: true` (bukan `status: 'locked'`).
 *        Filter via enrollment_id yang di-join dari student_class_enrollments.
 */
export async function lockAttendanceMonth(
  input: z.infer<typeof lockAttendanceSchema>,
): Promise<ActionResult> {
  try {
    const parsed = lockAttendanceSchema.parse(input);
    const admin = await createServiceRoleClient();
    const now = new Date().toISOString();

    // 1. Ambil semua enrollment di assignment ini
    const { data: enrollments, error: enErr } = await admin
      .from('student_class_enrollments')
      .select('id')
      .eq('class_period_assignment_id', parsed.assignmentId)  // PATCH
      .eq('status', 'active');

    if (enErr) return { ok: false, error: enErr.message };
    const enrollmentIds = (enrollments ?? []).map((e) => e.id as string);
    if (enrollmentIds.length === 0) {
      return { ok: false, error: 'Tidak ada siswa terdaftar di kelas ini' };
    }

    // 2. Update: is_locked = true (PATCH: bukan status: 'locked')
    const { error: lockErr } = await admin
      .from('monthly_attendance')
      .update({
        is_locked: true,                                       // PATCH: is_locked
        effective_days: parsed.effectiveDays,
        locked_at: now,
      })
      .in('enrollment_id', enrollmentIds)
      .eq('month', parsed.month)
      .eq('year', parsed.year);

    if (lockErr) return { ok: false, error: lockErr.message };
    revalidatePath('/dashboard/kehadiran');
    return { ok: true };
  } catch (err) {
    return { ok: false, error: err instanceof Error ? err.message : 'Error tidak diketahui' };
  }
}

/* ── Buka kunci bulan kehadiran ────────────────────────────────────── */

const unlockAttendanceSchema = z.object({
  assignmentId: z.string().uuid(),
  month: z.number().int().min(1).max(12),
  year: z.number().int(),
});

/**
 * Buka kunci bulan kehadiran agar dapat diedit kembali.
 * Set is_locked = false dan locked_at = null untuk semua enrollment di bulan ini.
 * ALASAN: diperlukan untuk meminimalisir human error — guru dapat mengoreksi
 * data yang sudah terkunci tanpa harus menghubungi admin.
 */
export async function unlockAttendanceMonth(
  input: z.infer<typeof unlockAttendanceSchema>,
): Promise<ActionResult> {
  try {
    const parsed = unlockAttendanceSchema.parse(input);
    const admin = await createServiceRoleClient();

    // Ambil semua enrollment aktif di assignment ini
    const { data: enrollments, error: enErr } = await admin
      .from('student_class_enrollments')
      .select('id')
      .eq('class_period_assignment_id', parsed.assignmentId)
      .eq('status', 'active');

    if (enErr) return { ok: false, error: enErr.message };
    const enrollmentIds = (enrollments ?? []).map((e) => e.id as string);
    if (enrollmentIds.length === 0) {
      return { ok: false, error: 'Tidak ada siswa terdaftar di kelas ini' };
    }

    const { error } = await admin
      .from('monthly_attendance')
      .update({ is_locked: false, locked_at: null })
      .in('enrollment_id', enrollmentIds)
      .eq('month', parsed.month)
      .eq('year', parsed.year);

    if (error) return { ok: false, error: error.message };
    revalidatePath('/dashboard/kehadiran');
    return { ok: true };
  } catch (err) {
    return { ok: false, error: err instanceof Error ? err.message : 'Error tidak diketahui' };
  }
}

/* ═══════════════════════════════════════════════════════════════════
 *  POIN PERILAKU
 * ═══════════════════════════════════════════════════════════════════ */

const behaviorTransactionSchema = z.object({
  enrollmentId: z.string().uuid(),
  assignmentId: z.string().uuid(),
  type: z.enum(['violation', 'reward']),
  categoryId: z.string().uuid(),
  transactionDate: z.string().date(),
  notes: z.string().max(500).optional(),
});

/**
 * Catat transaksi poin perilaku (pelanggaran atau reward).
 *
 * Patch 7.7.2c: payload insert menggunakan kolom yang benar:
 *   - violation_category_id  / reward_category_id  (bukan category_id + category_type)
 *   - points_delta, raw_score_after, recorded_by
 *   - Hapus: class_period_assignment_id, category_id, category_type, point_change
 */
export async function addBehaviorTransaction(
  input: z.infer<typeof behaviorTransactionSchema>,
): Promise<ActionResult> {
  try {
    const parsed = behaviorTransactionSchema.parse(input);
    const assignment = await getAssignmentContext();
    if (!assignment) return { ok: false, error: 'Penugasan wali kelas tidak ditemukan' };

    const admin = await createServiceRoleClient();

    // 1. Ambil nilai poin dari tabel kategori
    let delta = 0;
    if (parsed.type === 'violation') {
      const { data: cat } = await admin
        .from('violation_categories')
        .select('point_deduction')                              // PATCH: point_deduction
        .eq('id', parsed.categoryId)
        .single();
      if (!cat) return { ok: false, error: 'Kategori pelanggaran tidak ditemukan' };
      delta = -Math.abs(cat.point_deduction as number);
    } else {
      const { data: cat } = await admin
        .from('reward_categories')
        .select('point_addition')                              // PATCH: point_addition
        .eq('id', parsed.categoryId)
        .single();
      if (!cat) return { ok: false, error: 'Kategori reward tidak ditemukan' };
      delta = Math.abs(cat.point_addition as number);
    }

    // 2. Ambil raw_score saat ini
    const { data: scoreRow } = await admin
      .from('student_behavior_scores')
      .select('raw_score')
      .eq('enrollment_id', parsed.enrollmentId)
      .maybeSingle();

    const currentRaw = (scoreRow?.raw_score as number | undefined) ?? 100;
    const newRaw = currentRaw + delta;

    // 3. INSERT transaksi — PATCH: payload benar
    const { error: txErr } = await admin
      .from('behavior_point_transactions')
      .insert({
        enrollment_id: parsed.enrollmentId,
        transaction_type: parsed.type,
        ...(parsed.type === 'violation'
          ? { violation_category_id: parsed.categoryId }
          : { reward_category_id: parsed.categoryId }),
        points_delta: delta,
        raw_score_after: newRaw,
        transaction_date: parsed.transactionDate,
        notes: parsed.notes || null,
        recorded_by: assignment.teacherId,
        // PATCH: hapus class_period_assignment_id, category_id, category_type, point_change
      });

    if (txErr) return { ok: false, error: txErr.message };

    // 4. UPSERT student_behavior_scores
    const { error: scoreErr } = await admin
      .from('student_behavior_scores')
      .upsert(
        { enrollment_id: parsed.enrollmentId, raw_score: newRaw },
        { onConflict: 'enrollment_id' },
      );

    if (scoreErr) return { ok: false, error: scoreErr.message };

    revalidatePath('/dashboard/poin-perilaku');
    return { ok: true };
  } catch (err) {
    return { ok: false, error: err instanceof Error ? err.message : 'Error tidak diketahui' };
  }
}

/* ── Batalkan transaksi poin (soft delete) ──────────────────────── */

const cancelTransactionSchema = z.object({
  transactionId: z.string().uuid(),
});

/**
 * Batalkan transaksi poin perilaku dengan soft delete.
 * Mengisi `deleted_at = now()` → DB trigger otomatis membalik `points_delta`
 * dari `student_behavior_scores`, sehingga raw_score kembali ke nilai sebelum
 * transaksi ini dicatat.
 *
 * ALASAN: pakai service role agar bypass RLS — policy tx_teacher_update
 * mungkin tidak mencakup UPDATE kolom deleted_at secara eksplisit.
 */
export async function cancelTransaction(
  input: z.infer<typeof cancelTransactionSchema>,
): Promise<ActionResult> {
  try {
    const parsed = cancelTransactionSchema.parse(input);
    const assignment = await getAssignmentContext();
    if (!assignment) return { ok: false, error: 'Penugasan wali kelas tidak ditemukan' };

    const admin = createServiceRoleClient();

    // Verifikasi transaksi milik siswa di kelas ini sebelum membatalkan
    const { data: tx } = await admin
      .from('behavior_point_transactions')
      .select('id, enrollment_id, deleted_at')
      .eq('id', parsed.transactionId)
      .maybeSingle();

    if (!tx) return { ok: false, error: 'Transaksi tidak ditemukan' };
    if (tx.deleted_at) return { ok: false, error: 'Transaksi sudah dibatalkan sebelumnya' };

    // Pastikan enrollment ini memang ada di kelas si guru
    const { data: enrollment } = await admin
      .from('student_class_enrollments')
      .select('id')
      .eq('id', tx.enrollment_id)
      .eq('class_period_assignment_id', assignment.assignmentId)
      .maybeSingle();

    if (!enrollment) {
      return { ok: false, error: 'Transaksi tidak termasuk kelas Anda' };
    }

    // Soft delete → trigger DB akan otomatis balik raw_score
    const { error } = await admin
      .from('behavior_point_transactions')
      .update({ deleted_at: new Date().toISOString() })
      .eq('id', parsed.transactionId);

    if (error) return { ok: false, error: error.message };
    revalidatePath('/dashboard/poin-perilaku');
    return { ok: true };
  } catch (err) {
    return { ok: false, error: err instanceof Error ? err.message : 'Error tidak diketahui' };
  }
}

/* ═══════════════════════════════════════════════════════════════════
 *  PEER REVIEW
 * ═══════════════════════════════════════════════════════════════════ */

const openPeerSessionSchema = z.object({
  assignmentId: z.string().uuid(),
  deadline: z.string().date(),
});

/** Jumlah teman yang ditugaskan secara acak per siswa. */
const PEER_REVIEW_SUBSET_SIZE = 5;

/**
 * Fisher-Yates shuffle deterministik menggunakan seed string.
 * Menghasilkan urutan acak yang berbeda per siswa (seed = sessionId + studentId),
 * tapi tetap konsisten setiap kali fungsi dipanggil dengan seed yang sama.
 */
function seededShuffle<T>(arr: T[], seed: string): T[] {
  const result = [...arr];
  let h = 0;
  for (let i = 0; i < seed.length; i++) {
    h = Math.imul(31, h) + seed.charCodeAt(i) | 0;
  }
  for (let i = result.length - 1; i > 0; i--) {
    h = Math.imul(h ^ (h >>> 16), 0x45d9f3b) | 0;
    h = Math.imul(h ^ (h >>> 16), 0x45d9f3b) | 0;
    const j = Math.abs(h) % (i + 1);
    [result[i], result[j]] = [result[j]!, result[i]!];
  }
  return result;
}

/**
 * Buka sesi peer review dan generate assignment acak (5 teman per siswa).
 *
 * Alur:
 *  1. INSERT/UPDATE peer_review_sessions → status 'active'
 *  2. Hapus assignment lama (jika sesi dibuka ulang)
 *  3. Ambil semua siswa aktif di kelas
 *  4. Untuk setiap siswa: acak daftar teman, ambil PEER_REVIEW_SUBSET_SIZE pertama
 *  5. Bulk INSERT ke peer_review_assignments
 */
export async function openPeerSession(
  input: z.infer<typeof openPeerSessionSchema>,
): Promise<ActionResult<{ sessionId: string; assignedCount: number }>> {
  try {
    const parsed = openPeerSessionSchema.parse(input);
    const assignment = await getAssignmentContext();
    if (!assignment) return { ok: false, error: 'Penugasan tidak ditemukan' };

    if (assignment.assignmentId !== parsed.assignmentId) {
      return { ok: false, error: 'Anda tidak memiliki akses ke kelas ini' };
    }

    const admin = createServiceRoleClient();
    const now = new Date().toISOString();

    // ── 1. Cek / buat sesi ───────────────────────────────────────────
    const { data: existing } = await admin
      .from('peer_review_sessions')
      .select('id, status')
      .eq('class_period_assignment_id', parsed.assignmentId)
      .maybeSingle();

    if (existing?.status === 'active') {
      return { ok: false, error: 'Sudah ada sesi peer review yang sedang aktif' };
    }

    let sessionId: string;

    if (existing) {
      const { error } = await admin
        .from('peer_review_sessions')
        .update({
          status: 'active',
          deadline: parsed.deadline,
          opened_at: now,
          opened_by: assignment.teacherId,
          closed_at: null,
          closed_by: null,
          auto_closed: false,
        } as any)
        .eq('id', existing.id);

      if (error) return { ok: false, error: error.message };
      sessionId = existing.id as string;
    } else {
      const { data: session, error } = await admin
        .from('peer_review_sessions')
        .insert({
          class_period_assignment_id: parsed.assignmentId,
          deadline: parsed.deadline,
          status: 'active',
          opened_at: now,
          opened_by: assignment.teacherId,
        } as any)
        .select('id')
        .single();

      if (error || !session) {
        return { ok: false, error: error?.message ?? 'Gagal membuka sesi' };
      }
      sessionId = session.id as string;
    }

    // ── 2. Hapus assignment lama (jika sesi dibuka ulang) ────────────
    await admin
      .from('peer_review_assignments' as any)
      .delete()
      .eq('session_id', sessionId);

    // ── 3. Ambil semua siswa aktif di kelas ──────────────────────────
    const { data: enrolls, error: enrollErr } = await admin
      .from('student_class_enrollments')
      .select('student_id')
      .eq('class_period_assignment_id', parsed.assignmentId)
      .eq('status', 'active');

    if (enrollErr || !enrolls || enrolls.length < 2) {
      revalidatePath('/dashboard/peer-review');
      return { ok: true, data: { sessionId, assignedCount: 0 } };
    }

    const studentIds = (enrolls as { student_id: string }[]).map((e) => e.student_id);
    const subsetSize = Math.min(PEER_REVIEW_SUBSET_SIZE, studentIds.length - 1);

    // ── 4. Generate assignment acak per siswa ────────────────────────
    const assignmentRows: { session_id: string; reviewer_id: string; reviewee_id: string }[] = [];

    for (const reviewerId of studentIds) {
      const candidates = studentIds.filter((id) => id !== reviewerId);
      // Seed berbeda per reviewer → urutan acak berbeda antar siswa
      const shuffled = seededShuffle(candidates, `${sessionId}-${reviewerId}`);
      const assigned = shuffled.slice(0, subsetSize);

      for (const revieweeId of assigned) {
        assignmentRows.push({ session_id: sessionId, reviewer_id: reviewerId, reviewee_id: revieweeId });
      }
    }

    // ── 5. Bulk INSERT assignments ────────────────────────────────────
    const { error: assignErr } = await admin
      .from('peer_review_assignments' as any)
      .insert(assignmentRows);

    if (assignErr) {
      return { ok: false, error: `Gagal membuat assignment: ${assignErr.message}` };
    }

    revalidatePath('/dashboard/peer-review');
    return { ok: true, data: { sessionId, assignedCount: studentIds.length } };
  } catch (err) {
    return { ok: false, error: err instanceof Error ? err.message : 'Error tidak diketahui' };
  }
}

/* ── Tutup sesi peer review ──────────────────────────────────────── */

export async function closePeerSession(input: {
  sessionId: string;
}): Promise<ActionResult> {
  try {
    const assignment = await getAssignmentContext();
    if (!assignment) return { ok: false, error: 'Penugasan tidak ditemukan' };

    const admin = await createServiceRoleClient();

    // Verifikasi sesi milik kelas ini
    const { data: session } = await admin
      .from('peer_review_sessions')
      .select('id, status, class_period_assignment_id')        // PATCH
      .eq('id', input.sessionId)
      .maybeSingle();

    if (!session) return { ok: false, error: 'Sesi tidak ditemukan' };
    if (session.class_period_assignment_id !== assignment.assignmentId) {
      return { ok: false, error: 'Anda tidak memiliki akses ke sesi ini' };
    }
    if (session.status !== 'active') {
      return { ok: false, error: 'Sesi sudah ditutup atau tidak aktif' };
    }

    // Tutup sesi — trigger DB akan hitung X3 final
    const { error } = await admin
      .from('peer_review_sessions')
      .update({
        status: 'closed',
        closed_at: new Date().toISOString(),
        closed_by: assignment.teacherId,  // PATCH: catat siapa yang menutup
      } as any)
      .eq('id', input.sessionId);

    if (error) return { ok: false, error: error.message };
    revalidatePath('/dashboard/peer-review');
    return { ok: true };
  } catch (err) {
    return { ok: false, error: err instanceof Error ? err.message : 'Error tidak diketahui' };
  }
}

/* ═══════════════════════════════════════════════════════════════════
 *  CATATAN WALI KELAS
 * ═══════════════════════════════════════════════════════════════════ */

const teacherNoteSchema = z.object({
  enrollmentId: z.string().uuid(),
  note: z.string().max(2000),
});

/**
 * Simpan catatan wali kelas untuk siswa.
 * Patch: gunakan `note_text` (bukan `note`).
 */
export async function saveTeacherNote(
  input: z.infer<typeof teacherNoteSchema>,
): Promise<ActionResult> {
  try {
    const parsed = teacherNoteSchema.parse(input);
    const admin = await createServiceRoleClient();

    const { error } = await admin.from('teacher_narrative_notes').upsert(
      {
        enrollment_id: parsed.enrollmentId,
        note_text: parsed.note,               
        updated_at: new Date().toISOString(),
      } as any,
      { onConflict: 'enrollment_id' },
    );

    if (error) return { ok: false, error: error.message };
    revalidatePath('/dashboard/siswa');
    return { ok: true };
  } catch (err) {
    return { ok: false, error: err instanceof Error ? err.message : 'Error tidak diketahui' };
  }
}
