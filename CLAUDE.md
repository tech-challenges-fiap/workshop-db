# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

`workshop-db` provisions PostgreSQL infrastructure (AWS RDS) for the `workshop` service. It owns Terraform only — no migrations, seeds, application code, or shared networking.


## OpenSpec Instructions

This repository uses OpenSpec as the mandatory governance process for product, architecture, contracts, infrastructure, and behavior changes. Read `openspec/AGENTS.md` and this repository's `AGENTS.md` before any code change.

- Do not modify implementation paths (`src/`, `terraform/`, `k8s/`, `kubernetes/`, workflows, schemas, API contracts, or runtime behavior) unless an approved change exists under `openspec/changes/<change-id>/`.
- Validate the change with `npx --yes @fission-ai/openspec validate <change-id> --strict` before implementation and before PR handoff.
- If the requested work has no change-id, or if the spec is ambiguous, stop and raise the question to Hermes/Void. Do not decide product or architecture scope silently.
- Keep implementation inside the approved `tasks.md`; update the OpenSpec change before expanding scope.
- Mention the OpenSpec change-id and validation result in the PR body.
- After merge to `stag`, archive the completed change with `npx --yes @fission-ai/openspec archive <change-id>`.

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
- PRs trigger `pr-validation.yml` (fmt, init without remote state, validate) without protected GitHub environments

## Documentation

Update `README.md`, `docs/`, and `.ai/` in the same change when you modify Terraform variables, outputs, naming conventions, validation commands, or workflow behavior. Do not document resources that the Terraform code does not define.
