resource "random_password" "password" {
  length  = 32
  special = false
}

resource "aws_db_instance" "this" {
  allocated_storage      = 20
  storage_type           = "gp3"
  engine                 = "postgres"
  engine_version         = "16.6"
  instance_class         = var.db_instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = random_password.password.result
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.this.name
  port                   = var.db_port
}

resource "aws_db_subnet_group" "this" {
  name       = "rds-db-subnet-group"
  subnet_ids = [aws_subnet.rds_isolated1.id, aws_subnet.rds_isolated2.id]

  tags = {
    Name = "rds-db-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "RDS Postgres SG"
  vpc_id      = aws_vpc.rds.id

  tags = {
    Name = "rds-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_db_port_rds_resource_gateway_sg" {
  security_group_id            = aws_security_group.rds.id
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.rds_resource_gateway.id
  description                  = "TCP ${var.db_port} traffic from RDS Resource Gateway Sg"

  tags = {
    Name = "tcp-${var.db_port}-allow-${aws_security_group.rds_resource_gateway.id}"
  }
}
