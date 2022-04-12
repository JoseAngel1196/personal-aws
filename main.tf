module "networking" {
  source           = "./networking"
  cidr_block       = local.cidr_block
  max_subnets      = 8
  private_sn_count = 4
  public_sn_count  = 4
  public_cidrs     = [for i in range(2, 256, 2) : cidrsubnet(local.cidr_block, 8, i)]
  private_cidrs    = [for i in range(1, 256, 2) : cidrsubnet(local.cidr_block, 8, i)]
}

module "compute" {
  source          = "./compute"
  ami             = "ami-0c02fb55956c7d316"
  key_name        = "aws_key_ec2"
  public_key_path = "/Users/jose/.ssh/aws_key_ec2.pub"
  public_subnets  = module.networking.public_subnets
  public_security_group = module.networking.public_security_group
}
