terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.19.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
    
}

module "networking" {
  source = "../../modules/networking"
}

module "iam" {
 source = "../../modules/iam"
}

module "cloudwatch" {
 source = "../../modules/cloudwatch" 
}

module "alb" {
  source = "../../modules/alb"

  vpc_id         = module.networking.vpc_id
  public_subnets = module.networking.public_subnets
  alb_sg         = module.networking.alb_sg_id
}

module "ecs" {
  source = "../../modules/ecs"

  vpc_id           = module.networking.vpc_id
  private_subnets  = module.networking.private_subnets
  ecs_sg_id        = module.networking.ecs_sg_id
  target_group_arn = module.alb.alb_target_group_arn
  image_pull_arn   = module.iam.image_pull_arn
  cloudwatch      = module.cloudwatch.cloudwatch


  db_port     = module.rds.rds_port
  db_name     = module.rds.rds_db_name
  db_username = module.rds.rds_username
  db_password = module.rds.rds_password
  app_secret = "mysupersecret" 



}

module "rds" {
  source = "../../modules/rds"

  vpc_id               = module.networking.vpc_id
  private_rds  = module.networking.private_rds  
  rds_sg               = module.networking.mysql_sg_id 

}


variable "environment" {
  type = string
  default = "dev"
}


