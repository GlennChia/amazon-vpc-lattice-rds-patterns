resource "aws_vpc_endpoint" "ec2_client_resource" {
  vpc_endpoint_type          = "Resource"
  resource_configuration_arn = aws_vpclattice_resource_configuration.rds.arn
  vpc_id                     = aws_vpc.ec2_client.id
  private_dns_enabled        = true # Set to true to allow connection to RDS original address

  subnet_ids         = [aws_subnet.ec2_client_resource_endpoint1.id, aws_subnet.ec2_client_resource_endpoint2.id]
  security_group_ids = [aws_security_group.ec2_client_vpc_resource_endpoint.id]

  tags = {
    Name = "ec2-client-rds-resource"
  }
}

resource "aws_security_group" "ec2_client_vpc_resource_endpoint" {
  name        = "ec2-client-vpc-resource-endpoint-sg"
  description = "Security group for EC2 Client VPC Resource Endpoint"
  vpc_id      = aws_vpc.ec2_client.id

  tags = {
    Name = "ec2-client-vpc-resource-endpoint-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_client_vpc_resource_endpoint_db_port_allow_ec2_client_sg" {
  security_group_id            = aws_security_group.ec2_client_vpc_resource_endpoint.id
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ec2_client.id
  description                  = "TCP ${var.db_port} traffic from EC2 Client Sg"

  tags = {
    Name = "tcp-${var.db_port}-allow-${aws_security_group.ec2_client.id}"
  }
}