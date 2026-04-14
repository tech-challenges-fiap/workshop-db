output "name_prefix" {
  description = "Default prefix for repository resources."
  value       = local.name_prefix
}

output "postgres_identifier" {
  description = "Canonical reference name for the main instance."
  value       = local.postgres_identifier
}
