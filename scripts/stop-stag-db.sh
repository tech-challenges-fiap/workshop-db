#!/usr/bin/env bash
set -euo pipefail

AWS_REGION="${AWS_REGION:-us-east-1}"
DB_INSTANCE_IDENTIFIER="${DB_INSTANCE_IDENTIFIER:-workshop-db-stag-postgres}"

if ! command -v aws >/dev/null 2>&1; then
  echo "aws CLI is required." >&2
  exit 1
fi

status="$(
  aws rds describe-db-instances \
    --region "${AWS_REGION}" \
    --db-instance-identifier "${DB_INSTANCE_IDENTIFIER}" \
    --query 'DBInstances[0].DBInstanceStatus' \
    --output text
)"

case "${status}" in
  available)
    aws rds stop-db-instance \
      --region "${AWS_REGION}" \
      --db-instance-identifier "${DB_INSTANCE_IDENTIFIER}" >/dev/null
    echo "Stop requested for ${DB_INSTANCE_IDENTIFIER} in ${AWS_REGION}."
    ;;
  stopped)
    echo "${DB_INSTANCE_IDENTIFIER} is already stopped in ${AWS_REGION}."
    ;;
  stopping)
    echo "${DB_INSTANCE_IDENTIFIER} is already stopping in ${AWS_REGION}."
    ;;
  *)
    echo "${DB_INSTANCE_IDENTIFIER} is ${status}; stop is only requested from available state." >&2
    exit 1
    ;;
esac
