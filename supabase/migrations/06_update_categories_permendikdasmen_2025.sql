-- ═══════════════════════════════════════════════════════════════════════════
--  SiPandu — Migrasi 06: Penyelarasan label kategori ke
--                        Permendikdasmen No. 10 Tahun 2025 (Standar
--                        Kompetensi Lulusan / Kurikulum Merdeka)
--
--  Ruang lingkup (UPDATE DATA saja, TIDAK mengubah skema):
--    A. peer_review_aspects  — perbarui label & deskripsi 5 aspek.
--    B. reward_categories    — perbarui HANYA kolom category_label 10 kategori
--                              resmi (idempotent; bila sudah benar → no-op).
--    C. reward_categories    — nonaktifkan (is_active=false) 8 kategori sisa
--                              seed/dummy lama agar tersisa 10 kategori aktif.
--
--  TIDAK diubah:
--    - Struktur tabel / nama kolom / tipe data.
--    - aspect_key & jumlah aspek peer review (tetap 5).
--    - Nama & nilai poin (point_addition) kategori reward.
--    - Baris kategori ekstra TIDAK dihapus (hanya di-nonaktifkan) agar
--      transaksi poin lama tetap utuh (FK ON DELETE RESTRICT).
--    - Seluruh kategori pelanggaran (violation_categories) — tidak disentuh.
--
--  Catatan: seed pada migrasi 01/03 memakai ON CONFLICT DO NOTHING sehingga
--           TIDAK menimpa baris yang sudah ada di DB. File ini melakukan
--           UPDATE eksplisit untuk memperbarui data yang sudah terlanjur ada.
--
--  Cara pakai : Buka Supabase → SQL Editor → New Query → Paste → Run.
--  Idempotent : Aman dijalankan ulang (murni UPDATE ke nilai target;
--               deaktivasi dicocokkan via daftar nama eksplisit).
-- ═══════════════════════════════════════════════════════════════════════════

BEGIN;

-- ── A. PEER ASSESSMENT — 5 aspek (label + deskripsi) ────────────────────────
--    Dicocokkan via aspect_key (kunci tetap). Urutan display tidak berubah.
UPDATE public.peer_review_aspects AS t SET
  label       = v.label,
  description = v.description
FROM (VALUES
  ('courtesy',       'Akhlak Mulia',
   'Seberapa jujur dan baik sikap siswa ini dalam berkata dan bertindak kepada guru maupun teman-teman?'),
  ('cooperation',    'Kewargaan',
   'Seberapa taat siswa ini terhadap aturan sekolah dan bertanggung jawab menjaga nama baik kelas maupun sekolah?'),
  ('empathy',        'Kolaborasi',
   'Seberapa aktif siswa ini peduli, berbagi, dan bekerja sama dengan teman-teman dalam kegiatan bersama?'),
  ('honesty',        'Kemandirian',
   'Seberapa bertanggung jawab dan berinisiatif siswa ini dalam menyelesaikan tugas dan kewajibannya sendiri?'),
  ('responsibility', 'Komunikasi',
   'Seberapa sopan siswa ini saat berbicara atau menyampaikan pendapat kepada teman-teman?')
) AS v(aspect_key, label, description)
WHERE t.aspect_key = v.aspect_key;

-- ── B. REWARD — perbarui HANYA category_label (dicocokkan via name) ──────────
--    Nama & point_addition TIDAK diubah. Nilai label mengacu dimensi
--    Profil Lulusan Permendikdasmen No. 10 Tahun 2025. Idempotent: bila DB
--    sudah bernilai target, UPDATE ini tidak mengubah apa pun.
UPDATE public.reward_categories AS t SET
  category_label = v.category_label
FROM (VALUES
  ('Aktif dalam kegiatan ekstrakurikuler (Min 1 semester)', 'Kemandirian'),
  ('Aktif dalam kegiatan keagamaan dan sosial sekolah',     'Keimanan dan Ketakwaan'),
  ('Berprestasi dalam lomba tingkat kota/kabupaten',        'Penalaran Kritis dan Kreativitas'),
  ('Berprestasi dalam lomba tingkat provinsi/nasional',     'Penalaran Kritis dan Kreativitas'),
  ('Berprestasi dalam lomba tingkat sekolah',               'Penalaran Kritis dan Kreativitas'),
  ('Membantu guru/staf sekolah secara sukarela',            'Kolaborasi'),
  ('Menjadi ketua/pengurus OSIS aktif',                     'Kolaborasi'),
  ('Menjadi panitia kegiatan resmi sekolah',                'Kolaborasi'),
  ('Menulis/merepresentasikan karya di forum sekolah',      'Kreativitas'),
  ('Tanpa alpa sebulan penuh',                              'Kemandirian')
) AS v(name, category_label)
WHERE t.name = v.name;

