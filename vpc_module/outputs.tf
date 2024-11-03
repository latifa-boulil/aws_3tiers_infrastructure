output "vpc" {
    value = aws_vpc.my_vpc
}

output "public_subnet" {
    value = aws_subnet.public_subnet
}

output "private_subnet" {
    value = aws_subnet.private_subnet
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id  # Returns a list of IDs for the public subnets
}
