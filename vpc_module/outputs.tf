output "vpc_id" {
    value = aws_vpc.my_vpc.id
}

output "public_subnet_ids" {
    value = [for subnet in aws_subnet.public_subnet : subnet.id]
}


output "database_subnet_ids" {
    value = [for subnet in aws_subnet.database_subnet : subnet.id] 
}

output "private_subnet_ids" {
    value = [ for subnet in aws_subnet.private_subnet : subnet.id]
  
}


# FILE TESTED AND APPROVED ZERO MISTAKE 
