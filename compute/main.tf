# --- compute/main.tf

# To create a EC2, we need to provision a key-pair (public-private key)
# For this, we're going to use ssh-keygen
# Like this: ssh-keygen -t rsa -b 2048

resource "random_shuffle" "subnet_ids" {
  input        = var.public_subnets
  result_count = 1
}

resource "random_id" "random_number" {
  byte_length = 2
}

resource "aws_key_pair" "ec2-auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "ec2-us-east-1-example" {
  instance_type = "t2.micro"
  ami           = var.ami
  key_name      = aws_key_pair.ec2-auth.id
  subnet_id     = random_shuffle.subnet_ids.result[0]
  security_groups = [var.public_security_group]

  tags = {
    Name = "ec2-us-east-1-example-${random_id.random_number.dec}"
  }
}
