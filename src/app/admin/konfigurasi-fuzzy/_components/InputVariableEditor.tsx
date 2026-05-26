'use client';

/**
 * @file admin/konfigurasi-fuzzy/_components/InputVariableEditor.tsx
 * @description Akordion editor parameter untuk satu variabel input
 * (X1 / X2 / X3). Berisi 3 himpunan (Rendah/Sedang/Tinggi)
 * dengan dropdown tipe + input parameter, plus preview
 * kurva SVG di kanan yang update real-time.
 */

import { useState, useTransition } from 'react';
import { ChevronUp, Loader2, RotateCcw } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { cn } from '@/lib/utils/cn';
import { updateFuzzyConfig } from '@/lib/actions/admin';
import { DEFAULT_FUZZY_CONFIG } from '@/lib/fuzzy/rules';
import type {
  InputSetName,
  MembershipFunctionType,
  MembershipFunction,
} from '@/lib/fuzzy/types';
import { MembershipCurveChart } from './MembershipCurveChart';

export interface InputVariableEditorProps {
  variable: 'x1' | 'x2' | 'x3';
  title: string;
  subtitle: string;
  defaultOpen?: boolean;
  initialSets: {
    rendah: MembershipFunction;
    sedang: MembershipFunction;
    tinggi: MembershipFunction;
  };
}

const SET_COLORS: Record<InputSetName, string> = {
  rendah: '#DC2626',
  sedang: '#D97706',
  tinggi: '#16A34A',
};

const SET_LABELS: Record<InputSetName, string> = {
  rendah: 'Rendah',
  sedang: 'Sedang',
  tinggi: 'Tinggi',
};

const TYPE_OPTIONS: Array<{
  value: MembershipFunctionType;
  label: string;
  paramCount: number;
}> = [
  { value: 'trapezoid_left', label: 'Trapesium Turun', paramCount: 2 },
  { value: 'triangle', label: 'Segitiga', paramCount: 3 },
  { value: 'trapezoid_right', label: 'Trapesium Naik', paramCount: 2 },
];

