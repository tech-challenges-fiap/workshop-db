# workshop-db docs

This directory explains how `workshop-db` should be developed and maintained as
a standalone database infrastructure repository.

## Read This First

- Start with [../README.md](../README.md) for the repository purpose, commands, and delivery flow.
- Read [architecture.md](architecture.md) before deciding whether database-related work belongs here.
- Read [development.md](development.md) before changing Terraform or CI behavior.
- Read [../AGENTS.md](../AGENTS.md) if you are using an AI agent in this repository.

## Document Map

- [architecture.md](architecture.md) - current boundaries and database architecture guidance
- [development.md](development.md) - Terraform workflow, validation commands, and doc rules
- [../AGENTS.md](../AGENTS.md) - repo instructions for AI agents
- [../.ai/project-context.md](../.ai/project-context.md) - compact AI-readable project context
- [../.ai/contributing.md](../.ai/contributing.md) - AI-assisted change checklist
- [../.ai/task-template.md](../.ai/task-template.md) - reusable task brief template

## Who Should Read What

- Engineers new to the repo: `README.md` then `development.md`
- Engineers deciding ownership boundaries: `architecture.md`
- AI-assisted contributors: `AGENTS.md` and `.ai/project-context.md`

## Current Working Contract

- `terraform/modules/postgresql` owns the reusable PostgreSQL building blocks
- `terraform/environments/stag` and `terraform/environments/prod` document backend and input examples
- root Terraform outputs define the database connection contract exposed by this repository
- default sizing is intentionally cost-optimized for coursework: `db.t4g.micro`, 20 GiB gp3 storage, Single-AZ, and 1 day of automated backup retention
- this repo still does not own migrations, schema, seeds, or queries

## GitHub Environment Variables

Configure these variables separately in the `staging` and `production` GitHub environments:

- `AWS_REGION`
- `AWS_ROLE_ARN`
- `TF_STATE_BUCKET`
- `TF_STATE_KEY`
- `DB_VPC_ID`
- `DB_PRIVATE_SUBNET_IDS`
- `DB_ALLOWED_SECURITY_GROUP_IDS`
- `DB_ALLOWED_CIDR_BLOCKS`
- `DB_NAME`
- `DB_MASTER_USERNAME`

`DB_PRIVATE_SUBNET_IDS`, `DB_ALLOWED_SECURITY_GROUP_IDS`, and `DB_ALLOWED_CIDR_BLOCKS` must be JSON arrays, for example `["subnet-0123","subnet-0456"]`.
`DB_ALLOWED_SECURITY_GROUP_IDS`, `DB_ALLOWED_CIDR_BLOCKS`, `DB_NAME`, and `DB_MASTER_USERNAME` can be omitted when the Terraform defaults are acceptable.

## Terraform Outputs

Downstream repositories consume the database contract through these outputs:

- `db_host`
- `db_port`
- `db_name`
- `db_secret_arn`
- `db_security_group_id`

Additional operational outputs:

- `db_instance_identifier`
- `db_subnet_group_name`
- `db_parameter_group_name`

## Out Of Scope

This repository must not contain SQL migrations, Drizzle schema, seeds, queries, or application domain rules.
