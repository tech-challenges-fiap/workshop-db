# workshop-db docs

## Ownership

- escopo: PostgreSQL gerenciado, configuracao base e credenciais
- fora do escopo: migrations, schema evolutivo, seeds e dominio da aplicacao

## Estrutura inicial

- `terraform/`: baseline Terraform do repositorio
- `.github/`: templates, ownership e automacao minima

## Ambientes

- branch `stag` publica no ambiente `staging`
- branch `prod` publica no ambiente `production`
- sufixos AWS: `stag` e `prod`

## Variaveis e secrets esperados por ambiente

- `AWS_REGION`
- `AWS_ROLE_ARN`
- `DB_INSTANCE_IDENTIFIER`
- `DB_SUBNET_GROUP`
- `DATADOG_API_KEY`
- `DATADOG_APP_KEY`

