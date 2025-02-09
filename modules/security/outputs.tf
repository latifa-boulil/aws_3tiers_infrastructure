# output "ssh_key" {
#     description = "SSH KEY ID"
#     value = aws_key_pair.ssh-key.id
# }

output "web_sg" {
    description = "FrontEnd Security Group ID"
    value = aws_security_group.web_sg.id
}

output "app_sg" {
    description = "BackEnd Security Group ID"
    value = aws_security_group.app_sg.id
}

output "database_sg" {
    description = "Database Security Group ID"
    value = aws_security_group.database_sg.id
}

output "external_loadBalancer_sg" {
    description = "Load Balancer Security Group ID"
    value = aws_security_group.external_loadBalancer_sg.id
}

output "internal_loadBalancer_sg" {
    description = "value"
    value = aws_security_group.internal_loadBalancer_sg.id
  
}