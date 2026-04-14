# workshop-db docs

## Ownership

- scope: managed PostgreSQL, baseline configuration, and credentials
- out of scope: migrations, evolutionary schema, seeds, and application domain logic

## Initial structure

- `terraform/`: repository Terraform baseline
- `.github/`: templates, ownership, and minimum automation

## Environments

- branch `stag` deploys into `staging`
- branch `prod` deploys into `production`
- AWS suffixes: `stag` and `prod`

## Expected environment variables and secrets

- `AWS_REGION`
- `AWS_ROLE_ARN`
- `DB_INSTANCE_IDENTIFIER`
- `DB_SUBNET_GROUP`
- `DATADOG_API_KEY`
- `DATADOG_APP_KEY`
