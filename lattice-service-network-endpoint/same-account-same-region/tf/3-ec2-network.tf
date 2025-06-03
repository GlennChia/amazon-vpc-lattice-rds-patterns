resource "aws_vpc" "ec2_client" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ec2-client-vpc"
  }
}

resource "aws_subnet" "ec2_client_lattice_service_network_endpoint1" {
  vpc_id            = aws_vpc.ec2_client.id
  cidr_block        = "10.1.0.0/24"
  availability_zone = local.matching_azs[0]

  tags = {
    Name = "ec2-client-lattice-service-network-endpoint1"
  }
}

resource "aws_subnet" "ec2_client_lattice_service_network_endpoint2" {
  vpc_id            = aws_vpc.ec2_client.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = local.matching_azs[1]

  tags = {
    Name = "ec2-client-lattice-service-network-endpoint2"
  }
}

resource "aws_subnet" "ec2_client_compute1" {
  vpc_id            = aws_vpc.ec2_client.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = local.matching_azs[0]

  tags = {
    Name = "ec2-client-compute1"
  }
}

resource "aws_subnet" "ec2_client_compute2" {
  vpc_id            = aws_vpc.ec2_client.id
  cidr_block        = "10.1.4.0/24"
  availability_zone = local.matching_azs[1]

  tags = {
    Name = "ec2-client-compute2"
  }
}

resource "aws_subnet" "ec2_client_interface_endpoint1" {
  vpc_id            = aws_vpc.ec2_client.id
  cidr_block        = "10.1.6.0/24"
  availability_zone = local.matching_azs[0]

  tags = {
    Name = "ec2-client-interface1"
  }
}

resource "aws_subnet" "ec2_client_interface_endpoint2" {
  vpc_id            = aws_vpc.ec2_client.id
  cidr_block        = "10.1.7.0/24"
  availability_zone = local.matching_azs[1]

  tags = {
    Name = "ec2-client-interface2"
  }
}

resource "aws_route_table" "ec2_client_isolated" {
  vpc_id = aws_vpc.ec2_client.id

  tags = {
    Name = "ec2-client-isolated-rtb"
  }
}

resource "aws_route_table_association" "ec2_client_lattice_service_network_endpoint1" {
  subnet_id      = aws_subnet.ec2_client_lattice_service_network_endpoint1.id
  route_table_id = aws_route_table.ec2_client_isolated.id
}

resource "aws_route_table_association" "ec2_client_lattice_service_network_endpoint2" {
  subnet_id      = aws_subnet.ec2_client_lattice_service_network_endpoint2.id
  route_table_id = aws_route_table.ec2_client_isolated.id
}

resource "aws_route_table_association" "ec2_client_compute1" {
  subnet_id      = aws_subnet.ec2_client_compute1.id
  route_table_id = aws_route_table.ec2_client_isolated.id
}

resource "aws_route_table_association" "ec2_client_compute2" {
  subnet_id      = aws_subnet.ec2_client_compute2.id
  route_table_id = aws_route_table.ec2_client_isolated.id
}

resource "aws_route_table_association" "ec2_client_interface_endpoint1" {
  subnet_id      = aws_subnet.ec2_client_interface_endpoint1.id
  route_table_id = aws_route_table.ec2_client_isolated.id
}

resource "aws_route_table_association" "ec2_client_interface_endpoint2" {
  subnet_id      = aws_subnet.ec2_client_interface_endpoint2.id
  route_table_id = aws_route_table.ec2_client_isolated.id
}

resource "aws_vpc_endpoint" "ec2_client_interface" {
  for_each = { for v in var.interface_endpoints : v => v }

  vpc_id            = aws_vpc.ec2_client.id
  service_name      = "${data.aws_partition.current.reverse_dns_prefix}.${data.aws_region.current.id}.${each.key}"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.ec2_client_session_manager_interface_endpoint.id]

  subnet_ids = [aws_subnet.ec2_client_interface_endpoint1.id, aws_subnet.ec2_client_interface_endpoint2.id]

  private_dns_enabled = true

  tags = {
    Name = each.key
  }
}

resource "aws_vpc_endpoint" "ec2_client_s3_gateway" {
  vpc_id            = aws_vpc.ec2_client.id
  service_name      = "${data.aws_partition.current.reverse_dns_prefix}.${data.aws_region.current.id}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_route_table.ec2_client_isolated.id]

  tags = {
    Name = "s3"
  }
}

resource "aws_security_group" "ec2_client_session_manager_interface_endpoint" {
  name        = "ec2-client-session-manager-interface-endpoint-sg"
  description = "EC2 Client VPC Interface Endpoint SG for VPCEs required for session manager"
  vpc_id      = aws_vpc.ec2_client.id

  tags = {
    Name = "ec2-client-session-manager-interface-endpoint-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_client_session_manager_interface_endpoint_443" {
  security_group_id = aws_security_group.ec2_client_session_manager_interface_endpoint.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = aws_vpc.ec2_client.cidr_block
  description       = "HTTPs 443 traffic from the VPC"

  tags = {
    Name = "https-443-${aws_vpc.ec2_client.cidr_block}"
  }
}