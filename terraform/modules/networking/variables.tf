variable "environment" {
  type = string 
}


# VPC CIDR BLOCK
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# ALB SUBNET CIDR BLOCK
variable "alb_cidr" {
  
  type        = string
  default     = "10.0.2.0/24"
}

# ALB-B SUBNET CIDR BLOCK
variable "alb_cidr_b" {
  
  type        = string
  default     = "10.0.3.0/24"
}

# PRIVATE ECS SUBNET CIDR BLOCK
variable "private_ecs_cidr" {
  
  type        = string
  default     = "10.0.4.0/24"
}

# PRIVATE RDS SUBNET CIDR BLOCK
variable "private_rds_cidr" {
  
  type        = string
  default     = "10.0.7.0/24"
}

# PRIVATE RDS-B SUBNET CIDR BLOCK
variable "private_rds_cidr_b" {
  
  type        = string
  default     = "10.0.11.0/24"
}

# NAT-GW SUBNET CIDR BLOCK
variable "nategateway_cidr" {

  type        = string
  default     = "10.0.8.0/24"

}
