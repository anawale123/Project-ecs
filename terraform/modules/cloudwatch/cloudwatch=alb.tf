# CLOUDWATCH LOG FOR alb 
resource "aws_cloudwatch_log_group" "cloudwatch_alb" {
  name              = "aws-waf-logs-staging"
  retention_in_days = 7

  tags = {
    Environment = var.environment
    
  }
}

# ALB GREEN TG ALARM FOR ROLLS (ALB5XX)
 resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "alb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 5

  dimensions = {
    LoadBalancer = var.alb_name
  }

  alarm_description = "Triggers when ALB target 5xx errors spike"

  tags = {
    Environment = var.environment
    
  }
}

# ALB LATENCY ALARM
resource "aws_cloudwatch_metric_alarm" "alb_latency_high" {
  alarm_name          = "alb-latency-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1

  dimensions = {
    LoadBalancer = "alb-main"
  }

  alarm_description = "Triggers when ALB latency exceeds 1 second"
  treat_missing_data = "missing"

  tags = {
    Environment = var.environment
    
  }
}
