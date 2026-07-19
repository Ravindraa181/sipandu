-- ═══════════════════════════════════════════════════════════════════════════
--  SiPandu — Fix: auth.users token NULL menyebabkan login gagal
--
--  Gejala : Login siswa/guru gagal dengan toast "Database error querying
--           schema". Auth Logs Supabase menunjukkan:
--             "error finding user: sql: Scan error on column index 3,
--              name \"confirmation_token\": converting NULL to string
--              is unsupported"
--
--  Sebab  : GoTrue (Supabase Auth) mengharapkan kolom token di auth.users
--           berisi string kosong ('' ), bukan NULL. Sebagian akun (biasanya
--           yang dibuat manual/lewat Admin API) punya nilai NULL di kolom
--           ini sehingga proses login gagal saat GoTrue membaca baris user.
--
--  Ruang lingkup : HANYA UPDATE data di skema `auth` (dikelola Supabase).
--                  TIDAK mengubah struktur tabel apa pun. TIDAK menyentuh
--                  skema `public` (profiles, enrollments, dsb).
--
--  Idempotent : Aman dijalankan berulang kali — baris yang sudah benar
--               (tidak NULL) tidak akan berubah.
--
--  Cara pakai : Supabase Dashboard → SQL Editor → New Query → Paste → Run.
-- ═══════════════════════════════════════════════════════════════════════════

UPDATE auth.users SET confirmation_token = ''         WHERE confirmation_token IS NULL;
UPDATE auth.users SET email_change = ''                WHERE email_change IS NULL;
UPDATE auth.users SET email_change_token_new = ''      WHERE email_change_token_new IS NULL;
UPDATE auth.users SET email_change_token_current = ''  WHERE email_change_token_current IS NULL;
UPDATE auth.users SET recovery_token = ''              WHERE recovery_token IS NULL;
UPDATE auth.users SET phone_change = ''                WHERE phone_change IS NULL;
UPDATE auth.users SET phone_change_token = ''          WHERE phone_change_token IS NULL;
UPDATE auth.users SET reauthentication_token = ''      WHERE reauthentication_token IS NULL;

-- ── Verifikasi: harus menampilkan 0 baris bila semua sudah diperbaiki ──────
SELECT id, email, confirmation_token, recovery_token, email_change_token_new
FROM auth.users
WHERE confirmation_token IS NULL
   OR email_change IS NULL
   OR email_change_token_new IS NULL
   OR email_change_token_current IS NULL
   OR recovery_token IS NULL
   OR phone_change IS NULL
   OR phone_change_token IS NULL
   OR reauthentication_token IS NULL;
