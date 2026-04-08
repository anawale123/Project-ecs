# ECS SERVICE (UMAMI)
resource "aws_ecs_service" "umami-service" {
  name            = "umami-ecs-service"
  cluster         = aws_ecs_cluster.umami_app.id
  task_definition = aws_ecs_task_definition.umami_task_def.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  # DEPLOYMENT CONTROLLER
  deployment_controller {
    type = "CODE_DEPLOY"
  }

  # NETWORK CONFIGURATION
  network_configuration {
    subnets          = var.private_subnets
    assign_public_ip = false
    security_groups  = [var.ecs_sg_id]
  }

  # LOAD BALANCER CONFIGURATION
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "umami"
    container_port   = 3000
  }

  lifecycle {
    ignore_changes = [task_definition, load_balancer]
  }

  # ECS SERVICE TASK DEFINITION
  depends_on = [
    aws_ecs_task_definition.umami_task_def
  ]
}
