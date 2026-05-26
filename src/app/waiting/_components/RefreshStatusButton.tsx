'use client';

/**
 * @file waiting/_components/RefreshStatusButton.tsx
 * @description Tombol "Refresh Status" yang re-check assignment guru.
 *
 *  Gunakan router.refresh() agar Server Component layout-nya re-fetch
 *  session + assignment dari Supabase. Bila sudah di-assign, layout
 *  akan men-redirect ke /dashboard secara otomatis.
 */

import { useTransition } from 'react';
import { useRouter } from 'next/navigation';
import { Loader2, RefreshCw } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';

export function RefreshStatusButton() {
  const router = useRouter();
  const [pending, startTransition] = useTransition();

  function handleRefresh() {
    startTransition(() => {
      router.refresh();
      toast.info('Memeriksa status penugasan...');
    });
  }

  return (
    <Button
      type="button"
      variant="outline"
      onClick={handleRefresh}
      disabled={pending}
      className="gap-1.5 border-sipandu-blue text-sipandu-blue hover:bg-blue-50"
    >
      {pending ? (
        <Loader2 className="h-3.5 w-3.5 animate-spin" aria-hidden />
      ) : (
        <RefreshCw className="h-3.5 w-3.5" aria-hidden />
      )}
      Refresh Status
    </Button>
  );
}
