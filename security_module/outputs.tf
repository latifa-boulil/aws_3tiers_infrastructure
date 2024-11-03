output "ssh_key" {
    value = aws_key_pair.ssh-key
}

output "web_sg" {
    value = aws_security_group.app_sg
}

output "app_sg" {
    value = aws_security_group.app_sg
}

output "database_sg" {
    value = aws_security_group.database_sg
}

