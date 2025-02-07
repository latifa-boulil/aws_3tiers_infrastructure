
####################################
# RDS 
####################################

# relational Database
resource "aws_db_instance" "database" {
    identifier = var.db_name
    instance_class = var.db_instance_class
    allocated_storage = var.storage
    max_allocated_storage = var.max_storage
    storage_type = var.storage_type
    engine = var.engine
    username = var.db_username
    password = var.db_password
    
    # vpc network 
    db_subnet_group_name = aws_db_subnet_group.default.name
    vpc_security_group_ids = [var.database_sg]

    multi_az = var.multi_az
    publicly_accessible = false

    # automate backup 
    skip_final_snapshot = var.final_snapshot
    final_snapshot_identifier = "db-snap"
    backup_retention_period = 1 # Number of days to retain automated backups
    backup_window = "03:00-04:00" # Preferred UTC backup window (hh24:mi-hh24:mi format)
    
    # software update
    maintenance_window = "mon:04:00-mon:04:30" # Preferred UTC maintenance window
    iam_database_authentication_enabled = true
}

# RDS network setup
resource "aws_db_subnet_group" "default" {
    name = "rds-subnet-group"
    subnet_ids = var.database_subnets
}

# authorize IAM authentication for RDS
resource "null_resource" "setup_rds_iam_auth" {
  provisioner "local-exec" {
    command = <<EOT
      mysql -h ${aws_db_instance.database.endpoint} \
            -u admin -p'${var.db_password}' \
            -e "CREATE USER 'admin'@'%' IDENTIFIED WITH AWSAuthenticationPlugin AS 'RDS'; GRANT ALL PRIVILEGES ON database_name.* TO 'admin'@'%';"
    EOT
  }

  depends_on = [aws_db_instance.database]
}

