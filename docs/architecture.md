# workshop-db Architecture

## Role

`workshop-db` is the database infrastructure repository. It provisions and
manages PostgreSQL foundations while leaving schema evolution and business
logic out of scope.

## Boundaries

This repository owns:

- PostgreSQL infrastructure provisioning
- environment-specific database naming and baseline inputs
- Terraform validation and database-focused deployment workflows

This repository does not own application logic, migrations, seeds, gateway
behavior, or shared runtime platform capabilities.

## Current Implementation Surface

Today the repository provisions a minimal managed PostgreSQL stack:

- `terraform/main.tf` composes environment defaults for `stag` and `prod`
- `terraform/modules/postgresql` provisions the RDS instance, subnet group, security group, parameter group, and credentials secret
- `terraform/outputs.tf` exposes the database connection contract
- `terraform/versions.tf` configures the AWS and random providers plus the S3 backend interface

## Exposed Contract

This repository exposes infrastructure outputs such as host, port, database
name, secret ARN, and security group identifiers. Those outputs are part of the
public infrastructure contract of this repository.

## Managed Resources

- `aws_db_instance` for PostgreSQL
- `aws_db_subnet_group`
- `aws_security_group` and ingress rules for approved callers
- `aws_db_parameter_group`
- `aws_secretsmanager_secret` and secret version for credentials and connection metadata

## Non-Goals

- Do not move migrations, seeds, or ORM-specific files into this repo by default.
- Do not add application runtime behavior here.
- Do not treat this repo as the owner of shared networking or cluster concerns.
