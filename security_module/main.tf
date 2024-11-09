# Security Group Rule are to be separate from Security Group to avoid cycle errors


####################################
# SSH KEY
###################################3

resource "aws_key_pair" "ssh-key" {  
    key_name = "ssh_key"
    public_key = var.ssh_key
}

####################################
# SECURITY GROUPS
####################################

# FRONT END - CLIENT TIER
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

# BACKEND - APP TIERS
resource "aws_security_group" "app_sg" {
  name = "backend-sg"
  description = "Back end Security Group"
  vpc_id = var.vpc_id

  tags = {
    Name = "back_security_group"
  }
}

# DATABASE
resource "aws_security_group" "database_sg" {
  name        = "database-sg"
  description = "Database Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "databse-sg"
  }
}


##############################
# FRONT END RULES
##############################

resource "aws_security_group_rule" "front_ingress_ssh" {
  type = "ingress"
  description = "Allow SSH connection"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [var.trusted_ip] # from personal/professional IP only 
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "front_ingress_https" {
  type = "ingress"
  description = "Allow https connection "
  from_port = 442
  to_port = 442
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"] 
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "front_ingress_http" {
  type = "ingress"
  description = "Allow http connection "
  from_port = var.frontend_port
  to_port = var.frontend_port
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"] 
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "front_ingress_backend" {
  type = "ingress"
  description = "Allow backend connection "
  from_port = var.backend_port
  to_port = var.backend_port
  protocol = "tcp"
  source_security_group_id = aws_security_group.app_sg.id # from back end security group
  security_group_id = aws_security_group.web_sg.id # attach to front end 
}


##############################
# BACK END RULES
##############################

resource "aws_security_group_rule" "back_ingress_front" {
  type = "ingress"
  description = "allow traffic from frontend only"
  from_port = var.frontend_port
  to_port = var.frontend_port
  protocol = "tcp"
  source_security_group_id = aws_security_group.web_sg.id
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
  from_port = var.frontend_port
  to_port = var.frontend_port
  protocol = "tcp"
  source_security_group_id = aws_security_group.web_sg.id
  security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "back_egress_database" {
  type = "egress"
  description = "allow traffic toward database"
  from_port = var.database_port
  to_port = var.database_port
  protocol = "tcp"
  source_security_group_id = aws_security_group.database_sg.id
  security_group_id = aws_security_group.app_sg.id
}



##############################
# DATABASE RULES
##############################

resource "aws_security_group_rule" "databse_ingress_backend" {
  type = "ingress"
  description = "allow traffic from backend"
  from_port = var.backend_port
  to_port = var.backend_port
  protocol = "tcp"
  source_security_group_id = aws_security_group.app_sg.id
  security_group_id = aws_security_group.database_sg.id
}

resource "aws_security_group_rule" "databse_egress_backend" {
  type = "egress"
  description = "allow traffic towards backend"
  from_port = var.backend_port
  to_port = var.backend_port
  protocol = "tcp"
  source_security_group_id = aws_security_group.app_sg.id
  security_group_id = aws_security_group.database_sg.id
}


####################################
# IAM ROLES
####################################


# resource "aws_iam_role" "eni_management_role" {
#   name = "eni-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid = ""
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_policy" "eni_delete_policy" {
#   name = "eni-delete-policy"
#   description = "Policy to allow Elastic Newtork Interfaces to be delete upon terraform destroy"
#   policy = jsondecode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "ec2:DeleteNetworkInterface"
#         ]
#         Effect = "Allow"
#         Ressource = "*"
#       }
#     ]
#   })  
# }


