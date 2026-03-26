

# PRIVATE ROUTE
resource "aws_route" "private_route" {
    route_table_id      =   aws_route_table.private_rt.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.nat_gw.id 
}

# PRIVATE ROUTE TABLE
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc_app.id

  tags = {
    Name = "private-route-table"
  }
}

# ROUTE TABLE ASSIOCIATION FOR PRIVATE ROUTES 
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_ecs.id
  route_table_id = aws_route_table.private_rt.id
}

# ROUTE TABLE ASSIOCIATION FOR PRIVATE ROUTE B
resource "aws_route_table_association" "private_assoc_b" {
  subnet_id      = aws_subnet.private_rds.id
  route_table_id = aws_route_table.private_rt.id
}
