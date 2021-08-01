# --- compute/main.tf

resource "random_id" "jose_node_id" {
  byte_length = 2
  count       = var.instance_count
  keepers = {
    key_name = var.key_name
  }
}

resource "aws_key_pair" "jose_personal_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "jose_node" {
  count         = var.instance_count
  instance_type = var.instance_type
  ami           = var.ami
  key_name      = aws_key_pair.jose_personal_auth.id
  tags = {
    Name = "jose_node-${random_id.jose_node_id[count.index].dec}" # decimal of random id we are using
  }
}
