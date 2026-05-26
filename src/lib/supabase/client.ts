/**
 * @file lib/supabase/client.ts
 * @description Browser-side Supabase client (singleton) untuk Client Components.
 *
 * Dipakai dalam komponen yang punya `'use client'`. Setelah dipanggil
 * pertama kali, instance disimpan di module-level variable agar tidak
 * membuat ulang koneksi tiap render.
 *
 * Untuk Server Components / Route Handlers / Server Actions, gunakan
 * `lib/supabase/server.ts` (createClient dari sana).
 */

import { createBrowserClient } from '@supabase/ssr';
import type { Database } from './database.types';

/**
 * Singleton instance Supabase Browser client.
 * `null` sebelum panggilan pertama.
 */
let cachedClient: ReturnType<typeof createBrowserClient<Database>> | null =
  null;

/**
 * Ambil (atau buat) Supabase Browser client untuk dipakai di Client Component.
 *
 * @example
 * 'use client';
 * import { createClient } from '@/lib/supabase/client';
 * const supabase = createClient();
 * const { data: { user } } = await supabase.auth.getUser();
 */
export function createClient() {
  if (cachedClient) return cachedClient;

  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  if (!url || !key) {
    throw new Error(
      '[supabase/client] NEXT_PUBLIC_SUPABASE_URL atau NEXT_PUBLIC_SUPABASE_ANON_KEY belum di-set di .env.local',
    );
  }

  cachedClient = createBrowserClient<Database>(url, key);
  return cachedClient;
}
