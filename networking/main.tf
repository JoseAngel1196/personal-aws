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

  vpc_id = local.vpc_id
  cidr_block = var.public_cidrs[count.index]
  availability_zone = random_shuffle.az_list.result[count.index]
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
  
  vpc_id = local.vpc_id
  cidr_block = var.private_cidrs[count.index]
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
  route_table_id            =  aws_route_table.public_rtb.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw-example.id
}

resource "aws_route_table_association" "public_rtb_association" {
  count = var.public_sn_count

  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_rtb.id
}