resource "aws_vpclattice_service_network" "this" {
  name      = "ec2-rds-service-network"
  auth_type = "AWS_IAM"
}

resource "aws_vpclattice_auth_policy" "service_network" {
  resource_identifier = aws_vpclattice_service_network.this.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "*"
        Effect    = "Allow"
        Principal = "*"
        Resource  = "*"
      }
    ]
  })
}
