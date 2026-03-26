# ECS TASK DEFINITION (URL-SHORTNER)
resource "aws_ecs_task_definition" "url_shortner_task" {
  family                   = "url_shortner_service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn = var.image_pull_arn
  task_role_arn      = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = "url_shortner"
      image     = "111810594106.dkr.ecr.eu-west-2.amazonaws.com/url_shortner:new-2"
      cpu       = 256
      memory    = 512
      essential = true

      portMappings = [
        {
          containerPort = 3001
          hostPort      = 3001
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "HOSTNAME"
          value = "0.0.0.0"
        },
        {
          name  = "PORT"
          value = "3001"
        },
        {
          name  = "APP_URL"
          value = var.app_url
        },
        {
          name  = "NODE_ENV"
          value = "production"
        },
        {
          name  = "UIID_BUCKET"
          value = var.bucket_name
        },
        {
          name  = "UIID_KEY"
          value = "domains.json"
        },
        {
          name  = "AWS_REGION"
          value = "eu-west-2"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/url_shortner_logs"
          awslogs-region        = "eu-west-2"
          awslogs-stream-prefix = "ecs2"
        }
      }
    }
  ])
}
