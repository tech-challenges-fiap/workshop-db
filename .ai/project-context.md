# workshop-db project context

## Purpose

`workshop-db` is the database infrastructure repository. It provisions
PostgreSQL resources and related database infrastructure.

## Current State

- Terraform composition for a managed PostgreSQL stack
- RDS, subnet group, security group, parameter group, and credentials secret
- CI validation, promotion policy, and environment-specific apply workflow

## Operating Constraint

- keep the repository focused on database provisioning
- treat schema, seeds, and queries as out of scope unless ownership changes
- document only resources and interfaces that Terraform actually defines

## Important Workflow

- develop on `feature/*`
- merge into `stag`
- promote from `stag` to `prod`
- validate Terraform locally before proposing changes
