-- Deploy with the server-side signup endpoint. Browsers must no longer write
-- directly, which would bypass verification and disclose duplicate addresses.
begin;
drop policy if exists "waitlist inserts are open" on public.dialogue_waitlist;
alter table public.dialogue_waitlist enable row level security;
revoke all on table public.dialogue_waitlist from public, anon, authenticated;
grant insert (email, source) on public.dialogue_waitlist to service_role;
-- NOT VALID preserves legacy rows while enforcing limits for new submissions.
alter table public.dialogue_waitlist add constraint dialogue_waitlist_email_shape
  check (email = lower(btrim(email)) and length(email) <= 254
         and email ~ '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$') not valid;
alter table public.dialogue_waitlist add constraint dialogue_waitlist_source_length
  check (length(source) between 1 and 40) not valid;
commit;
