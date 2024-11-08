
module "vpc" {
  source = "./vpc_module"
  environment = "production"
  dns_support = "true"
  dns_hostnames = "true"
}

module "compute" {
  source = "./compute_module"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  ssh_key = module.security.ssh_key
  web_sg = module.security.web_sg
  app_sg = module.security.app_sg
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "database" {
  source = "./database_module"
  vpc_id = module.vpc.vpc_id
  db_password = var.db_password
  database_subnets = module.vpc.database_subnet_ids
  database_sg = module.security.database_sg

}

module "security" {
  source = "./security_module"
  vpc_id = module.vpc.vpc_id
  trusted_ip = "172.18.0.0/16"
}

