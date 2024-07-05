# Generic Variables
region      = "eu-west-1"
environment = "prod"
owners      = "aws"


# VPC Variables
name                               = "vpc-terraform" # Overridning the name defined in variable file
cidr                               = "10.0.0.0/16"
azs                                = ["eu-west-1b", "eu-west-1c"]
public_subnets                     = ["10.0.0.0/24", "10.0.3.0/24"]
private_subnets                    = ["10.0.1.0/24", "10.0.4.0/24"]
database_subnets                   = ["10.0.2.0/24", "10.0.5.0/24"]
create_database_subnet_group       = true
create_database_subnet_route_table = true
enable_nat_gateway                 = true
single_nat_gateway                 = true
