# ECS CODE DEPLOY APPLICATION 

resource "aws_codedeploy_app" "ecs" {
  compute_platform = "ECS"
  name             = "ecs_code_deployment"
  tags = {
    Environment = var.environment
    
  }
}
