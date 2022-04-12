output "availability_zones_available" {
  value = data.aws_availability_zones.available.names
}

output "public_subnets" {
  value = aws_subnet.public_subnet.*.id
}

output "public_security_group" {
  value = aws_security_group.security-group-us-east-1-example.id
}