output "db_host" {
  description = "RDS endpoint hostname."
  value       = aws_db_instance.postgres.address
}

output "db_port" {
  description = "RDS endpoint port."
  value       = aws_db_instance.postgres.port
}

output "db_name" {
  description = "Initial PostgreSQL database name."
  value       = aws_db_instance.postgres.db_name
}

output "db_secret_arn" {
  description = "Secrets Manager ARN with database credentials."
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "db_security_group_id" {
  description = "Security group attached to the RDS instance."
  value       = aws_security_group.db.id
}

output "db_instance_identifier" {
  description = "RDS instance identifier."
  value       = aws_db_instance.postgres.identifier
}

output "db_subnet_group_name" {
  description = "DB subnet group name."
  value       = aws_db_subnet_group.postgres.name
}

output "db_parameter_group_name" {
  description = "Parameter group name."
  value       = aws_db_parameter_group.postgres.name
}
