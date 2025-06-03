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

output "lattice_service_network_endpoint_address_connect" {
  description = "Command to connect to postgres using the Lattice Service Network Endpoint DNS name"
  value       = <<EOT
psql \
   --host=${try(data.aws_vpc_endpoint_associations.lattice_service_network_vpc_endpoint_associations.associations[0].dns_entry[0].dns_name, "")} \
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