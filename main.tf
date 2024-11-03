
module "vpc" {
  source = "./vpc_module"
  environment = "production"
  vpc_cidr = "10.0.0.0/16"
  availability_zones = ["eu-west-3a","eu-west-3b"]
  dns_support = "true"
  dns_hostnames = "true"
  pub_subnet_cidr = ""
}

module "compute" {
  source = "./ec2_module"
}

module "database" {
  source = "./database_module"
}

module "security" {
  source = "./security_module"
  vpc = module.vpc.vpc.id
  trusted_ip = "10.0.0/0"
  public_subnet = module.vpc.public_subnet.ids
}

