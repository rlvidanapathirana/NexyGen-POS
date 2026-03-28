-- ════════════════════════════════════════════════════════════
-- POS SYSTEM v2 — Complete Schema
-- Supabase Dashboard → SQL Editor → Paste → Run
-- ════════════════════════════════════════════════════════════

-- 1. BUSINESS PROFILE
CREATE TABLE IF NOT EXISTS business_profile (
  id                 UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  shop_name          TEXT NOT NULL DEFAULT 'My Shop',
  phone              TEXT,
  address            TEXT,
  email              TEXT,
  website            TEXT,
  logo_url           TEXT,
  theme_primary      TEXT DEFAULT '#c8f55a',
  currency_symbol    TEXT DEFAULT 'Rs.',
  loyalty_point_ratio INTEGER DEFAULT 100,
  receipt_footer     TEXT DEFAULT 'Thank you for shopping!',
  paper_size         TEXT DEFAULT '80mm',
  print_mode         TEXT DEFAULT 'browser',
  auto_print         BOOLEAN DEFAULT false,
  show_receipt       BOOLEAN DEFAULT true,
  sugar_enabled      BOOLEAN DEFAULT false,
  sugar_limit        INTEGER DEFAULT 2,
  pay_methods        JSONB DEFAULT '["Cash","Card","QR","Koko","Mint Pay"]',
  cust_types         JSONB DEFAULT '["Walk-in","Online","Pickme","Uber"]',
  created_at         TIMESTAMPTZ DEFAULT now()
);
INSERT INTO business_profile (shop_name, currency_symbol)
SELECT 'My Shop','Rs.' WHERE NOT EXISTS (SELECT 1 FROM business_profile);

-- 2. CUSTOMERS
CREATE TABLE IF NOT EXISTS customers (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name            TEXT NOT NULL,
  mobile_number   TEXT UNIQUE NOT NULL,
  email           TEXT,
  customer_type   TEXT DEFAULT 'Walk-in',
  loyalty_points  INTEGER DEFAULT 0,
  total_spent     DECIMAL(12,2) DEFAULT 0,
  created_at      TIMESTAMPTZ DEFAULT now()
);

-- 3. PRODUCTS (with multi-price support)
CREATE TABLE IF NOT EXISTS products (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  barcode         TEXT UNIQUE,
  name            TEXT NOT NULL,
  category        TEXT,
  cost_price      DECIMAL(10,2) DEFAULT 0,
  selling_price   DECIMAL(10,2) NOT NULL,
  stock_qty       INTEGER DEFAULT 0,
  low_stock_limit INTEGER DEFAULT 5,
  item_discount   DECIMAL(10,2) DEFAULT 0,
  image_url       TEXT,
  price_variants  JSONB DEFAULT '[]',
  is_sugar        BOOLEAN DEFAULT false,
  created_at      TIMESTAMPTZ DEFAULT now(),
  updated_at      TIMESTAMPTZ DEFAULT now()
);

-- 4. SALES
CREATE TABLE IF NOT EXISTS sales (
  id               UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  customer_id      UUID REFERENCES customers(id) ON DELETE SET NULL,
  cashier_id       UUID,
  sub_total        DECIMAL(12,2) NOT NULL,
  bill_discount    DECIMAL(12,2) DEFAULT 0,
  voucher_discount DECIMAL(12,2) DEFAULT 0,
  points_discount  DECIMAL(12,2) DEFAULT 0,
  net_amount       DECIMAL(12,2) NOT NULL,
  status           TEXT DEFAULT 'completed' CHECK(status IN ('completed','refunded','void')),
  payment_method   TEXT DEFAULT 'Cash',
  customer_type    TEXT DEFAULT 'Walk-in',
  notes            TEXT,
  created_at       TIMESTAMPTZ DEFAULT now()
);

-- 5. SALE ITEMS
CREATE TABLE IF NOT EXISTS sale_items (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  sale_id         UUID REFERENCES sales(id) ON DELETE CASCADE,
  product_id      UUID REFERENCES products(id) ON DELETE SET NULL,
  qty             INTEGER NOT NULL,
  unit_price      DECIMAL(10,2) NOT NULL,
  item_discount   DECIMAL(10,2) DEFAULT 0,
  price_variant   TEXT,
  total_price     DECIMAL(12,2) NOT NULL,
  created_at      TIMESTAMPTZ DEFAULT now()
);

