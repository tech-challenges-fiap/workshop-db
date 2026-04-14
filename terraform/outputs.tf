output "name_prefix" {
  description = "Prefixo padrao para os recursos do repositorio."
  value       = local.name_prefix
}

output "postgres_identifier" {
  description = "Nome canonico de referencia para a instancia principal."
  value       = local.postgres_identifier
}

