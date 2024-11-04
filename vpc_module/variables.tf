################
# vpc variables
################

variable "vpc_cidr" {
    description     = "define the cidr block for the vpc"
    type            = string
}

variable "environment" {
    description     = "environment type where the infrastructure will be deployed "
    type            = string
}

variable "dns_hostnames" {
    description     = "whether or not we enable the dns hostname"
    type            = bool
}

variable "dns_support" {
    description     = "whether or not the VPC has DNS support"
    type            = bool
}

variable "public_cidr" {
    description     = "define the public subnet CIDR block "
    type            = list(string)
    default         = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_cidr" {
    description     = "define the private subnet CIDR block"
    type            = list(string)
    default         = ["10.0.3.0/24", "10.0.4.0/24"]
  
}

variable "database_cidr" {
    description     = "define the database range of CIDR block"
    type            = list(string)
    default         = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "az" {
    description     = "List of availability zones for the public subnets"
    type            = list(string)
    default         = ["eu-west-3b", "eu-west-3a"]
}

variable "vpc" {
    description     = "rather the eip is in the vpc"
    type            = bool
    default         = true 
}


# FILE TESTED AND APPROVED ZERO MISTAKE 
