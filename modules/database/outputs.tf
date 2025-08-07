output "address" {
  value       = aws_db_instance.example.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = aws_db_instance.example.port
  description = "The port the database is listening on"
}

output "username" {
  value       = random_string.username.result
  sensitive   = true
  description = "The username for the database"
}

output "password" {
  value       = random_password.password.result
  sensitive   = true
  description = "The password for the database user"
}
