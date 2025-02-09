variable "front_auto_scaling_name" {
    description = "value"
    type = string
}

variable "front_scale_up_policy_arn" {
    description = "value"
    type = string
}

variable "front_scale_down_policy_arn" {
    description = "value"
    type = string
}

variable "back_auto_scaling_name" {
    description = "value"
    type = string
}

variable "back_scale_up_policy_arn" {
    description = "value"
    type = string 
}

variable "back_scale_down_policy_arn" {
    description = "value"
    type = string 
}

variable "email" {
    description = "email"
    type = string 
    sensitive = true
}

