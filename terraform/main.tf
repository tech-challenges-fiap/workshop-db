locals {
  name_prefix = "${var.project}-${var.repo}-${var.environment}"

  environment_defaults = {
    stag = {
      allocated_storage       = 20
      backup_retention_period = 7
      backup_window           = "04:00-05:00"
      db_instance_class       = "db.t4g.micro"
      deletion_protection     = false
      maintenance_window      = "Mon:03:00-Mon:04:00"
      max_allocated_storage   = 100
      multi_az                = false
    }
    prod = {
      allocated_storage       = 50
      backup_retention_period = 14
      backup_window           = "03:00-04:00"
      db_instance_class       = "db.t4g.small"
      deletion_protection     = true
      maintenance_window      = "Sun:02:00-Sun:03:00"
      max_allocated_storage   = 200
      multi_az                = true
    }
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = var.project
    Repository  = "workshop-${var.repo}"
  }
}

module "postgresql" {
  source = "./modules/postgresql"

  allocated_storage          = coalesce(var.allocated_storage, local.environment_defaults[var.environment].allocated_storage)
  allowed_cidr_blocks        = var.allowed_cidr_blocks
  allowed_security_group_ids = var.allowed_security_group_ids
  apply_immediately          = var.apply_immediately
  backup_retention_period    = coalesce(var.backup_retention_period, local.environment_defaults[var.environment].backup_retention_period)
  backup_window              = coalesce(var.backup_window, local.environment_defaults[var.environment].backup_window)
  db_master_username         = var.db_master_username
  db_name                    = var.db_name
  db_port                    = var.db_port
  deletion_protection        = coalesce(var.deletion_protection, local.environment_defaults[var.environment].deletion_protection)
  engine_version             = var.engine_version
  instance_class             = coalesce(var.db_instance_class, local.environment_defaults[var.environment].db_instance_class)
  maintenance_window         = coalesce(var.maintenance_window, local.environment_defaults[var.environment].maintenance_window)
  max_allocated_storage      = coalesce(var.max_allocated_storage, local.environment_defaults[var.environment].max_allocated_storage)
  multi_az                   = coalesce(var.multi_az, local.environment_defaults[var.environment].multi_az)
  name_prefix                = local.name_prefix
  parameter_overrides        = var.parameter_overrides
  private_subnet_ids         = var.private_subnet_ids
  resource_suffix            = var.resource_suffix
  tags                       = local.tags
  vpc_id                     = var.vpc_id
}
