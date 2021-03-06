##################################################
# AWS VPC Network - AWS VPC, IGW/NGW, EIP, 
# Public/Private Subnets, Route Tables and Table Association
##################################################

resource "aws_vpc" "api_ecs_vpc" {
  cidr_block = var.vpc_allocation
}

resource "aws_subnet" "api_ecs_public_subnet1" {
  vpc_id     = "${aws_vpc.api_ecs_vpc.id}"
  availability_zone = var.availability_primary_zone
  cidr_block = var.public_subnet1
}

resource "aws_subnet" "api_ecs_public_subnet_lb" {
  vpc_id                  = aws_vpc.api_ecs_vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true
}

resource "aws_route_table" "api_ecs_public_lb" {
  vpc_id = aws_vpc.api_ecs_vpc.id
}

resource "aws_route" "api_public_route_lb" {
  route_table_id         = aws_route_table.api_ecs_public_lb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.api_ecs_igw.id
}

resource "aws_route_table_association" "api_public_route_association" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.api_ecs_public_subnet_lb.*.id, count.index)
  route_table_id = aws_route_table.api_ecs_public_lb.id
}

resource "aws_subnet" "api_ecs_private_subnet1" {
  vpc_id     = "${aws_vpc.api_ecs_vpc.id}"
  availability_zone = var.availability_primary_zone
  cidr_block = var.private_subnet1
}

resource "aws_internet_gateway" "api_ecs_igw" {
  vpc_id = "${aws_vpc.api_ecs_vpc.id}"
}

resource "aws_route_table" "api_ecs_route_table" {
  vpc_id = "${aws_vpc.api_ecs_vpc.id}"
}

resource aws_route "api_ecs_public_route" {
  route_table_id         = "${aws_route_table.api_ecs_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.api_ecs_igw.id}"
}

resource "aws_route_table_association" "api_ecs_route_table_association1" {
  subnet_id      = "${aws_subnet.api_ecs_public_subnet1.id}"
  route_table_id = "${aws_route_table.api_ecs_route_table.id}"
}

resource "aws_eip" "api_elastic_ip" {
  vpc = true
}

resource "aws_nat_gateway" "api_ecs_ngw" {
  allocation_id = "${aws_eip.api_elastic_ip.id}" 
  subnet_id = "${aws_subnet.api_ecs_public_subnet1.id}" 
}

resource "aws_route_table" "api_ngw_route_table" {
  vpc_id = "${aws_vpc.api_ecs_vpc.id}"
}

resource aws_route "api_ngw_route" {
  route_table_id         = "${aws_route_table.api_ngw_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_nat_gateway.api_ecs_ngw.id}"
}

resource "aws_route_table_association" "api_ngw_route_table_association1" {
  subnet_id      = "${aws_subnet.api_ecs_private_subnet1.id}"
  route_table_id = "${aws_route_table.api_ngw_route_table.id}"
}

resource "aws_route_table" "api_vpce_route_table" {
  vpc_id = "${aws_vpc.api_ecs_vpc.id}"
}

resource aws_route "api_vpce_route" {
  route_table_id         = "${aws_route_table.api_vpce_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_nat_gateway.api_ecs_ngw.id}"
}
