-- Opcional: tabla para persistir notificaciones reales en Supabase.
-- El login funciona con localStorage aunque no crees esta tabla.

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  body text not null,
  type text default 'success',
  read boolean default false,
  metadata jsonb default '{}'::jsonb,
  created_at timestamptz default now()
);

alter table public.notifications enable row level security;

create policy "Users can read own notifications"
on public.notifications for select
using (auth.uid() = user_id);

create policy "Users can insert own notifications"
on public.notifications for insert
with check (auth.uid() = user_id);

create policy "Users can update own notifications"
on public.notifications for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
