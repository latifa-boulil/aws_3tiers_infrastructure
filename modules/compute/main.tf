###################################
# APP LOAD BALANCER FRONT END 
##################################

# Application Load Balancer
resource "aws_lb" "public_alb" {
  name               = "public-loadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.external_loadBalancer_sg]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.delection_protection
  idle_timeout               = 60
}

# Listener (receive traffic from )
resource "aws_lb_listener" "public_listener" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06" #"ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_alb_targetgroup.arn
  }
}

# Target Group (forward traffic to)
resource "aws_lb_target_group" "public_alb_targetgroup" {
  name        = "public-target-group"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  health_check {
    path                = "/"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

#################################
# EC2 LAUNCH TEMPLATE FRONT END 
#################################

# Launch Template for Client(front) EC2
resource "aws_launch_template" "public_launch_template" {
  name          = "web_launch_template"
  image_id      = var.front_instance_image
  instance_type = var.instance_type
  user_data = base64encode(file("${path.module}/ec2-init.sh")) 

  monitoring {
    enabled = var.monitoring
  }
  network_interfaces {
    associate_public_ip_address = var.associate_ip
    delete_on_termination = true # ENI is deleted with the instance delection
    security_groups = [var.web_sg]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web_tier${var.environment}"
    }
  }
  # add IAM ROLE to access S3 (code source)
}


#################################
# AUTO SCALING GROUP FRONT END 
#################################

# AUTO SCALING GROUP - front end
resource "aws_autoscaling_group" "web_tier_asg" {
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  vpc_zone_identifier  = var.public_subnet_ids 

  launch_template {
    id      = aws_launch_template.public_launch_template.id
    version = "$Latest"
  }
  # link to Public ALB
  target_group_arns           = [aws_lb_target_group.public_alb_targetgroup.arn] 
  health_check_type           = "ELB"  # Health check is done via ALB
  health_check_grace_period   = 300
  termination_policies        = ["OldestInstance"]
}

# AUTO SCALING POLICY
resource "aws_autoscaling_policy" "front_scale_up" {
  name = "front_scale_out"
  scaling_adjustment = 1  # add one instance
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.web_tier_asg.name 
}

resource "aws_autoscaling_policy" "front_scale_down" {
  name = "front_scale_in"
  scaling_adjustment = -1 # delete one instance
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.web_tier_asg.name
}


#####################################
# APPLICATION LOAD BALANCER BACKEND 
#####################################

#Application Load Balancer
resource "aws_lb" "private_alb" {
  name               = "private-LB"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.internal_loadBalancer_sg]
  subnets            = var.private_subnet_ids

  enable_deletion_protection = false
  idle_timeout               = 60
}

# # Listener (receive traffic from)
resource "aws_lb_listener" "frontend_listener" {
  load_balancer_arn = aws_lb.private_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_alb_targetgroup.arn
  }
}

# Target Group (forward traffic to)
resource "aws_lb_target_group" "private_alb_targetgroup" {
  name        = "private-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# #################################
# # EC2 LAUNCH TEMPLATE BACK END 
# #################################

resource "aws_launch_template" "private_launch_template" {
  name          = "app_launch_template"
  image_id      = var.back_instance_image
  instance_type = var.instance_type

  monitoring {
    enabled = var.monitoring
  }
  network_interfaces {
    associate_public_ip_address = false # No publicIp for private instance
    delete_on_termination = true 
    security_groups = [var.app_sg]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "app_tier${var.environment}"
    }
  }
  # IAM ROLE to allow DB access
  iam_instance_profile {
    name = var.backend_instance_profile_name
  }
}

# #################################
# # AUTO SCALING GROUP BACK END 
# #################################

resource "aws_autoscaling_group" "app_tier_asg" {
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  vpc_zone_identifier  = var.private_subnet_ids 

  launch_template {
    id      = aws_launch_template.private_launch_template.id
    version = "$Latest"
  }
  # Link to private Load Balancer
  health_check_type          = "ELB" 
  target_group_arns = [aws_lb_target_group.private_alb_targetgroup.arn]
  health_check_grace_period  = 300
}

# # auto scaling policy
resource "aws_autoscaling_policy" "back_scale_up" {
  name = "back_scale_out"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.app_tier_asg.name 
}

resource "aws_autoscaling_policy" "back_scale_down" {
  name = "back_scale_in"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.app_tier_asg.name
}

