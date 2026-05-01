output "name_prefix" {
  description = "Default prefix for repository resources."
  value       = local.name_prefix
}

output "db_host" {
  description = "RDS endpoint hostname."
  value       = module.postgresql.db_host
}

output "db_port" {
  description = "RDS endpoint port."
  value       = module.postgresql.db_port
}

output "db_name" {
  description = "Initial PostgreSQL database name."
  value       = module.postgresql.db_name
}

output "db_secret_arn" {
  description = "Secrets Manager ARN containing the database credentials."
  value       = module.postgresql.db_secret_arn
}

output "db_security_group_id" {
  description = "Security group attached to the database."
  value       = module.postgresql.db_security_group_id
}

output "db_instance_identifier" {
  description = "Canonical RDS instance identifier."
  value       = module.postgresql.db_instance_identifier
}

output "db_subnet_group_name" {
  description = "DB subnet group name."
  value       = module.postgresql.db_subnet_group_name
}

output "db_parameter_group_name" {
  description = "PostgreSQL parameter group name."
  value       = module.postgresql.db_parameter_group_name
}
