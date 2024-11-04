####################################
# SSH KEY
###################################3

resource "aws_key_pair" "ssh-key" {               #works do not change
    key_name = "ssh_key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCX1JCM6Zii0aXKA5hP8dnNA8NBCc6ihyeyjtM3igWIfDecVZPsNWvaQ7qrevTehvAJvt2qgCAdTIuI/nicjTZCje8KPg+v2OUbnB1MME7u8h4eANf16L2oSD66xo0Azpjahbrr0oFvGWL61cKgYyACcEvAhUsTgZGC6ZKatxOUb9cMRtnjtkpxycVOj0D5QASld2x6vBFbuA3YSRe7uLp+duZhZgxw2HxQ3CoIxZZIAfjQ7hDO6GEuLHAwMcnILqIZKyBTJSKrZbgRpGm/r/cPcOkkfjmpEonzfgwjefBsc6710pifTFiZXS6SsELpr/+nxYe90TNFpCfqzSO1dbbeffgoFI5t9UH21GBgEY/nOMjX++VdzUl/S58AR+CiutrPK1KtAWxpgaDQvpN/2v4B9Rq4OzmCxvZKXm0EG0/S/Wxag1qQJJGW5i+CA5hZqqp0pdbp8Ow4gzemLrOlXXhXqgc1bujd04RRBk4Meoy47qogVwq7sl47X7syF0Gjq2MHQUeZxOE6pP8breA8CTaNEftv8YXKPZslxKimLRQXXBeAqMXLiyGLU3wLSGRFwFc6ik0RVKJ/nUazagkZNPT01HpHkre+RbrKJ1W2E5kNJHui8DfGvhkL68FFIuTBL8YVPTwMLPFMADqeIqvgDw+oRywEUM+1JA3/pIqvpj8eaQ== engineer@debian"
}

####################################
# SECURITY GROUPS
####################################

# Web Tier (front End)
resource "aws_security_group" "web_sg" {
  name = "frontend-sg"
  description = "Security group for front end app"                    # works but to change rue in separate ressource 
  vpc_id = var.vpc_id

    # Inbound Rules
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.trusted_ip] # only trusted ip adress check range issue ivp4
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
  description = "Security group for back end app"
  vpc_id = var.vpc_id

    # Inbound Rules
  ingress {
    from_port   = var.backend_port
    to_port     = var.backend_port
    protocol    = "tcp"
    security_groups = [aws_security_group.web_sg.id]  # Allow traffic from front end
  }

  ingress {
    from_port = var.database_port  
    to_port = var.database_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # cycle errorshould be database security group but throwing error cycle to solve by creating separate ressource for rule 
    # ans assign it to security group
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

# Database
resource "aws_security_group" "database_sg" {
  name        = "database-sg"
  description = "Security group for the database"
  vpc_id      = var.vpc_id

  # Inbound rules
  ingress {
    from_port   = var.database_port 
    to_port     = var.database_port
    protocol    = "tcp"
    security_groups = [aws_security_group.app_sg.id]  # Allow traffic from back end
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
# SECURITY GROUP RULES 
####################################

####################################
# IAM ROLES
####################################

# add cloud watch monitoring  
#can add a CloudWatch Alarm to monitor CPU usage or other metrics. 
#If thresholds are exceeded, the alarm can trigger notifications or actions.
