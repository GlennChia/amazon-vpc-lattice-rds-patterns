resource "aws_vpclattice_resource_gateway" "rds" {
  name               = "rds"
  vpc_id             = aws_vpc.rds.id
  security_group_ids = [aws_security_group.rds_resource_gateway.id]
  subnet_ids         = [aws_subnet.rds_resource_gateway1.id, aws_subnet.rds_resource_gateway2.id]
}

resource "aws_vpclattice_resource_configuration" "rds" {
  name                        = "rds"
  resource_gateway_identifier = aws_vpclattice_resource_gateway.rds.id
  type                        = "ARN"

  resource_configuration_definition {
    arn_resource {
      arn = aws_db_instance.this.arn
    }
  }
}

resource "aws_security_group" "rds_resource_gateway" {
  name        = "rds-vpc-resource-gateway-sg"
  description = "Security group for RDS VPC Resource Gateway"
  vpc_id      = aws_vpc.rds.id

  tags = {
    Name = "rds-vpc-resource-gateway-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "rds_resource_gateway_db_port_rds_sg" {
  security_group_id            = aws_security_group.rds_resource_gateway.id
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.rds.id
  description                  = "TCP ${var.db_port} traffic to RDS Sg"

  tags = {
    Name = "tcp-${var.db_port}-allow-${aws_security_group.rds.id}"
  }
}
