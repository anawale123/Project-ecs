# ALB TG ARN

output "blue_tg_arn" {
  description = "  Main app target group"
  value       = aws_lb_target_group.blue_tg.arn
}


# ALB NAME
output "alb_name" {
  description = " Url shortner target group"
  value       = aws_lb.alb_main.name
}

# ALB NAME
output "alb_arn" {
  description = " alb arn reference output variable"
  value       = aws_lb.alb_main.arn
}


# ALB LISTENER 
output "alb_listener" {
  description = " alb listener" 
  value       = aws_lb_listener.https.arn
}

#ALB BLUE TG
output "blue_tg" {
  description = "blue target code deployment" 
  value       = aws_lb_target_group.blue_tg.name
}

# ALB GREEN TG
output "green_tg" {
  description = "blue target code deployment" 
  value       = aws_lb_target_group.green_tg.name
}