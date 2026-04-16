# AI Contributing Guide

## Checklist

- confirm the requested change belongs in `workshop-db`
- inspect `terraform/` and current docs before editing
- keep docs in English
- do not claim resources are provisioned unless Terraform defines them
- run the relevant Terraform validation commands for the touched area
- update `README.md` or `docs/` if variables, outputs, commands, or workflows changed
- preserve the boundary that migrations, schema, and seeds stay outside this repository

## Review Focus

- repository boundary correctness
- Terraform contract accuracy
- environment naming consistency
- no accidental application or platform responsibility creep
