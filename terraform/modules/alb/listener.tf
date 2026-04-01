# HTTPS listener: terminate TLS and forward to default target group (Umami)
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb_main_1.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  certificate_arn   = "arn:aws:acm:eu-west-2:111810594106:certificate/69d60269-82aa-4a03-ac73-3598f5537daf"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_http.arn
  }
}

# Listener rule: forward /website* and health requests to the shortener target group
resource "aws_lb_listener_rule" "url_shortner_rule" {
  load_balancer_arn = aws_lb.alb_main_1.arn
  listener_arn = aws_lb_listener.https.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_url_shortner_tg.arn
  }

  condition {
  path_pattern {
    values = [
      "/website*",
      "/health"
      ]
    }
  }

}


