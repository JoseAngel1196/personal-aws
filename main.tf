# module "compute" {
#   source          = "./compute"
#   instance_count  = 1
#   instance_type   = "t3.micro"
#   ami             = "ami-04387c27258f75ab9" # Hardcoded AMI kali-linux
#   key_name        = "jose-personal-aws"
#   public_key_path = "/Users/jose/.ssh/jose_kali_machine.pub"
# }

module "iam" {
  source           = "./iam"
  s3_bucket_1_name = module.s3.s3_bucket_1_name
  s3_bucket_2_name = module.s3.s3_bucket_2_name
}

module "s3" {
  source = "./s3"
}