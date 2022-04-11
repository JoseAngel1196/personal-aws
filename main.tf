module "networking" {
  source     = "./networking"
  cidr_block = local.cidr_block
  max_subnets = 8
  private_sn_count = 4
  public_sn_count = 4
  public_cidrs     = [for i in range(2, 256, 2) : cidrsubnet(local.cidr_block, 8, i)]
  private_cidrs    = [for i in range(1, 256, 2) : cidrsubnet(local.cidr_block, 8, i)]
}
