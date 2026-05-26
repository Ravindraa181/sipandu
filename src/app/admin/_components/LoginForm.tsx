'use client';

import { useState, useTransition } from 'react';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { Eye, EyeOff, Loader2 } from 'lucide-react';
import { toast } from 'sonner';

import { createClient } from '@/lib/supabase/client';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';

const loginSchema = z.object({
  email: z
    .string()
    .min(1, 'Email wajib diisi')
    .email('Format email tidak valid'),
  password: z.string().min(6, 'Password minimal 6 karakter'),
  // PERBAIKAN: Cukup gunakan z.boolean() untuk mengatasi error undefined
  remember: z.boolean(),
});

type LoginValues = z.infer<typeof loginSchema>;

export function LoginForm() {
  const router = useRouter();
  const [pending, startTransition] = useTransition();
  const [showPassword, setShowPassword] = useState(false);

  const {
    register,
    handleSubmit,
    setValue, // Digunakan khusus untuk Checkbox
    formState: { errors },
  } = useForm<LoginValues>({
    resolver: zodResolver(loginSchema),
    // Harus inisiasi defaultValues agar tidak undefined
    defaultValues: {
      email: '',
      password: '',
      remember: false,
    },
  });

  const onSubmit = (values: LoginValues) => {
    startTransition(async () => {
      const supabase = createClient();
      const { error } = await supabase.auth.signInWithPassword({
        email: values.email,
        password: values.password,
      });

      if (error) {
        // Tampilkan pesan error asli dari Supabase untuk memudahkan diagnosa
        toast.error('Gagal masuk', { description: error.message });
        return;
      }

      toast.success('Login berhasil');
      router.push('/admin/dashboard');
      router.refresh();
    });
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-4" noValidate>
      <div>
        <Label htmlFor="email">Email</Label>
        <Input
          id="email"
          type="email"
          placeholder="admin@sekolah.id"
          {...register('email')}
        />
        {errors.email && (
          <p className="mt-1 text-xs text-status-err">{errors.email.message}</p>
        )}
      </div>

      <div>
        <Label htmlFor="password">Password</Label>
        <div className="relative">
          <Input
            id="password"
            type={showPassword ? 'text' : 'password'}
            placeholder="••••••••"
            className="pr-9"
            {...register('password')}
          />
          <button
            type="button"
            onClick={() => setShowPassword(!showPassword)}
            className="absolute right-2 top-1/2 -translate-y-1/2 p-1 text-muted-foreground hover:text-foreground"
          >
            {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
          </button>
        </div>
        {errors.password && (
          <p className="mt-1 text-xs text-status-err">{errors.password.message}</p>
        )}
      </div>

      {/* ALASAN: pakai native <input type="checkbox"> bukan Radix Checkbox —
          Radix punya hidden input internal yang tidak bisa diberi
          suppressHydrationWarning dari luar, menyebabkan warning hydration
          dari browser extension (password manager) */}
      <label className="flex cursor-pointer items-center gap-2 text-sm text-foreground">
        <input
          type="checkbox"
          id="remember"
          suppressHydrationWarning
          onChange={(e) => setValue('remember', e.target.checked)}
          className="h-4 w-4 rounded border border-input accent-sipandu-navy"
        />
        <span>Ingat saya</span>
      </label>

      <Button
        type="submit"
        disabled={pending}
        className="h-11 w-full bg-sipandu-navy text-base font-semibold text-white hover:bg-sipandu-navy/90"
      >
        {pending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
        Masuk
      </Button>
    </form>
  );
}