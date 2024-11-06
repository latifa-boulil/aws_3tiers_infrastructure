output "vpc_id" {
    value = module.vpc.vpc_id                                       
}

output "public_subnet_ids" {
    value = module.vpc.public_subnet_ids                           
}

output "private_subnet_ids" {
    value = module.vpc.private_subnet_ids
}

output "ssh_key" {
    value = module.security.ssh_key
}

output "web_sg" {
    value = module.security.web_sg
}

output "app_sg" {
    value = module.security.app_sg
}


# output "database_subnet_ids" {
#     value = module.vpc.database_subnet_ids                          
# }


# FILE TESTED AND APPROVED 

# output is the module + the name of the output in the module , not the value inside !!!!!!!!!!!!!!!!!!!!
