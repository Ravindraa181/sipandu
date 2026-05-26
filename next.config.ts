/**
 * @file next.config.ts
 * @description Konfigurasi Next.js 14/15 untuk SiPandu — SMAN 13 Bandung.
 *
 * Cakupan konfigurasi:
 *   - images.remotePatterns: izinkan <Image> dari Supabase Storage
 *   - experimental.serverActions: tetap aktif & set body size limit
 *   - env: variabel build-time custom (di luar NEXT_PUBLIC_*)
 *   - logging: aktifkan log fetch di dev untuk debugging RSC
 *   - eslint/typescript: jangan abaikan error saat build production
 *
 * Note: file ini menggantikan `next.config.mjs` default. Bila Next.js
 * versi Anda belum mendukung `next.config.ts`, ganti ekstensi ke `.mjs`
 * dan ubah `export default` sintaksnya.
 */

import type { NextConfig } from 'next';

/* ────────────────────────────────────────────────────────────────────
 * Helper: ekstrak host dari URL Supabase
 *
 * NEXT_PUBLIC_SUPABASE_URL bentuknya:
 *   https://<project-ref>.supabase.co
 *
 * Kita ambil host-nya untuk dipakai di images.remotePatterns. Bila
 * env belum di-set saat build (mis. saat `next build` di CI tanpa env),
 * fallback ke wildcard `*.supabase.co`.
 * ──────────────────────────────────────────────────────────────────── */

function supabaseHost(): string {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  if (!url) return '*.supabase.co';
  try {
    return new URL(url).hostname;
  } catch {
    return '*.supabase.co';
  }
}

/* ────────────────────────────────────────────────────────────────────
 * Konfigurasi utama
 * ──────────────────────────────────────────────────────────────────── */

const nextConfig: NextConfig = {
  reactStrictMode: true,

  // ── Optimasi gambar ───────────────────────────────────────────────
  // Hanya host yang ter-whitelist di sini yang boleh di-render via
  // <Image>. Default Next memblok eksternal demi keamanan.
  images: {
    remotePatterns: [
      // Storage Supabase project SiPandu
      {
        protocol: 'https',
        hostname: supabaseHost(),
        pathname: '/storage/v1/object/public/**',
      },
      // Avatar/icon sekolah dari unit lain (opsional)
      {
        protocol: 'https',
        hostname: 'sman13bdg.sch.id',
      },
    ],
    // Sekolah punya bandwidth terbatas — batasi ukuran cache device.
    deviceSizes: [640, 750, 828, 1080, 1200, 1920],
    imageSizes: [16, 32, 64, 96, 128, 256, 384],
  },

  // ── Server Actions ────────────────────────────────────────────────
  // Default sudah aktif di Next 14.2+, namun kita set bodySizeLimit
  // agar import Excel siswa berukuran ~5 MB tetap diterima.
  // Aktifkan typed routes (Next 13.2+) → linkable dengan tipe yang dijaga
    typedRoutes: true,
  experimental: {
    serverActions: {
      bodySizeLimit: '5mb',
      // Daftar host yang boleh trigger server action (CSRF protection).
      // Tambahkan domain Vercel preview & production di sini saat deploy.
      allowedOrigins: [
        'localhost:3000',
        '127.0.0.1:3000',
        'sipandu.vercel.app',
        'sipandu-*.vercel.app',
      ],
    },
    
  },

  // ── Variabel build-time non-public ────────────────────────────────
  // Hanya untuk variabel yang TIDAK perlu di-expose ke browser.
  // Variabel NEXT_PUBLIC_* otomatis di-inline oleh Next; tidak perlu
  // diulang di sini.
  env: {
    APP_NAME: process.env.NEXT_PUBLIC_APP_NAME ?? 'SiPandu',
    SCHOOL_NAME: process.env.NEXT_PUBLIC_SCHOOL_NAME ?? 'SMAN 13 Bandung',
    BUILD_TIMESTAMP: new Date().toISOString(),
  },

  // ── Header keamanan ───────────────────────────────────────────────
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          { key: 'X-Frame-Options', value: 'DENY' },
          { key: 'X-Content-Type-Options', value: 'nosniff' },
          { key: 'Referrer-Policy', value: 'strict-origin-when-cross-origin' },
          {
            key: 'Permissions-Policy',
            value:
              'camera=(), microphone=(), geolocation=(), interest-cohort=()',
          },
        ],
      },
    ];
  },

  // ── Redirect halaman login berdasarkan path ───────────────────────
  async redirects() {
    return [
      // Jika user buka /admin tanpa subpath, arahkan ke /admin/login
      {
        source: '/admin',
        destination: '/admin/login',
        permanent: false,
      },
    ];
  },

  // ── ESLint & TypeScript: pastikan error tidak diabaikan saat build ─
  // eslint: {
  //   // Build production akan GAGAL bila ada error ESLint.
  //   ignoreDuringBuilds: false,
  // },
  typescript: {
    // Build production akan GAGAL bila ada error TypeScript.
    ignoreBuildErrors: false,
  },

  // ── Logging ───────────────────────────────────────────────────────
  // Bantu debugging fetch / cache di server components.
  logging: {
    fetches: {
      fullUrl: false,
    },
  },

  // ── Optimasi paket eksternal yang tidak di-bundle ─────────────────
  // Beberapa package (mis. xlsx) cukup besar; biarkan Next memutuskan
  // apakah mau di-bundle atau di-import dynamic.
  serverExternalPackages: ['xlsx'],
};

export default nextConfig;
