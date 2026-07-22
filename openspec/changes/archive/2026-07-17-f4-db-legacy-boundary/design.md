## Context

`workshop-db` was introduced in Phase 3 as the PostgreSQL infrastructure repository for the `workshop` service. At the time, the system had a single service with a single database, so no cross-service boundary needed to be formally stated. Phase 4 introduces a microservice decomposition where each service must own its database independently. Without an explicit boundary on this repository, agents and engineers could misinterpret it as a shared central database provider, leading to cross-service coupling that violates Phase 4 isolation requirements.

This design is documentation-only. It introduces no new Terraform resources, no infrastructure changes, and no CI modifications.

## Goals / Non-Goals

**Goals:**
- Formally declare `workshop-db` as the legacy/reference database for the `workshop` service only.
- State the Phase 4 rule: no microservice may share a central database with another service, and no service may access another service's database.
- Document the requirements that any future per-service database provisioning must follow.
- Add these boundaries to `docs/architecture.md` so they are visible to agents and engineers reading the existing documentation entry point.

**Non-Goals:**
- Do not provision new Terraform resources in this change.
- Do not define which microservices will exist in Phase 4 or which databases they will need.
- Do not modify CI workflows, Terraform modules, or AWS resources.
- Do not set access control or security group rules for hypothetical future services.
- Do not create new `*-db` repositories for other services; that is a separate change per service.

## Decisions

**Decision: Documentation-only scope**
The boundary is enforced through governance documentation (`docs/architecture.md`, `openspec/changes/f4-db-legacy-boundary/`) rather than Terraform isolation rules. Terraform-level isolation (separate VPCs, separate security groups, no shared credentials) is a future concern for each per-service database provisioning change. The immediate need is a clear written rule that blocks unintentional shared-database patterns before any Phase 4 service database is created.

**Decision: `docs/architecture.md` as the canonical boundary statement**
The existing `docs/architecture.md` already defines the repository's role and current implementation surface. Extending it with a Phase 4 section keeps all boundary information in one document that agents are already required to read (`AGENTS.md` → Read First). A separate Phase 4 boundary doc would fragment the ownership story.

**Decision: Single `db-legacy-boundary` capability spec**
All Phase 4 boundary rules for this repo are expressed in one capability (`db-legacy-boundary`) rather than one spec per rule. The rules are tightly related (they all concern database ownership in Phase 4) and a single spec makes the constraint easy to validate against.

## Risks / Trade-offs

- Documentation-enforcement risk: the boundary is stated in docs and specs, not enforced by Terraform or IAM. Future agents or engineers must read the docs and OpenSpec before acting. Mitigation: `AGENTS.md` and `openspec/AGENTS.md` already require agents to read `docs/architecture.md` before implementation.
- Ambiguity risk for future per-service databases: the spec states isolation rules but does not prescribe a naming convention or module structure for new `*-db` repos. Each future provisioning change will need its own OpenSpec proposal. Mitigation: tasks include adding a forward-reference in `docs/architecture.md` pointing to this spec as the baseline for future per-service database changes.
