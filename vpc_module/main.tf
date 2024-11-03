#####################################
# VPC
#####################################

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr 
  enable_dns_hostnames = var.dns_hostnames
  enable_dns_support = var.dns_support

  tags = {
    Name = "vpc_${var.environment}"
  }
}


#####################################
# SUBNETS
#####################################

resource "aws_subnet" "public_subnet" {
    for_each = toset(var.availability_zones)
    vpc_id = aws_vpc.my_vpc.id      #attach to the vpc created above
    cidr_block = var.pub_subnet_cidr
    availability_zone = each.key
    map_public_ip_on_launch = true

    tags = {
        Name = "web_tier_${var.environment}" # front_end 
    }
}

resource "aws_subnet" "private_subnet" {
    for_each = toset(var.availability_zones)
    vpc_id = aws_vpc.my_vpc.id      
    cidr_block = var.pub_subnet_cidr
    availability_zone = each.key
    map_public_ip_on_launch = false #no public ip assigned for private subnet 

    tags = {
        Name = "app_tier_${var.environment}" # back_end 
    }
}

resource "aws_subnet" "database_subnet" {
    for_each = toset(var.availability_zones)
    vpc_id = aws_vpc.my_vpc.id      
    cidr_block = var.pub_subnet_cidr
    availability_zone = each.key
    map_public_ip_on_launch = false #no public ip for database subnet

    tags = {
        Name = "database_tier_${var.environment}" # database
    }
}



############################################
# CONNECTIVITY RESSOURCES
############################################

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id
}


# -------- PUBLIC SUBNET CONNECTIVITY ------------

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_subnet.public_subnet.id
  # allocated_id = aws_eip.example.id

  tags = {
    Name = "Nat Gateway"
  }
  depends_on = [aws_internet_gateway.internet_gateway]
}

# Route Table for Public Subnet (Front End) with NAT Gateway
resource "aws_route_table" "pub_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "publicRTlink" {
  subnet_id = aws_subnet.public_subnet.id 
  route_table_id = aws_route_table.pub_route_table.id
}


# ------PRIVATE SUBNET CONNECTIVITY ( APP TIERS )--------


resource "aws_route_table" "private_route_table_backend" {
  vpc_id =  aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0" 
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "private-backend-route-table"
  }
}

resource "aws_route_table_association" "private_subnet_association_backend" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table_backend.id
}


# ------- PRIVATE SUBNET CONNECTIVITY ( DATABASE TIERS) -------

resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  # No outbound internet route, only internal routes if needed

  tags = {
    Name = "private-database-route-table"
  }
}

resource "aws_route_table_association" "database_subnet_association" {
  subnet_id      = aws_subnet.database_subnet.id
  route_table_id = aws_route_table.database_route_table.id
}




