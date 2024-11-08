####################################
# SSH KEY
###################################3

resource "aws_key_pair" "ssh-key" {  
    key_name = "ssh_key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCX1JCM6Zii0aXKA5hP8dnNA8NBCc6ihyeyjtM3igWIfDecVZPsNWvaQ7qrevTehvAJvt2qgCAdTIuI/nicjTZCje8KPg+v2OUbnB1MME7u8h4eANf16L2oSD66xo0Azpjahbrr0oFvGWL61cKgYyACcEvAhUsTgZGC6ZKatxOUb9cMRtnjtkpxycVOj0D5QASld2x6vBFbuA3YSRe7uLp+duZhZgxw2HxQ3CoIxZZIAfjQ7hDO6GEuLHAwMcnILqIZKyBTJSKrZbgRpGm/r/cPcOkkfjmpEonzfgwjefBsc6710pifTFiZXS6SsELpr/+nxYe90TNFpCfqzSO1dbbeffgoFI5t9UH21GBgEY/nOMjX++VdzUl/S58AR+CiutrPK1KtAWxpgaDQvpN/2v4B9Rq4OzmCxvZKXm0EG0/S/Wxag1qQJJGW5i+CA5hZqqp0pdbp8Ow4gzemLrOlXXhXqgc1bujd04RRBk4Meoy47qogVwq7sl47X7syF0Gjq2MHQUeZxOE6pP8breA8CTaNEftv8YXKPZslxKimLRQXXBeAqMXLiyGLU3wLSGRFwFc6ik0RVKJ/nUazagkZNPT01HpHkre+RbrKJ1W2E5kNJHui8DfGvhkL68FFIuTBL8YVPTwMLPFMADqeIqvgDw+oRywEUM+1JA3/pIqvpj8eaQ== engineer@debian"
}

####################################
# SECURITY GROUPS
####################################

# Web Tier (front End)

resource "aws_security_group" "web_sg" {
  name = "frontend-sg"
  description = "Front end Security Group"                   
  vpc_id = var.vpc_id

    # Inbound Rules
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.trusted_ip] # to set in prod.tfvars
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow https from everywhere
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow http from everywhere
  }

    # Outbound Rules
  egress {
    description = "Allow all traffic out"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "client_security_group"
  }
}


# App Tier (Back End)

resource "aws_security_group" "app_sg" {
  name = "backend-sg"
  description = "Back end Security Group"
  vpc_id = var.vpc_id

    # Inbound Rules
  ingress {
    from_port   = var.backend_port
    to_port     = var.backend_port
    protocol    = "tcp"
    security_groups = [aws_security_group.web_sg.id]  # Allow traffic from FrontEnd Security Group
  }

  ingress {
    from_port = var.database_port  
    to_port = var.database_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # cycle error
  }

    # Outbound Rules
  egress {
    description = "Allow all traffic out"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "app_security_group"
  }
}

#Database

resource "aws_security_group" "database_sg" {
  name        = "database-sg"
  description = "Database Security Group"
  vpc_id      = var.vpc_id

  # Inbound rules
  ingress {
    from_port   = var.database_port 
    to_port     = var.database_port
    protocol    = "tcp"
    security_groups = [aws_security_group.app_sg.id]  # Allow traffic from BackEnd Security Group
  }

  # Outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic (or restrict as needed)
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "database_security_group"
  }
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