-- 6. REFUND LOGS
CREATE TABLE IF NOT EXISTS refund_logs (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  sale_id         UUID REFERENCES sales(id),
  refund_reason   TEXT,
  refund_notes    TEXT,
  total_refunded  DECIMAL(12,2),
  is_partial      BOOLEAN DEFAULT false,
  refunded_by     UUID,
  created_at      TIMESTAMPTZ DEFAULT now()
);

-- 7. GIFT VOUCHERS
CREATE TABLE IF NOT EXISTS gift_vouchers (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  code            TEXT UNIQUE NOT NULL,
  value           DECIMAL(10,2) NOT NULL,
  balance         DECIMAL(10,2) NOT NULL,
  status          TEXT DEFAULT 'active' CHECK(status IN ('active','used','expired')),
  notes           TEXT,
  expires_at      TIMESTAMPTZ,
  created_at      TIMESTAMPTZ DEFAULT now()
);

-- INDEXES
CREATE INDEX IF NOT EXISTS idx_products_barcode   ON products(barcode);
CREATE INDEX IF NOT EXISTS idx_products_name      ON products USING gin(to_tsvector('simple',name));
CREATE INDEX IF NOT EXISTS idx_customers_mobile   ON customers(mobile_number);
CREATE INDEX IF NOT EXISTS idx_sales_created      ON sales(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_sales_status       ON sales(status);
CREATE INDEX IF NOT EXISTS idx_sales_customer     ON sales(customer_id);
CREATE INDEX IF NOT EXISTS idx_sale_items_sale    ON sale_items(sale_id);
CREATE INDEX IF NOT EXISTS idx_sale_items_prod    ON sale_items(product_id);
CREATE INDEX IF NOT EXISTS idx_sale_items_created ON sale_items(created_at);
CREATE INDEX IF NOT EXISTS idx_vouchers_code      ON gift_vouchers(code);

-- RLS
ALTER TABLE business_profile ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers         ENABLE ROW LEVEL SECURITY;
ALTER TABLE products          ENABLE ROW LEVEL SECURITY;
ALTER TABLE sales             ENABLE ROW LEVEL SECURITY;
ALTER TABLE sale_items        ENABLE ROW LEVEL SECURITY;
ALTER TABLE refund_logs       ENABLE ROW LEVEL SECURITY;
ALTER TABLE gift_vouchers     ENABLE ROW LEVEL SECURITY;

-- Drop old policies safely
DO $$ BEGIN
  DROP POLICY IF EXISTS "auth_select"    ON business_profile;
  DROP POLICY IF EXISTS "auth_update"    ON business_profile;
  DROP POLICY IF EXISTS "auth_bp_insert" ON business_profile;
  DROP POLICY IF EXISTS "auth_select"    ON customers;
  DROP POLICY IF EXISTS "auth_insert"    ON customers;
  DROP POLICY IF EXISTS "auth_update"    ON customers;
  DROP POLICY IF EXISTS "auth_select"    ON products;
  DROP POLICY IF EXISTS "auth_insert"    ON products;
  DROP POLICY IF EXISTS "auth_update"    ON products;
  DROP POLICY IF EXISTS "auth_select"    ON sales;
  DROP POLICY IF EXISTS "auth_insert"    ON sales;
  DROP POLICY IF EXISTS "auth_update"    ON sales;
  DROP POLICY IF EXISTS "auth_select"    ON sale_items;
  DROP POLICY IF EXISTS "auth_insert"    ON sale_items;
  DROP POLICY IF EXISTS "auth_select"    ON refund_logs;
  DROP POLICY IF EXISTS "auth_insert"    ON refund_logs;
  DROP POLICY IF EXISTS "auth_select"    ON gift_vouchers;
  DROP POLICY IF EXISTS "auth_insert"    ON gift_vouchers;
  DROP POLICY IF EXISTS "auth_update"    ON gift_vouchers;
EXCEPTION WHEN OTHERS THEN NULL; END $$;

-- SELECT all authenticated
CREATE POLICY "auth_select"    ON business_profile FOR SELECT TO authenticated USING(true);
CREATE POLICY "auth_update"    ON business_profile FOR UPDATE TO authenticated USING(true);
CREATE POLICY "auth_bp_insert" ON business_profile FOR INSERT TO authenticated WITH CHECK(true);
CREATE POLICY "auth_select"    ON customers    FOR SELECT TO authenticated USING(true);
CREATE POLICY "auth_insert"    ON customers    FOR INSERT TO authenticated WITH CHECK(true);
CREATE POLICY "auth_update"    ON customers    FOR UPDATE TO authenticated USING(true);
CREATE POLICY "auth_select"    ON products     FOR SELECT TO authenticated USING(true);
CREATE POLICY "auth_insert"    ON products     FOR INSERT TO authenticated WITH CHECK(true);
CREATE POLICY "auth_update"    ON products     FOR UPDATE TO authenticated USING(true);
CREATE POLICY "auth_select"    ON sales        FOR SELECT TO authenticated USING(true);
CREATE POLICY "auth_insert"    ON sales        FOR INSERT TO authenticated WITH CHECK(true);
CREATE POLICY "auth_update"    ON sales        FOR UPDATE TO authenticated USING(true);
CREATE POLICY "auth_select"    ON sale_items   FOR SELECT TO authenticated USING(true);
CREATE POLICY "auth_insert"    ON sale_items   FOR INSERT TO authenticated WITH CHECK(true);
CREATE POLICY "auth_select"    ON refund_logs  FOR SELECT TO authenticated USING(true);
CREATE POLICY "auth_insert"    ON refund_logs  FOR INSERT TO authenticated WITH CHECK(true);
CREATE POLICY "auth_select"    ON gift_vouchers FOR SELECT TO authenticated USING(true);
CREATE POLICY "auth_insert"    ON gift_vouchers FOR INSERT TO authenticated WITH CHECK(true);
CREATE POLICY "auth_update"    ON gift_vouchers FOR UPDATE TO authenticated USING(true);

-- SAMPLE DATA
INSERT INTO products (name,barcode,category,cost_price,selling_price,stock_qty,low_stock_limit,item_discount) VALUES
('Coca Cola 330ml','5449000000996','drink',85,120,48,10,0),
('Pepsi 500ml','4902102141567','drink',95,130,36,10,0),
('Bread Loaf','6234560001234','food',180,220,15,5,0),
('Rice 1kg','6234560005678','grocery',350,420,30,8,0),
('Sugar 1kg','6234560002222','sugar',250,320,20,5,0),
('Panadol 10s','4020011204563','health',60,85,5,3,0),
('Dettol Soap 75g','6223006406076','beauty',95,130,20,5,0),
('Milk 1L','6900000001234','dairy',200,250,24,6,0),
('Biscuits 200g','6001057010002','snack',75,110,40,10,5)
ON CONFLICT (barcode) DO NOTHING;

INSERT INTO customers (name,mobile_number,loyalty_points,total_spent,customer_type) VALUES
('Kamal Perera','0712345678',250,25000.00,'Walk-in'),
('Saman Silva','0771234567',180,18000.00,'Walk-in'),
('Nimal Fernando','0761234567',90,9000.00,'Walk-in')
ON CONFLICT (mobile_number) DO NOTHING;

-- ════════════════════════════════════════════════════════════
-- SETUP CHECKLIST:
-- ✅ 1. Run this SQL in Supabase → SQL Editor
-- ✅ 2. Go to: Project Settings → API → copy "anon/public" key
-- ✅ 3. Open index.html AND pos.html, find __ANON_KEY__
--        Replace with your actual anon key (both files)
-- ✅ 4. Create users: Authentication → Users → Add user
--        Admin email: must contain "admin" (e.g. admin@shop.com)
--        Cashier email: any other email
-- ✅ 5. Open index.html in browser — done!
-- ════════════════════════════════════════════════════════════
