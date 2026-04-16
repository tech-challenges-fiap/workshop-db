# workshop-db project context

## Purpose

`workshop-db` is the database infrastructure repository for the workshop split.
It should provision PostgreSQL resources and related baseline database
infrastructure over time.

## Current State

- Terraform composition for a managed PostgreSQL stack
- RDS, subnet group, security group, parameter group, and credentials secret
- CI validation, promotion policy, and environment-specific apply workflow

## Adjacent Repositories

- `workshop-app`: application logic and future database consumer
- `workshop-edge`: edge contracts, not database provisioning
- `workshop-platform`: shared platform infrastructure

## Important Workflow

- develop on `feature/*`
- merge into `stag`
- promote from `stag` to `prod`
- validate Terraform locally before proposing changes
