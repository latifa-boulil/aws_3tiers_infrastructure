variable "db_password" {
    description = "Database Password"
    type = string
    sensitive = true
}

variable "db_username" {
    description = "Database Username"
    type = string
    sensitive = true
  
}

variable "ssh_key" {
    description = "SSH Public Key"
    type = string
    sensitive = true
}

# variables's values available at prod.tfvars 

