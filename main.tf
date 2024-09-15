module "networking" {
  source = "./networking"
}

module "security" {
  source = "./security"
}

module "compute" {
  source = "./compute"

  vpc_id             = module.networking.vpc_id
  public_subnet_id   = module.networking.public_subnet_ids[0]
  private_subnet_ids = module.networking.private_subnet_ids
  key_pair_name      = module.security.key_pair_name

  depends_on = [
    module.networking,
    module.security
  ]
}

