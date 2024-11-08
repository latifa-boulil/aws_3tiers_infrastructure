########################################
# OTHER MODULE VARIABLES
#########################################

variable "vpc_id" {
    description = "Workload VPC Id"
    type = string
}


#########################################
# MODULE VARIABLES
#########################################

variable "trusted_ip" {
    description = "personal Ip Adress range to access Public EC2 via SSH protocol"
    type = string
}

variable "database_port" {
    description = "Database Port"
    type = number
    default = 3306  
}

variable "backend_port" {
    description = "BackEnd App Port"
    type = number
    default = 3000
}

