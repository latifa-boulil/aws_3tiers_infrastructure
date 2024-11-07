
####################################
# RDS 
####################################


resource "aws_db_instance" "database" {
    allocated_storage = var.storage
    instance_class = var.db_instance_class
    max_allocated_storage = var.max_storage
    engine = var.engine
    db_name = var.db_name
    username = var.db_username
    password = var.db_password
    multi_az = var.multi_az
    publicly_accessible = var.access 
    storage_type = var.storage_type
    skip_final_snapshot = var.final_snapshot

    db_subnet_group_name = aws_db_subnet_group.default.name

    vpc_security_group_ids = [var.database_sg]

    tags = {
        Name = var.db_name
    }
}

resource "aws_db_subnet_group" "default" {
    name = "rds-subnet-group"
    subnet_ids = var.database_subnets
}