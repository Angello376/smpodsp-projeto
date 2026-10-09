# SMPODSP

Sistema de gestão para a loja de pods: produtos e sabores, clientes, vendas (à vista e a prazo, com pagamento parcial), cobrança pelo WhatsApp, gastos e controle do investimento em produtos.

## Estrutura
- `index.html`: o app inteiro (interface, regras e conexão com o Supabase).
- `supabase/schema.sql`: tabelas, regras de acesso e atualização ao vivo do banco.

## Configuração (uma vez)
1. Crie um projeto no supabase.com.
2. No **SQL Editor**, rode o arquivo `supabase/schema.sql`.
3. Em **Authentication > Providers**, deixe e-mail e senha ativados. Em **Authentication > Users**, crie um usuário para você e outro para seu amigo.
4. Em **Project Settings > API**, copie a **Project URL** e a chave **anon public**.
5. No `index.html`, troque `COLE_A_URL_DO_PROJETO_AQUI` e `COLE_A_CHAVE_ANON_PUBLIC_AQUI` pelos valores copiados.

Nunca coloque a chave `service_role` no projeto.

## Publicar no Vercel
1. Suba este repositório no GitHub.
2. No vercel.com, em **Add New > Project**, importe o repositório e clique em **Deploy**.

## Uso
Abra o link do Vercel e entre com o e-mail e a senha de cada usuário. As vendas, produtos e clientes aparecem ao vivo nos dois aparelhos.
