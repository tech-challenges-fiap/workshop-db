# Project Context

## Repository

`workshop-db` is the database infrastructure repository for managed PostgreSQL provisioning.

## Ownership

This repository owns: Terraform for RDS PostgreSQL, subnet/security/parameter group wiring, Secrets Manager connection metadata, outputs, and database infrastructure documentation.

This repository does not own: application code, migrations, seeds, gateway behavior, or shared platform infrastructure.

## OpenSpec Governance

OpenSpec is the canonical process for non-trivial changes. Product, architecture, contract, infrastructure, schema, workflow, and runtime behavior changes must start with an OpenSpec change under `openspec/changes/<change-id>/`.

Claude Code and other agents must not implement from informal intent alone. If a change is missing, ambiguous, or expands beyond the approved tasks, the agent must stop and raise the question to Hermes/Void.

## Primary Change Areas

terraform/, docs/, .ai/

## Validation Baseline

```bash
cd terraform && terraform fmt -check -recursive && terraform init -backend=false && terraform validate
```

## Branching Baseline

Work starts from updated `origin/stag`, opens PRs into `stag`, and never pushes directly to `stag` or `prod`. Production remains promotion-only through `stag -> prod`.
