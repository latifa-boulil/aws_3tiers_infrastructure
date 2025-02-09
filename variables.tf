
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

# variable "ssh_key" {
#     description = "SSH Public Key"
#     type = string
#     sensitive = true
# }

variable "acm_certificate" {
    description = "SSL certificate Id"
    type = string 
    sensitive = true
}

variable "email" {
    description = "email"
    type = string 
    sensitive = true
}

variable "trusted_ip" {
    description = "value"
    type = list(string)
    sensitive = true
}

# sensitive variables's values available at prod.tfvars 
# templates at prod.tfvars.template

