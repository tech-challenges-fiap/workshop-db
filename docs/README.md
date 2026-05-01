# workshop-db docs

## Ownership

- scope: managed PostgreSQL, baseline configuration, and credentials
- out of scope: migrations, evolutionary schema, seeds, and application domain logic

## Repository structure

- `terraform/`: reusable PostgreSQL module and root environment composition
- `terraform/environments/stag/`: staging backend and tfvars examples
- `terraform/environments/prod/`: production backend and tfvars examples
- `.github/`: templates, ownership, and minimum automation

## Environments

- branch `stag` deploys into `staging`
- branch `prod` deploys into `production`
- AWS suffixes: `stag` and `prod`

## GitHub environment variables

Configure these variables separately in the `staging` and `production` GitHub environments:

- `AWS_REGION`
- `AWS_ROLE_ARN`
- `TF_STATE_BUCKET`
- `TF_STATE_KEY`
- `DB_VPC_ID`
- `DB_PRIVATE_SUBNET_IDS`
- `DB_ALLOWED_SECURITY_GROUP_IDS`
- `DB_ALLOWED_CIDR_BLOCKS`
- `DB_NAME`
- `DB_MASTER_USERNAME`

`DB_PRIVATE_SUBNET_IDS`, `DB_ALLOWED_SECURITY_GROUP_IDS`, and `DB_ALLOWED_CIDR_BLOCKS` must be JSON arrays, for example `["subnet-0123","subnet-0456"]`.
`DB_ALLOWED_SECURITY_GROUP_IDS`, `DB_ALLOWED_CIDR_BLOCKS`, `DB_NAME`, and `DB_MASTER_USERNAME` can be omitted when the Terraform defaults are acceptable.

## Terraform outputs

Downstream repositories consume the database contract through these outputs:

- `db_host`
- `db_port`
- `db_name`
- `db_secret_arn`
- `db_security_group_id`

Additional operational outputs:

- `db_instance_identifier`
- `db_subnet_group_name`
- `db_parameter_group_name`

## Out of scope

This repository must not contain SQL migrations, Drizzle schema, seeds, queries, or application domain rules.
