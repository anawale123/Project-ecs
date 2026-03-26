
# PRIVATE ECS SUBNET
resource "aws_subnet" "private_ecs" {
  vpc_id     = aws_vpc.vpc_app.id
  cidr_block = var.private_ecs_cidr

  tags = {
    Name = "private-ecs"
  }
}


# PRIVATE RDS SUBNET
resource "aws_subnet" "private_rds" {
  vpc_id     = aws_vpc.vpc_app.id
  cidr_block = var.private_rds_cidr
   availability_zone = "eu-west-2a"

  tags = {
    Name = "private-rds-a"
  }
}

# PRIVATE RDS SUBNET B
resource "aws_subnet" "private_rds_b" {
  vpc_id     = aws_vpc.vpc_app.id
  cidr_block = var.private_rds_cidr_b
  availability_zone = "eu-west-2b"

  tags = {
    Name = "private-rds-b"
  }
}
