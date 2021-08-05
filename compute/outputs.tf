output "public_ip" {
    value = aws_instance.jose_node.*.public_ip
}