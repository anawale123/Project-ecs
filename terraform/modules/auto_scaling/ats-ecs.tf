# ECS Autoscaling Target
resource "aws_appautoscaling_target" "umami" {
  max_capacity       = 6
  min_capacity       = 2
  resource_id        = "service/${var.cluster}/${var.service}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# CPU Scale Out (Target Tracking)
resource "aws_appautoscaling_policy" "cpu_scale_out" {
  name               = "umami-cpu-scale-out"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.umami.resource_id
  scalable_dimension = aws_appautoscaling_target.umami.scalable_dimension
  service_namespace  = aws_appautoscaling_target.umami.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 60

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    scale_out_cooldown = 30
    scale_in_cooldown  = 120
  }
}

# Memory Scale Out (Target Tracking)
resource "aws_appautoscaling_policy" "memory_scale_out" {
  name               = "umami-memory-scale-out"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.umami.resource_id
  scalable_dimension = aws_appautoscaling_target.umami.scalable_dimension
  service_namespace  = aws_appautoscaling_target.umami.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 70

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    scale_out_cooldown = 30
    scale_in_cooldown  = 120
  }
}

# CPU Scale In (Step Scaling)
resource "aws_appautoscaling_policy" "cpu_scale_in" {
  name               = "umami-cpu-scale-in"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.umami.resource_id
  scalable_dimension = aws_appautoscaling_target.umami.scalable_dimension
  service_namespace  = aws_appautoscaling_target.umami.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 180
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

# CloudWatch Alarm to Trigger Scale In
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "umami-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 30

  dimensions = {
    ClusterName = var.cluster
    ServiceName = var.service
  }

  alarm_actions = [
    aws_appautoscaling_policy.cpu_scale_in.arn
  ]
}
