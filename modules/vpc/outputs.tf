output "vpc_id" {
    description = "VPC ID"
    value = aws_vpc.my_vpc.id
}

output "public_subnet_ids" {
    description = "List of Subnet Ids for FrontEnd "
    value = [for subnet in aws_subnet.public_subnet : subnet.id]
}


output "database_subnet_ids" {
    description = "List of Subnet Ids for Database"
    value = [for subnet in aws_subnet.database_subnet : subnet.id] 
}

output "private_subnet_ids" {
    description = "List of Subnet Ids for BackEnd"
    value = [ for subnet in aws_subnet.private_subnet : subnet.id]
  
}



