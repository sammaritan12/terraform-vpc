resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "private" {
  count             = var.subnet_amount
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.subnet_azs, count.index)
}

resource "aws_subnet" "public" {
  count             = var.subnet_amount
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.subnet_azs, count.index)
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "nat" {
  count = var.subnet_amount
}

resource "aws_nat_gateway" "private" {
  count         = var.subnet_amount
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table" "private" {
  count  = var.subnet_amount
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.private.*.id, count.index)
  }
}

resource "aws_route_table_association" "public" {
  count          = var.subnet_amount
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = var.subnet_amount
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
