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
    default = "ami-00d81861317c2cc1f"
}

variable "instance_type" {
    description = "EC2 Instance type"
    type = string
    default = "t2.micro"
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

variable "monitoring" {
    description = "rather or not we monitor our instances"
    type = bool
    default = true 
}

variable "associate_ip" {
    description = "rather or not we associate an public ip to our instances"
    type = bool
    default = true 
  
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

variable "private_subnet_ids" {
    type = list(string)
  
}

variable "ssh_key" {
    type = string
}

variable "web_sg" {
    type = string
  
}

variable "app_sg" {
    type = string
  
}




