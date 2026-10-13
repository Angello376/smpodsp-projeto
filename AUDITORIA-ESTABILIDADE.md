# Auditoria de estabilidade — SMPODSP

**Escopo:** revisão estática inicial de `index.html` na branch `auditoria-estabilidade`, criada a partir de `versao-oficial`.

**Importante:** esta etapa não altera o comportamento do aplicativo. A revisão do código não substitui testes com uma conta e dados de teste no Supabase. Nenhuma alteração foi feita em `main` ou em `versao-oficial`.

## Resultado inicial

### 1. Sincronização e concorrência — prioridade alta
- O app usa Supabase Realtime e uma consulta periódica de segurança a cada 5 segundos.
- A rotina de sincronização substitui o array local de uma tabela pelos registros retornados do banco.
- Há uma trava para impedir duas execuções simultâneas da sincronização completa, mas o callback do Realtime chama a sincronização de uma tabela diretamente. Isso significa que uma atualização pontual pode ocorrer ao mesmo tempo que uma sincronização completa.
- **Risco a testar:** concorrência entre gravação otimista, evento Realtime e consulta periódica. Dependendo da ordem das respostas, a interface pode mostrar temporariamente um estado antigo. Não há evidência suficiente nesta revisão estática para afirmar perda permanente de dados.

**Próximo teste:** abrir duas sessões de teste, criar/editar/excluir registros rapidamente e observar se os dois aparelhos terminam com os mesmos dados, inclusive durante reconexão.

### 2. Erros de armazenamento local — prioridade média
- A função `saveLocal()` captura exceções do `localStorage` sem informar o chamador.
- Se o navegador bloquear o armazenamento ou atingir a quota, o salvamento local pode falhar silenciosamente.

**Melhoria proposta:** registrar o erro e sinalizar claramente quando o armazenamento local não puder ser gravado, sem interromper a operação principal.

### 3. Tratamento de falhas de rede — prioridade média
- Há tratamento de erro nas gravações e avisos no console para falhas de sincronização.
- A interface não aparenta apresentar um indicador persistente e visível de conexão/sincronização no trecho revisado.

**Melhoria proposta:** exibir estados claros como sincronizado, sincronizando e sem conexão; nunca sugerir que uma alteração foi salva quando o banco não confirmou a gravação.

### 4. Integridade do estoque e operações repetidas — precisa de teste funcional
- As alterações de dados usam atualização otimista e revertem o estado local quando a gravação remota falha.
- Uma revisão estática não comprova que todos os fluxos de venda, edição, exclusão e reposição protejam contra cliques repetidos ou alterações concorrentes em dois aparelhos.

**Próximo teste:** testar venda, cancelamento/exclusão, reposição e cliques rápidos com produtos de teste, conferindo a quantidade final no banco.

### 5. Cálculos financeiros — precisa de teste funcional
- O arquivo contém lógica financeira e fluxos de venda a prazo.
- Ainda é necessário comparar os valores apresentados com casos de teste conhecidos: venda à vista, venda a prazo, pagamento parcial, gasto e exclusão/estorno.

### 6. Backup e restauração — precisa de validação
- O código tem lógica relacionada a dados locais e importação.
- Isso não comprova, por si só, que exista um processo completo e testado de exportação, restauração e prevenção de importação duplicada.

**Melhoria proposta:** validar exportação e restauração em ambiente de teste antes de considerar o backup confiável.

## Plano seguro de trabalho

1. Preservar `versao-oficial` sem alterações.
2. Reproduzir os cenários em `auditoria-estabilidade` e, quando possível, usar dados/conta de teste.
3. Corrigir um problema por vez e revisar o diff.
4. Validar os fluxos principais antes de considerar qualquer integração na versão oficial.

## Limitações desta etapa

- Auditoria estática inicial do arquivo principal; não é um teste de ponta a ponta.
- Não foram realizadas gravações ou exclusões no banco real.
- Não foi possível comprovar o comportamento do Realtime, as políticas de acesso do Supabase ou a restauração de backup somente pela leitura do frontend.


## Atualização — melhorias iniciais aplicadas na branch de auditoria

Commit: `c1dd872693bcbd5eb6c0f104035ff0082d7a1192`

- **Sincronização centralizada:** os eventos do Realtime agora solicitam a rotina única de sincronização completa, em vez de consultar diretamente uma tabela por fora da trava de sincronização. Isso reduz concorrência entre leituras disparadas por Realtime e pelo polling. O polling de 5 segundos continua como rede de segurança.
- **Falha no armazenamento local observável:** `saveLocal()` agora retorna sucesso/falha e registra aviso no console quando o navegador não consegue gravar os dados, em vez de engolir silenciosamente a exceção.

### O que ainda não está comprovado
- Essas mudanças passaram por revisão do código e conferência dos trechos alterados, mas não foram executadas num navegador conectado ao Supabase nesta etapa.
- A sincronização centralizada reduz uma condição de concorrência entre leituras, mas não resolve por si só todos os conflitos entre gravações simultâneas feitas em dispositivos diferentes.
- O aviso de `localStorage` aparece no console; ainda não há alerta visual para o usuário final.
- Estoque, cálculos financeiros, backup/restauração e reconexão continuam exigindo testes funcionais antes de declarar a auditoria concluída.
