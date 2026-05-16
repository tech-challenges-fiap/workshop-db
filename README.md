# workshop-db

[![Prod/Stag sync](https://github.com/tech-challenges-fiap/workshop-db/actions/workflows/branch-sync.yml/badge.svg)](https://github.com/tech-challenges-fiap/workshop-db/actions/workflows/branch-sync.yml)

`workshop-db` owns PostgreSQL infrastructure for the `workshop` service.
It provisions and names managed database resources, but it does not own schema
evolution or application behavior.

## What This Repository Owns

- Terraform composition for `stag` and `prod`
- managed PostgreSQL infrastructure in AWS
- database-focused CI validation and deployment workflow

This repository does not own migrations, seeds, application runtime code, or
shared runtime platform logic.

## Provisioned Surface

The Terraform stack now provisions:

- one PostgreSQL RDS instance per environment
- one DB subnet group
- one database security group with controlled ingress
- one PostgreSQL parameter group
- one Secrets Manager secret with credentials and connection metadata

Formal outputs exposed by the root module:

- `db_host`
- `db_port`
- `db_name`
- `db_secret_arn`
- `db_security_group_id`

## Local Commands

Minimal validation without touching remote state:

```bash
cd terraform
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

Environment plan with real backend and AWS access:

```bash
cd terraform
terraform init -reconfigure -backend-config=environments/stag/backend.hcl.example
terraform plan -var-file=environments/stag/terraform.tfvars.example
```

Stop the staging database when it is not being used:

```bash
./scripts/stop-stag-db.sh
```

The script defaults to `us-east-1` and `workshop-db-stag-postgres`. Override
with `AWS_REGION` or `DB_INSTANCE_IDENTIFIER` when needed.

Stop the production database when it is not being used:

```bash
./scripts/stop-prod-db.sh
```

Staging is also stopped automatically:

- every night at 03:00 America/Sao_Paulo, through the `Stop Staging DB` workflow

Production is stopped automatically every night at 03:30 America/Sao_Paulo,
through the `Stop Production DB` workflow.

## Delivery Flow

- `feature/* -> stag`: Pull Request validated by Terraform formatting, validation, and plan
- `stag -> prod`: promotion Pull Request allowed only from `stag`
- `push` to `stag` or `prod`: deployment workflow uses AWS OIDC and runs Terraform apply
- `prod` Pull Requests: drift-report and promotion-source workflows enforce branch discipline
- `Create Promotion PR`: manual workflow that opens the `stag` to `prod` promotion PR when one does not already exist

The `Create Promotion PR` workflow requires the `PROMOTION_PR_TOKEN` repository
secret. Use a fine-grained GitHub token with access to this repository and
pull request read/write permission.

## Documentation

- [docs/README.md](docs/README.md) - docs index and reading guide
- [docs/architecture.md](docs/architecture.md) - repository boundaries and target database role
- [docs/development.md](docs/development.md) - Terraform workflow, validation, and documentation rules
- [AGENTS.md](AGENTS.md) - instructions for AI contributors
