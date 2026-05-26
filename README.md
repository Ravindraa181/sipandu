# SiPandu — Sistem Penilaian Perilaku Siswa Terpadu

A student behavior assessment system for SMAN 13 Bandung that uses **Fuzzy Mamdani** inference to calculate student behavior scores based on attendance, behavior points, and peer review.

## Features

- **Multi-role authentication** — Admin, Homeroom Teacher, Student
- **Attendance tracking** — Monthly input with percentage calculation
- **Behavior points** — Violation & reward transaction system
- **Peer review** — Anonymous 5-aspect peer assessment
- **Fuzzy Mamdani engine** — 27 IF-THEN rules, centroid defuzzification
- **Dashboard & reports** — PDF/Excel export with category distribution
- **Fuzzy configuration** — Admin can adjust membership parameters and rules via UI

## Tech Stack

- **Framework:** Next.js 16.2 (App Router)
- **Language:** TypeScript 5
- **Styling:** Tailwind CSS 3 + shadcn/ui
- **Backend:** Supabase (PostgreSQL + Auth + RLS)
- **Forms:** React Hook Form + Zod
- **PDF Export:** jsPDF + jspdf-autotable

## Getting Started

### Prerequisites

- Node.js 18+
- Supabase project ([supabase.com](https://supabase.com))

### Installation

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/sipandu.git
cd sipandu

# Install dependencies
npm install

# Set up environment variables
cp .env.local.example .env.local
# Fill in your Supabase credentials in .env.local
```

### Environment Variables

Create a `.env.local` file in the root directory:

```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key
NEXT_PUBLIC_APP_NAME=SiPandu
NEXT_PUBLIC_SCHOOL_NAME=SMAN 13 Bandung
NEXT_PUBLIC_BASE_URL=http://localhost:3000
```

### Database Setup

Run the migration file in your Supabase SQL editor:

```
supabase/migrations/01_migration.sql
```

### Run Development Server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Project Structure

```
src/
├── app/
│   ├── (auth)/login/        # Teacher & Student login
│   ├── admin/               # Admin portal (8 pages)
│   ├── dashboard/           # Homeroom teacher portal
│   ├── siswa/               # Student portal
│   └── api/                 # API routes (export, fuzzy, auth)
├── components/
│   ├── shared/              # Layout, sidebar, header
│   └── ui/                  # shadcn/ui components
└── lib/
    ├── fuzzy/               # Fuzzy Mamdani engine
    ├── supabase/            # Supabase client
    └── actions/             # Server actions
```

## Fuzzy Mamdani System

| Variable | Description | Range |
|---|---|---|
| X1 | Attendance percentage | 0 – 100% |
| X2 | Behavior points | 0 – 100 |
| X3 | Peer review score | 0 – 100 |
| Z* | Final behavior score (defuzzified) | 0 – 100 |

**Output categories:**

| Category | Score Range |
|---|---|
| Perlu Pembinaan (Needs Guidance) | Z* < 55 |
| Cukup (Sufficient) | 55 ≤ Z* < 70 |
| Baik (Good) | 70 ≤ Z* < 85 |
| Sangat Baik (Excellent) | Z* ≥ 85 |

## Deployment

This project is deployed on **Vercel**. For deployment:

1. Push to GitHub
2. Import project on [vercel.com](https://vercel.com)
3. Add environment variables in Vercel dashboard
4. Configure Supabase redirect URLs to your Vercel domain

## License

This project was developed as an undergraduate thesis project at **Universitas Pendidikan Indonesia**.
