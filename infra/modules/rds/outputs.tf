output "db_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.postgres.endpoint
}

output "db_port" {
  description = "The database port"
  value       = aws_db_instance.postgres.port
}

output "db_name" {
  description = "The database name"
  value       = aws_db_instance.postgres.db_name
}

output "db_username" {
  description = "The master username"
  value       = aws_db_instance.postgres.username
  sensitive   = true
}

output "db_password" {
  description = "The master password"
  value       = aws_db_instance.postgres.password
  sensitive   = true
}
