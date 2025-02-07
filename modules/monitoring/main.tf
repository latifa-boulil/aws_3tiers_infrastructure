#################################
# MONITORING FRONT AUTO SCALING 
#################################

# CLOUD WATCH METRIC ALARM ( SCALE UP AND DOWN )

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_up" {
  alarm_name = "high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "300"
  statistic = "Average"
  threshold = "30" # +1 instance once cpu is > or = 30
  dimensions = {
    AutoScalingGroupName = var.front_auto_scaling_name
  }
  actions_enabled = true
  alarm_actions = [var.front_scale_up_policy_arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_down" {
  alarm_name = "cpu-utilization-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "27" # -1 instance once cpu = or < at 27
  dimensions = {
    "AutoScalingGroupName" = var.front_auto_scaling_name
  }
  actions_enabled = true
  alarm_actions = [var.front_scale_down_policy_arn]
}


###############################
# MONITORING BACK AUTO SCALING 
###############################

# CLOUD WATCH METRIC ALARM ( SCALE UP AND DOWN )

resource "aws_cloudwatch_metric_alarm" "back_cpu_utilization_up" {
  alarm_name = "high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "300"
  statistic = "Average"
  threshold = "30" 
  dimensions = {
    AutoScalingGroupName = var.back_auto_scaling_name
  }
  actions_enabled = true
  alarm_actions = [var.back_scale_up_policy_arn]
}

resource "aws_cloudwatch_metric_alarm" "back_cpu_utilization_down" {
  alarm_name = "cpu-utilization-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "27"
  dimensions = {
    "AutoScalingGroupName" = var.back_auto_scaling_name
  }
  actions_enabled = true
  alarm_actions = [var.back_scale_down_policy_arn]
}


###############################
# MONITORING RDS LOW STORAGE 
###############################

resource "aws_sns_topic" "database_alerts" {
  name = "database-alert"
}

resource "aws_sns_topic_subscription" "sns_email" {
  topic_arn = aws_sns_topic.database_alerts.arn
  endpoint = var.email
  protocol = "email"
}

resource "aws_cloudwatch_metric_alarm" "low_storage_alarm" {
  alarm_name          = "RDS-Low-FreeStorageSpace"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300 # 5 minutes
  statistic           = "Average"
  threshold           = 10737418240 # 10 GB in bytes
  alarm_description   = "Alarm when RDS FreeStorageSpace is below 10GB"
  dimensions = {
    DBInstanceIdentifier = "your-rds-instance-id" # TO ADD
  }

  # Action when alarm is triggered
  alarm_actions = [aws_sns_topic.database_alerts.arn] 
}
