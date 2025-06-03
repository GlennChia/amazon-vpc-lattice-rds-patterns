resource "aws_vpc_endpoint" "lattice_service_network" {
  vpc_endpoint_type   = "ServiceNetwork"
  service_network_arn = aws_vpclattice_service_network.this.arn
  vpc_id              = aws_vpc.ec2_client.id
  private_dns_enabled = true # Set to true to allow connection to RDS original address

  subnet_ids         = [aws_subnet.ec2_client_lattice_service_network_endpoint1.id, aws_subnet.ec2_client_lattice_service_network_endpoint2.id]
  security_group_ids = [aws_security_group.ec2_client_vpc_lattice_service_network_endpoint.id]

  tags = {
    Name = "lattice-service-network"
  }
}

resource "aws_security_group" "ec2_client_vpc_lattice_service_network_endpoint" {
  name        = "vpce-lattice-service-network-sg"
  description = "Security group for Lattice Service Network vpce"
  vpc_id      = aws_vpc.ec2_client.id

  tags = {
    Name = "vpce-lattice-service-network-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_client_vpc_lattice_service_network_endpoint_db_port_allow_ec2_client_sg" {
  security_group_id            = aws_security_group.ec2_client_vpc_lattice_service_network_endpoint.id
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ec2_client.id
  description                  = "TCP ${var.db_port} traffic from EC2 Client Sg"

  tags = {
    Name = "tcp-${var.db_port}-allow-${aws_security_group.ec2_client.id}"
  }
}
