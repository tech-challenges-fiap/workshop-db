#!/usr/bin/env bash
set -euo pipefail

DB_INSTANCE_IDENTIFIER="${DB_INSTANCE_IDENTIFIER:-workshop-db-prod-postgres}"
export DB_INSTANCE_IDENTIFIER

"$(dirname "${BASH_SOURCE[0]}")/stop-db-instance.sh"
