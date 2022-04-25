data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

# Local variables

locals {
  cidr_block = var.cidr_block
  vpc_id     = aws_vpc.vpc-us-east-1-d-example.id
}

#####################################
############## VPC ##################
#####################################

# Naming convention: vpc-region-environment-application-name

resource "aws_vpc" "vpc-us-east-1-d-example" {
  cidr_block = local.cidr_block

  tags = {
    Name = "vpc-us-east-1-d-example"
  }
}

#####################################
######## Internet Gateway ###########
#####################################

resource "aws_internet_gateway" "gw-example" {
  vpc_id = local.vpc_id

  tags = {
    Name = "main"
  }
}

#####################################
######### Public Subnets ############
#####################################

resource "aws_subnet" "public_subnet" {
  count = var.public_sn_count

  vpc_id                  = local.vpc_id
  cidr_block              = var.public_cidrs[count.index]
  availability_zone       = random_shuffle.az_list.result[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.vpc_id}-public-sn-${count.index}"
  }
}

#####################################
######### Private Subnets ###########
#####################################

resource "aws_subnet" "private_subnet" {
  count = var.private_sn_count

  vpc_id            = local.vpc_id
  cidr_block        = var.private_cidrs[count.index]
  availability_zone = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "${local.vpc_id}-private-sn-${count.index}"
  }
}

#########################################
######### Public Route Table ############
#########################################

resource "aws_route_table" "public_rtb" {
  vpc_id = local.vpc_id

  tags = {
    Name = "${local.vpc_id}-public-route-table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw-example.id
}

resource "aws_route_table_association" "public_rtb_association" {
  count = var.public_sn_count

  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_rtb.id
}

#########################################
########### Security Groups #############
#########################################

resource "aws_security_group" "security-group-us-east-1-example" {
  name        = "public_sg"
  description = "Security Group for Public Access"
  vpc_id      = local.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#########################################
############# Nat Gateway ###############
#########################################

# To create a nat gateway, we need to:
# Create a Elastic IP
# Associate the Elastic IP to our nat gateway
# Modify our main route table to allow public connections for our nat gateway

# resource "aws_eip" "eip-example" {
#   vpc      = true
# }

# resource "aws_nat_gateway" "nat-gateway-us-east-1-example" {
#   allocation_id = aws_eip.eip-example.id
#   subnet_id = aws_subnet.public_subnet.*.id[0]

#   tags = {
#     Name = "${local.vpc_id}-nat-gateway-us-east-1-example"
#   }
# }

# resource "aws_default_route_table" "default-route-table" {
#   default_route_table_id = aws_vpc.vpc-us-east-1-d-example.default_route_table_id

#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat-gateway-us-east-1-example.id
#   }

#   tags = {
#     Name = "${local.vpc_id}-default-route-table-example"
#   }
# }