terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.19.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

# NETWORKING 
module "networking" {
  source = "../../../modules/networking"
}

# S3 BUCKET
module "s3_bucket" {
  source = "../../../modules/s3_bucket"
}

# IAM
module "iam" {
  source = "../../../modules/iam"
  bucket_arn = module.s3_bucket.bucket_arn
}

# RDS
module "rds" {
  source = "../../../modules/rds"
  vpc_id               = module.networking.vpc_id
  private_rds          = module.networking.private_rds  
  rds_sg               = module.networking.mysql_sg_id 

}


# CLOUDWATCH
module "cloudwatch" {
  source = "../../../modules/cloudwatch"
  alb_name       = module.alb.alb_name
  cluster        = module.ecs.cluster
  service        = module.ecs.service
  green_tg       = module.alb.green_tg
  rds_id           = module.rds.rds_id
}

# ALB MODULE
module "alb" {
  source = "../../../modules/alb"

  vpc_id         = module.networking.vpc_id
  public_subnets = module.networking.public_subnets
  alb_sg         = module.networking.alb_sg_id

  domain_name     = "umami-analytics.co.uk"
  certificate_arn = "arn:aws:acm:eu-west-2:111810594106:certificate/69d60269-82aa-4a03-ac73-3598f5537daf"
}

# ECS CLUSTER + UMAMI SERVICE
module "ecs" {
  source = "../../../modules/ecs"

  vpc_id                  = module.networking.vpc_id
  private_subnets         = module.networking.private_subnets
  ecs_sg_id               = module.networking.ecs_sg_id
  target_group_arn        = module.alb.alb_target_group_arn
  image_pull_arn          = module.iam.image_pull_arn
  cloudwatch              = module.cloudwatch.cloudwatch
  secret_db_arn           = module.iam.secret_db_arn
  secret_db_task_role_arn = module.iam.secret_db_task_role_arn
}

# URL Shortener ECS service
module "url_shortner_ecs" {
  source = "../../../modules/url_shortner_ecs"

  ecs_cluster      = module.ecs.ecs_cluster_name
  alb_target_group_url_shortner_arn = module.alb.alb_target_group_url_shortner_arn
  vpc_id           = module.networking.vpc_id
  private_subnets  = module.networking.private_subnets
  ecs_sg_id        = module.networking.ecs_sg_id
  image_pull_arn   = module.iam.image_pull_arn
  bucket_name      = module.s3_bucket.bucket_name
  ecs_task_role_arn = module.iam.ecs_task_role_arn

  app_url = "https://umami-analytics.co.uk"
}

# WAF 
module "waf" {
  source = "../../../modules/waf"

  alb_arn             = module.alb.alb_arn
 
}

# CODE-DEPLOYMENT - BLUE & GREEN
module "code_deployment" {
  source = "../../../modules/code_deployment"
  codedeploy_role_arn = module.iam.codedeploy_role_arn
  alb_listener = [module.alb.alb_listener]
  blue_tg      = module.alb.blue_tg
  green_tg     = module.alb.green_tg
  cluster        = module.ecs.cluster
  service        = module.ecs.service
}

# ATS AUTO SCALING ECS

module "auto-scaling" {
    source = "../../../modules/auto_scaling"
    cluster        = module.ecs.cluster
    service        = module.ecs.service

}
