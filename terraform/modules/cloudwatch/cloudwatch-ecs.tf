# CLOUDWATCH LOG FOR ECS TASK (UMAMI)
resource "aws_cloudwatch_log_group" "umami_logs" {
  name              = "/ecs/umami-ecs-service"
  retention_in_days = 7

}

# CLOUDWATCH HOST CHECK
resource "aws_cloudwatch_metric_alarm" "host_check" {
  alarm_name          = "ecs-healthy-hosts"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1

  dimensions = {
    TargetGroup  = var.green_tg
    LoadBalancer = var.alb_name
  }

  alarm_description = "Trigger when green tasks become unhealthy"
}

# CLOUDWATCH CPU ECS 

resource "aws_cloudwatch_metric_alarm" "ecs_cpu" {
  alarm_name                = "ecs_cpu"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = 10
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "This metric monitors ecs cpu utilization"
  
  dimensions = {
    ClusterName = var.cluster 
    service     = var.service
  }
}

# CLOUDWATCH ECS RAM

resource "aws_cloudwatch_metric_alarm" "ecs_ram" {
  alarm_name                = "ecs_ram"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "MemoryUtilization"
  namespace                 = "AWS/ECS"
  period                    = 10
  statistic                 = "Average"
  threshold                 = 80
 alarm_description          = "high memory usage on ECS service"
  
  dimensions = {
    ClusterName = var.cluster 
    service     = var.service
  }
}

