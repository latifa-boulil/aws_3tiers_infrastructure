# DB instance type, DB name, multi-AZ, etc.

#########################################
# variables inherited from output modules
#########################################


variable "db_name" {
    description = "database name"
    type = string
    default = "app_database"
}

variable "db_username" {
    description = "database access : Username"
    type = string
    default = "admin"
}

variable "db_password" {
    description = "database access : Password"
    type = string
    sensitive = true
}

variable "db_instance_class" {
    description = "Instance class for the databas"
    type = string
    default = "db.t3.micro"
}

variable "storage" {
    type = number 
    description = "storage in gb"
    default = 20
}

variable "max_storage" {
    type = number
    description = "max auto scaling storage"
    default = 50
}

variable "engine" {
    type = string
    description = "type of engine my sql or postgre"
    default = "mysql"
}

variable "storage_type" {
    type = string
    description = "storage type "
    default = "gp2"
}

variable "final_snapshot" {
    type = bool
    description = "rather or not we have back up"
    default = false # set to true for production
  
}

variable "multi_az" {
    type = bool
    description = "rather or not we apply multi az option "
    default = true 
}

variable "access" {
    type = bool 
    description = "rather or not our database will be publicly accesible"
    default = false
  
}
#########################################
    # other
#########################################

variable "database_subnets" {
    description = "value"
    type = list(string)
}

variable "database_sg" {
    description = "value"
    type = string
}


variable "vpc_id"{
    description = "vpc_id"
    type = string
}