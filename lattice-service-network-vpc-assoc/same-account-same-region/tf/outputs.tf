output "lattice_service_address_connect" {
  description = "Command to connect to RDS postgres using the Lattice Service DNS name"
  value       = <<EOT
psql \
   --host=${data.external.resource_config_details.result["domain_name"]} \
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
