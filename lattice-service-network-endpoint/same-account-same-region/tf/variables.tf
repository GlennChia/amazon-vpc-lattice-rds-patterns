variable "region" {
  description = "Region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "interface_endpoints" {
  description = "The interface endpoints to create for the EC2 Client VPC to enable Session Manager Connections"
  type        = list(string)
  default     = ["ssm", "ec2messages", "ssmmessages"]
}

variable "db_name" {
  description = "RDS DB Name"
  type        = string
  default     = "demo"
}

variable "db_username" {
  description = "RDS DB Username"
  type        = string
  default     = "demoadmin"
}

variable "db_instance_class" {
  description = "RDS DB Instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "db_port" {
  description = "RDS DB PostgreSQL Port"
  type        = number
  default     = 5432
}

locals {
  valid_instance_types = ["t2.micro", "t3.medium"]
}

variable "instance_type" {
  description = "The instance type for the EC2 instance that runs the sample client and server"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = contains(local.valid_instance_types, var.instance_type)
    error_message = "Valid values for var: instance_type are (${jsonencode(local.valid_instance_types)})."
  }
}
