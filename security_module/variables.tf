# role policies

#########################################
# variables inherited from output modules
#########################################

variable "vpc" {

}

variable "public_subnet" {
  
}


#########################################
    # other
#########################################

variable "trusted_ip" {
    description = "My trusted Ip for SSH connection"
    type = string
}

variable "database_port" {
    description = "value"
    type = number
    default = 3306  
}

variable "backend_port" {
    description = "value"
    type = number
    default = 3000
}