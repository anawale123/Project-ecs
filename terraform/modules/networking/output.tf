
# VPC OUTPUT VARIABLE
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc_app.id
}

# PUBLIC SUBNET OUTPUT VARIABLE
output "public_subnets" {
  description = "List of public subnet IDs"
  value       = [aws_subnet.alb_subnet.id, aws_subnet.alb_subnet_b.id]
}

# PRIVATE SUBNET OUTPUT VARIABLE
output "private_subnets" {
  description = "Private subnet IDs for ECS tasks"
  value       = [aws_subnet.private_ecs.id]  
}

# PRIVATE RDS SUBNET OUTPUT VARIABLE
output "private_rds" {
    description = "rds subnets"
    value     = [aws_subnet.private_rds.id, aws_subnet.private_rds_b.id]
}

# ALB SECURITY GROUP ID
output "alb_sg_id" {
  description = "Security group ID for the ALB"
  value       = aws_security_group.alb_sg.id
}

# ECS SECURITY GROUP ID OUTPUT VARIABLE
output "ecs_sg_id" {
  description = "Security group ID for ECS tasks"
  value       = aws_security_group.ecs_sg.id
}

# RDS SECURITY GROUP ID OUTPUT VARIABLE
output "mysql_sg_id" {
  description = "Security group ID for MySQL database"
  value       = aws_security_group.mysql_sg.id
}
