# ECS CODE DEPLOY IAM ROLE VARIABLE 
variable "codedeploy_role_arn"{
    type = string 
    description = " iam role variable enable code deploy to run"
}


# ALB LISTENER PROD prod_traffic_route
variable "alb_listener" {
    type = list(string)
    description = "alb listener for prod traffic route" 
}


# BLUE ALB TG 
variable "blue_tg" {
    type = string 
    description = " target group variable of blue deployment target group" 
}

# GREEN ALB TG 
variable "green_tg" {
    type = string 
    description = " target group variable of green deployment target group" 
}


