#VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/24"
   tags = {
    Name = "MyVPC"
  }
}

#Subnets
resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/26"
  availability_zone = "us-east-1a"
tags = {
    Name = "MyPublicSubnet"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.64/26"
  availability_zone = "us-east-1b"
tags = {
    Name = "MyPublicSubnet"
  }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.128/26"
  availability_zone = "us-east-1a"
tags = {
    Name = "MyPrivateSubnet"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.192/26"
  availability_zone = "us-east-1b"
tags = {
    Name = "MyPrivateSubnet"
  }
}

#IGW
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
 tags = {
    Name = "MyIGW"
  }
}

#Route Tables
resource "aws_route_table" "rt_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
 tags = {
    Name = "RouteTable"
  }
}

resource "aws_route_table_association" "hello_association" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.rt_route_table.id
}

resource "aws_route_table_association" "hello_association_second" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.rt_route_table.id
}

resource "aws_eip" "elastic-ip" {}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.elastic-ip.id
  subnet_id     = aws_subnet.public_subnet1.id

tags = {
  Name = "gw NAT"
}
}

resource "aws_route_table" "rt_private_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

resource "aws_route_table_association" "nat-rt1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.rt_private_subnet.id
}

resource "aws_route_table_association" "nat-rt2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.rt_private_subnet.id
}