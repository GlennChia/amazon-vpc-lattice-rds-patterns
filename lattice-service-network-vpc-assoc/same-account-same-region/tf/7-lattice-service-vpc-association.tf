resource "aws_vpclattice_service_network_vpc_association" "ec2_client" {
  vpc_identifier             = aws_vpc.ec2_client.id
  service_network_identifier = aws_vpclattice_service_network.this.id
  security_group_ids         = [aws_security_group.ec2_client_vpc_lattice_service_network_vpc_assoc.id]
}

resource "aws_security_group" "ec2_client_vpc_lattice_service_network_vpc_assoc" {
  name        = "ec2-client-lattice-service-network-vpc-assoc-sg"
  description = "Security group for EC2 Client Lattice Service Network VPC Association"
  vpc_id      = aws_vpc.ec2_client.id

  tags = {
    Name = "ec2-client-lattice-service-network-vpc-assoc-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_client_vpc_lattice_service_network_vpc_assoc_db_port_allow_ec2_client_sg" {
  security_group_id            = aws_security_group.ec2_client_vpc_lattice_service_network_vpc_assoc.id
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ec2_client.id
  description                  = "TCP ${var.db_port} traffic from EC2 Client Sg"

  tags = {
    Name = "tcp-${var.db_port}-allow-${aws_security_group.ec2_client.id}"
  }
}
