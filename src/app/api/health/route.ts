/**
 * @file app/api/health/route.ts
 * @description Health check endpoint sederhana.
 *
 *  Dipakai oleh:
 *   - Vercel uptime monitoring
 *   - Smoke test deployment (curl /api/health)
 *   - CI/CD pipeline post-deploy verification
 *
 *  Tidak melakukan query DB agar tetap ringan dan tidak memakan
 *  egress quota. Cukup verifikasi runtime hidup.
 */

import { ok } from '../_lib/response';

export const dynamic = 'force-dynamic';

interface HealthBody {
  status: 'ok';
  timestamp: string;
  version: string;
}

export async function GET(): Promise<Response> {
  const body: HealthBody = {
    status: 'ok',
    timestamp: new Date().toISOString(),
    version: '1.0.0',
  };
  return ok(body);
}
