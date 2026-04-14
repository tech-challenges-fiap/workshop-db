locals {
  name_prefix         = "${var.project}-${var.repo}-${var.environment}"
  postgres_identifier = "${local.name_prefix}-${var.resource_suffix}"
}

resource "terraform_data" "baseline" {
  input = {
    name_prefix         = local.name_prefix
    postgres_identifier = local.postgres_identifier
  }
}

