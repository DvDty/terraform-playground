output "alb_dns_name" {
  value       = module.webserver.alb_dns_name
  description = "The domain name of the load balancer"
}

output "db_address" {
  value       = module.database.address
  description = "Connect to the database at this endpoint"
}

output "db_port" {
  value       = module.database.port
  description = "The port the database is listening on"
}

output "db_username" {
  value     = module.database.username
  sensitive = true
}

output "db_password" {
  value     = module.database.password
  sensitive = true
}
