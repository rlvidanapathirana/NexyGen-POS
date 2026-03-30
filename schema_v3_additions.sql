-- ════════════════════════════════════════════════════════════
-- POS v3 SCHEMA ADDITIONS
-- Run this AFTER schema_V2.sql if upgrading, OR
-- add these tables at the end of schema_V2.sql if fresh install
-- ════════════════════════════════════════════════════════════

-- Add expiry_date to products (if upgrading from v2)
ALTER TABLE products ADD COLUMN IF NOT EXISTS expiry_date DATE;

-- Add cash tracking to sales (if upgrading)
ALTER TABLE sales ADD COLUMN IF NOT EXISTS cash_given DECIMAL(12,2);
ALTER TABLE sales ADD COLUMN IF NOT EXISTS cash_change DECIMAL(12,2);
ALTER TABLE sales ADD COLUMN IF NOT EXISTS payment_ref TEXT;

-- Add refund_method to refund_logs
ALTER TABLE refund_logs ADD COLUMN IF NOT EXISTS refund_method TEXT DEFAULT 'cash';

-- 8. EXPENSES TABLE
CREATE TABLE IF NOT EXISTS expenses (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  category      TEXT NOT NULL DEFAULT 'Other',
  description   TEXT NOT NULL,
  amount        DECIMAL(10,2) NOT NULL,
  date          DATE NOT NULL DEFAULT CURRENT_DATE,
  recorded_by   TEXT,
  created_at    TIMESTAMPTZ DEFAULT now()
);

-- RLS for expenses
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
DO $$ BEGIN
  DROP POLICY IF EXISTS "auth_select" ON expenses;
  DROP POLICY IF EXISTS "auth_insert" ON expenses;
EXCEPTION WHEN OTHERS THEN NULL; END $$;
CREATE POLICY "auth_select" ON expenses FOR SELECT TO authenticated USING(true);
CREATE POLICY "auth_insert" ON expenses FOR INSERT TO authenticated WITH CHECK(true);

-- Index for expenses
CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(date DESC);

-- ════════════════════════════════════════════════════════════
-- DONE ✓
-- All tables updated for POS v3
-- ════════════════════════════════════════════════════════════
