locals {
  resource_configuration_child_name = "${aws_vpclattice_resource_configuration.rds.id}-${aws_db_instance.this.identifier}"
}

data "external" "resource_config_details" {
  depends_on = [aws_vpclattice_service_network_resource_association.rds]

  program = ["bash", "${path.module}/helper/get_dns_entry_domain_name.sh", local.resource_configuration_child_name, data.aws_region.current.name]
}
