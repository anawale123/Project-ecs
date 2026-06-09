
# MAIN ALB 
resource "aws_lb" "alb_main" {
  name               = "alb-main"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg]
  subnets = var.public_subnets
  enable_deletion_protection = true

  

  tags = {
    Environment = var.environment
    
  }
}