variable "vpc_id" {
  type = string
}

variable "ubuntu_ami" {
  type    = string
  default = "ami-0e86e20dae9224db8"
}

variable "instance_type" {
  type    = string
  default = "t2.medium"
}

variable "worker_nodes_count" {
  type    = number
  default = 2
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "key_pair_name" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "deploy_public_instance" {
  type    = bool
  default = false
}

variable "deploy_private_instance" {
  type    = bool
  default = false
}