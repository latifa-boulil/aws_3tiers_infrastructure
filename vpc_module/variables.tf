################
# vpc variables
################

variable "vpc_cidr" {
    description = "define the cidr block for the vpc"
    type = "string"
}

variable "environment" {
    description = "environment type where the infrastructure will be deployed "
    type = "string"
}

variable "dns_hostnames" {
    description = "whether or not we enable the dns hostname"
    type = bool
}

variable "dns_support" {
    description = "whether or not the VPC has DNS support"
    type = bool
}

variable "pub_subnet_cidr" {
    description = "define the public subnet CIDR block "
    type = "string" 
}

variable "availability_zones" {
  description = "List of availability zones for the public subnets"
  type        = list(string)
}
