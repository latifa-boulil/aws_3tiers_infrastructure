# output "dns_name" {
#     description = "DNS name of Back Load Balancer for routing traffic"
#     value = aws_elb.app_loadbalancer.dns_name
# }

# output "dns_name" {
#     description = "DNS name of Front Load Balancer for routing traffic"
#     value = aws_elb.web_elb.dns_name
# }

# output "front_asg" {
#     description = "Auto scaling name for monitoring and management purposes"
#     value = aws_autoscaling_group.web_tier_asg.name
# }

# output "back_asg" {
#     description = "Auto scaling name for monitoring and management purposes"
#     value = aws_autoscaling_group.app_tier_asg.name
# }



# Instance IDs: IDs of instances launched by the ASGs for operational visibility.
