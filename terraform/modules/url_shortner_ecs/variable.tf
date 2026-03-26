
# ECS VARIABLE
variable "ecs_cluster" {
    type   = string 
    description =   " ecs cluster" 
}

# ALB VARIABLE
variable "alb_target_group_url_shortner_arn" {
    type = string 
    description = " alb url shortner target group"
}

# VPC VARIABLE
variable "vpc_id" {
  description = "VPC ID where ECS resources will be deployed"
  type        = string
}

# PRIVATE SUBNET VARIABLE
variable "private_subnets" {
  description = "List of private subnet IDs for ECS tasks"
  type        = list(string)
}

# ECS SECURITY GROUP VARIABLE
variable "ecs_sg_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

# IAM ROLE VARIABLE
variable "image_pull_arn" {
  type       = string
  description = " image pull iam role" 
}

# APP URL VARIABLE
variable "app_url" {
  type    = string
  default = "https://umami-analytics.co.uk"
}

# S3 BUCKET - WEBSITE UIID
variable "bucket_name" {
    type                = string 
    description = " s3 bucket that stores website uiid"
}

# ECS TASK ROLE
variable "ecs_task_role_arn" { 
  type = string 
  }