#############################
    # EC2 INSTANCES 
#############################

# resource "aws_instance" "public_ec2" {
#     for_each = zipmap([0,1], var.public_subnet_ids)         #this function works well do not change it 
#     subnet_id = each.value
#     ami = var.instance_image
#     instance_type = var.instance_type
#     key_name = var.ssh_key
#     monitoring = true
#     security_groups = [var.web_sg]                              
#        # add am i role here 
#     metadata_options {
#       http_tokens = "required" 
#     } 
#     root_block_device {
#         encrypted   = true  #Encrypting enhances security by ensuring data at rest is protected.
#     }
#     tags = {
#         Name = "web_tier${var.environment}"
#     }
#     # lifecycle {
#     # create_before_destroy = true
#     # }
# }

# resource "aws_instance" "private_ec2" {
#     for_each = zipmap([0,1], var.private_subnet_ids)
#     subnet_id = each.value
#     ami = var.instance_image
#     instance_type = var.instance_type
#     key_name = var.ssh_key
#     monitoring = true
#     security_groups = [var.app_sg] 
#        # add am i role here 
#     metadata_options {
#       http_tokens = "required" 
#     } 
#     root_block_device {
#         encrypted   = true  #Encrypting enhances security by ensuring data at rest is protected.
#     }
#     tags = {
#         Name = "app_tier${var.environment}"
#     }
#     # lifecycle {
#     # create_before_destroy = true
#     # }
# }


#############################
    # FRONT END 
#############################

# Application Load Balancer that will distribute all the trafic to the public subnets 
resource "aws_elb" "app_elb" {
    name = "app-load-balancer"
    security_groups = [var.web_sg]
    listener {
      instance_port = 80
      instance_protocol = "HTTP"
      lb_port = 80
      lb_protocol = "HTTP"
    }
    health_check {
      target = "HTTP:80"
      interval = 30
      timeout = 5
      healthy_threshold = 2
      unhealthy_threshold = 2
    }
}

# EC2 Template (holds the specification of our ec2 instances)
resource "aws_launch_template" "public_launch_template" {
  name                  = "web_launch_template"
  image_id              = var.instance_image
  instance_type         = var.instance_type
  key_name              = var.ssh_key

  monitoring {
    enabled = true
  }
  network_interfaces {
    associate_public_ip_address = true 
    security_groups = [var.web_sg]
  }
#   metadata_options {
#     http_tokens = "required"
#   }
#   block_device_mappings {
#     device_name = "/dev/xvda"  # Root block device
#     ebs {
#       volume_size = 8            # Specify volume size or any other options as needed
#       encrypted   = true         # Encrypt the root volume
#     }
#   }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web_tier${var.environment}"
    }
  }


}

# AUTO SCALING GROUP : Deploy ec2 to the appropriate public subnet 
resource "aws_autoscaling_group" "web_tier_asg" {
  launch_configuration = aws_launch_template.public_launch_template.id
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  vpc_zone_identifier  = var.public_subnet_ids #list of pb subnet from output in module vpc
  health_check_type    = aws_launch_template.public_launch_template.id # by default, the health check is perform at the ec2 level . we want it at the LB level
  health_check_grace_period = 300
  launch_template {
    id      = aws_launch_template.public_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "auto_scaling_client_${var.environment}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_elb.app_elb]
}


# auto scaling policies UP
resource "aws_autoscaling_policy" "scale_up" {
    name = "${var.environment}_scale_in"
    autoscaling_group_name = aws_autoscaling_group.web_tier_asg.arn # attach to which auto scaling group ( using the arn rather than the id)
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = 1 
    cooldown = 300
    policy_type = "SimpleScaling"
  
}

# auto scaling policies DOWN 
resource "aws_autoscaling_policy" "scale_down" {
    name = "${var.environment}_asg_scale_down"
    autoscaling_group_name = aws_autoscaling_group.web_tier_asg.arn
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = -1 
    cooldown = 300
    policy_type = "SimpleScaling"
  
}

# cloud watch alarn 
resource "aws_cloudwatch_metric_alarm" "cpu_utilisation_up" {
    alarm_name = "${var.environment}_scale_up_alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "30"  # new instance will be created once cpu Utilisation is greater than 30
    actions_enabled = true
    dimensions = {
      "AutoScalingGroupName" = aws_autoscaling_group.web_tier_asg.name
    }
    alarm_actions = [aws_autoscaling_policy.scale_up]

}

# cloud watch alarm for scale down 
resource "aws_cloudwatch_metric_alarm" "cpu_utilisation_down" {
    alarm_name = "${var.environment}_scale_down_alarm"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "27"  # new instance will be created once cpu Utilisation is greater than 30
    actions_enabled = true
    dimensions = {
      "AutoScalingGroupName" = aws_autoscaling_group.web_tier_asg.name
    }
    alarm_actions = [aws_autoscaling_policy.scale_down]

}


