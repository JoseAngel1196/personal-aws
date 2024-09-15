output "vpc_id" {
  value = aws_vpc.this.id
}

output "azs" {
  value = data.aws_availability_zones.available
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
