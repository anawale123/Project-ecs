# MAIN ALB TARGET GROUP Umami
resource "aws_lb_target_group" "alb_tg_http" {
  name        = "umami-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/api/heartbeat" 
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}


# BLUE TARGET GROUP
resource "aws_lb_target_group" "blue_tg" {
  name        = "app-blue"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

    health_check {
    path                = "/api/heartbeat" 
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

# GREEN TARGET GROUP
resource "aws_lb_target_group" "green_tg" {
  name        = "app-green"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
    health_check {
    path                = "/api/heartbeat" 
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}


