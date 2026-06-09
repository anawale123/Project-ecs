
# UMAMI APPLICATION VPC
resource "aws_vpc" "vpc_app" {
    cidr_block  = var.vpc_cidr

  tags = {
    Environment = var.environment
  }
}

