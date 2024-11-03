#########################################
    # other
#########################################

variable "environment" {
    description = "Environment type where the infrastructure will be deployed"
    type = string
}

variable "instance_image" {
    description = "EC2 Image"
    type = string
}

variable "instance_type" {
    description = "EC2 Instance type"
    type = string
}


#########################################
# variables inherited from output modules
#########################################

variable "vpc" {

}

variable "public_subnet" {
  
}

variable "private_subnet" {

}

variable "ssh_key" {
  
}

variable "web_sg" {
  
}

variable "app_sg" {
  
}

variable "public_subnet_ids" {
  
}




