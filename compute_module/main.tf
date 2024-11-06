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
#     # security_groups = [var.web_sg]                              
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
#     lifecycle {
#     create_before_destroy = true
#     }
# }

# resource "aws_instance" "private_ec2" {
#     for_each = zipmap([0,1], var.private_subnet_ids)
#     subnet_id = each.value
#     ami = var.instance_image
#     instance_type = var.instance_type
#     # key_name = var.ssh_key
#     # monitoring = true
#     # security_groups = [var.app_sg] 
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
#     lifecycle {
#     create_before_destroy = true
#     }
# }


#############################
    # FRONT END 
#############################

# Elastic Load Balancer

resource "aws_elb" "web_elb" {
  name = "${var.environment}-loadbalancer"
  internal = false
  security_groups = [var.web_sg]
  subnets = var.public_subnet_ids
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http" 
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 30
  }
  tags = {
    Name = "main_load_balancer"
  }
}


# Launch Template for EC2

resource "aws_launch_template" "public_launch_template" {
  name          = "web_launch_template"
  image_id      = var.instance_image
  instance_type = var.instance_type
  key_name      = var.ssh_key

  monitoring {
    enabled = true
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [var.web_sg]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web_tier${var.environment}"
    }
  }
}

  # Optionally, add IAM role for instance profile here
  #iam_instance_profile {


# AUTO SCALING GROUP

resource "aws_autoscaling_group" "web_tier_asg" {
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  vpc_zone_identifier  = var.public_subnet_ids #list of pb subnet from output in module vpc

  launch_template {
    id      = aws_launch_template.public_launch_template.id
    version = "$Latest"
  }

  health_check_type          = "ELB" # health check in load balancer , Bby default it is EC2
  load_balancers = [aws_elb.web_elb.name] # refer to load balancer resource created earlier 
  health_check_grace_period  = 300

  tag {
    key                 = "Name"
    value               = "web_tier${var.environment}"
    propagate_at_launch = true
  }
}


# AUTO SCALING POLICY

resource "aws_autoscaling_policy" "scale_up" {
  name = "scale_in"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.web_tier_asg.arn
}

resource "aws_autoscaling_policy" "scale_down" {
  name = "scale_in"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.web_tier_asg.arn
}

# CLOUD WATCH METRIC ALARM

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_up" {
  alarm_name = "cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "30" # new instance will be created if cpu is higher than 30
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.web_tier_asg.name
  }
  actions_enabled = true
  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_down" {
  alarm_name = "cpu-utilization-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "27" # instance will go down if cpu is lower than 27 
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.web_tier_asg.name
  }
  actions_enabled = true
  alarm_actions = [aws_autoscaling_policy.scale_down.arn]
}

