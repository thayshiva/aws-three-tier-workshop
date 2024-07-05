data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}


# Create VPC using Terraform Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  # Details
  name            = "${var.name}-${local.name}"
  cidr            = var.cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  database_subnets                   = var.database_subnets
  create_database_subnet_group       = var.create_database_subnet_group
  create_database_subnet_route_table = var.create_database_subnet_route_table
  # create_database_internet_gateway_route = true
  # create_database_nat_gateway_route = true

  # NAT Gateways - Outbound Communication
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  # DNS Parameters in VPC
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Additional tags for the VPC
  tags     = local.tags
  vpc_tags = local.tags

  # Additional tags
  # Additional tags for the public subnets
  public_subnet_tags = {
    Name = "Public-Subnet-AZ"
  }
  # Additional tags for the private subnets
  private_subnet_tags = {
    Name = "Private-Subnet-AZ"
  }
  # Additional tags for the database subnets
  database_subnet_tags = {
    Name = "Private-DB-Subnet"
  }
  # Instances launched into the Public subnet should be assigned a public IP address. Specify true to indicate that instances launched into the subnet should be assigned a public IP address
  map_public_ip_on_launch = true

  default_security_group_ingress = [{
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "External load balancer security group"
      cidr_blocks = "${chomp(data.http.myip.response_body)}/32"
    }]

  default_security_group_egress = []

  default_security_group_name = "internet-facing-lb-sg"

}
