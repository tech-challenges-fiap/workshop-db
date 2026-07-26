# db-legacy-boundary Specification

## Purpose
TBD - created by archiving change f4-db-legacy-boundary. Update Purpose after archive.
## Requirements
### Requirement: workshop-db serves the workshop service only
`workshop-db` SHALL provision and manage PostgreSQL infrastructure exclusively for the `workshop` service. It MUST NOT be used as a shared central database for other Phase 4 microservices.

#### Scenario: Agent or engineer evaluates whether to add another service to workshop-db
- **WHEN** a request arrives to add a schema, credentials, or database resource for a service other than `workshop` to this repository
- **THEN** the agent or engineer MUST reject the request and direct the requester to create a dedicated database infrastructure repository for that service

#### Scenario: Consumer service attempts to reuse workshop-db credentials or connection metadata
- **WHEN** a Phase 4 microservice other than `workshop` attempts to use the outputs of `workshop-db` (host, port, secret ARN, security group) to connect to the database
- **THEN** that connection MUST be identified as a cross-service database access violation and blocked by architecture review

### Requirement: No Phase 4 service may share a central database with another service
Each Phase 4 microservice that requires a persistent relational database SHALL own a dedicated database infrastructure repository. No two services MAY share one database instance, schema, or set of credentials.

#### Scenario: Phase 4 service needs a new database
- **WHEN** a Phase 4 microservice requires PostgreSQL infrastructure
- **THEN** a new dedicated `*-db` repository MUST be created for that service, following the same Terraform module pattern as `workshop-db`, and governed by its own OpenSpec changes

#### Scenario: Proposal attempts to co-locate two services on one database instance
- **WHEN** an OpenSpec proposal for any repository requests that two distinct Phase 4 services connect to the same RDS instance or share the same `aws_db_instance` resource
- **THEN** the proposal MUST be rejected and the requester directed to provision separate instances per service

### Requirement: No service may access another service's database
A Phase 4 microservice MUST NOT read from or write to another service's database, whether directly or through shared credentials, security group rules, or Terraform remote state references that expose another service's connection metadata.

#### Scenario: Security group ingress rule is proposed for a cross-service caller
- **WHEN** an OpenSpec change proposes adding an ingress rule on a service's database security group for a caller belonging to a different service boundary
- **THEN** the change MUST be rejected; the correct pattern is an API or event-based integration, not direct database access

#### Scenario: Terraform remote state from workshop-db is referenced by another service's infrastructure
- **WHEN** a Terraform configuration outside the `workshop` service boundary references `workshop-db` remote state outputs to obtain a database host, port, or secret ARN
- **THEN** that reference MUST be identified as a boundary violation and removed

### Requirement: Future per-service database provisioning follows the workshop-db reference pattern
Any new `*-db` repository provisioned for a Phase 4 microservice SHALL follow the same Terraform module structure, naming convention (`${project}-${repo}-${environment}`), and infrastructure contract (host, port, name, secret ARN, security group id, instance identifier, subnet group name, parameter group name) established in `workshop-db`.

#### Scenario: Agent creates a new per-service database repository
- **WHEN** an agent bootstraps a new Phase 4 database repository for a microservice
- **THEN** the agent SHALL use `workshop-db` as the reference implementation: same module layout under `terraform/modules/`, same output names, same environment convention under `terraform/environments/`, and the same validation baseline (`terraform fmt -check -recursive`, `terraform init -backend=false`, `terraform validate`)

#### Scenario: New database repository deviates from the reference naming convention
- **WHEN** a proposed Terraform resource in a new `*-db` repository uses a name that does not follow `${project}-${repo}-${environment}` or exposes outputs with different names than those defined in `workshop-db`
- **THEN** the deviation MUST be justified in the OpenSpec design document for that repository before implementation proceeds

