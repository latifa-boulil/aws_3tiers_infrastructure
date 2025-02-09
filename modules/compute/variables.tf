#########################################
    # MODULE VARIABLES
#########################################

variable "environment" {
    description = "Environment where infra will be deployed"
    type = string
    default = "production"
}

variable "delection_protection" {
    description = "rather or not delection protection is enabled"
    type = bool
    default = false # set to true for production environement
  
}

variable "instance_type" {
    description = "EC2 Instance type"
    type = string
    default = "t2.micro" #adapt to our app requirements
}

variable "front_instance_image" {
    description = "AMI id for the front layer app"
    type = string
    default = "ami-0359cb6c0c97c6607" #set to the custom frontend AMI id
}

variable "back_instance_image" {
    description = "AMI id for our back layer app"
    type = string 
    default = "ami-0359cb6c0c97c6607" # set to the custom backend AMI id
}

variable "desired_capacity" {
    description = "Desired number of EC2 - Auto Scaling Group"
    type = number
    default = 1 #adapt to your workload
}

variable "min_size" {
    description = " minimum EC2 running - Auto Scaling Group"
    type = number
    default = 1 #adapt to your workload
}

variable "max_size" {
    description = "maximum EC2 running - Auto Scaling Group"
    type = number
    default = 2 #adampt to your workload
}

variable "monitoring" {
    description = "rather or not we monitor our instances"
    type = bool
    default = true 
}

variable "associate_ip" {
    description = "rather or not we associate an public ip to our instances"
    type = bool
    default = true #set to false for private launch template
}

# to add to prod.tfvars 
variable "acm_certificate_arn" {
    description = "certificate arn"
    type = string
    sensitive = true
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

