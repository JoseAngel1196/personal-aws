resource "aws_instance" "public" {
  ami                         = var.ubuntu_ami
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true
  key_name                    = var.key_pair_name
  tags = {
    Name = "public_instance"
  }
}
