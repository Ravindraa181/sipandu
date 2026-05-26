/**
 * @file postcss.config.js
 * @description Konfigurasi PostCSS untuk Tailwind CSS v3 + autoprefixer.
 * ALASAN: Pakai .js (bukan .mjs) karena Next.js 16 + Turbopack memprioritaskan
 * .js untuk postcss config. Plugin 'tailwindcss' adalah untuk v3;
 * jangan ganti ke '@tailwindcss/postcss' kecuali upgrade ke Tailwind v4.
 */
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
