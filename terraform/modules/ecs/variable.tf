variable "environment" {
  type = string 
}

# VPC ID VARIABLE
variable "vpc_id" {
  description = "VPC ID where ECS resources will be deployed"
  type        = string
}

# PRIVATE SUBNET VARIABLE
variable "private_subnets" {
  description = "List of private subnet IDs for ECS tasks"
  type        = list(string)
}

# SECURITY GROUP VARIABLE
variable "ecs_sg_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

# TARGET GROUP VARIABLE
variable "blue_tg_arn" {
  description = "Target group for ALB"
  type        = string
}

# IAM ROLE VARIABLE
variable "image_pull_arn" {
  type        = string
  description = "IAM role for pulling images from ECR"
}

# CLOUDWATCH VARIABLE
variable "cloudwatch" {
  type        = string
  description = "CloudWatch log group name"
}

# IAM ROLE ARN VARIABLE
variable "secret_db_arn" {
  type        = string
  description = "Secrets Manager ARN containing DATABASE_URL"
}

# IAM ROLE ARN VARIABLE
variable "secret_db_task_role_arn" {
  type        = string
  description = "IAM task role ARN used to read Secrets Manager"
}
