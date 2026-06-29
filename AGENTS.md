# AGENTS.md

## Mission

Work in `workshop-db` as a database infrastructure repository. Keep this repo
focused on PostgreSQL provisioning concerns and Terraform contracts.

## Scope Boundaries

In scope:

- Terraform in `terraform/`
- database naming and environment conventions
- managed PostgreSQL provisioning resources
- database-focused CI and deployment docs

Out of scope:

- application runtime code
- migrations and seeds unless ownership is explicitly changed
- gateway behavior
- shared platform infrastructure such as networking or ingress


## OpenSpec Governance

- Before touching any in-scope implementation, infrastructure, contract, schema, or workflow path, confirm an OpenSpec change exists at `openspec/changes/<change-id>/` with `proposal.md`, `tasks.md`, and required spec deltas.
- If no change exists for the requested work, stop and ask Hermes/Void for the change-id instead of inventing scope.
- Run `npx --yes @fission-ai/openspec validate <change-id> --strict` before implementing and again before opening the PR.
- Implement only tasks listed in the approved OpenSpec change; if implementation reveals new scope, update the change first.
- Reference the change-id in the PR title and body.
- After the PR merges into `stag`, archive the change with `npx --yes @fission-ai/openspec archive <change-id>` in the same or a follow-up PR.
- Exemptions: typo-only documentation fixes and dependency lockfile refreshes with no behavior, contract, infrastructure, or workflow change.

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

## Workflow Rules

- Always run `git fetch origin --prune` before starting work.
- Always create a new branch from the updated `origin/stag`.
- Always open feature, fix, docs, and maintenance PRs into `stag`.
- Never open a direct PR to `prod`.
- Treat `prod` as promotion-only and update it only through the `stag -> prod` promotion PR.
- Before opening or updating a PR, verify that your branch is still based on current `origin/stag`.
- Stage files explicitly when the worktree contains unrelated changes.
- Never push directly to `stag` or `prod`.

## CI And Completion Rules

- Before saying the task is done, check the PR's required CI statuses.
- If CI fails, try to fix it once.
- If CI still fails after one reasonable fix attempt, stop and ask for help with the failure details.
- When reporting completion, include the branch name, PR URL, CI status, and any remaining blocker or risk.

## Promotion Rules

- Promotion PRs must always be `stag -> prod`.
- Promotion PRs must be merged with a merge commit.
- Do not use squash or rebase merges for promotions.

## Conflict Handling

- If a `stag -> prod` PR conflicts, do not create a direct branch or PR into `prod`.
- First inspect whether the conflict comes from broken promotion ancestry or from real content divergence.
- If branch protection or repository policy blocks the repair, stop and explain the exact maintainer action required.

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
