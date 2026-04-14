# workshop-db

Managed PostgreSQL infrastructure for the `workshop` project.

## Purpose

This repository owns PostgreSQL provisioning and baseline configuration in AWS.
It does not contain migrations, seeds, or business logic.

## Main stack

- Terraform
- AWS
- PostgreSQL

## Deployment strategy

- `feature/* -> stag`: Pull Request with Terraform validation and deployment to `staging`
- `stag -> prod`: promotion Pull Request with deployment to `production`
- AWS authentication through OIDC, without static keys in the repository

## Local documentation

- [docs/README.md](docs/README.md)
