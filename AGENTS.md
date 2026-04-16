# AGENTS.md

## Mission

Work in `workshop-db` as the database infrastructure repository for the
workshop split. Keep this repo focused on PostgreSQL provisioning concerns and
Terraform contracts.

## Scope Boundaries

In scope:

- Terraform in `terraform/`
- database naming and environment conventions
- managed PostgreSQL provisioning resources
- database-focused CI and deployment docs

Out of scope:

- application runtime code
- migrations and seeds unless ownership is explicitly changed
- API Gateway or Lambda behavior
- shared platform infrastructure such as EKS, networking, or ingress

If a change belongs to `workshop-app`, `workshop-edge`, or
`workshop-platform`, document the dependency instead of moving that
responsibility here.

## Read First

- `README.md`
- `docs/architecture.md`
- `docs/development.md`
- `terraform/main.tf`
- `terraform/variables.tf`
- `terraform/outputs.tf`

## Validation Commands

```bash
cd terraform
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

When a task requires a real plan or apply, reinitialize Terraform with the
environment backend before running `terraform plan`.

Run all relevant validation for any Terraform change. For documentation-only
changes, still verify that documented commands and paths are correct.

## Writing Rules

- Write docs and AI guidance in English
- Do not invent provisioned resources that the Terraform code does not define
- Keep repository boundaries explicit
- Separate provisioning concerns from schema/application concerns

## Documentation Expectations

Update `README.md`, `docs/`, and `.ai/` when you change:

- Terraform interfaces
- environment conventions
- validation commands
- deployment workflow behavior
- repository boundaries
