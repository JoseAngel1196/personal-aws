output "availability_zones_available" {
  value = data.aws_availability_zones.available.names
}