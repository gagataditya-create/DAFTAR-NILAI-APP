Coba AI secara langsung di aplikasi favorit Anda … Gunakan Gemini untuk membuat draf dan menyempurnakan konten, serta dapatkan Gemini Pro dengan akses ke AI generasi berikutnya dari Google
1
100%
-- Minimal schema for the current nilai-app
-- Run this in Supabase SQL Editor.

create table if not exists public.classes (
  id uuid primary key default gen_random_uuid(),
  school_id uuid null,
  class_name text null,
  name text null,
  grade_level text null,
  is_active boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.students (
  id uuid primary key default gen_random_uuid(),
  school_id uuid null,
  student_name text null,
  name text null,
  class_id uuid null,
  nis text null,
  is_active boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.assessments (
  id uuid primary key default gen_random_uuid(),
  teacher_id uuid null,
  subject_id uuid null,
  class_id uuid null,
  title text null,
  assessment_title text null,
  assessment_type text default 'Tugas',
  weight numeric default 1,
  max_score numeric default 100,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.classes add column if not exists class_name text;
alter table public.classes add column if not exists name text;
alter table public.students add column if not exists student_name text;
alter table public.students add column if not exists name text;
alter table public.students add column if not exists class_id uuid;
alter table public.assessments add column if not exists title text;
alter table public.assessments add column if not exists assessment_title text;
alter table public.assessments add column if not exists max_score numeric;

update public.classes set name = coalesce(name, class_name) where name is null and class_name is not null;
update public.students set name = coalesce(name, student_name) where name is null and student_name is not null;
update public.assessments set title = coalesce(title, assessment_title) where title is null and assessment_title is not null;

create table if not exists public.grades (
  id text primary key,
  student_id text not null,
  assessment_id text not null,
  score numeric not null,
  remarks text null,
  updated_at timestamptz default now()
);

create table if not exists public.teachers (
  id text primary key,
  username text unique,
  name text not null,
  subject text null,
  password_hash text null,
  is_admin boolean default false,
  icon text null,
  theme_from text null,
  theme_to text null,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Optional: allow reads for anonymous/public access for this demo app.
-- For production, replace with proper auth policies.
alter table public.classes enable row level security;
alter table public.students enable row level security;
alter table public.assessments enable row level security;
alter table public.grades enable row level security;
alter table public.teachers enable row level security;

drop policy if exists "Allow public read/write" on public.classes;
create policy "Allow public read/write" on public.classes
  for all using (true) with check (true);

drop policy if exists "Allow public read/write" on public.students;
create policy "Allow public read/write" on public.students
  for all using (true) with check (true);

drop policy if exists "Allow public read/write" on public.assessments;
create policy "Allow public read/write" on public.assessments
  for all using (true) with check (true);

drop policy if exists "Allow public read/write" on public.grades;
create policy "Allow public read/write" on public.grades
  for all using (true) with check (true);

drop policy if exists "Allow public read/write" on public.teachers;
create policy "Allow public read/write" on public.teachers
  for all using (true) with check (true);
