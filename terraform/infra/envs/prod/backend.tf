terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "backend-state-prod"
    key            = "prod/networking/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "tf-locks"
    encrypt        = true
  }
}

