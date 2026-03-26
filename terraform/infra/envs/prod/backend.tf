terraform {
  backend "s3" {
    bucket         = "backend-state-prod"
    key            = "prod/networking/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "tf-locks"
    encrypt        = true
  }
}
