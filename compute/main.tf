# --- compute/main.tf

# To create a EC2, we need to provision a key-pair (public-private key)
# For this, we're going to use ssh-keygen
# Like this: ssh-keygen -t rsa -b 2048

resource "random_shuffle" "public_subnets_id" {
  input        = var.public_subnets
  result_count = 1
}

resource "random_shuffle" "private_subnet_ids" {
  input        = var.private_subnets
  result_count = 1
}

resource "random_id" "random_number" {
  byte_length = 2
}

resource "aws_instance" "ec2-us-east-1-example" {
  instance_type = "t2.micro"
  ami           = var.ami
  key_name      = var.ssh_key_name
  subnet_id     = random_shuffle.private_subnet_ids.result[0]
  security_groups = [var.public_security_group]

  tags = {
    Name = "ec2-us-east-1-private-instance-example-${random_id.random_number.dec}"
  }
}

resource "aws_instance" "ec2-us-east-1-bastion-host" {
  instance_type = "t2.micro"
  ami           = var.ami
  key_name      = var.ssh_key_name
  subnet_id     = random_shuffle.public_subnets_id.result[0]
  security_groups = [var.public_security_group]

  tags = {
    Name = "ec2-us-east-1-bastion-host-example-${random_id.random_number.dec}"
  }
}
