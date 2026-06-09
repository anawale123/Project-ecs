
# INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_app.id

  tags = {
    Environment = var.environment
    
  }
}

# ELASTIC-IP
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Environment = var.environment
    
  }
}

# NAT GW
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_natgateway.id

  tags = {
    Environment = var.environment
    
  }

  depends_on = [aws_internet_gateway.igw]
}