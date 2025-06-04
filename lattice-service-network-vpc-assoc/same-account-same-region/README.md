# Amazon VPC Lattice Service Network VPC Association RDS pattern

These deployments steps are related to the blog: [Secure Cross-VPC Connections Part 3: EC2 to RDS with Lattice Service Network VPC Association]()

# 1. Prerequisites

- An AWS account with an IAM user with the appropriate permissions
- Terraform installed
- Refer to the [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#environment-variables) on instructions on how you can configure your AWS credentials for use with Terraform

# 2. Deployment steps

Step 1: Copy [./tf/terraform.tfvars.example](./tf/terraform.tfvars.example) to `./tf/terraform.tfvars` and replace the values accordingly. For example if want to deploy resources into `ap-southeast-1`, change the `region` value from `us-east-1` to `ap-southeast-1`

Step 2: In [tf](./tf/) run `terraform init`

Step 3: While in [tf](./tf/) run `terraform apply`. Review the plan output and approve the apply. The apply outputs commands that can be used to connect to the RDS instance using its regular endpoint or the VPC Lattice Resource Endpoint DNS Name. The output also displays the database password used for the connection.

> [!CAUTION]
> In a live environment it is not good practice to output the database password! The database password is output in this repo purely for demo purposes, such that readers can easily test connections to RDS. This also helps to reduce the cost of running this demo since [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/) is not used to store the secret.

> [!NOTE]
> In this demo, the [random_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) Terraform resource is used to generate a database password in [./tf/2-rds.tf](./tf/2-rds.tf). In a live environment you would likely use some other means to generate the password. For example, using [Terraform Ephemeral Resources](https://developer.hashicorp.com/terraform/language/resources/ephemeral) or by using a secrets management tool like [HashiCorp Vault](https://www.hashicorp.com/en/products/vault) or [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/).