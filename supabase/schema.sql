-- Daily Desk stores one private snapshot for each authenticated user.
-- Run this in the Supabase SQL Editor after creating the project.
create table if not exists public.daily_desk_sync_access (
  user_id uuid primary key references auth.users (id) on delete cascade,
  consented_at timestamptz not null,
  revoked_at timestamptz
);

alter table public.daily_desk_sync_access enable row level security;
revoke all on table public.daily_desk_sync_access from anon, authenticated;
grant select, insert, update on table public.daily_desk_sync_access to authenticated;

drop policy if exists "Users read their own sync consent" on public.daily_desk_sync_access;
create policy "Users read their own sync consent"
  on public.daily_desk_sync_access for select to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Users record their own sync consent" on public.daily_desk_sync_access;
create policy "Users record their own sync consent"
  on public.daily_desk_sync_access for insert to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "Users update their own sync consent" on public.daily_desk_sync_access;
create policy "Users update their own sync consent"
  on public.daily_desk_sync_access for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create table if not exists public.daily_desk_records (
  user_id uuid primary key references auth.users (id) on delete cascade,
  payload jsonb not null check (jsonb_typeof(payload) = 'object'),
  consent_version text not null,
  updated_at timestamptz not null default now()
);

alter table public.daily_desk_records enable row level security;
revoke all on table public.daily_desk_records from anon, authenticated;
grant select, insert, update, delete on table public.daily_desk_records to authenticated;

drop policy if exists "Users read their own Daily Desk records" on public.daily_desk_records;
create policy "Users read their own Daily Desk records"
  on public.daily_desk_records for select to authenticated
  using ((select auth.uid()) = user_id and exists (
    select 1 from public.daily_desk_sync_access a
    where a.user_id = daily_desk_records.user_id and a.revoked_at is null
  ));

drop policy if exists "Users add their own Daily Desk records" on public.daily_desk_records;
create policy "Users add their own Daily Desk records"
  on public.daily_desk_records for insert to authenticated
  with check ((select auth.uid()) = user_id and exists (
    select 1 from public.daily_desk_sync_access a
    where a.user_id = daily_desk_records.user_id and a.revoked_at is null
  ));

drop policy if exists "Users update their own Daily Desk records" on public.daily_desk_records;
create policy "Users update their own Daily Desk records"
  on public.daily_desk_records for update to authenticated
  using ((select auth.uid()) = user_id and exists (
    select 1 from public.daily_desk_sync_access a
    where a.user_id = daily_desk_records.user_id and a.revoked_at is null
  ))
  with check ((select auth.uid()) = user_id and exists (
    select 1 from public.daily_desk_sync_access a
    where a.user_id = daily_desk_records.user_id and a.revoked_at is null
  ));

drop policy if exists "Users delete their own Daily Desk records" on public.daily_desk_records;
create policy "Users delete their own Daily Desk records"
  on public.daily_desk_records for delete to authenticated
  using ((select auth.uid()) = user_id);

