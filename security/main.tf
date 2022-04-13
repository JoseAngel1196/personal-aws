resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  key_name = "aws-key"
  public_key = tls_private_key.ssh.public_key_openssh
}