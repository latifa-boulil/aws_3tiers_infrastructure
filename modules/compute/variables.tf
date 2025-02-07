#########################################
    # MODULE VARIABLES
#########################################

variable "environment" {
    description = "Environment where infra will be deployed"
    type = string
    default = "production"
}

variable "instance_image" {
    description = "EC2 Image"
    type = string
    default = "ami-00d81861317c2cc1f" #use customize AMI
}

variable "instance_type" {
    description = "EC2 Instance type"
    type = string
    default = "t2.micro"
}

variable "desired_capacity" {
    description = "Desired number of EC2 - Auto Scaling Group"
    type = number
    default = 2
}

variable "min_size" {
    description = " minimum EC2 running - Auto Scaling Group"
    type = number
    default = 1
}

variable "max_size" {
    description = "maximum EC2 running - Auto Scaling Group"
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

variable "acm_certificate_arn" {
    description = "certificate arn"
    type = string
    default = "arn:aws:acm:eu-west-3:061051253558:certificate/68fb4f6c-8591-43cd-98a5-bfc9c1c81f6b"
}

#########################################
# oTHER MODULES VARIABLES
#########################################

variable "vpc_id"{
    description = "Workload Vpc Id"
    type = string
}

variable "public_subnet_ids" {
    description = "List of Public Subnet Ids"
    type = list(string)
}

variable "private_subnet_ids" {
    description = "List of Private Subnet Ids"
    type = list(string)
  
}

variable "ssh_key" {
    description = "SSH Public Key of EC2 Connection"
    type = string
}

variable "web_sg" {
    description = "Security Group Ids - FrontEnd"
    type = string
  
}

variable "app_sg" {
    description = "Security Group Ids - BackEnd"
    type = string
}

variable "external_loadBalancer_sg" {
    description = "Security Group Id for the external load balancer"
    type = string
}

variable "internal_loadBalancer_sg" {
    description = "Security Group Id for the internal Load Balancer"
    type = string 
}   

variable "backend_instance_profile_name" {
    description = "instance profile name to attach to backend"
    type = string 
}



