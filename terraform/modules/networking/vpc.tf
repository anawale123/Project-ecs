
# UMAMI APPLICATION VPC
resource "aws_vpc" "vpc_app" {
    cidr_block  = var.vpc_cidr

  tags = {
    Name = "umami VPC"
  }
}

