resource "aws_instance" "public" {
  count = var.deploy_public_instance ? 1 : 0

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

resource "aws_instance" "private" {
  count = var.deploy_private_instance ? 1 : 0

  ami                         = var.ubuntu_ami
  instance_type               = var.instance_type
  subnet_id                   = element(var.private_subnet_ids, 0)
  associate_public_ip_address = false
  key_name                    = var.key_pair_name

  tags = {
    Name = "private_instance"
  }
}