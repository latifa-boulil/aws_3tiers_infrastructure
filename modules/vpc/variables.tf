##################################
# MODULE VARIABLES
##################################

variable "environment" {
    description     = "Environement Deployment "
    type            = string
}

variable "vpc_cidr" {
    description     = "Define VPC CIDR BLOCK"
    type            = string
    default         = "10.0.0.0/16"
}

variable "public_cidr" {
    description     = "Public Subnet CIDR block "
    type            = list(string)
    default         = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_cidr" {
    description     = "Private Subnet CIDR block"
    type            = list(string)
    default         = ["10.0.3.0/24", "10.0.4.0/24"]
  
}

variable "database_cidr" {
    description     = "Database Subnet CIDR block"
    type            = list(string)
    default         = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "az" {
    description     = "List of Availability Zones "
    type            = list(string)
    default         = ["eu-west-3b", "eu-west-3a"]
}

variable "dns_hostnames" {
    description     = "Rather Or Not we enable DNS Hostname"
    type            = bool
}

variable "dns_support" {
    description     = "Rather Or Not VPC has DNS support"
    type            = bool
}

variable "vpc" {
    description     = "Rather Elastic IP is in the vpc"
    type            = bool
    default         = true 
}


# FILE TESTED AND APPROVED ZERO MISTAKE 
