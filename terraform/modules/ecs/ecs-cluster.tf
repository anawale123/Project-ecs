# ECS CLUSTER
resource "aws_ecs_cluster" "umami_app" {
  name = "cluster-app" 

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = {
    Environment = var.environment
    
  }
}