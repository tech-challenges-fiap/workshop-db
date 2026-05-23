# workshop-db

[![prod/stag](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Ftech-challenges-fiap%2Fworkshop-db%2Fbadges%2Fbadges%2Fprod-stag-sync.json)](https://github.com/tech-challenges-fiap/workshop-db/compare/prod...stag)

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

## Delivery Flow

- `feature/* -> stag`: Pull Request validated by Terraform formatting, initialization, and validation
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
- [docs/database-choice.md](docs/database-choice.md) - formal justification for PostgreSQL and migration rationale
- [docs/development.md](docs/development.md) - Terraform workflow, validation, and documentation rules
- [AGENTS.md](AGENTS.md) - instructions for AI contributors

Transversal architecture documentation (component diagrams, sequence diagrams, ER model, RFCs, ADRs) is
maintained in [workshop-app/docs](https://github.com/tech-challenges-fiap/workshop-app/blob/stag/docs/README.md).
