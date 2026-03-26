



# CLOUDWATCH LOG FOR ECS TASK (url_shortner)
resource "aws_cloudwatch_log_group" "url_shortner" {
  name              = "/ecs/url_shortner_logs"
  retention_in_days = 7
}








