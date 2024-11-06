#####################################
# VPC
#####################################

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr 
  enable_dns_hostnames = var.dns_hostnames
  enable_dns_support = var.dns_support                                    # OK                                  

  tags = {
    Name = "vpc_${var.environment}"
  }
}


#####################################
# SUBNETS
#####################################

resource "aws_subnet" "public_subnet" {
    for_each = zipmap(var.az, var.public_cidr)
    vpc_id = aws_vpc.my_vpc.id      #attach to the vpc created above                 # OK    
    cidr_block = each.value
    availability_zone = each.key
    map_public_ip_on_launch = true

    tags = {
        Name = "web_tier_${var.environment}_${each.key}" # front_end 
    }
}

# resource "aws_subnet" "private_subnet" {
#     for_each = zipmap(var.az, var.private_cidr)
#     vpc_id = aws_vpc.my_vpc.id      
#     availability_zone = each.key
#     cidr_block = each.value 
#     map_public_ip_on_launch = false #no public ip assigned for private subnet         #OK

#     tags = {
#         Name = "app_tier_${var.environment}_${each.key}" # back_end 
#     }
# }

# resource "aws_subnet" "database_subnet" {
#     for_each = zipmap(var.az, var.database_cidr)
#     vpc_id = aws_vpc.my_vpc.id      
#     cidr_block = each.value                                                                #OK
#     availability_zone = each.key
#     map_public_ip_on_launch = false #no public ip for database subnet

#     tags = {
#         Name = "database_tier_${var.environment}_${each.key}" # database
#     }
# }



############################################
# CONNECTIVITY RESSOURCES
############################################

# resource "aws_internet_gateway" "internet_gateway" {                          # OK
#   vpc_id = aws_vpc.my_vpc.id
# }


# -------- PUBLIC SUBNET CONNECTIVITY ------------

# resource "aws_eip" "nat_ip" {                                                   # OK
#   for_each = toset(var.az)                        
# }


# resource "aws_nat_gateway" "nat_gateway" {
#   for_each            = aws_subnet.public_subnet
#   allocation_id       = aws_eip.nat_ip[each.key].id                               # OK 
#   subnet_id           = each.value.id
#   connectivity_type   = "public"

#   tags = {
#     Name = "nat_gateway_${each.key}"
#   }
#   depends_on = [aws_eip.nat_ip]  # cannot create nat_gateway without elastic IP adress error thrown
# }


# # Route Table for Public Subnet (Front End) with NAT Gateway
# resource "aws_route_table" "public_rt" {
#   for_each = aws_subnet.public_subnet
#   vpc_id = aws_vpc.my_vpc.id                                                     # OK
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.internet_gateway.id
#   }
#   tags = {
#     Name = "public-route-table"
#   }
# }

# resource "aws_route_table_association" "publicRTlink" {
#   for_each  = aws_subnet.public_subnet
#   subnet_id = each.value.id                                                         # OK
#   route_table_id = aws_route_table.public_rt[each.key].id
# }


# ------PRIVATE SUBNET CONNECTIVITY ( APP TIERS )--------


# resource "aws_route_table" "backend_rt" {
#   for_each          = aws_subnet.private_subnet
#   vpc_id            =  aws_vpc.my_vpc.id                                          # OK
#   route {
#     cidr_block      = "0.0.0.0/0" 
#     gateway_id      = aws_internet_gateway.internet_gateway.id
#   }

#   tags = {
#     Name = "private-route-table"
#   }
# }

# resource "aws_route_table_association" "private_subnet_association_backend" {
#   for_each = aws_subnet.private_subnet
#   subnet_id      = each.value.id                                                      # OK 
#   route_table_id = aws_route_table.backend_rt[each.key].id
# }


# ------- PRIVATE SUBNET CONNECTIVITY ( DATABASE TIERS) -------

# resource "aws_route_table" "database_rt" {
#   for_each = aws_subnet.database_subnet
#   vpc_id = aws_vpc.my_vpc.id

#   # No outbound internet route, only internal routes if needed                          # OK

#   tags = {
#     Name = "private-database-route-table"
#   }
# }

# resource "aws_route_table_association" "database_subnet_association" {
#   for_each = aws_subnet.database_subnet                                               # OK 
#   subnet_id      = each.value.id
#   route_table_id = aws_route_table.database_rt[each.key].id
# }






# FILE TESTED AND APPROVED ZERO MISTAKE 
