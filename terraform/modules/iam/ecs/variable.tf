

variable "vpc_id" {
  description = "VPC ID where ECS resources will be deployed"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for ECS tasks"
  type        = list(string)
}


variable "ecs_sg_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}



variable "target_group_arn" {
    description = "target group for alb"
    type        = string
}




variable "db_port" {
  type        = number
  description = "RDS port"
}

variable "db_name" {
  type        = string
  description = "RDS database name"
}

variable "db_username" {
  type        = string
  description = "RDS master username"
}

variable "db_password" {
  type        = string
  description = "RDS master password"
  sensitive   = true
}

variable "app_secret" {
  type        = string
  description = "App secret for Umami"
  sensitive   = true
}


variable "image_pull_arn" {
  type       = string
  description = " image pull iam role" 
}

variable "cloudwatch" {
  type      = string
  description  = "cloud watch "
}