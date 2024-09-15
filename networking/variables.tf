variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "public_subnet_count" {
  type    = number
  default = 6
}

variable "private_subnet_count" {
  type    = number
  default = 6
}

variable "tags" {
  type = map(string)
  default = {
    Project = "kubeadm"
  }
}