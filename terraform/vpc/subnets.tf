resource "aws_subnet" "rancher-prod-rds-a" {
  vpc_id                  = "${aws_vpc.rancher.id}"
  cidr_block              = "172.16.0.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = true

  tags {
    Name        = "rancher-prod-rds-a"
    Environment = "production"
    Terraform   = "True"
  }
}

resource "aws_subnet" "rancher-prod-rds-b" {
  vpc_id                  = "${aws_vpc.rancher.id}"
  cidr_block              = "172.16.2.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true

  tags {
    Name        = "rancher-prod-rds-b"
    Environment = "production"
    Terraform   = "True"
  }
}

resource "aws_subnet" "rancher-dev-rds-a" {
  vpc_id                  = "${aws_vpc.rancher.id}"
  cidr_block              = "172.16.4.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = true

  tags {
    Name        = "rancher-dev-rds-a"
    Environment = "development"
    Terraform   = "True"
  }
}

resource "aws_subnet" "rancher-dev-rds-b" {
  vpc_id                  = "${aws_vpc.rancher.id}"
  cidr_block              = "172.16.6.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true

  tags {
    Name        = "rancher-dev-rds-b"
    Environment = "development"
    Terraform   = "True"
  }
}

resource "aws_subnet" "rancher-prod" {
  vpc_id                  = "${aws_vpc.rancher.id}"
  cidr_block              = "172.16.8.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true

  tags {
    Name        = "rancher-prod"
    Environment = "production"
    Terraform   = "True"
  }
}

resource "aws_subnet" "rancher-dev" {
  vpc_id                  = "${aws_vpc.rancher.id}"
  cidr_block              = "172.16.10.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true

  tags {
    Name        = "rancher-dev"
    Environment = "development"
    Terraform   = "True"
  }
}
