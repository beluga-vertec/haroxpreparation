-- ============================================
-- HYROX LIFE — Supabase Database Setup
-- Run this entire file in:
-- Supabase Dashboard → SQL Editor → New Query → Paste → Run
-- ============================================

-- 1. USER PROFILES TABLE
create table if not exists user_profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  name text not null,
  starting_weight numeric(5,1) not null,
  goal_weight numeric(5,1) not null,
  created_at timestamptz default now()
);

-- 2. WEIGHT LOGS TABLE
create table if not exists weight_logs (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  date date not null,
  weight_kg numeric(5,1) not null,
  notes text,
  created_at timestamptz default now(),
  unique(user_id, date)
);

-- 3. CHECKLIST LOGS TABLE
create table if not exists checklist_logs (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  date date not null,
  completed_tasks text[] default '{}',
  water_cups integer default 0,
  created_at timestamptz default now(),
  unique(user_id, date)
);

-- 4. ROW LEVEL SECURITY (users only see their own data)
alter table user_profiles enable row level security;
alter table weight_logs enable row level security;
alter table checklist_logs enable row level security;

-- Policies for user_profiles
create policy "Users can view own profile"
  on user_profiles for select using (auth.uid() = id);
create policy "Users can insert own profile"
  on user_profiles for insert with check (auth.uid() = id);
create policy "Users can update own profile"
  on user_profiles for update using (auth.uid() = id);

-- Policies for weight_logs
create policy "Users can view own weight logs"
  on weight_logs for select using (auth.uid() = user_id);
create policy "Users can insert own weight logs"
  on weight_logs for insert with check (auth.uid() = user_id);
create policy "Users can update own weight logs"
  on weight_logs for update using (auth.uid() = user_id);
create policy "Users can delete own weight logs"
  on weight_logs for delete using (auth.uid() = user_id);

-- Policies for checklist_logs
create policy "Users can view own checklist logs"
  on checklist_logs for select using (auth.uid() = user_id);
create policy "Users can insert own checklist logs"
  on checklist_logs for insert with check (auth.uid() = user_id);
create policy "Users can update own checklist logs"
  on checklist_logs for update using (auth.uid() = user_id);

-- ============================================
-- DONE. Your database is ready.
-- ============================================