#########################################
    # other
#########################################

variable "environment" {
    description = "Environment type where the infrastructure will be deployed"
    type = string
    default = "production"
}

variable "instance_image" {
    description = "EC2 Image"
    type = string
}

variable "instance_type" {
    description = "EC2 Instance type"
    type = string
}

variable "desired_capacity" {
    description = "the desired number of EC2"
    type = number
    default = 2
}

variable "min_size" {
    description = "the desired number of EC2"
    type = number
    default = 1
}

variable "max_size" {
    description = "the desired number of EC2"
    type = number
    default = 4
}


#########################################
# variables inherited from output modules
#########################################

variable "vpc_id"{
    description = "vpc_id"
    type = string
}

variable "public_subnet_ids" {
    type = list(string)
}

# variable "private_subnet_ids" {
#     type = list(string)
  
# }

variable "ssh_key" {
    type = string
}

variable "web_sg" {
    type = string
  
}




