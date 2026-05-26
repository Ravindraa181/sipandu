// 'use client';

// /**
//  * @file (auth)/login/_components/UserLoginForm.tsx
//  * @description Form login terpadu untuk Guru & Siswa.
//  *
//  *  Setelah autentikasi sukses:
//  *   1. Verifikasi role via tabel `profiles`.
//  *   2. Bila role = 'teacher' → redirect ke /dashboard.
//  *      Layout dashboard akan re-route ke /waiting bila belum di-assign.
//  *   3. Bila role = 'student' → redirect ke /siswa/dashboard.
//  *   4. Bila role = 'admin' → tolak login (admin pakai portal sendiri di /admin).
//  *
//  *  Validasi error eksplisit:
//  *   - "Email atau password salah" untuk credential salah
//  *   - "Akun tidak aktif" bila is_active=false
//  */

// import { useState, useTransition } from 'react';
// import { useRouter } from 'next/navigation';
// import { useForm } from 'react-hook-form';
// import { zodResolver } from '@hookform/resolvers/zod';
// import { z } from 'zod';
// import { Eye, EyeOff, Loader2 } from 'lucide-react';
// import { toast } from 'sonner';

// import { createClient } from '@/lib/supabase/client';
// import { Button } from '@/components/ui/button';
// import { Input } from '@/components/ui/input';
// import { Label } from '@/components/ui/label';
// import { ROUTES } from '@/constants';

// const loginSchema = z.object({
//   email: z
//     .string()
//     .min(1, 'Email wajib diisi')
//     .email('Format email tidak valid'),
//   password: z.string().min(6, 'Password minimal 6 karakter'),
// });

// type LoginValues = z.infer<typeof loginSchema>;

// export function UserLoginForm() {
//   const router = useRouter();
//   const [pending, startTransition] = useTransition();
//   const [showPassword, setShowPassword] = useState(false);

//   const {
//     register,
//     handleSubmit,
//     formState: { errors, isSubmitting },
//   } = useForm<LoginValues>({
//     resolver: zodResolver(loginSchema),
//     defaultValues: {
//       email: '',
//       password: '',
//     },
//   });

//   async function onSubmit(values: LoginValues) {
//     const supabase = createClient();

//     // Tahap 1: Auth Supabase
//     const { data: authData, error: authErr } =
//       await supabase.auth.signInWithPassword({
//         email: values.email,
//         password: values.password,
//       });

//     if (authErr || !authData.user) {
//       // Pesan generic untuk credential salah (jangan reveal apakah email ada)
//       toast.error('Email atau password salah', {
//         description:
//           'Periksa kembali email dan password Anda, lalu coba lagi.',
//       });
//       return;
//     }

//     // Tahap 2: Cek role + status di tabel profiles
//     const { data: profile, error: profErr } = await supabase
//       .from('profiles')
//       .select('role, is_active, full_name')
//       .eq('id', authData.user.id)
//       .single();

//     if (profErr || !profile) {
//       await supabase.auth.signOut();
//       toast.error('Profil pengguna tidak ditemukan', {
//         description: 'Hubungi administrator sistem.',
//       });
//       return;
//     }

//     if (!profile.is_active) {
//       await supabase.auth.signOut();
//       toast.error('Akun tidak aktif', {
//         description:
//           'Akun Anda telah dinonaktifkan. Hubungi administrator untuk aktivasi.',
//       });
//       return;
//     }

//     // Tahap 3: Tolak admin dari halaman ini
//     if (profile.role === 'admin') {
//       await supabase.auth.signOut();
//       toast.error('Gunakan portal admin', {
//         description: 'Administrator masuk melalui halaman /admin.',
//       });
//       return;
//     }

//     // Tahap 4: Redirect sesuai role
//     toast.success(`Selamat datang, ${profile.full_name as string}`);
//     startTransition(() => {
//       if (profile.role === 'teacher') {
//         router.push(ROUTES.teacherHome);
//       } else {
//         router.push(ROUTES.studentHome);
//       }
//       router.refresh();
//     });
//   }

//   const isLoading = pending || isSubmitting;

//   return (
//     <form onSubmit={handleSubmit(onSubmit)} className="space-y-3" noValidate>
//       <div className="space-y-1">
//         <Label htmlFor="email">Alamat Email</Label>
//         <Input
//           id="email"
//           type="email"
//           autoComplete="username"
//           placeholder="contoh@sman13.sch.id"
//           aria-invalid={Boolean(errors.email)}
//           {...register('email')}
//         />
//         {errors.email && (
//           <p className="text-2xs text-status-err">{errors.email.message}</p>
//         )}
//       </div>

//       <div className="space-y-1">
//         <Label htmlFor="password">Password</Label>
//         <div className="relative">
//           <Input
//             id="password"
//             type={showPassword ? 'text' : 'password'}
//             autoComplete="current-password"
//             placeholder="••••••••"
//             aria-invalid={Boolean(errors.password)}
//             className="pr-9"
//             {...register('password')}
//           />
//           <button
//             type="button"
//             onClick={() => setShowPassword((s) => !s)}
//             className="absolute right-2 top-1/2 -translate-y-1/2 p-1 text-muted-foreground hover:text-foreground"
//             aria-label={
//               showPassword ? 'Sembunyikan password' : 'Tampilkan password'
//             }
//           >
//             {showPassword ? (
//               <EyeOff className="h-4 w-4" />
//             ) : (
//               <Eye className="h-4 w-4" />
//             )}
//           </button>
//         </div>
//         {errors.password && (
//           <p className="text-2xs text-status-err">{errors.password.message}</p>
//         )}
//       </div>

