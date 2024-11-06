output "ssh_key" {
    value = aws_key_pair.ssh-key.id
}

output "web_sg" {
    value = aws_security_group.web_sg.id
}
# output "app_sg" {
#     value = aws_security_group.app_sg.id
# }

# output "database_sg" {
#     value = aws_security_group.database_sg
# }

# output = the id of the ressource created stored in a output called ""