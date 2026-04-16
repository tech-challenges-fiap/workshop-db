# workshop-db Architecture

## Role in the Split

`workshop-db` is the database infrastructure repository for the workshop split.
Its long-term role is to provision and manage the PostgreSQL foundations that
support the application, while leaving schema evolution and business rules to
other repositories.

## Boundaries

This repository owns:

- PostgreSQL infrastructure provisioning
- environment-specific database naming and baseline inputs
- Terraform validation and database-focused deployment workflows

This repository does not own:

- application domain logic
- migrations and seeds executed by the app runtime
- API Gateway or Lambda behavior
- cluster-wide platform capabilities such as EKS or ingress

## Current Implementation Surface

Today the repository provisions a minimal managed PostgreSQL stack:

- `terraform/main.tf` composes environment defaults for `stag` and `prod`
- `terraform/modules/postgresql` provisions the RDS instance, subnet group, security group, parameter group, and credentials secret
- `terraform/outputs.tf` exposes the database connection contract
- `terraform/versions.tf` configures the AWS and random providers plus the S3 backend interface

## Dependencies and Interactions

- `workshop-app` is the future primary consumer of the database provisioned here.
- `workshop-platform` is expected to own shared runtime infrastructure where the app may execute.
- `workshop-edge` may depend on application-level interfaces that ultimately store data in infrastructure managed here, but it should not provision database resources itself.

## Contracts With Adjacent Repositories

- `workshop-platform` is expected to provide the VPC, private subnet IDs, and upstream security groups consumed here as inputs.
- `workshop-app` consumes `db_host`, `db_port`, `db_name`, and `db_secret_arn`, but keeps ownership of migrations, schema, and seeds.
- `workshop-edge` may consume the same secret and security group contract when the `auth-cpf` Lambda needs direct database access.

## Managed Resources

- `aws_db_instance` for PostgreSQL
- `aws_db_subnet_group`
- `aws_security_group` and ingress rules for approved callers
- `aws_db_parameter_group`
- `aws_secretsmanager_secret` and secret version for credentials and connection metadata

## Non-Goals

- Do not move migrations, seeds, or ORM-specific files into this repo by default.
- Do not add application runtime behavior here.
- Do not treat this repo as the owner of platform-wide networking or cluster concerns.
