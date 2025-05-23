data "aws_vpc_endpoint_associations" "resource_endpoint" {
  vpc_endpoint_id = aws_vpc_endpoint.ec2_client_resource.id
}