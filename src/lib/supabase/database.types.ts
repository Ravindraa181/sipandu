export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.5"
  }
  graphql_public: {
    Tables: {
      [_ in never]: never
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      graphql: {
        Args: {
          extensions?: Json
          operationName?: string
          query?: string
          variables?: Json
        }
        Returns: Json
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
  public: {
    Tables: {
      academic_periods: {
        Row: {
          academic_year: string
          created_at: string
          end_date: string
          id: string
          name: string
          semester: Database["public"]["Enums"]["semester_type"]
          start_date: string
          status: Database["public"]["Enums"]["period_status"]
          updated_at: string
        }
        Insert: {
          academic_year: string
          created_at?: string
          end_date: string
          id?: string
          name: string
          semester: Database["public"]["Enums"]["semester_type"]
          start_date: string
          status?: Database["public"]["Enums"]["period_status"]
          updated_at?: string
        }
        Update: {
          academic_year?: string
          created_at?: string
          end_date?: string
          id?: string
          name?: string
          semester?: Database["public"]["Enums"]["semester_type"]
          start_date?: string
          status?: Database["public"]["Enums"]["period_status"]
          updated_at?: string
        }
        Relationships: []
      }
      behavior_final_scores: {
        Row: {
          active_rules: Json | null
          alpha_b: number | null
          alpha_c: number | null
          alpha_pp: number | null
          alpha_sb: number | null
          category: Database["public"]["Enums"]["behavior_category"] | null
          computed_at: string | null
          created_at: string
          enrollment_id: string
          id: string
          raw_x2: number | null
          updated_at: string
          x1: number | null
          x2: number | null
          x3: number | null
          z_star: number | null
        }
        Insert: {
          active_rules?: Json | null
          alpha_b?: number | null
          alpha_c?: number | null
          alpha_pp?: number | null
          alpha_sb?: number | null
          category?: Database["public"]["Enums"]["behavior_category"] | null
          computed_at?: string | null
          created_at?: string
          enrollment_id: string
          id?: string
          raw_x2?: number | null
          updated_at?: string
          x1?: number | null
          x2?: number | null
          x3?: number | null
          z_star?: number | null
        }
        Update: {
          active_rules?: Json | null
          alpha_b?: number | null
          alpha_c?: number | null
          alpha_pp?: number | null
          alpha_sb?: number | null
          category?: Database["public"]["Enums"]["behavior_category"] | null
          computed_at?: string | null
          created_at?: string
          enrollment_id?: string
          id?: string
          raw_x2?: number | null
          updated_at?: string
          x1?: number | null
          x2?: number | null
          x3?: number | null
          z_star?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "behavior_final_scores_enrollment_id_fkey"
            columns: ["enrollment_id"]
            isOneToOne: true
            referencedRelation: "student_class_enrollments"
            referencedColumns: ["id"]
          },
        ]
      }
      behavior_point_transactions: {
        Row: {
          created_at: string
          deleted_at: string | null
          enrollment_id: string
          id: string
          notes: string | null
          points_delta: number
          raw_score_after: number
          recorded_by: string
          reward_category_id: string | null
          transaction_date: string
          transaction_type: Database["public"]["Enums"]["transaction_type"]
          violation_category_id: string | null
        }
        Insert: {
          created_at?: string
          deleted_at?: string | null
          enrollment_id: string
          id?: string
          notes?: string | null
          points_delta: number
          raw_score_after: number
          recorded_by: string
          reward_category_id?: string | null
          transaction_date?: string
          transaction_type: Database["public"]["Enums"]["transaction_type"]
          violation_category_id?: string | null
        }
        Update: {
          created_at?: string
          deleted_at?: string | null
          enrollment_id?: string
          id?: string
          notes?: string | null
          points_delta?: number
          raw_score_after?: number
          recorded_by?: string
          reward_category_id?: string | null
          transaction_date?: string
          transaction_type?: Database["public"]["Enums"]["transaction_type"]
          violation_category_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "behavior_point_transactions_enrollment_id_fkey"
            columns: ["enrollment_id"]
            isOneToOne: false
            referencedRelation: "student_class_enrollments"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "behavior_point_transactions_recorded_by_fkey"
            columns: ["recorded_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "behavior_point_transactions_reward_category_id_fkey"
            columns: ["reward_category_id"]
            isOneToOne: false
            referencedRelation: "reward_categories"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "behavior_point_transactions_violation_category_id_fkey"
            columns: ["violation_category_id"]
            isOneToOne: false
            referencedRelation: "violation_categories"
            referencedColumns: ["id"]
          },
        ]
      }
      class_period_assignments: {
        Row: {
          class_id: string
          created_at: string
          homeroom_teacher_id: string | null
          id: string
          period_id: string
          updated_at: string
        }
        Insert: {
          class_id: string
          created_at?: string
          homeroom_teacher_id?: string | null
          id?: string
          period_id: string
          updated_at?: string
        }
        Update: {
          class_id?: string
          created_at?: string
          homeroom_teacher_id?: string | null
          id?: string
          period_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "class_period_assignments_class_id_fkey"
            columns: ["class_id"]
            isOneToOne: false
            referencedRelation: "classes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "class_period_assignments_homeroom_teacher_id_fkey"
            columns: ["homeroom_teacher_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "class_period_assignments_period_id_fkey"
            columns: ["period_id"]
            isOneToOne: false
            referencedRelation: "academic_periods"
            referencedColumns: ["id"]
          },
        ]
      }
      classes: {
        Row: {
          created_at: string
          grade_level: Database["public"]["Enums"]["grade_level_type"]
          id: string
          name: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          grade_level: Database["public"]["Enums"]["grade_level_type"]
          id?: string
          name: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          grade_level?: Database["public"]["Enums"]["grade_level_type"]
          id?: string
          name?: string
          updated_at?: string
        }
        Relationships: []
      }
      fuzzy_configurations: {
        Row: {
          function_type: Database["public"]["Enums"]["membership_function_type"]
          id: string
          parameters: number[]
          set_name: Database["public"]["Enums"]["fuzzy_set_name"]
          updated_at: string
          updated_by: string | null
          variable_name: string
        }
        Insert: {
          function_type: Database["public"]["Enums"]["membership_function_type"]
          id?: string
          parameters: number[]
          set_name: Database["public"]["Enums"]["fuzzy_set_name"]
          updated_at?: string
          updated_by?: string | null
          variable_name: string
        }
        Update: {
          function_type?: Database["public"]["Enums"]["membership_function_type"]
          id?: string
          parameters?: number[]
          set_name?: Database["public"]["Enums"]["fuzzy_set_name"]
          updated_at?: string
          updated_by?: string | null
          variable_name?: string
        }
        Relationships: [
          {
            foreignKeyName: "fuzzy_configurations_updated_by_fkey"
            columns: ["updated_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      fuzzy_rules: {
        Row: {
          id: string
          output_set: Database["public"]["Enums"]["fuzzy_set_name"]
          rule_number: number
          updated_at: string
          updated_by: string | null
          x1_set: Database["public"]["Enums"]["fuzzy_set_name"]
          x2_set: Database["public"]["Enums"]["fuzzy_set_name"]
          x3_set: Database["public"]["Enums"]["fuzzy_set_name"]
        }
        Insert: {
          id?: string
          output_set: Database["public"]["Enums"]["fuzzy_set_name"]
          rule_number: number
          updated_at?: string
          updated_by?: string | null
          x1_set: Database["public"]["Enums"]["fuzzy_set_name"]
          x2_set: Database["public"]["Enums"]["fuzzy_set_name"]
          x3_set: Database["public"]["Enums"]["fuzzy_set_name"]
        }
        Update: {
          id?: string
          output_set?: Database["public"]["Enums"]["fuzzy_set_name"]
          rule_number?: number
          updated_at?: string
          updated_by?: string | null
          x1_set?: Database["public"]["Enums"]["fuzzy_set_name"]
          x2_set?: Database["public"]["Enums"]["fuzzy_set_name"]
          x3_set?: Database["public"]["Enums"]["fuzzy_set_name"]
        }
        Relationships: [
          {
            foreignKeyName: "fuzzy_rules_updated_by_fkey"
            columns: ["updated_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      monthly_attendance: {
        Row: {
          absent_days: number
          created_at: string
          effective_days: number
          enrollment_id: string
          id: string
          is_locked: boolean
          locked_at: string | null
          locked_by: string | null
          month: number
          permit_days: number
          present_days: number
          sick_days: number
          updated_at: string
          year: number
        }
        Insert: {
          absent_days?: number
          created_at?: string
          effective_days: number
          enrollment_id: string
          id?: string
          is_locked?: boolean
          locked_at?: string | null
          locked_by?: string | null
          month: number
          permit_days?: number
          present_days?: number
          sick_days?: number
          updated_at?: string
          year: number
        }
        Update: {
          absent_days?: number
          created_at?: string
          effective_days?: number
          enrollment_id?: string
          id?: string
          is_locked?: boolean
          locked_at?: string | null
          locked_by?: string | null
          month?: number
          permit_days?: number
          present_days?: number
          sick_days?: number
          updated_at?: string
          year?: number
        }
        Relationships: [
          {
            foreignKeyName: "monthly_attendance_enrollment_id_fkey"
            columns: ["enrollment_id"]
            isOneToOne: false
            referencedRelation: "student_class_enrollments"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "monthly_attendance_locked_by_fkey"
            columns: ["locked_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      peer_review_progress: {
        Row: {
          completed_count: number
          created_at: string
          id: string
          last_updated: string
          session_id: string
          student_id: string
          total_count: number
          updated_at: string
        }
        Insert: {
          completed_count?: number
          created_at?: string
          id?: string
          last_updated?: string
          session_id: string
          student_id: string
          total_count: number
          updated_at?: string
        }
        Update: {
          completed_count?: number
          created_at?: string
          id?: string
          last_updated?: string
          session_id?: string
          student_id?: string
          total_count?: number
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "peer_review_progress_session_id_fkey"
            columns: ["session_id"]
            isOneToOne: false
            referencedRelation: "peer_review_sessions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "peer_review_progress_student_id_fkey"
            columns: ["student_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      peer_review_sessions: {
        Row: {
          auto_closed: boolean
          class_period_assignment_id: string
          closed_at: string | null
          closed_by: string | null
          created_at: string
          deadline: string | null
          id: string
          opened_at: string | null
          opened_by: string | null
          status: Database["public"]["Enums"]["peer_review_status"]
          updated_at: string
        }
        Insert: {
          auto_closed?: boolean
          class_period_assignment_id: string
          closed_at?: string | null
          closed_by?: string | null
          created_at?: string
          deadline?: string | null
          id?: string
          opened_at?: string | null
          opened_by?: string | null
          status?: Database["public"]["Enums"]["peer_review_status"]
          updated_at?: string
        }
        Update: {
          auto_closed?: boolean
          class_period_assignment_id?: string
          closed_at?: string | null
          closed_by?: string | null
          created_at?: string
          deadline?: string | null
          id?: string
          opened_at?: string | null
          opened_by?: string | null
          status?: Database["public"]["Enums"]["peer_review_status"]
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "peer_review_sessions_class_period_assignment_id_fkey"
            columns: ["class_period_assignment_id"]
            isOneToOne: true
            referencedRelation: "class_period_assignments"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "peer_review_sessions_closed_by_fkey"
            columns: ["closed_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "peer_review_sessions_opened_by_fkey"
            columns: ["opened_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      peer_review_submissions: {
        Row: {
          created_at: string
          id: string
          reviewee_id: string
          reviewer_id: string
          score_cooperation: number
          score_courtesy: number
          score_empathy: number
          score_honesty: number
          score_responsibility: number
          session_id: string
          submitted_at: string
        }
        Insert: {
          created_at?: string
          id?: string
          reviewee_id: string
          reviewer_id: string
          score_cooperation: number
          score_courtesy: number
          score_empathy: number
          score_honesty: number
          score_responsibility: number
          session_id: string
          submitted_at?: string
        }
        Update: {
          created_at?: string
          id?: string
          reviewee_id?: string
          reviewer_id?: string
          score_cooperation?: number
          score_courtesy?: number
          score_empathy?: number
          score_honesty?: number
          score_responsibility?: number
          session_id?: string
          submitted_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "peer_review_submissions_reviewee_id_fkey"
            columns: ["reviewee_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "peer_review_submissions_reviewer_id_fkey"
            columns: ["reviewer_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "peer_review_submissions_session_id_fkey"
            columns: ["session_id"]
            isOneToOne: false
            referencedRelation: "peer_review_sessions"
            referencedColumns: ["id"]
          },
        ]
      }
      period_monthly_days: {
        Row: {
          created_at: string
          effective_days: number
          id: string
          month: number
          period_id: string
          updated_at: string
          year: number
        }
        Insert: {
          created_at?: string
          effective_days: number
          id?: string
          month: number
          period_id: string
          updated_at?: string
          year: number
        }
        Update: {
          created_at?: string
          effective_days?: number
          id?: string
          month?: number
          period_id?: string
          updated_at?: string
          year?: number
        }
        Relationships: [
          {
            foreignKeyName: "period_monthly_days_period_id_fkey"
            columns: ["period_id"]
            isOneToOne: false
            referencedRelation: "academic_periods"
            referencedColumns: ["id"]
          },
        ]
      }
      peer_review_aspects: {
        Row: {
          aspect_key: string
          description: string
          display_order: number
          id: string
          label: string
          updated_at: string
          updated_by: string | null
        }
        Insert: {
          aspect_key: string
          description: string
          display_order: number
          id?: string
          label: string
          updated_at?: string
          updated_by?: string | null
        }
        Update: {
          aspect_key?: string
          description?: string
          display_order?: number
          id?: string
          label?: string
          updated_at?: string
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "peer_review_aspects_updated_by_fkey"
            columns: ["updated_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      profiles: {
        Row: {
          created_at: string
          date_of_birth: string | null
          email: string
          full_name: string
          gender: Database["public"]["Enums"]["gender_type"] | null
          id: string
          is_active: boolean
          nip: string | null
          nisn: string | null
          role: Database["public"]["Enums"]["user_role"]
          updated_at: string
        }
        Insert: {
          created_at?: string
          date_of_birth?: string | null
          email: string
          full_name: string
          gender?: Database["public"]["Enums"]["gender_type"] | null
          id: string
          is_active?: boolean
          nip?: string | null
          nisn?: string | null
          role: Database["public"]["Enums"]["user_role"]
          updated_at?: string
        }
        Update: {
          created_at?: string
          date_of_birth?: string | null
          email?: string
          full_name?: string
          gender?: Database["public"]["Enums"]["gender_type"] | null
          id?: string
          is_active?: boolean
          nip?: string | null
          nisn?: string | null
          role?: Database["public"]["Enums"]["user_role"]
          updated_at?: string
        }
        Relationships: []
      }
      reward_categories: {
        Row: {
          category_label: string | null
          created_at: string
          description: string | null
          id: string
          is_active: boolean
          name: string
          point_addition: number
          updated_at: string
        }
        Insert: {
          category_label?: string | null
          created_at?: string
          description?: string | null
          id?: string
          is_active?: boolean
          name: string
          point_addition: number
          updated_at?: string
        }
        Update: {
          category_label?: string | null
          created_at?: string
          description?: string | null
          id?: string
          is_active?: boolean
          name?: string
          point_addition?: number
          updated_at?: string
        }
        Relationships: []
      }
      student_behavior_scores: {
        Row: {
          created_at: string
          enrollment_id: string
          id: string
          raw_score: number
          updated_at: string
        }
        Insert: {
          created_at?: string
          enrollment_id: string
          id?: string
          raw_score?: number
          updated_at?: string
        }
        Update: {
          created_at?: string
          enrollment_id?: string
          id?: string
          raw_score?: number
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "student_behavior_scores_enrollment_id_fkey"
            columns: ["enrollment_id"]
            isOneToOne: true
            referencedRelation: "student_class_enrollments"
            referencedColumns: ["id"]
          },
        ]
      }
      student_class_enrollments: {
        Row: {
          class_period_assignment_id: string
          created_at: string
          id: string
          initial_score: number
          status: Database["public"]["Enums"]["enrollment_status"]
          student_id: string
          updated_at: string
        }
        Insert: {
          class_period_assignment_id: string
          created_at?: string
          id?: string
          initial_score?: number
          status?: Database["public"]["Enums"]["enrollment_status"]
          student_id: string
          updated_at?: string
        }
        Update: {
          class_period_assignment_id?: string
          created_at?: string
          id?: string
          initial_score?: number
          status?: Database["public"]["Enums"]["enrollment_status"]
          student_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "student_class_enrollments_class_period_assignment_id_fkey"
            columns: ["class_period_assignment_id"]
            isOneToOne: false
            referencedRelation: "class_period_assignments"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "student_class_enrollments_student_id_fkey"
            columns: ["student_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      student_x3_scores: {
        Row: {
          avg_cooperation: number | null
          avg_courtesy: number | null
          avg_empathy: number | null
          avg_honesty: number | null
          avg_responsibility: number | null
          computed_at: string | null
          created_at: string
          id: string
          reviewer_count: number
          session_id: string
          student_id: string
          updated_at: string
          x3_score: number | null
        }
        Insert: {
          avg_cooperation?: number | null
          avg_courtesy?: number | null
          avg_empathy?: number | null
          avg_honesty?: number | null
          avg_responsibility?: number | null
          computed_at?: string | null
          created_at?: string
          id?: string
          reviewer_count?: number
          session_id: string
          student_id: string
          updated_at?: string
          x3_score?: number | null
        }
        Update: {
          avg_cooperation?: number | null
          avg_courtesy?: number | null
          avg_empathy?: number | null
          avg_honesty?: number | null
          avg_responsibility?: number | null
          computed_at?: string | null
          created_at?: string
          id?: string
          reviewer_count?: number
          session_id?: string
          student_id?: string
          updated_at?: string
          x3_score?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "student_x3_scores_session_id_fkey"
            columns: ["session_id"]
            isOneToOne: false
            referencedRelation: "peer_review_sessions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "student_x3_scores_student_id_fkey"
            columns: ["student_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      teacher_narrative_notes: {
        Row: {
          created_at: string
          enrollment_id: string
          id: string
          note_text: string
          updated_at: string
          written_by: string
        }
        Insert: {
          created_at?: string
          enrollment_id: string
          id?: string
          note_text: string
          updated_at?: string
          written_by: string
        }
        Update: {
          created_at?: string
          enrollment_id?: string
          id?: string
          note_text?: string
          updated_at?: string
          written_by?: string
        }
        Relationships: [
          {
            foreignKeyName: "teacher_narrative_notes_enrollment_id_fkey"
            columns: ["enrollment_id"]
            isOneToOne: true
            referencedRelation: "student_class_enrollments"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "teacher_narrative_notes_written_by_fkey"
            columns: ["written_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      violation_categories: {
        Row: {
          created_at: string
          description: string | null
          id: string
          is_active: boolean
          name: string
          point_deduction: number
          sop_reference: string | null
          updated_at: string
        }
        Insert: {
          created_at?: string
          description?: string | null
          id?: string
          is_active?: boolean
          name: string
          point_deduction: number
          sop_reference?: string | null
          updated_at?: string
        }
        Update: {
          created_at?: string
          description?: string | null
          id?: string
          is_active?: boolean
          name?: string
          point_deduction?: number
          sop_reference?: string | null
          updated_at?: string
        }
        Relationships: []
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      is_admin: { Args: never; Returns: boolean }
      is_homeroom_teacher_of_class_period: {
        Args: { p_class_period_id: string }
        Returns: boolean
      }
      is_homeroom_teacher_of_enrollment: {
        Args: { p_enrollment_id: string }
        Returns: boolean
      }
      is_student: { Args: never; Returns: boolean }
      is_teacher: { Args: never; Returns: boolean }
    }
    Enums: {
      behavior_category: "perlu_pembinaan" | "cukup" | "baik" | "sangat_baik"
      enrollment_status: "active" | "transferred" | "left"
      fuzzy_set_name:
        | "rendah"
        | "sedang"
        | "tinggi"
        | "perlu_pembinaan"
        | "cukup"
        | "baik"
        | "sangat_baik"
      gender_type: "L" | "P"
      grade_level_type: "X" | "XI" | "XII"
      membership_function_type:
        | "triangle"
        | "trapezoid_left"
        | "trapezoid_right"
      peer_review_status: "not_started" | "active" | "closed"
      period_status: "active" | "closed" | "archived"
      semester_type: "ganjil" | "genap"
      transaction_type: "violation" | "reward"
      user_role: "admin" | "teacher" | "student"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  graphql_public: {
    Enums: {},
  },
  public: {
    Enums: {
      behavior_category: ["perlu_pembinaan", "cukup", "baik", "sangat_baik"],
      enrollment_status: ["active", "transferred", "left"],
      fuzzy_set_name: [
        "rendah",
        "sedang",
        "tinggi",
        "perlu_pembinaan",
        "cukup",
        "baik",
        "sangat_baik",
      ],
      gender_type: ["L", "P"],
      grade_level_type: ["X", "XI", "XII"],
      membership_function_type: [
        "triangle",
        "trapezoid_left",
        "trapezoid_right",
      ],
      peer_review_status: ["not_started", "active", "closed"],
      period_status: ["active", "closed", "archived"],
      semester_type: ["ganjil", "genap"],
      transaction_type: ["violation", "reward"],
      user_role: ["admin", "teacher", "student"],
    },
  },
} as const
