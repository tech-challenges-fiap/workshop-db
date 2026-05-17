# Justificativa da Escolha do Banco de Dados

## 1. Visão Geral

O sistema de backend de oficina mecânica utiliza PostgreSQL como banco de dados principal, provisionado como instância gerenciada via AWS RDS (Amazon Relational Database Service). Este repositório (`workshop-db`) é responsável exclusivamente pelo provisionamento dessa infraestrutura via Terraform, enquanto a evolução do schema (migrations e seeds) é de responsabilidade do repositório `workshop-app`. Este documento formaliza a justificativa técnica da escolha do PostgreSQL como banco de dados do sistema, atendendo ao requisito de documentação do Tech Challenge Fase 3 (FIAP SOAT).

---

## 2. Requisitos que Guiaram a Decisão

Os seguintes requisitos do sistema de oficina influenciaram diretamente a escolha do banco de dados:

- **Transações ACID para operações de estoque e ordem de serviço**: operações como decremento de estoque durante execução de tarefas e transições de status de ordens de serviço exigem atomicidade e consistência garantidas pelo banco.
- **Relacionamentos fortes entre entidades**: o domínio possui vínculos explícitos entre `person`, `vehicles`, `work_orders`, `service_tasks`, `stock_items` e histórico de status — relacionamentos que se traduzem naturalmente em chaves estrangeiras e joins relacionais.
- **Consistência em fluxos de aprovação de tarefas**: o ciclo de vida da ordem de serviço (`RECEIVED → DIAGNOSIS → WAITING_APPROVAL → READY → IN_EXECUTION → FINALIZED → DELIVERED/CANCELED`) exige que transições de estado sejam registradas de forma consistente e auditável.
- **Escalabilidade gerenciada**: a operação em produção na AWS exige backups automáticos, failover, patching e disponibilidade gerenciada sem overhead operacional interno.
- **Facilidade de operação local para desenvolvimento**: a equipe precisa de um banco com setup simples via Docker para ciclos de desenvolvimento e testes isolados.

---

## 3. Banco Escolhido: PostgreSQL

### Por que relacional

O modelo de dados do sistema é intrinsecamente relacional. As entidades centrais (`person`, `vehicles`, `work_orders`, `service_tasks`, `stock_items`) possuem vínculos fortes entre si, representados por chaves estrangeiras. Consultas de domínio — como listar tarefas de uma ordem de serviço com seus itens de estoque associados, ou calcular tempo médio por etapa — dependem de joins eficientes entre tabelas normalizadas. Um banco não-relacional exigiria desnormalização artificial ou lógica adicional de agregação na camada de aplicação, adicionando complexidade sem benefício real para este domínio.

### ACID

As operações críticas do sistema exigem as garantias ACID (Atomicidade, Consistência, Isolamento, Durabilidade):

- O decremento de `stock_items` durante a execução de tarefas deve ser atômico: ou a operação completa com sucesso, ou nenhuma alteração persiste.
- Transições de status de `work_orders` e `service_tasks` devem ser consistentes: não é aceitável que o banco permita estados intermediários inválidos.
- O rastreamento de histórico de status (`work_order_status_history`) requer que cada registro seja durável e auditável.

O PostgreSQL fornece essas garantias nativamente em nível de transação, sem necessidade de workarounds na aplicação.

### Maturidade e ecossistema

O PostgreSQL é um banco de dados relacional com mais de 30 anos de desenvolvimento ativo, amplo suporte pela comunidade e ecossistema maduro:

- **Drizzle ORM**: o stack de aplicação utiliza Drizzle ORM, que possui suporte nativo e de primeira classe para PostgreSQL, incluindo tipagem TypeScript para o schema e geração de migrations.
- **Extensões**: o PostgreSQL suporta extensões como `uuid-ossp` e `pgcrypto`, úteis para geração de UUIDs e operações criptográficas na camada de infraestrutura.
- **Setup local via Docker**: disponível como imagem oficial no Docker Hub, permitindo ambiente de desenvolvimento idêntico ao de produção com uma única linha de configuração no `docker-compose`.

