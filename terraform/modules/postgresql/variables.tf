variable "name_prefix" {
  description = "Canonical resource prefix."
  type        = string
}

variable "resource_suffix" {
  description = "Identifier suffix for the RDS instance."
  type        = string
}

variable "vpc_id" {
  description = "VPC identifier used by the database security group."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet identifiers used by the DB subnet group."
  type        = list(string)
}

variable "network_resource_name_suffix" {
  description = "Optional suffix for DB network resource names."
  type        = string
}

variable "allowed_security_group_ids" {
  description = "Security groups allowed to reach PostgreSQL."
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "CIDR ranges allowed to reach PostgreSQL."
  type        = list(string)
}

variable "db_name" {
  description = "Initial PostgreSQL database name."
  type        = string
}

variable "db_master_username" {
  description = "Master username."
  type        = string
}

variable "db_port" {
  description = "PostgreSQL port."
  type        = number
}

variable "engine_version" {
  description = "PostgreSQL engine version."
  type        = string
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
}

variable "allocated_storage" {
  description = "Initial allocated storage in GiB."
  type        = number
}

variable "max_allocated_storage" {
  description = "Maximum autoscaled storage in GiB."
  type        = number
}

variable "backup_retention_period" {
  description = "Automated backup retention in days."
  type        = number
}

variable "backup_window" {
  description = "Preferred backup window."
  type        = string
}

variable "maintenance_window" {
  description = "Preferred maintenance window."
  type        = string
}

variable "multi_az" {
  description = "Whether Multi-AZ is enabled."
  type        = bool
}

variable "deletion_protection" {
  description = "Whether deletion protection is enabled."
  type        = bool
}

variable "apply_immediately" {
  description = "Whether changes should apply immediately."
  type        = bool
}

variable "parameter_overrides" {
  description = "Additional PostgreSQL parameters."
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string, "pending-reboot")
  }))
}

variable "tags" {
  description = "Common AWS tags."
  type        = map(string)
}
