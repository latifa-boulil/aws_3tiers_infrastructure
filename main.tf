
module "vpc" {
  source = "./vpc_module"
  environment = "production"
  vpc_cidr = "10.0.0.0/16"
  dns_support = "true"
  dns_hostnames = "true"
}

module "compute" {
  source = "./compute_module"
  environment = "production"
  instance_image = "ami-00d81861317c2cc1f"
  instance_type = "t2.micro"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  ssh_key = module.security.ssh_key
  web_sg = module.security.web_sg
  # app_sg = module.security.app_sg
  private_subnet_ids = module.vpc.private_subnet_ids
}

# module "database" {
#   source = "./database_module"
# }

module "security" {
  source = "./security_module"
  vpc_id = module.vpc.vpc_id
  trusted_ip = "172.18.0.0/16"

}

