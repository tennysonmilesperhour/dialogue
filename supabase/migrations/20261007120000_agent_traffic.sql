-- Traffic log for known bots and tools (D020). People's browsers are never
-- logged: the web proxy only calls this for user agents on its bot list.
-- Rows hold an agent name, a page path, a trimmed user agent and a time.
-- No IP address, no cookie, no identifier of any person.

create table if not exists public.dialogue_agent_hits (
  id bigint generated always as identity primary key,
  agent text not null,
  kind text not null check (kind in ('training', 'search', 'assistant', 'seo', 'tool', 'unknown')),
  path text not null,
  user_agent text not null,
  created_at timestamptz not null default now()
);

create index if not exists dialogue_agent_hits_created_idx
  on public.dialogue_agent_hits (created_at desc);

alter table public.dialogue_agent_hits enable row level security;
revoke all on public.dialogue_agent_hits from public, anon, authenticated;

-- No policies exist for anon or authenticated on purpose. Admins read through
-- the dashboard or the service role.

-- Write path. The publishable key can call this and nothing else. Inputs are
-- trimmed, the kind is validated, and an hourly cap limits junk from anyone
-- who copies the public key. Rows are advisory: a user agent can be faked.
create or replace function public.dialogue_log_agent_hit(
  p_agent text, p_kind text, p_path text, p_ua text
) returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_kind is null or p_kind not in ('training', 'search', 'assistant', 'seo', 'tool', 'unknown') then
    return;
  end if;
  if (select count(*) from public.dialogue_agent_hits
      where created_at > now() - interval '1 hour') >= 20000 then
    return;
  end if;
  insert into public.dialogue_agent_hits (agent, kind, path, user_agent)
  values (
    left(coalesce(nullif(trim(p_agent), ''), 'unknown'), 60),
    p_kind,
    left(coalesce(nullif(trim(p_path), ''), '/'), 200),
    left(coalesce(p_ua, ''), 300)
  );
end;
$$;

revoke all on function public.dialogue_log_agent_hit(text, text, text, text) from public;
grant execute on function public.dialogue_log_agent_hit(text, text, text, text) to anon, authenticated;

-- Monthly review summary. Service role only. Inside a security definer
-- function current_user is always the owner, so the check uses the request
-- role and session_user instead.
create or replace function public.dialogue_agent_review(p_days int default 30)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  d int := greatest(1, least(coalesce(p_days, 30), 365));
  cur_start timestamptz := now() - make_interval(days => d);
  prev_start timestamptz := now() - make_interval(days => 2 * d);
  result jsonb;
begin
  if coalesce(auth.role(), '') <> 'service_role'
     and session_user not in ('postgres', 'supabase_admin') then
    raise exception 'service role only' using errcode = '42501';
  end if;

  select jsonb_build_object(
    'days', d,
    'since', cur_start,
    'total', (select count(*) from public.dialogue_agent_hits where created_at >= cur_start),
    'previous_total', (select count(*) from public.dialogue_agent_hits
                       where created_at >= prev_start and created_at < cur_start),
    'by_agent', coalesce((select jsonb_agg(r order by r.hits desc) from (
        select agent, kind, count(*) as hits from public.dialogue_agent_hits
        where created_at >= cur_start group by agent, kind) r), '[]'::jsonb),
    'by_kind', coalesce((select jsonb_object_agg(kind, hits) from (
        select kind, count(*) as hits from public.dialogue_agent_hits
        where created_at >= cur_start group by kind) r), '{}'::jsonb),
    'top_paths', coalesce((select jsonb_agg(r order by r.hits desc) from (
        select path, count(*) as hits from public.dialogue_agent_hits
        where created_at >= cur_start group by path order by hits desc limit 15) r), '[]'::jsonb),
    'agent_files', coalesce((select jsonb_agg(r order by r.hits desc) from (
        select path, count(*) as hits from public.dialogue_agent_hits
        where created_at >= cur_start
          and (path like '%.md' or path in ('/llms.txt', '/robots.txt', '/sitemap.xml'))
        group by path) r), '[]'::jsonb),
    'unknown_user_agents', coalesce((select jsonb_agg(r order by r.hits desc) from (
        select user_agent, count(*) as hits from public.dialogue_agent_hits
        where created_at >= cur_start and kind = 'unknown'
        group by user_agent order by hits desc limit 15) r), '[]'::jsonb),
    'daily', coalesce((select jsonb_agg(r order by r.day) from (
        select (created_at at time zone 'utc')::date as day, count(*) as hits
        from public.dialogue_agent_hits where created_at >= cur_start group by 1) r), '[]'::jsonb)
  ) into result;
  return result;
end;
$$;

revoke all on function public.dialogue_agent_review(int) from public, anon, authenticated;
grant execute on function public.dialogue_agent_review(int) to service_role;

-- Retention: the monthly Action prunes rows older than 180 days.
create or replace function public.dialogue_agent_prune(p_days int default 180)
returns int
language plpgsql
security definer
set search_path = public
as $$
declare n int;
begin
  if coalesce(auth.role(), '') <> 'service_role'
     and session_user not in ('postgres', 'supabase_admin') then
    raise exception 'service role only' using errcode = '42501';
  end if;
  delete from public.dialogue_agent_hits
  where created_at < now() - make_interval(days => greatest(30, coalesce(p_days, 180)));
  get diagnostics n = row_count;
  return n;
end;
$$;

revoke all on function public.dialogue_agent_prune(int) from public, anon, authenticated;
grant execute on function public.dialogue_agent_prune(int) to service_role;
