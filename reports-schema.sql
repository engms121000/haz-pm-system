-- =============================================
-- HAz Construction PM System - Reports Database Schema
-- Run this in Supabase SQL Editor
-- =============================================

-- Monthly EVM Reports Table
CREATE TABLE IF NOT EXISTS monthly_evm_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    project_code TEXT NOT NULL,
    project_name TEXT NOT NULL,
    report_period TEXT NOT NULL,
    month INTEGER NOT NULL CHECK (month >= 1 AND month <= 12),
    year INTEGER NOT NULL,
    
    -- EVM Core Values
    bac DECIMAL(15,2) DEFAULT 0,
    pv DECIMAL(15,2) DEFAULT 0,
    ac DECIMAL(15,2) DEFAULT 0,
    ev DECIMAL(15,2) DEFAULT 0,
    
    -- Calculated EVM Metrics
    cv DECIMAL(15,2) DEFAULT 0,
    sv DECIMAL(15,2) DEFAULT 0,
    cpi DECIMAL(6,3) DEFAULT 0,
    spi DECIMAL(6,3) DEFAULT 0,
    tcpi DECIMAL(6,3) DEFAULT 0,
    eac DECIMAL(15,2) DEFAULT 0,
    etc DECIMAL(15,2) DEFAULT 0,
    vac DECIMAL(15,2) DEFAULT 0,
    percent_complete DECIMAL(5,2) DEFAULT 0,
    
    -- Profitability
    gross_profit DECIMAL(15,2) DEFAULT 0,
    gross_margin DECIMAL(6,2) DEFAULT 0,
    net_profit DECIMAL(15,2) DEFAULT 0,
    net_margin DECIMAL(6,2) DEFAULT 0,
    
    -- Indirect Costs
    indirect_costs DECIMAL(15,2) DEFAULT 0,
    salaries DECIMAL(15,2) DEFAULT 0,
    expenses DECIMAL(15,2) DEFAULT 0,
    other_indirect DECIMAL(15,2) DEFAULT 0,
    
    -- Status
    project_health TEXT DEFAULT 'Healthy',
    items_count INTEGER DEFAULT 0,
    notes TEXT,
    
    -- JSON for full data
    raw_data JSONB,
    
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Monthly EVM Work Items Table
CREATE TABLE IF NOT EXISTS monthly_evm_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    report_id UUID REFERENCES monthly_evm_reports(id) ON DELETE CASCADE,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    
    item_number INTEGER NOT NULL,
    item_code TEXT NOT NULL,
    description TEXT,
    
    -- EVM Values
    bac DECIMAL(15,2) DEFAULT 0,
    pv DECIMAL(15,2) DEFAULT 0,
    ac DECIMAL(15,2) DEFAULT 0,
    ev DECIMAL(15,2) DEFAULT 0,
    percent_complete DECIMAL(5,2) DEFAULT 0,
    
    -- Calculated Metrics
    cv DECIMAL(15,2) DEFAULT 0,
    sv DECIMAL(15,2) DEFAULT 0,
    cpi DECIMAL(6,3) DEFAULT 0,
    spi DECIMAL(6,3) DEFAULT 0,
    tcpi DECIMAL(6,3) DEFAULT 0,
    
    -- Cost Breakdown
    labor_cost DECIMAL(15,2) DEFAULT 0,
    equipment_cost DECIMAL(15,2) DEFAULT 0,
    material_cost DECIMAL(15,2) DEFAULT 0,
    subcontractor_cost DECIMAL(15,2) DEFAULT 0,
    
    status TEXT DEFAULT 'On Budget',
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Daily Reports Table
CREATE TABLE IF NOT EXISTS daily_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    project_code TEXT NOT NULL,
    project_name TEXT NOT NULL,
    report_date DATE NOT NULL,
    
    -- Location
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    location_address TEXT,
    
    -- Weather
    weather TEXT,
    
    -- Costs
    labor_cost DECIMAL(15,2) DEFAULT 0,
    equipment_cost DECIMAL(15,2) DEFAULT 0,
    subcontractor_cost DECIMAL(15,2) DEFAULT 0,
    total_direct_cost DECIMAL(15,2) DEFAULT 0,
    vat_amount DECIMAL(15,2) DEFAULT 0,
    grand_total DECIMAL(15,2) DEFAULT 0,
    
    -- Counts
    total_workers INTEGER DEFAULT 0,
    total_equipment INTEGER DEFAULT 0,
    
    -- JSON for detailed data
    labor_data JSONB,
    equipment_data JSONB,
    work_items_data JSONB,
    subcontractor_data JSONB,
    
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Weekly Reports Table
CREATE TABLE IF NOT EXISTS weekly_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    project_code TEXT NOT NULL,
    project_name TEXT NOT NULL,
    week_number INTEGER,
    week_start_date DATE,
    week_end_date DATE,
    
    -- EVM Summary
    total_pv DECIMAL(15,2) DEFAULT 0,
    total_ac DECIMAL(15,2) DEFAULT 0,
    total_ev DECIMAL(15,2) DEFAULT 0,
    cv DECIMAL(15,2) DEFAULT 0,
    sv DECIMAL(15,2) DEFAULT 0,
    cpi DECIMAL(6,3) DEFAULT 0,
    spi DECIMAL(6,3) DEFAULT 0,
    
    status TEXT DEFAULT 'On Budget',
    
    -- JSON for detailed data
    work_items_data JSONB,
    labor_summary JSONB,
    equipment_summary JSONB,
    
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_monthly_reports_user ON monthly_evm_reports(user_id);
CREATE INDEX IF NOT EXISTS idx_monthly_reports_project ON monthly_evm_reports(project_code);
CREATE INDEX IF NOT EXISTS idx_monthly_reports_period ON monthly_evm_reports(year, month);
CREATE INDEX IF NOT EXISTS idx_monthly_items_report ON monthly_evm_items(report_id);
CREATE INDEX IF NOT EXISTS idx_daily_reports_user ON daily_reports(user_id);
CREATE INDEX IF NOT EXISTS idx_daily_reports_date ON daily_reports(report_date);
CREATE INDEX IF NOT EXISTS idx_weekly_reports_user ON weekly_reports(user_id);

