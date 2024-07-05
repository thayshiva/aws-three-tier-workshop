# TODO: remove boiler plate code
# data "http" "myipv4" {
#   url = "https://ipv4.icanhazip.com"
# }

# module "web_server_sg" {
#   source = "terraform-aws-modules/security-group/aws//modules/http-80"

#   name        = "web-server"
#   description = "Security group for web-server with HTTP ports open within VPC"
#   vpc_id      = module.vpc.vpc_id

#   ingress_cidr_blocks = [data.http.myipv4]
# }

# First security group
resource "aws_security_group" "internet_facing_lb_sg" {
  name        = "internet_facing_lb_sg"
  description = "External Load Balancer Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "External LB SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ext_lb" {
  security_group_id = aws_security_group.internet_facing_lb_sg.id
  cidr_ipv4         = var.cidr_ipv4
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# second security group
resource "aws_security_group" "web_server_sg" {
  name        = "WebTierSG"
  description = "SG for Web Tier"
  vpc_id      = var.vpc_id

  tags = {
    Name = "web tier"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.web_server_sg.id
  cidr_ipv4         = var.cidr_ipv4
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


resource "aws_vpc_security_group_ingress_rule" "allow_http_inter_sg" {
  security_group_id            = aws_security_group.web_server_sg.id
  referenced_security_group_id = aws_security_group.internet_facing_lb_sg.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

# third security group
resource "aws_security_group" "internal_lb_sg" {
  name        = "internal_lb_sg"
  description = "Internal Load Balancer Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "Internal LB SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_int_lb" {
  security_group_id            = aws_security_group.internal_lb_sg.id
  referenced_security_group_id = aws_security_group.web_server_sg.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

# fourth security group
resource "aws_security_group" "privateinstances_sg" {
  name        = "privateinstances_sg"
  description = "Private Instances Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "Private INS SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_instances_ingress_1" {
  security_group_id            = aws_security_group.privateinstances_sg.id
  referenced_security_group_id = aws_security_group.internal_lb_sg.id
  from_port                    = 4000
  ip_protocol                  = "tcp"
  to_port                      = 4000
}

resource "aws_vpc_security_group_ingress_rule" "private_instances_ingress_2" {
  security_group_id = aws_security_group.privateinstances_sg.id
  cidr_ipv4         = var.cidr_ipv4
  from_port         = 4000
  ip_protocol       = "tcp"
  to_port           = 4000
}

# fifth security group
resource "aws_security_group" "db_sg" {
  name        = "DB_sg"
  description = "DB Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "DB SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "db_ingress" {
  security_group_id            = aws_security_group.db_sg.id
  referenced_security_group_id = aws_security_group.privateinstances_sg.id
  from_port                    = 3306
  ip_protocol                  = "tcp"
  to_port                      = 3306
}
