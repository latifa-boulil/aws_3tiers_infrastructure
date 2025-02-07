output "back_auto_scaling_name" {
    description = "auto scaling name for the backend"
    value = aws_autoscaling_group.app_tier_asg.name
}

output "back_scale_up_policy_arn" {
    description = "scale out policy for the backend "
    value = aws_autoscaling_policy.back_scale_up.arn
}

output "back_scale_down_policy_arn" {
    description = "scale in policy for the backend"
    value = aws_autoscaling_policy.back_scale_down.arn  
}

output "front_auto_scaling_name" {
    description = "auto scaling name for the frontend"
    value = aws_autoscaling_group.web_tier_asg.name
}

output "front_scale_up_policy_arn" {
    description = "scale out policy for the front end"
    value = aws_autoscaling_policy.front_scale_up.arn
}

output "front_scale_down_policy_arn" {
    description = "scale in policy for the front end"
    value = aws_autoscaling_policy.front_scale_down.arn
}

