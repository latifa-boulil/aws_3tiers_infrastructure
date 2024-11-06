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
    default = "t2.micro"
}

variable "desired_capacity" {
    description = "our desired number of ec2 from auto scaling group"
    type = number
    default = 2
}

variable "max_size" {
    description = "maximum number of ec2 provisioned by auto scaling group"
    type = number
    default = 4
}

variable "min_size" {
    description = "minimum number of ec2 provisioned by auto scaling group"
    type = number
    default = 1
}


#########################################
# variables inherited from other modules
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

# variable "app_sg" {
#     type = string
# }


