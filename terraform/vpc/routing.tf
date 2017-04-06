resource "aws_internet_gateway" "rancher-igw" {
  vpc_id = "${aws_vpc.rancher.id}"

  tags {
    Name        = "rancher"
    Environment = "rancher"
    Terraform   = "True"
  }
}

resource "aws_route_table" "rancher" {
  vpc_id = "${aws_vpc.rancher.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.rancher-igw.id}"
  }

  tags {
    Name        = "rancher"
    Environment = "rancher"
    Terraform   = "True"
  }
}

resource "aws_route_table_association" "rancher-prod-rds-a" {
  subnet_id      = "${aws_subnet.rancher-prod-rds-a.id}"
  route_table_id = "${aws_route_table.rancher.id}"
}

resource "aws_route_table_association" "rancher-prod-rds-b" {
  subnet_id      = "${aws_subnet.rancher-prod-rds-b.id}"
  route_table_id = "${aws_route_table.rancher.id}"
}

resource "aws_route_table_association" "rancher-dev-rds-a" {
  subnet_id      = "${aws_subnet.rancher-dev-rds-a.id}"
  route_table_id = "${aws_route_table.rancher.id}"
}

resource "aws_route_table_association" "rancher-dev-rds-b" {
  subnet_id      = "${aws_subnet.rancher-dev-rds-b.id}"
  route_table_id = "${aws_route_table.rancher.id}"
}

resource "aws_route_table_association" "rancher-prod-1" {
  subnet_id      = "${aws_subnet.rancher-prod-1.id}"
  route_table_id = "${aws_route_table.rancher.id}"
}

resource "aws_route_table_association" "rancher-prod-2" {
  subnet_id      = "${aws_subnet.rancher-prod-2.id}"
  route_table_id = "${aws_route_table.rancher.id}"
}

resource "aws_route_table_association" "rancher-dev" {
  subnet_id      = "${aws_subnet.rancher-dev.id}"
  route_table_id = "${aws_route_table.rancher.id}"
}
