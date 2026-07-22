## Why

Phase 4 of the FIAP Tech Challenge introduces per-service ownership as a core architectural principle. `workshop-db` was provisioned in Phase 3 as the PostgreSQL infrastructure for the `workshop` service, but its role has never been formally bounded to prevent it from being treated as a shared central database for all microservices. This change establishes the explicit legacy boundary for this repository and the rules any future per-service database provisioning must follow.

## What Changes

- Add a `db-legacy-boundary` capability spec that formally restricts `workshop-db` to serving the `workshop` service only and prohibits cross-service database sharing.
- Document the Phase 4 rule: each Phase 4 microservice must own its database infrastructure through a dedicated repository and Terraform stack; no service may share one central database or access another service's database.
- Add documentation guidance in `docs/architecture.md` covering the legacy boundary, Phase 4 database ownership rules, and the isolation requirements for new per-service databases.

## Capabilities

### New Capabilities
- `db-legacy-boundary`: Defines the boundary rules for this repository as a legacy/reference database under Phase 4. Covers: single-service ownership, cross-service access prohibition, Phase 4 per-service provisioning rules, and isolation requirements for new service databases.

### Modified Capabilities
- None.

## Impact

- Documentation only for this change (`docs/architecture.md`). No Terraform resources, outputs, CI workflows, or runtime behavior change.
- Establishes a governance constraint that future Phase 4 changes in this repo and any new `*-db` repos must satisfy.
- Does not affect `stag` or `prod` deployments.
