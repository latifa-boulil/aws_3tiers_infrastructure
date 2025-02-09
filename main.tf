
module "vpc" {
  source = "./modules/vpc"
  environment = "production"
  dns_support = "true"
  dns_hostnames = "true"
}

module "compute" {
  source = "./modules/compute"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  web_sg = module.security.web_sg
  app_sg = module.security.app_sg
  private_subnet_ids = module.vpc.private_subnet_ids
  external_loadBalancer_sg = module.security.external_loadBalancer_sg
  internal_loadBalancer_sg = module.security.internal_loadBalancer_sg
  backend_instance_profile_name = module.iam.backend_instance_profile_name
  acm_certificate_arn = var.acm_certificate
}


module "database" {
  source = "./modules/database"
  vpc_id = module.vpc.vpc_id
  db_password = var.db_password
  db_username = var.db_username
  database_subnets = module.vpc.database_subnet_ids
  database_sg = module.security.database_sg
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
  trusted_ip = var.trusted_ip
  #ssh_key = var.ssh_key
}

module "iam" {
  source = "./modules/iam"
}

module "monitoring" {
  source = "./modules/monitoring"
  back_auto_scaling_name = module.compute.back_auto_scaling_name
  front_auto_scaling_name = module.compute.front_auto_scaling_name
  back_scale_up_policy_arn = module.compute.back_scale_up_policy_arn
  front_scale_up_policy_arn = module.compute.front_scale_up_policy_arn
  back_scale_down_policy_arn = module.compute.back_scale_down_policy_arn
  front_scale_down_policy_arn = module.compute.front_scale_down_policy_arn
  email = var.email
}