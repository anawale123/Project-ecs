# ECS Cluster
resource "aws_ecs_cluster" "umami_app" {
  name = "cluster-app" 

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}