
# output "rds_endpoint" {
#     value =  module.database.rds_endpoint
# }

output "loadbalancer_dns" {
    value = module.compute.loadbalancer_dns
}

