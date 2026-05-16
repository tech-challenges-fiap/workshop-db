locals {
  credentials_secret_name = "${var.name_prefix}-credentials"
  network_name_suffix     = var.network_resource_name_suffix == "" ? "" : "-${var.network_resource_name_suffix}"
  db_security_group_name  = "${var.name_prefix}-db${local.network_name_suffix}"
  db_subnet_group_name    = "${var.name_prefix}-subnets${local.network_name_suffix}"
  parameter_group_family  = "postgres${split(".", var.engine_version)[0]}"
  parameter_group_name    = "${var.name_prefix}-postgres"
  postgres_identifier     = "${var.name_prefix}-${var.resource_suffix}"

  default_parameters = [
    {
      apply_method = "pending-reboot"
      name         = "rds.force_ssl"
      value        = "1"
    },
    {
      apply_method = "immediate"
      name         = "log_connections"
      value        = "1"
    },
    {
      apply_method = "immediate"
      name         = "log_disconnections"
      value        = "1"
    }
  ]
}

resource "random_password" "db_master" {
  length           = 24
  override_special = "!#$%&*()-_=+[]{}<>:?"
  special          = true
}

resource "aws_db_subnet_group" "postgres" {
  name        = local.db_subnet_group_name
  description = "Private subnets for ${local.postgres_identifier}."
  subnet_ids  = var.private_subnet_ids
  tags        = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "db" {
  description = "Connectivity boundary for ${local.postgres_identifier}."
  name        = local.db_security_group_name
  vpc_id      = var.vpc_id
  tags        = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "from_security_groups" {
  for_each = toset(var.allowed_security_group_ids)

  description                  = "PostgreSQL access from ${each.value}."
  from_port                    = var.db_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = each.value
  security_group_id            = aws_security_group.db.id
  to_port                      = var.db_port
}

resource "aws_vpc_security_group_ingress_rule" "from_cidrs" {
  for_each = toset(var.allowed_cidr_blocks)

  cidr_ipv4         = each.value
  description       = "PostgreSQL access from ${each.value}."
  from_port         = var.db_port
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.db.id
  to_port           = var.db_port
}

resource "aws_vpc_security_group_egress_rule" "all" {
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  security_group_id = aws_security_group.db.id
}

resource "aws_db_parameter_group" "postgres" {
  family = local.parameter_group_family
  name   = local.parameter_group_name
  tags   = var.tags

  dynamic "parameter" {
    for_each = concat(local.default_parameters, var.parameter_overrides)

    content {
      apply_method = parameter.value.apply_method
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage               = var.allocated_storage
  apply_immediately               = var.apply_immediately
  auto_minor_version_upgrade      = true
  backup_retention_period         = var.backup_retention_period
  backup_window                   = var.backup_window
  copy_tags_to_snapshot           = true
  db_name                         = var.db_name
  db_subnet_group_name            = aws_db_subnet_group.postgres.name
  delete_automated_backups        = false
  deletion_protection             = var.deletion_protection
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  engine                          = "postgres"
  engine_version                  = var.engine_version
  final_snapshot_identifier       = var.deletion_protection ? "${local.postgres_identifier}-final" : null
  identifier                      = local.postgres_identifier
  instance_class                  = var.instance_class
  maintenance_window              = var.maintenance_window
  max_allocated_storage           = var.max_allocated_storage
  multi_az                        = var.multi_az
  parameter_group_name            = aws_db_parameter_group.postgres.name
  password                        = random_password.db_master.result
  port                            = var.db_port
  publicly_accessible             = false
  skip_final_snapshot             = !var.deletion_protection
  storage_encrypted               = true
  storage_type                    = "gp3"
  username                        = var.db_master_username
  vpc_security_group_ids          = [aws_security_group.db.id]
}

resource "aws_secretsmanager_secret" "db_credentials" {
  description             = "Credentials for ${local.postgres_identifier}."
  name                    = local.credentials_secret_name
  recovery_window_in_days = 0
  tags                    = var.tags
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    dbname   = var.db_name
    engine   = "postgres"
    host     = aws_db_instance.postgres.address
    password = random_password.db_master.result
    port     = var.db_port
    username = var.db_master_username
  })
}