export function InputVariableEditor({
  variable,
  title,
  subtitle,
  defaultOpen = false,
  initialSets,
}: InputVariableEditorProps) {
  const [open, setOpen] = useState(defaultOpen);
  const [pending, startTransition] = useTransition();

  const [sets, setSets] = useState<{
    rendah: MembershipFunction;
    sedang: MembershipFunction;
    tinggi: MembershipFunction;
  }>(initialSets);

  function updateSet(
    label: InputSetName,
    update: Partial<MembershipFunction>,
  ) {
    setSets((prev) => ({
      ...prev,
      [label]: { ...prev[label], ...update },
    }));
  }

  function setParam(label: InputSetName, idx: number, value: number) {
    setSets((prev) => {
      const newParams = [...prev[label].parameters];
      newParams[idx] = value;
      return {
        ...prev,
        [label]: { ...prev[label], parameters: newParams },
      };
    });
  }

  function setType(label: InputSetName, type: MembershipFunctionType) {
    const tOpt = TYPE_OPTIONS.find((t) => t.value === type);
    const count = tOpt?.paramCount ?? 2;
    const existing = sets[label].parameters;
    const newParams = Array.from({ length: count }, (_, i) =>
      typeof existing[i] === 'number' ? existing[i] : i * 20 + 40,
    );
    updateSet(label, { type, parameters: newParams });
  }

  /** Reset state lokal ke nilai default dari DEFAULT_FUZZY_CONFIG (belum disimpan ke DB). */
  function handleResetDefault() {
    setSets({ ...DEFAULT_FUZZY_CONFIG[variable] });
    toast.success(
      `${variable.toUpperCase()} direset ke default (belum disimpan)`,
    );
  }

  function handleSave() {
    startTransition(async () => {
      const labels: InputSetName[] = ['rendah', 'sedang', 'tinggi'];
      let allOk = true;
      for (const label of labels) {
        const result = await updateFuzzyConfig({
          variableName: variable,
          setName: label,
          functionType: sets[label].type,
          parameters: [...sets[label].parameters],
        });
        if (!result.ok) {
          allOk = false;
          toast.error(`Gagal menyimpan ${label}`, {
            description: result.error,
          });
          break;
        }
      }
      if (allOk) toast.success(`Konfigurasi ${variable.toUpperCase()} disimpan`);
    });
  }

  const chartSets = (['rendah', 'sedang', 'tinggi'] as InputSetName[]).map(
    (label) => ({
      label: SET_LABELS[label],
      color: SET_COLORS[label],
      fn: sets[label],
    }),
  );

  return (
    <div className="overflow-hidden rounded-md border border-sipandu-border bg-white">
      <button
        type="button"
        onClick={() => setOpen((v) => !v)}
        className="flex w-full items-center justify-between px-3.5 py-3 text-left transition-colors hover:bg-gray-50"
      >
        <span className="text-base font-bold text-foreground">
          {title}{' '}
          <span className="ml-1 text-xs font-normal text-muted-foreground">
            {subtitle}
          </span>
        </span>
        <ChevronUp
          className={cn(
            'h-3.5 w-3.5 transition-transform',
            !open && 'rotate-180',
          )}
          aria-hidden
        />
      </button>

      {open && (
        <div className="border-t border-sipandu-border p-3.5">
          <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">
            <div className="space-y-2">
              {(['rendah', 'sedang', 'tinggi'] as InputSetName[]).map(
                (label) => {
                  const fn = sets[label];
                  const tOpt = TYPE_OPTIONS.find(
                    (t) => t.value === fn.type,
                  );
                  return (
                    <div
                      key={label}
                      className="rounded-md border border-sipandu-border p-2.5"
                      style={{ borderLeftColor: SET_COLORS[label], borderLeftWidth: 3 }}
                    >
                      <div
                        className="mb-1.5 text-xs font-bold"
                        style={{ color: SET_COLORS[label] }}
                      >
                        {SET_LABELS[label]}
                      </div>
                      <div className="flex flex-wrap items-end gap-1.5">
                        <div>
                          <label className="mb-1 block text-2xs text-muted-foreground">
                            Tipe
                          </label>
                          <Select
                            value={fn.type}
                            onValueChange={(v) =>
                              setType(label, v as MembershipFunctionType)
                            }
                          >
                            <SelectTrigger className="h-7 w-[150px] text-xs">
                              <SelectValue />
                            </SelectTrigger>
                            <SelectContent>
                              {TYPE_OPTIONS.map((t) => (
                                <SelectItem key={t.value} value={t.value}>
                                  {t.label}
                                </SelectItem>
                              ))}
                            </SelectContent>
                          </Select>
                        </div>
                        {Array.from(
                          { length: tOpt?.paramCount ?? 2 },
                          (_, idx) => (
                            <div key={idx}>
                              <label className="mb-1 block text-2xs text-muted-foreground">
                                Param {String.fromCharCode(97 + idx)}
                              </label>
                              <Input
                                type="number"
                                value={fn.parameters[idx] ?? 0}
                                onChange={(e) =>
                                  setParam(label, idx, Number(e.target.value))
                                }
                                className="h-7 w-16 text-center text-xs"
                              />
                            </div>
                          ),
                        )}
                      </div>
                    </div>
                  );
                },
              )}

              <div className="flex flex-wrap gap-2">
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  onClick={handleResetDefault}
                  disabled={pending}
                  className="gap-1.5"
                >
                  <RotateCcw className="h-3 w-3" aria-hidden />
                  Reset Default
                </Button>
                <Button
                  type="button"
                  onClick={handleSave}
                  disabled={pending}
                  size="sm"
                  className="bg-sipandu-blue text-white hover:bg-sipandu-blue/90"
                >
                  {pending && (
                    <Loader2
                      className="mr-1.5 h-3 w-3 animate-spin"
                      aria-hidden
                    />
                  )}
                  Simpan {variable.toUpperCase()}
                </Button>
              </div>
            </div>

            <div className="rounded-md border border-sipandu-border bg-gray-50 p-2">
              <MembershipCurveChart sets={chartSets} />
            </div>
          </div>
        </div>
      )}
    </div>
  );
}