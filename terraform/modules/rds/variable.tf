variable "environment" {
  type = string 
}

# VPC ID VARIABLE 
variable "vpc_id" {
  description = "VPC for rds " 
  type        = string
}

# DB PORT VARIABLE
variable "db_port" {
  description = "Database port"
  type        = string
  default     = "5432"
}

# DB NAME VARIABLE
variable "db_name" {
  description = "Database name"
  type        = string
  default     = "umami-sql"
}

# PRIVATE RDS SUBNET VARIABLE
variable "private_rds" {
  type    = list(string)
  default = []
}

# SECURITY GROUP VARIABLE
variable "rds_sg" {
  description = "List of private subnet IDs for ECS tasks"
  type        = string
}