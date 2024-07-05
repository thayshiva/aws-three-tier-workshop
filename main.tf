module "vpc" {
  source = "./modules/vpc"
}

module "security_group" {

  source    = "./modules/sg"
  vpc_id    = module.vpc.vpc_id
  cidr_ipv4 = module.vpc.my_ip_addr
}

module "db_mysql" {

  source    = "./modules/db"
  private_subnets = module.vpc.private_subnets
  sg_db = module.security_group.db_sg
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "default_sg" {
  value = module.vpc.security_group_id
}

output "my_ip_addr" {
  value = module.vpc.my_ip_addr
}

output "private_subnets" {
  value = module.vpc.private_subnets
}
