resource "aws_subnet" "public" {
  count = var.public_subnet_count

  vpc_id            = aws_vpc.this.id
  cidr_block        = local.public_cidr[count.index]
  availability_zone = random_shuffle.az_list.result[count.index]
  tags              = merge({ Name = "public-${count.index}" }, var.tags)
}

resource "aws_subnet" "private" {
  count = var.private_subnet_count

  vpc_id            = aws_vpc.this.id
  cidr_block        = local.private_cidr[count.index]
  availability_zone = random_shuffle.az_list.result[count.index]
  tags              = merge({ Name = "private-${count.index}" }, var.tags)
}
