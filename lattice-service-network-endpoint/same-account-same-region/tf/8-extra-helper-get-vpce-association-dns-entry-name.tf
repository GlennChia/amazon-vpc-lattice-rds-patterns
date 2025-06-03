data "aws_vpc_endpoint_associations" "lattice_service_network_vpc_endpoint_associations" {
  vpc_endpoint_id = aws_vpc_endpoint.lattice_service_network.id

  depends_on = [
    aws_vpclattice_service_network_resource_association.rds
  ]
}