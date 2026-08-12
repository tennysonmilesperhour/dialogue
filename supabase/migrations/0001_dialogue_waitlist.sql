-- Waitlist capture for the marketing site.
-- Portable on purpose: re-run this against any project to move the table.
-- After moving, update SUPABASE_URL and the publishable key in web/lib/supabase.ts.

create table if not exists public.dialogue_waitlist (
  id uuid primary key default gen_random_uuid(),
  email text not null check (position('@' in email) > 1 and length(email) <= 320),
  source text not null default 'web',
  created_at timestamptz not null default now()
);

create unique index if not exists dialogue_waitlist_email_key
  on public.dialogue_waitlist (lower(email));

alter table public.dialogue_waitlist enable row level security;

-- The anon key can add an email and nothing else. No select, update, or
-- delete policies exist on purpose: the browser can write to the list and
-- can never read it back.
create policy "waitlist inserts are open"
  on public.dialogue_waitlist
  for insert
  to anon
  with check (true);
