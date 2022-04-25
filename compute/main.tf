# --- compute/main.tf

# To create a EC2, we need to provision a key-pair (public-private key)
# For this, we're going to use ssh-keygen
# Like this: ssh-keygen -t rsa -b 2048

resource "random_shuffle" "public_subnets_id" {
  input        = var.public_subnets
  result_count = 3
}

resource "random_shuffle" "private_subnet_ids" {
  input        = var.private_subnets
  result_count = 1
}

resource "random_id" "random_number" {
  byte_length = 2
}

######################################
########## Data Sources ##############
######################################

data "aws_subnet" "random_subnet_1" {
  id = var.public_subnets[0]
}

data "aws_ebs_volume" "ebs_volume" {
  most_recent = true

  filter {
    name   = "volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "tag:Name"
    values = ["ebs-us-east-1-example-us-east-1a"]
  }
}

data "aws_region" "current" {}

######################################
############### EC2 ##################
######################################

# Private Hosts

# resource "aws_instance" "ec2-us-east-1-example" {
#   instance_type = "t2.micro"
#   ami           = var.ami
#   key_name      = var.ssh_key_name
#   subnet_id     = random_shuffle.private_subnet_ids.result[0]
#   security_groups = [var.public_security_group]

#   tags = {
#     Name = "ec2-us-east-1-private-instance-example-${random_id.random_number.dec}"
#   }
# }

# Bastion Hosts

# resource "aws_instance" "ec2-us-east-1-bastion-host" {
#   count = 3
#   instance_type = "t2.micro"
#   ami           = var.ami
#   key_name      = var.ssh_key_name
#   subnet_id     = random_shuffle.public_subnets_id.result[count.index]
#   security_groups = [var.public_security_group]

#   tags = {
#     Name = "ec2-us-east-1-bastion-host-example-${random_id.random_number.dec}"
#   }
# }

# Public Hosts

resource "aws_instance" "ec2-us-east-1-host-1" {
  instance_type          = "t2.micro"
  ami                    = var.ami
  key_name               = var.ssh_key_name
  subnet_id              = data.aws_subnet.random_subnet_1.id
  vpc_security_group_ids = [var.public_security_group]

  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = 10
    tags = {
      Name = "ebs-us-east-1-example-${data.aws_subnet.random_subnet_1.availability_zone}"
    }
  }

  tags = {
    Name = "ec2-us-east-1-host-example-1"
  }
}

resource "aws_instance" "ec2-us-east-1-host-2" {
  instance_type          = "t2.micro"
  ami                    = var.ami
  key_name               = var.ssh_key_name
  subnet_id              = data.aws_subnet.random_subnet_1.id
  vpc_security_group_ids = [var.public_security_group]

  tags = {
    Name = "ec2-us-east-1-host-example-2"
  }
}

######################################
########### EBS Volume ###############
######################################

# Note to self: to attach an EBS volume to multiple instance, enable Multi-Attach
# You can attach multiple EBS volumes to a single instance

# resource "aws_ebs_volume" "ebs-us-east-1-example" {
#   availability_zone = data.aws_subnet.random_subnet_1.availability_zone
#   size              = 10

#   tags = {
#     Name = "ebs-us-east-1-example-${data.aws_subnet.random_subnet_1.availability_zone}"
#   }
# }


resource "aws_ebs_snapshot" "ebs-snapshot-volume-1" {
  volume_id = data.aws_ebs_volume.ebs_volume.id

  tags = {
    Name = "ebs-snapshot-us-east-1-host-example-1"
  }
}

resource "aws_ebs_snapshot_copy" "ebs-copy-us-east-1-example" {
  source_snapshot_id = aws_ebs_snapshot.ebs-snapshot-volume-1.id
  source_region      = data.aws_region.current.name

  tags = {
    Name = "ebs-copy-us-east-1-example-${data.aws_subnet.random_subnet_1.availability_zone}"
  }
}

resource "aws_ebs_volume" "ebs-us-east-1-example-2" {
  availability_zone = data.aws_subnet.random_subnet_1.availability_zone
  size              = 10
  snapshot_id = aws_ebs_snapshot.ebs-snapshot-volume-1.id

  tags = {
    Name = "ebs-us-east-1-example-${data.aws_subnet.random_subnet_1.availability_zone}"
  }
}

resource "aws_volume_attachment" "ebs-att-host-2" {
  # Another way to attach an EBS with an EC2 instance
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs-us-east-1-example-2.id
  instance_id = aws_instance.ec2-us-east-1-host-2.id
}