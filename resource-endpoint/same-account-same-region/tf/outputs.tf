output "postgres_address_connect" {
  description = "Command to connect to postgres using the RDS DNS name"
  value       = <<EOT
psql \
   --host=${aws_db_instance.this.address} \
   --port=${var.db_port} \
   --username=${var.db_username} \
   --password \
   --dbname=${var.db_name}
EOT
}

output "resource_endpoint_address_connect" {
  description = "Command to connect to postgres using the Resource Endpoint DNS name"
  value       = <<EOT
psql \
   --host=${data.aws_vpc_endpoint_associations.resource_endpoint.associations[0].dns_entry[0].dns_name} \
   --port=${var.db_port} \
   --username=${var.db_username} \
   --password \
   --dbname=${var.db_name}
EOT
}

output "postgres_password" {
  description = "The password to connect to the RDS PostgreSQL Instance"
  value       = nonsensitive(aws_db_instance.this.password)
}