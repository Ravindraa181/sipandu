'use client';

/**
 * @file components/shared/MobileSidebarContext.tsx
 * @description Context React untuk mengontrol buka/tutup sidebar pada
 * tampilan mobile. Disediakan oleh MobileLayoutShell, dikonsumsi oleh
 * TopHeader (tombol hamburger).
 *
 * Default context menggunakan no-op functions sehingga aman dipakai
 * di luar provider (mis. halaman login yang tidak pakai MobileLayoutShell).
 */

import { createContext, useCallback, useContext, useState } from 'react';
import type { ReactNode } from 'react';

interface MobileSidebarContextValue {
  isOpen: boolean;
  open: () => void;
  close: () => void;
}

const MobileSidebarContext = createContext<MobileSidebarContextValue>({
  isOpen: false,
  open: () => {},
  close: () => {},
});

/** Provider — letakkan di root MobileLayoutShell. */
export function MobileSidebarProvider({ children }: { children: ReactNode }) {
  const [isOpen, setIsOpen] = useState(false);

  // useCallback agar referensi open/close stabil (tidak trigger re-render anak)
  const open  = useCallback(() => setIsOpen(true), []);
  const close = useCallback(() => setIsOpen(false), []);

  return (
    <MobileSidebarContext.Provider value={{ isOpen, open, close }}>
      {children}
    </MobileSidebarContext.Provider>
  );
}

/** Hook untuk mengakses state dan aksi sidebar mobile. */
export function useMobileSidebar() {
  return useContext(MobileSidebarContext);
}
