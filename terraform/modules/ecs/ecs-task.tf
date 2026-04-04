
# ECS TASK DEFINITION (UMAMI)
resource "aws_ecs_task_definition" "umami_task_def" {
  family                   = "umami-service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn = var.image_pull_arn
  task_role_arn = var.secret_db_task_role_arn


# CONFIGURATION BUILT UPON docker IMAGE, TO DEFINE IMAGE AND RUN IT AS A TASK, MIRROR DOCKER IMAGE AND OPTIMIZING COMPUTE IN ORDER TO CONTAINER TO SUCCESSFULLY RUN
  container_definitions = jsonencode([
    {
      name      = "umami"
      image     = "111810594106.dkr.ecr.eu-west-2.amazonaws.com/image_umami:latest"
      cpu       = 256
      memory    = 512
      essential = true

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "HOSTNAME"
          value = "0.0.0.0"
        },
        {
          name  = "DATABASE_TYPE"
          value = "postgres"
        },
        {
          name  = "APP_SECRET"
          value = "asdwe233424321"
        },
        {
          name  = "BASE_PATH"
          value = "/"
        },
        {
          name  = "APP_URL"
          value = "http://umami-analytics.co.uk"
        }
      ]
    # DATABASE URL IS HOSTED IN AWS SECRET MANAGER IN ORDER TO SAFEGAURD DB CREDENTIALS BY NOT HARDCODING SENSITIVE INFORMATION.
      secrets = [
        {
          name      = "DATABASE_URL"
          valueFrom = var.secret_db_arn
        }
      ]
    # LOG CONFIGURATION FOR CLOUD WATCH TO ENHANCE OBSERVIBILITY AND ENABLING TROUBLE SHOOT REGARDING TASK IN THE FUTURE IF THERE ARE ANY ERRORS WHILST RUNNING TASK OR BEGININNG TASK
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.cloudwatch
          "awslogs-region"        = "eu-west-2"
          "awslogs-stream-prefix" = "umami_1"
        }
      }
    }
  ])
  # CLOUD WATCH 
  depends_on = [var.cloudwatch]
}
