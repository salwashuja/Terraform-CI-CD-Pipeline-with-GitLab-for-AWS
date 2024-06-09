

module "vpc" {
  source = "./vpc"
}

module "ec2_instance" {
 source = "./ec2"
 sn = module.vpc.pb_sn
 sg = module.vpc.sg
}