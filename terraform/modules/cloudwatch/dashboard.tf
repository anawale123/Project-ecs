resource "aws_cloudwatch_dashboard" "umami_dashboard" {
  dashboard_name = "umami-cloudwatch-dashboard"

  dashboard_body = jsonencode({
    widgets = [

      # ALB Latency
      {
        "type": "metric",
        "x": 0, "y": 0, "width": 12, "height": 6,
        "properties": {
          "title": "ALB Target Response Time",
          "metrics": [
            [ "AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.alb_name ]
          ],
          "stat": "Average",
          "period": 60,
          "region": "eu-west-2"
        }
      },

      # ALB 4xx & 5xx Errors
      {
        "type": "metric",
        "x": 12, "y": 0, "width": 12, "height": 6,
        "properties": {
          "title": "ALB 4xx & 5xx Errors",
          "metrics": [
            [ "AWS/ApplicationELB", "HTTPCode_Target_4XX_Count", "LoadBalancer", var.alb_name ],
            [ ".", "HTTPCode_Target_5XX_Count", ".", "." ]
          ],
          "stat": "Sum",
          "period": 60,
          "region": "eu-west-2"
        }
      },

      # ECS CPU
      {
        "type": "metric",
        "x": 0, "y": 6, "width": 12, "height": 6,
        "properties": {
          "title": "ECS CPU Utilization",
          "metrics": [
            [ "AWS/ECS", "CPUUtilization", "ClusterName", var.cluster, "ServiceName", var.service ]
          ],
          "stat": "Average",
          "period": 60,
          "region": "eu-west-2"
        }
      },

      # ECS Memory
      {
        "type": "metric",
        "x": 12, "y": 6, "width": 12, "height": 6,
        "properties": {
          "title": "ECS Memory Utilization",
          "metrics": [
            [ "AWS/ECS", "MemoryUtilization", "ClusterName", var.cluster, "ServiceName", var.service ]
          ],
          "stat": "Average",
          "period": 60,
          "region": "eu-west-2"
        }
      },

      # ECS Running Task Count
      {
        "type": "metric",
        "x": 0, "y": 12, "width": 12, "height": 6,
        "properties": {
          "title": "ECS Running Task Count",
          "metrics": [
            [ "AWS/ECS", "RunningTaskCount", "ClusterName", var.cluster, "ServiceName", var.service ]
          ],
          "stat": "Average",
          "period": 60,
          "region": "eu-west-2"
        }
      },

      # ALB Request Count
      {
        "type": "metric",
        "x": 12, "y": 12, "width": 12, "height": 6,
        "properties": {
          "title": "ALB Request Count",
          "metrics": [
            [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.alb_name ]
          ],
          "stat": "Sum",
          "period": 60,
          "region": "eu-west-2"
        }
      },

      # WAF Blocked Requests
      {
        "type": "metric",
        "x": 0, "y": 18, "width": 24, "height": 6,
        "properties": {
          "title": "WAF Blocked Requests",
          "metrics": [
            [ "AWS/WAFV2", "BlockedRequests", "WebACL", "umami-waf", "Region", "eu-west-2" ]
          ],
          "stat": "Sum",
          "period": 300,
          "region": "eu-west-2"
        }
      }

    ]
  })
}
