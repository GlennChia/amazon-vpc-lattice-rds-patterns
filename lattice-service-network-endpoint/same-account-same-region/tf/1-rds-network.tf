resource "aws_vpc" "rds" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "rds-vpc"
  }
}

resource "aws_subnet" "rds_isolated1" {
  vpc_id            = aws_vpc.rds.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = local.matching_azs[0]

  tags = {
    Name = "rds-isolated-subnet-1"
  }
}

resource "aws_subnet" "rds_isolated2" {
  vpc_id            = aws_vpc.rds.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = local.matching_azs[1]

  tags = {
    Name = "rds-isolated-subnet-2"
  }
}

resource "aws_subnet" "rds_resource_gateway1" {
  vpc_id            = aws_vpc.rds.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = local.matching_azs[0]

  tags = {
    Name = "rds-resource-gateway-1"
  }
}

resource "aws_subnet" "rds_resource_gateway2" {
  vpc_id            = aws_vpc.rds.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = local.matching_azs[1]

  tags = {
    Name = "rds-resource-gateway-2"
  }
}

resource "aws_route_table" "isolated" {
  vpc_id = aws_vpc.rds.id

  tags = {
    Name = "rds-isolated-rtb"
  }
}

resource "aws_route_table_association" "rds_isolated_rtb_isolated1_subnet" {
  subnet_id      = aws_subnet.rds_isolated1.id
  route_table_id = aws_route_table.isolated.id
}

resource "aws_route_table_association" "rds_isolated_rtb_isolated2_subnet" {
  subnet_id      = aws_subnet.rds_isolated2.id
  route_table_id = aws_route_table.isolated.id
}

resource "aws_route_table_association" "rds_isolated_rtb_resource_gateway1_subnet" {
  subnet_id      = aws_subnet.rds_resource_gateway1.id
  route_table_id = aws_route_table.isolated.id
}

resource "aws_route_table_association" "rds_isolated_rtb_resource_gateway2_subnet" {
  subnet_id      = aws_subnet.rds_resource_gateway2.id
  route_table_id = aws_route_table.isolated.id
}
