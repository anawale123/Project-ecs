# VPC ID VARIABLE
variable "vpc_id" {
  description = "main aws_vpc"
  type        = string
}


# ALB SG VARIABLE
variable "alb_sg" {
  description = "alb security group"
  type        = string
}

# PUBLIC SUBNET VARIABLE
variable "public_subnets" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

# CLOUDFLARE DOMAIN NAME VARIABLE
variable "domain_name" {
  type = string
  description = " website dns variable"
}

# ACM CERT VARIABLE
variable "certificate_arn" {
  type = string
  description = " acm certification for dns variable"
}

variable "environment" {
    description = "environment phase " 
    type        =  string 
}