//       <div className="text-right">
//         <button
//           type="button"
//           onClick={() =>
//             toast.info('Hubungi admin sekolah untuk reset password', {
//               description: 'admin@sman13bdg.sch.id',
//             })
//           }
//           className="text-sm text-sipandu-blue hover:underline"
//         >
//           Lupa password?
//         </button>
//       </div>

//       <Button
//         type="submit"
//         disabled={isLoading}
//         className="h-11 w-full bg-sipandu-navy text-base font-semibold text-white hover:bg-sipandu-navy/90"
//       >
//         {isLoading && (
//           <Loader2 className="mr-2 h-4 w-4 animate-spin" aria-hidden />
//         )}
//         Masuk
//       </Button>
//     </form>
//   );
// }

'use client';

import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { Loader2, Eye, EyeOff, Lock, Mail } from 'lucide-react';
import { toast } from 'sonner';

import { createClient } from '@/lib/supabase/client';
import { ROUTES } from '@/constants';

// Schema validasi menggunakan Zod
const loginSchema = z.object({
  email: z.string().email({ message: 'Email tidak valid' }),
  password: z.string().min(6, { message: 'Password minimal 6 karakter' }),
});

type LoginFormValues = z.infer<typeof loginSchema>;

// Interface untuk tipe data Profile agar tidak dianggap 'never'
interface UserProfile {
  role: string;
  is_active: boolean;
  full_name: string;
}

export function UserLoginForm() {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const supabase = createClient();

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<LoginFormValues>({
    resolver: zodResolver(loginSchema),
    defaultValues: {
      email: '',
      password: '',
    },
  });

  const onSubmit = async (values: LoginFormValues) => {
    setIsLoading(true);
    try {
      // 1. Proses Login ke Supabase Auth
      const { data: authData, error: authError } = await supabase.auth.signInWithPassword({
        email: values.email,
        password: values.password,
      });

      if (authError) {
        // Tampilkan pesan error asli dari Supabase untuk memudahkan diagnosa
        throw new Error(authError.message);
      }

      if (!authData.user) {
        throw new Error('Data user tidak ditemukan');
      }

      // 2. Ambil data profil dari tabel public.profiles
      const { data: profileData, error: profileError } = await supabase
        .from('profiles')
        .select('role, is_active, full_name')
        .eq('id', authData.user.id)
        .single();

      // Perbaikan Error TS2339: Melakukan casting ke interface UserProfile
      const profile = profileData as UserProfile | null;

      if (profileError || !profile) {
        await supabase.auth.signOut();
        throw new Error('Profil pengguna tidak ditemukan');
      }

      // 3. Validasi status akun (is_active)
      if (!profile.is_active) {
        await supabase.auth.signOut();
        toast.error('Akun Anda dinonaktifkan. Silakan hubungi admin.');
        return;
      }

      // 4. Pengalihan halaman berdasarkan role
      if (profile.role === 'admin') {
        toast.success(`Selamat datang Admin, ${profile.full_name}`);
        router.push(ROUTES.adminHome);
        router.refresh();
        return;
      }

      toast.success(`Selamat datang, ${profile.full_name}`);

      if (profile.role === 'teacher') {
        router.push(ROUTES.teacherHome);
      } else if (profile.role === 'student') {
        router.push(ROUTES.studentHome);
      } else {
        router.push(ROUTES.waiting);
      }
      
      router.refresh();
    } catch (error: any) {
      toast.error(error.message || 'Terjadi kesalahan saat login');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="grid gap-6">
      <form onSubmit={handleSubmit(onSubmit)}>
        <div className="grid gap-4">
          <div className="grid gap-2">
            <div className="relative">
              <Mail className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
              {/* ALASAN: suppressHydrationWarning mencegah warning dari browser extension
                  (password manager) yang menyuntikkan atribut data-has-listeners ke input */}
              <input
                {...register('email')}
                placeholder="nama@email.com"
                type="email"
                autoCapitalize="none"
                autoComplete="email"
                autoCorrect="off"
                disabled={isLoading}
                suppressHydrationWarning
                className="flex h-10 w-full rounded-md border border-input bg-background px-10 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
              />
            </div>
            {errors.email && (
              <p className="text-xs text-destructive">{errors.email.message}</p>
            )}
          </div>

          <div className="grid gap-2">
            <div className="relative">
              <Lock className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
              <input
                {...register('password')}
                placeholder="••••••••"
                type={showPassword ? 'text' : 'password'}
                autoComplete="current-password"
                disabled={isLoading}
                suppressHydrationWarning
                className="flex h-10 w-full rounded-md border border-input bg-background px-10 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="absolute right-3 top-3 text-muted-foreground hover:text-foreground"
              >
                {showPassword ? (
                  <EyeOff className="h-4 w-4" />
                ) : (
                  <Eye className="h-4 w-4" />
                )}
              </button>
            </div>
            {errors.password && (
              <p className="text-xs text-destructive">{errors.password.message}</p>
            )}
          </div>

          <button
            className="inline-flex items-center justify-center rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground ring-offset-background transition-colors hover:bg-primary/90 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50"
            disabled={isLoading}
          >
            {isLoading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
            Masuk ke SiPandu
          </button>
        </div>
      </form>
    </div>
  );
}