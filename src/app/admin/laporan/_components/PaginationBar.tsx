'use client';

import { useRouter, useSearchParams } from 'next/navigation';
import { useTransition } from 'react';
import { ChevronLeft, ChevronRight } from 'lucide-react';
import { Button } from '@/components/ui/button';

export interface PaginationBarProps {
  currentPage: number;
  totalPages: number;
  totalRows: number;
  pageSize: number;
}

export function PaginationBar({
  currentPage,
  totalPages,
  totalRows,
  pageSize,
}: PaginationBarProps) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [pending, startTransition] = useTransition();

  if (totalPages <= 1) return null;

  function goTo(page: number) {
    const params = new URLSearchParams(searchParams.toString());
    params.set('page', String(page));
    startTransition(() => router.push(`?${params.toString()}`));
  }

  // Build page number list: always show first, last, current ±2, ellipsis elsewhere
  const pages: (number | 'ellipsis')[] = [];
  const delta = 2;
  const range: number[] = [];
  for (
    let i = Math.max(1, currentPage - delta);
    i <= Math.min(totalPages, currentPage + delta);
    i++
  ) {
    range.push(i);
  }
  if (range[0] > 1) {
    pages.push(1);
    if (range[0] > 2) pages.push('ellipsis');
  }
  pages.push(...range);
  if (range[range.length - 1] < totalPages) {
    if (range[range.length - 1] < totalPages - 1) pages.push('ellipsis');
    pages.push(totalPages);
  }

  const from = (currentPage - 1) * pageSize + 1;
  const to = Math.min(currentPage * pageSize, totalRows);

  return (
    <div className="flex items-center justify-between gap-2 rounded-md border border-sipandu-border bg-white px-3 py-2">
      <span className="text-xs text-muted-foreground">
        {from}–{to} dari {totalRows} siswa
      </span>

      <div className="flex items-center gap-1">
        <Button
          size="sm"
          variant="outline"
          className="h-7 w-7 p-0"
          disabled={currentPage <= 1 || pending}
          onClick={() => goTo(currentPage - 1)}
        >
          <ChevronLeft className="h-3.5 w-3.5" />
        </Button>

        {pages.map((p, i) =>
          p === 'ellipsis' ? (
            <span key={`e-${i}`} className="px-1 text-xs text-muted-foreground">
              …
            </span>
          ) : (
            <Button
              key={p}
              size="sm"
              variant={p === currentPage ? 'default' : 'outline'}
              className={`h-7 min-w-[28px] px-2 text-xs ${
                p === currentPage
                  ? 'bg-sipandu-blue text-white hover:bg-sipandu-blue/90'
                  : ''
              }`}
              disabled={pending}
              onClick={() => goTo(p)}
            >
              {p}
            </Button>
          ),
        )}

        <Button
          size="sm"
          variant="outline"
          className="h-7 w-7 p-0"
          disabled={currentPage >= totalPages || pending}
          onClick={() => goTo(currentPage + 1)}
        >
          <ChevronRight className="h-3.5 w-3.5" />
        </Button>
      </div>
    </div>
  );
}
