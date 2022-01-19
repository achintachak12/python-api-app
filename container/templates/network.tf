##################################################
# AWS Network
##################################################

resource "aws_vpc" "api_vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_internet_gateway" "api_igw" {
  vpc_id = aws_vpc.api_vpc.id
}

resource "aws_subnet" "api_private" {
  vpc_id            = aws_vpc.api_vpc.id
  count             = length(var.private_subnets)
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)

}

resource "aws_subnet" "api_public" {
  vpc_id                  = aws_vpc.api_vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true

}

resource "aws_route_table" "api_public" {
  vpc_id = aws_vpc.api_vpc.id

}

resource "aws_route" "api_public" {
  route_table_id         = aws_route_table.api_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.api_igw.id
}

resource "aws_route_table_association" "api_public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.api_public.*.id, count.index)
  route_table_id = aws_route_table.api_public.id
}