-- Enable RLS
ALTER TABLE monthly_evm_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE monthly_evm_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE weekly_reports ENABLE ROW LEVEL SECURITY;

-- RLS Policies - Users can only see their own data
CREATE POLICY "Users can manage own monthly reports"
ON monthly_evm_reports FOR ALL
USING (auth.uid() = user_id);

CREATE POLICY "Users can manage own monthly items"
ON monthly_evm_items FOR ALL
USING (auth.uid() = user_id);

CREATE POLICY "Users can manage own daily reports"
ON daily_reports FOR ALL
USING (auth.uid() = user_id);

CREATE POLICY "Users can manage own weekly reports"
ON weekly_reports FOR ALL
USING (auth.uid() = user_id);

-- Updated at trigger for all tables
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS monthly_reports_updated_at ON monthly_evm_reports;
CREATE TRIGGER monthly_reports_updated_at
    BEFORE UPDATE ON monthly_evm_reports
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS daily_reports_updated_at ON daily_reports;
CREATE TRIGGER daily_reports_updated_at
    BEFORE UPDATE ON daily_reports
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS weekly_reports_updated_at ON weekly_reports;
CREATE TRIGGER weekly_reports_updated_at
    BEFORE UPDATE ON weekly_reports
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- VIEWS FOR REPORTING & DASHBOARDS
-- =============================================

-- Monthly EVM Summary View
CREATE OR REPLACE VIEW v_monthly_evm_summary AS
SELECT 
    m.id,
    m.user_id,
    m.project_code,
    m.project_name,
    m.report_period,
    m.month,
    m.year,
    m.bac,
    m.pv,
    m.ac,
    m.ev,
    m.cv,
    m.sv,
    m.cpi,
    m.spi,
    m.tcpi,
    m.eac,
    m.etc,
    m.percent_complete,
    m.gross_profit,
    m.gross_margin,
    m.net_profit,
    m.net_margin,
    m.project_health,
    m.items_count,
    m.created_at,
    CASE 
        WHEN m.cpi >= 1 AND m.spi >= 1 THEN 'green'
        WHEN m.cpi >= 0.9 AND m.spi >= 0.9 THEN 'yellow'
        ELSE 'red'
    END AS health_color
FROM monthly_evm_reports m;

-- Project Progress Dashboard View
CREATE OR REPLACE VIEW v_project_dashboard AS
SELECT 
    project_code,
    project_name,
    COUNT(*) as total_reports,
    MAX(report_period) as latest_period,
    MAX(bac) as current_bac,
    SUM(ev) as total_earned,
    SUM(ac) as total_spent,
    AVG(cpi) as avg_cpi,
    AVG(spi) as avg_spi,
    SUM(gross_profit) as total_gross_profit,
    SUM(net_profit) as total_net_profit
FROM monthly_evm_reports
GROUP BY project_code, project_name;

-- =============================================
-- SAMPLE DATA (Optional - Remove in Production)
-- =============================================

-- Uncomment to insert sample data for testing
/*
INSERT INTO monthly_evm_reports (
    user_id, project_code, project_name, report_period, month, year,
    bac, pv, ac, ev, cv, sv, cpi, spi, tcpi, eac, etc,
    percent_complete, gross_profit, gross_margin, net_profit, net_margin,
    indirect_costs, project_health, items_count
) VALUES (
    auth.uid(), 'PRJ-001', 'King Abdullah Road Development', 'January 2025', 1, 2025,
    1000000, 300000, 280000, 320000, 40000, 20000, 1.14, 1.07, 0.95, 877193, 597193,
    32.0, 40000, 14.3, 25000, 8.9,
    15000, 'Healthy', 5
);
*/

-- =============================================
-- SETUP COMPLETE
-- =============================================
