
# ECS SERVICE (URL-SHORTNER)
resource "aws_ecs_service" "url_shortner_service" {
  name            = "url_shortner"
  cluster         = var.ecs_cluster
  task_definition = aws_ecs_task_definition.url_shortner_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  health_check_grace_period_seconds = 60

  network_configuration {
    subnets          = var.private_subnets
    assign_public_ip = false
    security_groups  = [var.ecs_sg_id]
  }

# LOAD BALANCER CONFIGURATION 
  load_balancer {
    target_group_arn = var.alb_target_group_url_shortner_arn
    container_name   = "url_shortner"
    container_port   = 3001
  }
}
