# Allocate Elastic IP Address (EPI 1)
# terraform aws allocate elastic ip
resource "aws_eip" "eip-for-nat-gateway-1" {

  domain = "vpc"

  tags = {
    Name = "EIP 1"
  }
}

# Allocate Elastic IP Address (EPI 2)
# terraform aws allocate elastic ip
resource "aws_eip" "eip-for-nat-gateway-2" {


  domain = "vpc"

  tags = {
    Name = "EIP 2"
  }
}

# Create Nat Gateway 1 in Public Sunet 1
# terraform create aws nat gateway
resource "aws_nat_gateway" "nat-gateway-1" {
  allocation_id = aws_eip.eip-for-nat-gateway-1.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name = "Nat Gateway Public Subnte 1"
  }
}

# Create Nat Gateway 2 in Public Sunet 2
# terraform create aws nat gateway
resource "aws_nat_gateway" "nat-gateway-2" {
  allocation_id = aws_eip.eip-for-nat-gateway-2.id
  subnet_id     = aws_subnet.public-subnet-2.id

  tags = {
    Name = "Nat Gateway Public Subnte 2"
  }
}


# Create Private Route Table 1 and Add Route Through Nat Gateway 1
# terraform aws create route table
resource "aws_route_table" "private-route-table-1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gateway-1.id
  }

  tags = {
    Name = "Private Route Table 1"
  }
}

# Associate Private Subnet 1 with "Private Route Table 1"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "private-subnet-1-route-table-association" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-route-table-1.id

}

# Associate Private Subnet 3 with "Private Route Table 1"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "private-subnet-3-route-table-association" {
  subnet_id      = aws_subnet.private-subnet-3.id
  route_table_id = aws_route_table.private-route-table-1.id

}

# Create Private Route Table 2 and Add Route Through Nat Gateway 2
# terraform aws create route table
resource "aws_route_table" "private-route-table-2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gateway-2.id
  }

  tags = {
    Name = "Private Route Table 2"
  }
}

# Associate Private Subnet 2 with "Private Route Table 2"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "private-subnet-2-route-table-association" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-route-table-2.id

}

# Associate Private Subnet 4 with "Private Route Table 2"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "private-subnet-4-route-table-association" {
  subnet_id      = aws_subnet.private-subnet-4.id
  route_table_id = aws_route_table.private-route-table-2.id

}
