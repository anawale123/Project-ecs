# ALB VARIABLE 
variable "alb_name" {
    type        = string
    description = "alb variable" 
}



# GREEN TargetGroup VARIABLE
variable "green_tg" {
    type       =  string
    description = "green target group variable" 
}

# ECS CLUSTER VARIABLE 
variable "cluster" {
    type        = string
    description = " ecs cluster variable" 
}

# ECS SERVICE VARIABLE
variable "service" {
    type        =  string
    description = " ecs service variable"
}

# RDS BACKUP VARIABLE 
variable "rds_id" {
    type        = string 
    description = "rds instance "
}