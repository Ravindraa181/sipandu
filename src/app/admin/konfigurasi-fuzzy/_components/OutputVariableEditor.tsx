'use client';

/**
 * @file admin/konfigurasi-fuzzy/_components/OutputVariableEditor.tsx
 * @description Editor parameter untuk variabel output Z* (4 himpunan:
 * Perlu Pembinaan / Cukup / Baik / Sangat Baik).
 */

import { useState, useTransition } from 'react';
import { Loader2, RotateCcw } from 'lucide-react';
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
import { updateFuzzyConfig } from '@/lib/actions/admin';
import { DEFAULT_FUZZY_CONFIG } from '@/lib/fuzzy/rules';
import type {
  CategoryType,
  MembershipFunctionType,
  MembershipFunction,
} from '@/lib/fuzzy/types';
import { MembershipCurveChart } from './MembershipCurveChart';

export interface OutputVariableEditorProps {
  initialSets: {
    perlu_pembinaan: MembershipFunction;
    cukup: MembershipFunction;
    baik: MembershipFunction;
    sangat_baik: MembershipFunction;
  };
}

const SET_LABELS: Record<CategoryType, string> = {
  perlu_pembinaan: 'Perlu Pembinaan',
  cukup: 'Cukup',
  baik: 'Baik',
  sangat_baik: 'Sangat Baik',
};

const SET_COLORS: Record<CategoryType, string> = {
  perlu_pembinaan: '#DC2626',
  cukup: '#D97706',
  baik: '#2563EB',
  sangat_baik: '#16A34A',
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

const ORDER: CategoryType[] = ['perlu_pembinaan', 'cukup', 'baik', 'sangat_baik'];

export function OutputVariableEditor({
  initialSets,
}: OutputVariableEditorProps) {
  const [pending, startTransition] = useTransition();
  const [sets, setSets] =
    useState<OutputVariableEditorProps['initialSets']>(initialSets);

  function setType(label: CategoryType, type: MembershipFunctionType) {
    const tOpt = TYPE_OPTIONS.find((t) => t.value === type);
    const count = tOpt?.paramCount ?? 2;
    const existing = sets[label].parameters;
    const newParams = Array.from({ length: count }, (_, i) =>
      typeof existing[i] === 'number' ? existing[i] : i * 20 + 40,
    );
    setSets((prev) => ({
      ...prev,
      [label]: { type, parameters: newParams },
    }));
  }

  function setParam(label: CategoryType, idx: number, value: number) {
    setSets((prev) => {
      const newParams = [...prev[label].parameters];
      newParams[idx] = value;
      return {
        ...prev,
        [label]: { ...prev[label], parameters: newParams },
      };
    });
  }

  /** Reset state lokal ke nilai default dari DEFAULT_FUZZY_CONFIG.output (belum disimpan ke DB). */
  function handleResetDefault() {
    setSets({ ...DEFAULT_FUZZY_CONFIG.output });
    toast.success('Output Z* direset ke default (belum disimpan)');
  }

  function handleSave() {
    startTransition(async () => {
      let allOk = true;
      for (const label of ORDER) {
        const result = await updateFuzzyConfig({
          variableName: 'z',
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
      if (allOk) toast.success('Konfigurasi output Z* disimpan');
    });
  }

  const chartSets = ORDER.map((label) => ({
    label: SET_LABELS[label],
    color: SET_COLORS[label],
    fn: sets[label],
  }));

  return (
    <div className="rounded-md border border-sipandu-border bg-white p-3.5">
      <div className="mb-3 text-base font-bold text-foreground">
        Z* — Output Skor Perilaku{' '}
        <span className="ml-1 text-xs font-normal text-muted-foreground">
          (Semesta: 0–100)
        </span>
      </div>

      <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">
        <div className="space-y-2">
          {ORDER.map((label) => {
            const fn = sets[label];
            const tOpt = TYPE_OPTIONS.find((t) => t.value === fn.type);
            return (
              <div
                key={label}
                className="rounded-md border border-sipandu-border p-2.5"
                style={{
                  borderLeftColor: SET_COLORS[label],
                  borderLeftWidth: 3,
                }}
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
          })}

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
                <Loader2 className="mr-1.5 h-3 w-3 animate-spin" aria-hidden />
              )}
              Simpan Output
            </Button>
          </div>
        </div>

        <div className="rounded-md border border-sipandu-border bg-gray-50 p-2">
          <MembershipCurveChart sets={chartSets} />
        </div>
      </div>
    </div>
  );
}