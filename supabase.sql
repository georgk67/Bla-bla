-- Abi 2027 - Sync-Backend
-- Im Supabase-Dashboard unter SQL Editor einfuegen und einmal ausfuehren.

create table if not exists public.planer (
  key        text primary key check (length(key) >= 20),
  data       jsonb       not null,
  updated_at timestamptz not null default now()
);

alter table public.planer enable row level security;

-- Bewusst keine Policy fuer anon: die Tabelle ist von aussen komplett dicht.
-- Der Zugriff laeuft ausschliesslich ueber die beiden Funktionen unten, die
-- den Sync-Key als Argument erwarten und genau die eine passende Zeile lesen
-- bzw. schreiben. Damit ist auch kein Auflisten fremder Zeilen moeglich.
-- (Eine Policy ueber current_setting('request.headers') waere die Alternative,
--  haengt aber daran, dass das API-Gateway den Custom-Header durchreicht.)
revoke all on public.planer from anon, authenticated;

create or replace function public.planer_get(p_key text)
returns table (data jsonb, updated_at timestamptz)
language sql
security definer
set search_path = public
as $$
  select p.data, p.updated_at
  from public.planer p
  where length(p_key) >= 20 and p.key = p_key;
$$;

create or replace function public.planer_put(p_key text, p_data jsonb)
returns timestamptz
language plpgsql
security definer
set search_path = public
as $$
declare ts timestamptz := now();
begin
  if p_key is null or length(p_key) < 20 then
    raise exception 'Sync-Key zu kurz (mindestens 20 Zeichen)';
  end if;
  insert into public.planer (key, data, updated_at)
  values (p_key, p_data, ts)
  on conflict (key) do update
    set data = excluded.data, updated_at = excluded.updated_at;
  return ts;
end;
$$;

revoke all on function public.planer_get(text)        from public;
revoke all on function public.planer_put(text, jsonb) from public;
grant execute on function public.planer_get(text)        to anon;
grant execute on function public.planer_put(text, jsonb) to anon;
