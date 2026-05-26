/**
 * @file tailwind.config.ts
 * @description Konfigurasi Tailwind CSS untuk SiPandu.
 *
 *  - Mempertahankan default tema dari shadcn/ui (CSS variables).
 *  - Menambah token spesifik SiPandu: warna brand navy, kategori Z*,
 *    dan beberapa accent.
 *  - Memuat plugin tailwindcss-animate (wajib shadcn) + custom keyframes.
 *
 * Class Tailwind yang dipakai mockup tetap valid; class baru yang
 * ditambah:
 *    bg-sipandu-navy / bg-sipandu-blue / bg-sipandu-bg
 *    text-sipandu-blue / text-sipandu-navy
 *    border-sipandu-blue
 *    bg-category-sangat-baik / bg-category-baik / bg-category-cukup /
 *      bg-category-perlu-pembinaan (+ varian text-, ring-, border-)
 *    bg-category-{name}-soft   (versi pucat untuk badge background)
 *    text-category-{name}-text (warna teks untuk badge)
 */

import type { Config } from 'tailwindcss';
import animatePlugin from 'tailwindcss-animate';

const config: Config = {
  darkMode: ['class'],
  content: [
    './pages/**/*.{ts,tsx}',
    './components/**/*.{ts,tsx}',
    './app/**/*.{ts,tsx}',
    './src/**/*.{ts,tsx}',
  ],
  prefix: '',
  theme: {
    container: {
      center: true,
      padding: '1rem',
      screens: {
        sm: '640px',
        md: '768px',
        lg: '1024px',
        xl: '1280px',
        '2xl': '1400px',
      },
    },
    extend: {
      /* ────────────────────────────────────────────────────────────
       *  Colors — token sistem SiPandu + token shadcn (CSS variables)
       * ──────────────────────────────────────────────────────────── */
      colors: {
        /* shadcn/ui — gunakan CSS variables (didefinisikan di
         * src/app/globals.css). Tetap ada agar komponen shadcn
         * tetap berfungsi tanpa modifikasi. */
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        primary: {
          DEFAULT: 'hsl(var(--primary))',
          foreground: 'hsl(var(--primary-foreground))',
        },
        secondary: {
          DEFAULT: 'hsl(var(--secondary))',
          foreground: 'hsl(var(--secondary-foreground))',
        },
        destructive: {
          DEFAULT: 'hsl(var(--destructive))',
          foreground: 'hsl(var(--destructive-foreground))',
        },
        muted: {
          DEFAULT: 'hsl(var(--muted))',
          foreground: 'hsl(var(--muted-foreground))',
        },
        accent: {
          DEFAULT: 'hsl(var(--accent))',
          foreground: 'hsl(var(--accent-foreground))',
        },
        popover: {
          DEFAULT: 'hsl(var(--popover))',
          foreground: 'hsl(var(--popover-foreground))',
        },
        card: {
          DEFAULT: 'hsl(var(--card))',
          foreground: 'hsl(var(--card-foreground))',
        },

        /* ── Brand SiPandu ────────────────────────────────────────── */
        sipandu: {
          /** Sidebar, header gelap, tombol primary login. */
          navy: '#1E3A5F',
          /** Versi navy lebih gelap untuk sub-card di sidebar. */
          'navy-dark': '#163358',
          /** Action utama, link, fill bar, focus border. */
          blue: '#2D7DD2',
          /** Warna teks pada bg blue (mis. "Baik" badge). */
          'blue-deep': '#1D4ED8',
          /** Warna teks samar di sidebar gelap. */
          'blue-light': '#93C5FD',
          /** Background area konten (di luar card). */
          bg: '#F4F6F9',
          /** Surface card. */
          surface: '#FFFFFF',
          /** Border halus default. */
          border: '#E5E7EB',
        },

        /* ── Kategori Z* ──────────────────────────────────────────── *
         * Warna utama (foreground). Untuk badge bg pakai *-soft.     */
        category: {
          'sangat-baik': {
            DEFAULT: '#16A34A',
            text: '#15803D',
            soft: '#DCFCE7',
            border: '#BBF7D0',
            ring: '#86EFAC',
          },
          baik: {
            DEFAULT: '#2563EB',
            text: '#1D4ED8',
            soft: '#DBEAFE',
            border: '#BFDBFE',
            ring: '#93C5FD',
          },
          cukup: {
            DEFAULT: '#D97706',
            text: '#B45309',
            soft: '#FEF3C7',
            border: '#FDE68A',
            ring: '#FCD34D',
          },
          'perlu-pembinaan': {
            DEFAULT: '#DC2626',
            text: '#B91C1C',
            soft: '#FEE2E2',
            border: '#FECACA',
            ring: '#FCA5A5',
          },
        },

        /* ── Status & state generic ───────────────────────────────── */
        status: {
          on: { DEFAULT: '#16A34A', soft: '#DCFCE7', text: '#15803D' },
          off: { DEFAULT: '#9CA3AF', soft: '#F3F4F6', text: '#6B7280' },
          warn: { DEFAULT: '#D97706', soft: '#FEF3C7', text: '#B45309' },
          err: { DEFAULT: '#DC2626', soft: '#FEE2E2', text: '#B91C1C' },
        },

        /* ── Tile dashboard siswa (pastel per variabel) ───────────── */
        tile: {
          x1: '#E0F2FE',
          x2: '#EDE9FE',
          x3: '#F0FDF4',
          z: '#EFF6FF',
        },

        /* ── Fuzzy curve colors (untuk SVG kurva keanggotaan) ─────── */
        fuzzy: {
          rendah: '#DC2626',
          sedang: '#D97706',
          tinggi: '#16A34A',
          /* Output kurva */
          pp: '#DC2626',
          c: '#D97706',
          b: '#2563EB',
          sb: '#16A34A',
        },
      },

      /* ────────────────────────────────────────────────────────────
       *  Border radius — selaras dengan shadcn variables
       * ──────────────────────────────────────────────────────────── */
      borderRadius: {
        lg: 'var(--radius)',
        md: 'calc(var(--radius) - 2px)',
        sm: 'calc(var(--radius) - 4px)',
      },

      /* ────────────────────────────────────────────────────────────
       *  Font family — system stack (sesuai mockup)
       * ──────────────────────────────────────────────────────────── */
      fontFamily: {
        sans: [
          'system-ui',
          '-apple-system',
          'BlinkMacSystemFont',
          'Segoe UI',
          'Roboto',
          'sans-serif',
        ],
        mono: [
          'ui-monospace',
          'SFMono-Regular',
          'Menlo',
          'Monaco',
          'Consolas',
          'monospace',
        ],
      },

      /* ────────────────────────────────────────────────────────────
       *  Font size — base 13px sesuai mockup
       * ──────────────────────────────────────────────────────────── */
      fontSize: {
        '2xs': ['10px', { lineHeight: '14px' }],
        xs: ['11px', { lineHeight: '15px' }],
        sm: ['12px', { lineHeight: '17px' }],
        base: ['13px', { lineHeight: '19px' }],
        md: ['14px', { lineHeight: '20px' }],
        lg: ['15px', { lineHeight: '22px' }],
        xl: ['17px', { lineHeight: '24px' }],
        '2xl': ['20px', { lineHeight: '28px' }],
        '3xl': ['24px', { lineHeight: '32px' }],
        '4xl': ['28px', { lineHeight: '36px' }],
      },

      /* ────────────────────────────────────────────────────────────
       *  Layout sizes — selaras mockup
       * ──────────────────────────────────────────────────────────── */
      width: {
        sidebar: '220px',
      },
      height: {
        header: '60px',
      },
      minWidth: {
        modal: '500px',
        'modal-lg': '700px',
      },
      maxWidth: {
        modal: '95vw',
      },

      /* ────────────────────────────────────────────────────────────
       *  Shadow — modal & card
       * ──────────────────────────────────────────────────────────── */
      boxShadow: {
        modal: '0 16px 48px rgba(0, 0, 0, 0.28)',
        card: '0 1px 3px rgba(0, 0, 0, 0.04)',
        'card-hover': '0 4px 12px rgba(0, 0, 0, 0.08)',
      },

      /* ────────────────────────────────────────────────────────────
       *  Animations — wajib shadcn (collapsible, accordion, dialog)
       * ──────────────────────────────────────────────────────────── */
      keyframes: {
        'accordion-down': {
          from: { height: '0' },
          to: { height: 'var(--radix-accordion-content-height)' },
        },
        'accordion-up': {
          from: { height: 'var(--radix-accordion-content-height)' },
          to: { height: '0' },
        },
        'fade-in': {
          from: { opacity: '0' },
          to: { opacity: '1' },
        },
        'slide-in-up': {
          from: { transform: 'translateY(8px)', opacity: '0' },
          to: { transform: 'translateY(0)', opacity: '1' },
        },
      },
      animation: {
        'accordion-down': 'accordion-down 0.18s ease-out',
        'accordion-up': 'accordion-up 0.18s ease-out',
        'fade-in': 'fade-in 0.2s ease-out',
        'slide-in-up': 'slide-in-up 0.25s ease-out',
      },

      /* ────────────────────────────────────────────────────────────
       *  Background image — gradient login
       * ──────────────────────────────────────────────────────────── */
      backgroundImage: {
        'sipandu-login':
          'linear-gradient(180deg, #1E3A5F 0%, #2D7DD2 100%)',
      },
    },
  },
  plugins: [animatePlugin],
};

export default config;
