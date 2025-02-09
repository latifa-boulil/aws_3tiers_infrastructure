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

variable "ssh_port" {
    description = "ssh port"
    type = number
    default = 22
}

variable "http_port" {
    description = "front end port"
    type = number
    default = 80
}

variable "https_port" {
    description = "https"
    type = number
    default = 442
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

variable "trusted_ip" {
    description = "value"
    type = list(string)
    sensitive = true
}
