#########################################
# MODULE VARIABLES
#########################################


variable "db_name" {
    description = "Database Name"
    type = string
    default = "app_database"
}

variable "db_instance_class" {
    description = "Database Instance Type"
    type = string
    default = "db.t3.micro"
}

variable "storage" {
    description = "Database Storage - in GB"
    type = number 
    default = 20
}

variable "max_storage" {
    description = "Max Storage Allowed - autoscaling"
    type = number
    default = 50
}

variable "storage_type" {
    description = "Storage Type - SSD"
    type = string
    default = "gp2"
}

variable "engine" {
    description = "Database Type - engine "
    type = string
    default = "mysql"
}

variable "db_username" {
    description = "Database Access: Username"
    type = string
    sensitive = true    # prod.tfvars
}

variable "db_password" {
    description = "Database Access : Password"
    type = string
    sensitive = true       # prod.tfvars 
}

variable "final_snapshot" {
    description = "Rather or Not we Skip Last Data Backup Upon Deletion"
    type = bool
    default = true # false by default 
    # if true all data might be lost. Upon production set to false 
}

variable "multi_az" {
    description = "Rather Or Not We Apply MultiAZ option"
    type = bool
    default = false  # Free tier allow One AZ only - for High Availability and disaster recovery set to true
}

variable "access" {
    description = "Rather Or Not Datbase will be Publicly Accesible"
    type = bool 
    default = false
  
}
#########################################
# OTHER MODULE VARIABLE 
#########################################

variable "database_subnets" {
    description = "List of Datbase Subnet Ids"
    type = list(string)
}

variable "database_sg" {
    description = "Database Security Group Id"
    type = string
}


variable "vpc_id"{
    description = "Workload Vpc Id"
    type = string
}