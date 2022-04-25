variable "instance_count" {
  type    = number
  default = 1
}

variable "ami" {
  type = string
}

variable "key_name" {
  type = string
}

variable "public_key_path" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "public_security_group" {
  type = string
}

variable "ssh_key_name" {
  type = string
}

variable "ssh_public_key_pem" {
  type = string
}

variable "total_of_hosts_to_create" {
  type    = number
  default = 3
}