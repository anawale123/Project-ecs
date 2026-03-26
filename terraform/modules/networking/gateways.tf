
# INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_app.id

  tags = {
    Name = "main"
  }
}

# ELASTIC-IP
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

# NAT GW
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_natgateway.id

  tags = {
    Name = "gw NAT"
  }


  depends_on = [aws_internet_gateway.igw]
}