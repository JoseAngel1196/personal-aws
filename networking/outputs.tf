output "availability_zones_available" {
  value = data.aws_availability_zones.available.names
}

output "public_subnets" {
  value = aws_subnet.public_subnet.*.id
}

output "private_subnets" {
  value = aws_subnet.private_subnet.*.id
}

output "public_security_group" {
  value = aws_security_group.security-group-us-east-1-example.id
}

# output "nateway_subnet_id" {
#   value = aws_nat_gateway.nat-gateway-us-east-1-example.subnet_id
# }