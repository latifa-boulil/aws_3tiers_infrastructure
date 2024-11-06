#############################
    # EC2 INSTANCES 
#############################

resource "aws_instance" "public_ec2" {
    for_each = zipmap([0,1], var.public_subnet_ids)         #this function works well do not change it 
    subnet_id = each.value
    ami = var.instance_image
    instance_type = var.instance_type
    key_name = var.ssh_key
    monitoring = true
    # security_groups = [var.web_sg]                              
       # add am i role here 
    metadata_options {
      http_tokens = "required" 
    } 
    root_block_device {
        encrypted   = true  #Encrypting enhances security by ensuring data at rest is protected.
    }
    tags = {
        Name = "web_tier${var.environment}"
    }
    lifecycle {
    create_before_destroy = true
    }
}

resource "aws_instance" "private_ec2" {
    for_each = zipmap([0,1], var.private_subnet_ids)
    subnet_id = each.value
    ami = var.instance_image
    instance_type = var.instance_type
    # key_name = var.ssh_key
    # monitoring = true
    # security_groups = [var.app_sg] 
       # add am i role here 
    metadata_options {
      http_tokens = "required" 
    } 
    root_block_device {
        encrypted   = true  #Encrypting enhances security by ensuring data at rest is protected.
    }
    tags = {
        Name = "app_tier${var.environment}"
    }
    lifecycle {
    create_before_destroy = true
    }
}


#############################
    # FRONT END 
#############################

# Launch Instance template, Auto scaling SG, ELB

    # EC2 Template 
# resource "aws_launch_template" "public_launch_template" {
#   name          = "web_launch_template"
#   image_id      = var.instance_image
#   instance_type = var.instance_type
#   key_name      = var.ssh_key

#   monitoring {
#     enabled = true
#   }
#   network_interfaces {
#     security_groups = [var.web_sg]
#   }
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
#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "web_tier${var.environment}"
#     }
#   }

  # Optionally, add IAM role for instance profile here
  #iam_instance_profile {
   # name = var.instance_profile  # Replace with your instance profile variable
  #}
  # depends_on = [aws_security_group.web_sg]
# }

#     # AUTO SCALING GROUP
# resource "aws_autoscaling_group" "web_tier_asg" {
#   desired_capacity     = 2
#   max_size             = 4
#   min_size             = 1
#   vpc_zone_identifier  = [var.public_subnet_ids] #list of pb subnet from output in module vpc

#   launch_template {
#     id      = aws_launch_template.public_launch_template.id
#     version = "$Latest"
#   }

#   health_check_type          = "EC2"
#   health_check_grace_period  = 300

#   tag {
#     key                 = "Name"
#     value               = "web_tier${var.environment}"
#     propagate_at_launch = true
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
#   depends_on = [aws_security_group.web_sg]
# }



