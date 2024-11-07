#############################
    # FRONT END 
#############################

# Elastic Load Balancer

resource "aws_elb" "web_elb" {
  name = "${var.environment}-loadbalancer"
  internal = false   # INTERNET FACING 
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


# Launch Template for Client side EC2

resource "aws_launch_template" "public_launch_template" {
  name          = "web_launch_template"
  image_id      = var.instance_image
  instance_type = var.instance_type
  key_name      = var.ssh_key
  user_data = base64encode(file("${path.module}/ec2-init.sh"))

  monitoring {
    enabled = var.monitoring
  }
  network_interfaces {
    associate_public_ip_address = var.associate_ip
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
  autoscaling_group_name = aws_autoscaling_group.web_tier_asg.name # attention arn ne marche pas ! name is the way to go 
}

resource "aws_autoscaling_policy" "scale_down" {
  name = "scale_in"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.web_tier_asg.name
}

# CLOUD WATCH METRIC ALARM ( SCALE UP AND DOWN )

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_up" {
  alarm_name = "high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "300"
  statistic = "Average"
  threshold = "30" # new instance will be created if cpu is higher than 30
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_tier_asg.name
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


#############################
    # BACK END 
#############################

# back end Elastic Load Balancer
resource "aws_elb" "app_loadbalancer" {
  name = "${var.environment}-app-loadbalancer"
  internal = true  # not internet-facing
  security_groups = [var.web_sg]
  subnets = var.private_subnet_ids # deploy it in private subnets
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
    Name = "backend_load_balancer"
  }
}

# Launch Template for app- tier EC2

resource "aws_launch_template" "private_launch_template" {
  name          = "web_launch_template"
  image_id      = var.instance_image
  instance_type = var.instance_type
  key_name      = var.ssh_key
  user_data = base64encode(file("${path.module}/ec2-init.sh"))

  monitoring {
    enabled = var.monitoring
  }
  network_interfaces {
    associate_public_ip_address = false # no public ip for private ec2
    security_groups = [var.app_sg]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "app_tier${var.environment}"
    }
  }
}

  # Optionally, add IAM role for instance profile here
  #iam_instance_profile {


# AUTO SCALING GROUP Back end 

resource "aws_autoscaling_group" "app_tier_asg" {
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  vpc_zone_identifier  = var.private_subnet_ids #list of pb subnet from output in module vpc

  launch_template {
    id      = aws_launch_template.private_launch_template.id
    version = "$Latest"
  }

  health_check_type          = "ELB" # health check in load balancer , Bby default it is EC2
  load_balancers = [aws_elb.app_loadbalancer.name] # refer to load balancer resource created earlier 
  health_check_grace_period  = 300

  tag {
    key                 = "Name"
    value               = "app_tier${var.environment}"
    propagate_at_launch = true
  }
}

# AUTO SCALING POLICY

resource "aws_autoscaling_policy" "back_scale_up" {
  name = "scale_in"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.app_tier_asg.name # attention arn ne marche pas ! name is the way to go 
}

resource "aws_autoscaling_policy" "back_scale_down" {
  name = "scale_in"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.app_tier_asg.name
}

# CLOUD WATCH METRIC ALARM ( SCALE UP AND DOWN )

resource "aws_cloudwatch_metric_alarm" "back_cpu_utilization_up" {
  alarm_name = "high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "300"
  statistic = "Average"
  threshold = "30" # new instance will be created if cpu is higher than 30
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_tier_asg.name
  }
  actions_enabled = true
  alarm_actions = [aws_autoscaling_policy.back_scale_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "back_cpu_utilization_down" {
  alarm_name = "cpu-utilization-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "27" # instance will go down if cpu is lower than 27 
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.app_tier_asg.name
  }
  actions_enabled = true
  alarm_actions = [aws_autoscaling_policy.back_scale_down.arn]
}
