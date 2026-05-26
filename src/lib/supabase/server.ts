/**
 * @file lib/supabase/server.ts
 * @description Server-side Supabase client untuk Server Components,
 *              Route Handlers, dan Server Actions.
 *
 * Bedanya dengan `client.ts`: di sini cookies dibaca/ditulis lewat
 * `next/headers`. Tiap request membuat instance baru (no singleton)
 * agar cookies selalu fresh.
 *
 * Penting: panggilan `cookies()` di Next 15+ adalah `Promise<...>`,
 * sedangkan di Next 14 ia sinkron. Kita memakai `await` agar kompatibel
 * dengan keduanya (di Next 14 await pada non-promise tetap aman).
 */

import { createServerClient, type CookieOptions } from '@supabase/ssr';
import { createClient as createBaseClient } from '@supabase/supabase-js';
import { cookies } from 'next/headers';
import type { Database } from './database.types';

/**
 * Buat Supabase Server client untuk request saat ini.
 *
 * @example
 * // Di Server Component
 * import { createClient } from '@/lib/supabase/server';
 * export default async function Page() {
 *   const supabase = await createClient();
 *   const { data } = await supabase.from('profiles').select('*');
 *   return <pre>{JSON.stringify(data, null, 2)}</pre>;
 * }
 */
export async function createClient() {
  const cookieStore = await cookies();

  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  if (!url || !key) {
    throw new Error(
      '[supabase/server] NEXT_PUBLIC_SUPABASE_URL atau NEXT_PUBLIC_SUPABASE_ANON_KEY belum di-set',
    );
  }

  return createServerClient<Database>(url, key, {
    cookies: {
      getAll() {
        return cookieStore.getAll();
      },
      setAll(cookiesToSet) {
        try {
          cookiesToSet.forEach(({ name, value, options }) => {
            cookieStore.set(name, value, options as CookieOptions);
          });
        } catch {
          // Saat dipanggil dari Server Component (read-only cookies),
          // setAll akan throw — abaikan. Server Action / Route Handler
          // akan tetap berhasil set cookies di response middleware.
        }
      },
    },
  });
}

/**
 * Versi privileged: menggunakan `SUPABASE_SERVICE_ROLE_KEY` (bypass RLS).
 *
 * PENTING: Menggunakan `createClient` dari `@supabase/supabase-js` langsung
 * (BUKAN `createServerClient` dari `@supabase/ssr`), karena `createServerClient`
 * menyertakan cookie session user ke setiap request. PostgREST memprioritaskan
 * JWT dari cookie sebagai Authorization, sehingga RLS tetap aktif meskipun
 * service role key sudah di-set. Dengan `createBaseClient` tanpa cookie,
 * hanya service role key yang dipakai → RLS benar-benar di-bypass.
 *
 * JANGAN PERNAH expose ke Client Component — service role key tidak
 * boleh sampai ke browser.
 */
export function createServiceRoleClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!url || !serviceKey) {
    throw new Error(
      '[supabase/server] SUPABASE_SERVICE_ROLE_KEY belum di-set; tidak bisa membuat service-role client',
    );
  }

  // ALASAN: createBaseClient tanpa cookie tidak mengirim JWT user → service role
  // key digunakan murni sebagai Authorization → RLS di-bypass sepenuhnya.
  return createBaseClient<Database>(url, serviceKey, {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
    },
  });
}
