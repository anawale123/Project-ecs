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

# Networking
module "networking" {
  source = "../../modules/networking"
}

# S3 Bucket
module "s3_bucket" {
  source = "../../modules/s3_bucket"

}

# RDS
module "rds" {
  source = "../../../modules/rds"
  vpc_id               = module.networking.vpc_id
  private_rds          = module.networking.private_rds  
  rds_sg               = module.networking.mysql_sg_id 

}
# IAM
module "iam" {
  source = "../../modules/iam"

  bucket_arn = module.s3_bucket.bucket_arn
}

# CloudWatch
module "cloudwatch" {
  source = "../../modules/cloudwatch"
}

# ALB with staging domain + cert
module "alb" {
  source = "../../modules/alb"

  vpc_id         = module.networking.vpc_id
  public_subnets = module.networking.public_subnets
  alb_sg         = module.networking.alb_sg_id

  domain_name     = "umami-analytics.co.uk"
 certificate_arn = "arn:aws:acm:eu-west-2:111810594106:certificate/69d60269-82aa-4a03-ac73-3598f5537daf"

}

# ECS cluster + Umami service
module "ecs" {
  source = "../../modules/ecs"

  vpc_id                  = module.networking.vpc_id
  private_subnets         = module.networking.private_subnets
  ecs_sg_id               = module.networking.ecs_sg_id
  target_group_arn        = module.alb.alb_target_group_arn
  image_pull_arn          = module.iam.image_pull_arn
  cloudwatch              = module.cloudwatch.cloudwatch
  secret_db_arn           = module.iam.secret_db_arn
  secret_db_task_role_arn = module.iam.secret_db_task_role_arn
}

# waf module 

module "waf" {
  source = "../../modules/waf"

  alb_arn             = module.alb.alb_arn
  cloudwatch_waf_logs = module.cloudwatch.cloudwatch_waf_logs
}


variable "environment" {
  type = string
  default = "staging"
}
