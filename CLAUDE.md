# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

`workshop-db` provisions PostgreSQL infrastructure (AWS RDS) for the `workshop` service. It owns Terraform only — no migrations, seeds, application code, or shared networking.

## Commands

Always run from `terraform/`:

```bash
cd terraform
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

For an environment plan with real AWS state:

```bash
terraform init -reconfigure -backend-config=environments/stag/backend.hcl.example
terraform plan -var-file=environments/stag/terraform.tfvars.example
```

Run all three validation steps for any Terraform change. For documentation-only changes, verify that documented commands and paths still match reality.

## Architecture

The Terraform root module (`terraform/`) composes environment defaults for `stag` and `prod` and delegates to a single child module:

- **`terraform/modules/postgresql/`** — provisions `aws_db_instance`, `aws_db_subnet_group`, `aws_security_group` (with ingress rules per security group and per CIDR), `aws_db_parameter_group`, `aws_secretsmanager_secret`, and `aws_secretsmanager_secret_version`.

Resource naming follows `${project}-${repo}-${environment}` (e.g. `workshop-db-stag`), producing identifiers like `workshop-db-stag-postgres`. Network resources (security group, subnet group) accept an optional `network_resource_name_suffix` to allow name-changing during VPC moves without destroying the RDS instance first — when set, the suffix is appended to those two resources only.

Root outputs exposed as the infrastructure contract: `db_host`, `db_port`, `db_name`, `db_secret_arn`, `db_security_group_id`, `db_instance_identifier`, `db_subnet_group_name`, `db_parameter_group_name`.

## Branching and Delivery

- Work on `feature/*` branches based on `origin/stag`
- Open PRs into `stag` (never directly into `prod`)
- `prod` is updated only through the `stag → prod` promotion PR, merged with a merge commit (no squash, no rebase)
- `push` to `stag` or `prod` triggers `deploy.yml` which runs `terraform apply` via AWS OIDC
- PRs trigger `pr-validation.yml` (fmt, validate, plan) using environment-specific GitHub variables

## Documentation

Update `README.md`, `docs/`, and `.ai/` in the same change when you modify Terraform variables, outputs, naming conventions, validation commands, or workflow behavior. Do not document resources that the Terraform code does not define.
