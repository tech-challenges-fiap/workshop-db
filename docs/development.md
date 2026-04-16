# Developing In workshop-db

## Prerequisites

- Terraform `>= 1.14.0`
- AWS credentials only when you intentionally run remote operations outside local validation

## Local Workflow

Move into the Terraform directory:

```bash
cd terraform
```

Run validation:

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

Run an environment plan when you have AWS access and a valid state backend:

```bash
terraform init -reconfigure -backend-config=environments/stag/backend.hcl.example
terraform plan -var-file=environments/stag/terraform.tfvars.example
```

## What The Commands Do

- `terraform fmt -check -recursive` verifies Terraform formatting
- `terraform init -backend=false` initializes providers without requiring a remote backend
- `terraform validate` checks the Terraform configuration
- `terraform init -reconfigure -backend-config=...` connects Terraform to the environment state bucket
- `terraform plan ...` validates the environment-specific contract used by CI

## Branching and Delivery Expectations

- Build features from `feature/*` branches
- Open Pull Requests into `stag` for normal integration
- Promote to `prod` only from `stag`
- Expect `pr-validation.yml` to run Terraform formatting, validation, and plan
- Expect `deploy.yml` to use AWS OIDC, remote state, and `terraform apply`
- Expect `promotion-source.yml` and `drift-report.yml` to protect production promotions

## Documentation Rules

- Write all documentation in English
- Keep docs faithful to the Terraform baseline that exists today
- When variables, outputs, commands, or workflows change, update the docs in the same change
- Keep documentation aligned with the actual RDS, subnet group, security group, parameter group, and secret resources defined in Terraform

## When To Update Documentation

Update documentation when you change:

- Terraform variables, outputs, or naming rules
- expected validation commands
- deployment workflow behavior
- repository ownership boundaries
- AI contributor guidance in `AGENTS.md` or `.ai/`
