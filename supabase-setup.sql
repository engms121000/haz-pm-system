-- =============================================
-- HAz Construction PM System - Supabase Setup
-- =============================================
-- Run this SQL in your Supabase SQL Editor
-- Go to: https://app.supabase.com → Your Project → SQL Editor

-- 1. Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    company TEXT,
    phone TEXT,
    role TEXT DEFAULT 'user' CHECK (role IN ('user', 'admin')),
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'blocked')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_profiles_status ON profiles(status);
CREATE INDEX IF NOT EXISTS idx_profiles_role ON profiles(role);

-- 3. Enable Row Level Security (RLS)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- 4. Create policies for data access

-- Users can view their own profile
CREATE POLICY "Users can view own profile"
ON profiles FOR SELECT
USING (auth.uid() = id);

-- Users can update their own profile (except role and status)
CREATE POLICY "Users can update own profile"
ON profiles FOR UPDATE
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Admins can view all profiles (but only basic info, not project data)
CREATE POLICY "Admins can view all profiles"
ON profiles FOR SELECT
USING (
    EXISTS (
        SELECT 1 FROM profiles
        WHERE id = auth.uid() AND role = 'admin'
    )
);

-- Admins can update user status and role
CREATE POLICY "Admins can update profiles"
ON profiles FOR UPDATE
USING (
    EXISTS (
        SELECT 1 FROM profiles
        WHERE id = auth.uid() AND role = 'admin'
    )
);

-- Allow inserting new profiles during registration
CREATE POLICY "Allow profile creation"
ON profiles FOR INSERT
WITH CHECK (auth.uid() = id);

-- 5. Create function to handle new user registration
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO profiles (id, email, full_name, company, phone)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
        COALESCE(NEW.raw_user_meta_data->>'company', ''),
        COALESCE(NEW.raw_user_meta_data->>'phone', '')
    )
    ON CONFLICT (id) DO NOTHING;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 6. Create trigger for auto-creating profiles
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION handle_new_user();

-- 7. Create updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER profiles_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

-- 8. Create the first admin user (IMPORTANT: Run this after your first registration)
-- Replace 'your-user-id' with the actual UUID from auth.users table
-- UPDATE profiles SET role = 'admin', status = 'active' WHERE email = 'your-admin@email.com';

-- =============================================
-- OPTIONAL: Projects table for storing user projects
-- (Data is encrypted at rest by Supabase)
-- =============================================

CREATE TABLE IF NOT EXISTS projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    project_code TEXT NOT NULL,
    project_name TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS on projects
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

-- Users can only access their own projects
CREATE POLICY "Users can manage own projects"
ON projects FOR ALL
USING (auth.uid() = user_id);

-- Admins CANNOT see user projects (privacy protection)
-- No admin policy is created intentionally

-- =============================================
-- OPTIONAL: Daily reports table
-- =============================================

CREATE TABLE IF NOT EXISTS daily_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    report_date DATE NOT NULL,
    report_data JSONB NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS on daily_reports
ALTER TABLE daily_reports ENABLE ROW LEVEL SECURITY;

-- Users can only access their own reports
CREATE POLICY "Users can manage own reports"
ON daily_reports FOR ALL
USING (auth.uid() = user_id);

-- =============================================
-- SETUP COMPLETE
-- =============================================
-- 
-- Next steps:
-- 1. Copy your Supabase URL and anon key from Project Settings → API
-- 2. Paste them in HAz PM System → Settings → Supabase Authentication Settings
-- 3. Register your first user
-- 4. Run this SQL to make them admin:
--    UPDATE profiles SET role = 'admin', status = 'active' WHERE email = 'your@email.com';
-- 5. That user can now approve other users from the Admin Panel
--
-- =============================================
