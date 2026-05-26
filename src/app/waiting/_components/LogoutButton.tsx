'use client';

/**
 * @file waiting/_components/LogoutButton.tsx
 * @description Tombol "Keluar" sederhana untuk halaman waiting.
 */

import { useRouter } from 'next/navigation';
import { LogOut } from 'lucide-react';

import { createClient } from '@/lib/supabase/client';
import { Button } from '@/components/ui/button';
import { ROUTES } from '@/constants';

export function LogoutButton() {
  const router = useRouter();

  async function handleLogout() {
    const supabase = createClient();
    await supabase.auth.signOut();
    router.push(ROUTES.login);
    router.refresh();
  }

  return (
    <Button
      type="button"
      variant="outline"
      size="sm"
      onClick={handleLogout}
      className="gap-1.5"
    >
      <LogOut className="h-3 w-3" aria-hidden /> Keluar
    </Button>
  );
}