-- ── C. REWARD — nonaktifkan 8 kategori sisa seed/dummy lama ──────────────────
--    Baris TIDAK dihapus (jaga integritas transaksi poin lama). Hanya
--    is_active=false agar tidak lagi muncul di dropdown reward wali kelas.
--    Menyisakan tepat 10 kategori resmi yang aktif.
UPDATE public.reward_categories SET is_active = FALSE
WHERE name IN (
  'Aktif Dalam Diskusi Kelas',
  'Hadir 100% sebulan penuh',
  'Hadir sempurna satu bulan penuh (tanpa alpa)',
  'Juara Kelas / Prestasi Akademik',
  'Juara olimpiade tingkat kota',
  'Ketua OSIS',
  'Membantu Sesama / Gotong Royong',
  'Mewakili sekolah lomba provinsi'
);

-- ── Verifikasi ───────────────────────────────────────────────────────────────
DO $$
DECLARE
  v_aspect_cnt     INT;
  v_reward_active  INT;
  v_reward_total   INT;
  v_official_ok    INT;   -- dari 10 resmi: aktif DAN label sesuai target
  v_viol_cnt       INT;
BEGIN
  SELECT count(*) INTO v_aspect_cnt   FROM public.peer_review_aspects;
  SELECT count(*) INTO v_reward_total FROM public.reward_categories;
  SELECT count(*) INTO v_reward_active
    FROM public.reward_categories WHERE is_active;
  SELECT count(*) INTO v_viol_cnt     FROM public.violation_categories;

  -- 10 kategori resmi: harus aktif dan label sudah sesuai target.
  SELECT count(*) INTO v_official_ok
  FROM public.reward_categories t
  JOIN (VALUES
    ('Aktif dalam kegiatan ekstrakurikuler (Min 1 semester)', 'Kemandirian'),
    ('Aktif dalam kegiatan keagamaan dan sosial sekolah',     'Keimanan dan Ketakwaan'),
    ('Berprestasi dalam lomba tingkat kota/kabupaten',        'Penalaran Kritis dan Kreativitas'),
    ('Berprestasi dalam lomba tingkat provinsi/nasional',     'Penalaran Kritis dan Kreativitas'),
    ('Berprestasi dalam lomba tingkat sekolah',               'Penalaran Kritis dan Kreativitas'),
    ('Membantu guru/staf sekolah secara sukarela',            'Kolaborasi'),
    ('Menjadi ketua/pengurus OSIS aktif',                     'Kolaborasi'),
    ('Menjadi panitia kegiatan resmi sekolah',                'Kolaborasi'),
    ('Menulis/merepresentasikan karya di forum sekolah',      'Kreativitas'),
    ('Tanpa alpa sebulan penuh',                              'Kemandirian')
  ) AS v(name, category_label)
    ON v.name = t.name AND v.category_label = t.category_label AND t.is_active;

  RAISE NOTICE '════════════════════════════════════════════════════════════';
  RAISE NOTICE 'Migrasi 06 selesai (Permendikdasmen No. 10 Tahun 2025).';
  RAISE NOTICE 'Aspek peer review (target 5)          : %', v_aspect_cnt;
  RAISE NOTICE 'Reward resmi label OK & aktif (t.10)  : %', v_official_ok;
  RAISE NOTICE 'Reward AKTIF total (target 10)        : %', v_reward_active;
  RAISE NOTICE 'Reward baris total (10 aktif + 8 non) : %', v_reward_total;
  RAISE NOTICE 'Pelanggaran (tidak disentuh)          : %', v_viol_cnt;
  RAISE NOTICE '════════════════════════════════════════════════════════════';

  IF v_aspect_cnt <> 5 THEN
    RAISE WARNING 'Jumlah aspek bukan 5 (%). Periksa data peer_review_aspects.', v_aspect_cnt;
  END IF;
  IF v_official_ok <> 10 THEN
    RAISE WARNING '10 kategori resmi belum semua benar/aktif (cocok=%). Cek: SELECT name, category_label, is_active FROM reward_categories ORDER BY name;', v_official_ok;
  END IF;
  IF v_reward_active <> 10 THEN
    RAISE WARNING 'Reward aktif = % (diharapkan 10). Mungkin ada kategori lain di luar daftar. Cek is_active.', v_reward_active;
  END IF;
END $$;

COMMIT;
