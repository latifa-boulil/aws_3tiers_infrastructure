# output "vpc_id" {
#     value = module.vpc.vpc_id                                       
# }

# output "public_subnet_ids" {
#     value = module.vpc.public_subnet_ids                           
# }
# output "web_sg" {
#     value = module.security.web_sg
# }

output "rds_endpoint" {
    value =  module.database.rds_endpoint
}

output "rds_arn" {
    value = module.database.rds_arn
  
}
# output "app_sg" {
#     value = module.security.app_sg
# }


# output "database_subnet_ids" {
#     value = module.vpc.database_subnet_ids                          
# }

# output is the module + the name of the output in the module , not the value inside !!!!!!!!!!!!!!!!!!!!
