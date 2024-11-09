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

variable "frontend_port" {
    description = "front end port"
    type = number
    default = 80
  
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



variable "ssh_key" {
    description = "ssh Public Key"
    type = string
    sensitive = true 
}
