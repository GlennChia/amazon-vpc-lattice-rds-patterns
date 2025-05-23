resource "aws_instance" "ec2_client" {
  ami                  = data.aws_ssm_parameter.al_2023.value
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_client.name
  subnet_id            = aws_subnet.ec2_client_compute1.id

  vpc_security_group_ids = [aws_security_group.ec2_client.id]

  user_data = file(
    "./user-data/ec2-client.sh"
  )

  tags = {
    Name = "ec2-client"
  }
}

resource "aws_security_group" "ec2_client" {
  name        = "ec2-client-sg"
  description = "Security group for EC2 Client"
  vpc_id      = aws_vpc.ec2_client.id

  tags = {
    Name = "ec2-client-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "ec2_client_443_all" {
  security_group_id = aws_security_group.ec2_client.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "All 443"

  tags = {
    Name = "all-443"
  }
}

resource "aws_vpc_security_group_egress_rule" "ec2_client_db_port_ec2_client_resource_vpc_endpoint_sg" {
  security_group_id            = aws_security_group.ec2_client.id
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ec2_client_vpc_resource_endpoint.id
  description                  = "TCP ${var.db_port} traffic to EC2 Client Resource VPCE Sg"

  tags = {
    Name = "tcp-${var.db_port}-allow-${aws_security_group.ec2_client_vpc_resource_endpoint.id}"
  }
}

resource "aws_iam_role" "ec2_client" {
  name               = "ec2-client-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
}

resource "aws_iam_instance_profile" "ec2_client" {
  name = "ec2-client-profile"
  role = aws_iam_role.ec2_client.name
}

resource "aws_iam_role_policy_attachment" "ec2_client_ssm" {
  policy_arn = data.aws_iam_policy.amazon_ssm_managed_instance_core.arn
  role       = aws_iam_role.ec2_client.name
}
