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

## Phase 4 Database Ownership

`workshop-db` is a **legacy/reference database repository** under Phase 4. The following rules govern this repository and any future per-service database provisioning:

1. **Single-service ownership.** `workshop-db` provisions and manages PostgreSQL infrastructure exclusively for the `workshop` service. It MUST NOT be used as a shared central database for other Phase 4 microservices.
2. **No shared central database.** Each Phase 4 microservice that requires a persistent relational database SHALL own a dedicated database infrastructure repository. No two services MAY share one database instance, schema, or set of credentials.
3. **No cross-service database access.** A Phase 4 microservice MUST NOT read from or write to another service's database, whether directly or through shared credentials, security group rules, or Terraform remote state references that expose another service's connection metadata.
4. **Reference pattern for future per-service databases.** Any new `*-db` repository provisioned for a Phase 4 microservice SHALL follow the same Terraform module structure, naming convention (`${project}-${repo}-${environment}`), and infrastructure contract (host, port, name, secret ARN, security group id, instance identifier, subnet group name, parameter group name) established in this repository.

The governing specification for these boundary rules is [`openspec/changes/f4-db-legacy-boundary/`](../openspec/changes/f4-db-legacy-boundary/). Refer to that change (proposal, design, and capability spec) for detailed requirements and rejection scenarios.
