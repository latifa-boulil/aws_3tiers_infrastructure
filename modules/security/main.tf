# Security Group Rule are to be separate from Security Group to avoid cycle errors

####################################
# SSH KEY
###################################3

resource "aws_key_pair" "ssh-key" {  
    key_name = "ssh_key"
    public_key = var.ssh_key
}

####################################
# FRONT END LAYER 
####################################

# application load balancer security group
resource "aws_security_group" "external_loadBalancer_sg" {
  name = "external-loadbalancer-sg"
  description = "LoadBalancer Security Group"                   
  vpc_id = var.vpc_id

  ingress {
    description = "allow all traffic in from 80"
    from_port = 443     
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    description = "allow all traffic out"
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  tags = {
    Name = "loadBalancerSg"
  }
}

# Front Tier security group
resource "aws_security_group" "web_sg" {
  name = "frontend-sg"
  description = "Front end Security Group"                   
  vpc_id = var.vpc_id

  egress {
    description = "allow all traffic out"
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  tags = {
    Name = "client_security_group"
  }
}

# receive http traffic from ALB security group
resource "aws_security_group_rule" "front_ingress_http" {
  type = "ingress"
  description = "Allow http connection "
  from_port = var.http_port
  to_port = var.http_port
  protocol = "tcp"
  source_security_group_id = aws_security_group.external_loadBalancer_sg.id # from public load balancer
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "front_ingress_backend" {
  type = "ingress"
  description = "Allow backend connection "
  from_port = var.backend_port
  to_port = var.backend_port
  protocol = "tcp"
  source_security_group_id = aws_security_group.app_sg.id # TO CHANGE TO INTERNET LOAD BALANCER SG 
  security_group_id = aws_security_group.web_sg.id # attach to front end 
}

####################################
# BACK END LAYER 
####################################

# internal Load Balancer Security Group
resource "aws_security_group" "internal_loadBalancer_sg" {
  name = "internal-loadbalancer-sg"
  description = "LoadBalancer Security Group"                   
  vpc_id = var.vpc_id

  ingress {
    description = "allow all traffic in from 80"
    from_port = var.http_port
    to_port = var.http_port
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]  # to change to front security group 
  }

  egress {
    description = "allow all traffic out"
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  tags = {
    Name = "internal_loadBalancerSg"
  }
}


# Back end Security Group
resource "aws_security_group" "app_sg" {
  name = "backend-sg"
  description = "Back end Security Group"
  vpc_id = var.vpc_id

  tags = {
    Name = "back_security_group"
  }
}

# Back End Rules
resource "aws_security_group_rule" "back_ingress_front" {
  type = "ingress"
  description = "allow traffic from frontend only"
  from_port = var.http_port
  to_port = var.http_port
  protocol = "tcp"
  source_security_group_id = aws_security_group.internal_loadBalancer_sg.id # from Internal Load Balancer SG
  security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "back_ingress_db" {
  type = "ingress"
  description = "allow traffic from database"
  from_port = var.database_port
  to_port = var.database_port
  protocol = "tcp"
  source_security_group_id = aws_security_group.database_sg.id
  security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "back_egress_front" {
  type = "egress"
  description = "allow traffic towards frontend"
  from_port = var.http_port
  to_port = var.http_port
  protocol = "tcp"
  source_security_group_id = aws_security_group.internal_loadBalancer_sg.id # to internal Load Balancer Sg
  security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "back_egress_database" {
  type = "egress"
  description = "allow traffic toward database"
  from_port = var.database_port
  to_port = var.database_port
  protocol = "tcp"
  source_security_group_id = aws_security_group.database_sg.id # to database Sg
  security_group_id = aws_security_group.app_sg.id
}

##############################
# DATABASE RULES
##############################

# Database Security Group
resource "aws_security_group" "database_sg" {
  name        = "database-sg"
  description = "Database Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "databse-sg"
  }
}

# Database Rules
resource "aws_security_group_rule" "database_ingress_backend" {
  type = "ingress"
  description = "allow traffic from backend"
  from_port = var.backend_port
  to_port = var.backend_port
  protocol = "tcp"
  source_security_group_id = aws_security_group.app_sg.id
  security_group_id = aws_security_group.database_sg.id
}

resource "aws_security_group_rule" "database_egress_backend" {
  type = "egress"
  description = "allow traffic towards backend"
  from_port = var.backend_port
  to_port = var.backend_port
  protocol = "tcp"
  source_security_group_id = aws_security_group.app_sg.id
  security_group_id = aws_security_group.database_sg.id
}

# add NACL for database






