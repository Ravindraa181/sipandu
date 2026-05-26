/**
 * @file app/page.tsx
 * @description Halaman root `/` — selalu redirect.
 *
 *  Logika redirect sebenarnya ditangani oleh `middleware.ts` (yang
 *  meresolve role user → home path). Halaman ini berfungsi sebagai
 *  fallback bila middleware tidak ter-trigger (mis. setelah edge bug
 *  atau saat cookies kosong).
 */

import { redirect } from 'next/navigation';
import { ROUTES } from '@/constants';

export default function RootPage(): never {
  redirect(ROUTES.login);
}
