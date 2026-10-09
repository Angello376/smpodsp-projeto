-- SMPODSP: tabelas do banco (rode no SQL Editor do Supabase)

create table if not exists produtos (
  id text primary key,
  dados jsonb not null default '{}'::jsonb,
  atualizado_em timestamptz not null default now()
);
create table if not exists clientes (
  id text primary key,
  dados jsonb not null default '{}'::jsonb,
  atualizado_em timestamptz not null default now()
);
create table if not exists vendas (
  id text primary key,
  dados jsonb not null default '{}'::jsonb,
  atualizado_em timestamptz not null default now()
);
create table if not exists gastos (
  id text primary key,
  dados jsonb not null default '{}'::jsonb,
  atualizado_em timestamptz not null default now()
);

-- Só usuários logados podem ler e escrever
alter table produtos enable row level security;
alter table clientes enable row level security;
alter table vendas enable row level security;
alter table gastos enable row level security;

create policy "logados acessam produtos" on produtos for all to authenticated using (true) with check (true);
create policy "logados acessam clientes" on clientes for all to authenticated using (true) with check (true);
create policy "logados acessam vendas" on vendas for all to authenticated using (true) with check (true);
create policy "logados acessam gastos" on gastos for all to authenticated using (true) with check (true);

-- Atualização ao vivo entre os aparelhos
alter publication supabase_realtime add table produtos, clientes, vendas, gastos;
