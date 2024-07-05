# resource "aws_route_table" "aws_three_tier_route_table" {
#   vpc_id = aws_vpc.example.id

#   route {
#     cidr_block = "10.0.1.0/24"
#     gateway_id = aws_internet_gateway.example.id
#   }

#   route {
#     ipv6_cidr_block        = "::/0"
#     egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
#   }

#   tags = {
#     Name = "example"
#   }
# }

# module "network_route-table" {
#   source  = "tedilabs/network/aws//modules/route-table"
#   version = "0.32.1"
#   name    = "aws_three_tier_rt"
#   vpc_id  = "vpc.id"
# }