### AWS RDS gerenciado

A escolha do AWS RDS para PostgreSQL elimina o overhead operacional de gerenciamento de banco em produção:

- **Backups automáticos**: snapshots diários com retenção configurável (atualmente 1 dia, otimizado para custo do coursework).
- **Failover automático**: suporte a Multi-AZ para ambientes que exijam alta disponibilidade.
- **Patching gerenciado**: atualizações de segurança e de minor version aplicadas pela AWS sem downtime manual.
- **Secrets Manager**: credenciais de conexão armazenadas e rotacionadas via `aws_secretsmanager_secret`, sem exposição de senhas em variáveis de ambiente em texto plano.
- **Sizing ajustável**: a instância atual usa `db.t4g.micro` com 20 GiB de armazenamento `gp3` em Single-AZ, otimizada para custo no escopo do challenge, mas escalável sem mudança de stack.

### Versão escolhida

**PostgreSQL 16** — última versão estável com suporte completo pelo AWS RDS no momento da implementação. Oferece melhorias de desempenho em queries paralelas, aprimoramentos no controle de acesso por linha (Row-Level Security) e melhor monitoramento via `pg_stat_io`.

---

## 4. Alternativas Consideradas

| Banco | Tipo | Por que não foi escolhido |
|-------|------|--------------------------|
| MySQL | Relacional | Menor suporte a tipos avançados (ex.: `jsonb`, arrays nativos); ecossistema ORM menos rico para o stack Bun/Drizzle; suporte a transações DDL menos maduro que o PostgreSQL. |
| DynamoDB | NoSQL documento | Modelo de dados baseado em chave-valor/documento não é adequado para os relacionamentos fortes e queries complexas do domínio; consultas multi-entidade exigiriam desnormalização extensiva ou múltiplas requisições. |
| MongoDB | NoSQL documento | Ausência de garantias transacionais fortes entre documentos em versões anteriores; overhead de schema-less desnecessário para um domínio com modelo estável e bem definido; menor integração nativa com Drizzle ORM. |
| Aurora PostgreSQL | Relacional gerenciado | Custo mais elevado desnecessário para o escopo do challenge; o Aurora adiciona valor em cenários de escala horizontal que não se aplicam a este sistema no estágio atual. |

---

## 5. Ajustes no Modelo Relacional (Fase 3)

Na Fase 3 do Tech Challenge, dois ajustes relevantes foram realizados no modelo relacional para suportar novos requisitos funcionais. Esses ajustes foram implementados no repositório `workshop-app` (que é o proprietário do schema e das migrations) e são consumidos pelo banco provisionado por este repositório:

- **Adição de `person.status` (migration 012)**: nova coluna de status na entidade `person` para suportar o fluxo de autenticação. Apenas persons com `status = active` recebem tokens JWT válidos, permitindo controle de acesso baseado no estado do cadastro.
- **Adição de `work_order_status_history` (migration 013)**: nova tabela para rastreamento de todas as transições de status das ordens de serviço. Esse histórico é a base para o cálculo do tempo médio gasto por etapa do fluxo (Diagnóstico, Execução, Finalização), atendendo ao requisito de métricas operacionais da Fase 3.

Esses ajustes são compatíveis com o modelo relacional existente e não exigiram mudança de banco de dados nem de engine — reforçando que a escolha do PostgreSQL foi adequada para absorver a evolução do domínio.

---

## 6. Conclusão

O PostgreSQL foi a escolha natural para o sistema de oficina mecânica pelo conjunto de fatores que atendem diretamente aos requisitos do domínio: fit relacional com as entidades e seus relacionamentos fortes, garantias ACID que protegem invariantes de estoque e status de ordens de serviço, maturidade e suporte nativo no stack Bun/Drizzle, e operação simplificada via AWS RDS. O uso do RDS elimina o overhead operacional de gerenciamento de banco em produção, mantendo o foco da equipe na evolução do domínio. A evolução do schema na Fase 3 confirmou que a escolha foi adequada: os novos requisitos foram absorvidos com migrations incrementais, sem necessidade de mudança de tecnologia.
