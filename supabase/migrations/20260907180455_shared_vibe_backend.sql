-- App-specific table on the shared Vibe Check project. Existing rows are preserved.
create table if not exists public.dialogue_waitlist (
  id uuid primary key default gen_random_uuid(),
  email text not null check (length(email) <= 320 and email ~ '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$'),
  source text not null default 'web' check (source = 'web'),
  created_at timestamptz not null default now()
);
create unique index if not exists dialogue_waitlist_email_key on public.dialogue_waitlist(lower(email));
alter table public.dialogue_waitlist enable row level security;
revoke all on public.dialogue_waitlist from public, anon, authenticated;
grant insert (email, source) on public.dialogue_waitlist to anon;
drop policy if exists "waitlist inserts are open" on public.dialogue_waitlist;
create policy "waitlist inserts are open" on public.dialogue_waitlist for insert to anon
  with check (source = 'web' and length(email) <= 320 and email ~ '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$');
