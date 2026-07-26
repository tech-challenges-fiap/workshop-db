## 1. Document Phase 4 Legacy Boundary

- [x] 1.1 Update `docs/architecture.md` to add a "Phase 4 Database Ownership" section that states: `workshop-db` serves the `workshop` service only; no Phase 4 service may share a central database with another service; no service may access another service's database; future per-service databases must follow the `workshop-db` reference pattern.
- [x] 1.2 Add a forward-reference in `docs/architecture.md` pointing to `openspec/changes/f4-db-legacy-boundary/` as the governing spec for the boundary rules.

## 2. Validate Terraform Baseline

- [x] 2.1 Run `terraform fmt -check -recursive` from `terraform/` and confirm zero formatting errors. PASSED with Terraform v1.15.8.
- [x] 2.2 Run `terraform init -backend=false` from `terraform/` and confirm successful provider initialization. PASSED with Terraform v1.15.8.
- [x] 2.3 Run `terraform validate` from `terraform/` and confirm zero validation errors. PASSED with Terraform v1.15.8.

## 3. Review Documentation

- [x] 3.1 Verify that `docs/architecture.md` changes accurately reflect the spec requirements in `openspec/changes/f4-db-legacy-boundary/specs/db-legacy-boundary/spec.md` with no contradictions.
- [x] 3.2 Verify that `README.md` still accurately describes the repository's scope after the architecture doc update; update if needed.

## 4. OpenSpec Validation and PR Prep

- [x] 4.1 Run `npx --yes @fission-ai/openspec validate f4-db-legacy-boundary --strict` and confirm it passes.
- [ ] 4.2 Open a PR into `stag` with title referencing `f4-db-legacy-boundary` and include the change id and strict validation result in the PR body.
