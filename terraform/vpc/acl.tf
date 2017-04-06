resource "aws_network_acl" "rancher-prod-rds" {
  vpc_id     = "${aws_vpc.rancher.id}"
  subnet_ids = [
    "${aws_subnet.rancher-prod-rds-a.id}",
    "${aws_subnet.rancher-prod-rds-b.id}"
  ]

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 100
    action     = "deny"
    protocol   = "-1"
    cidr_block = "${aws_subnet.rancher-dev-rds-a.cidr_block}"
  }

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 110
    action     = "deny"
    protocol   = "-1"
    cidr_block = "${aws_subnet.rancher-dev-rds-b.cidr_block}"
  }

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 120
    action     = "deny"
    protocol   = "-1"
    cidr_block = "${aws_subnet.rancher-dev.cidr_block}"
  }

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 200
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  egress {
    from_port  = 0
    to_port    = 0
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  tags {
    Name        = "rancher-prod-rds-a"
    Environment = "rancher-prod-rds"
    Terraform   = "True"
  }
}

resource "aws_network_acl" "rancher-dev-rds" {
  vpc_id     = "${aws_vpc.rancher.id}"
  subnet_ids = [
    "${aws_subnet.rancher-dev-rds-a.id}",
    "${aws_subnet.rancher-dev-rds-b.id}"
  ]

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 100
    action     = "deny"
    protocol   = "-1"
    cidr_block = "${aws_subnet.rancher-prod-rds-a.cidr_block}"
  }

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 110
    action     = "deny"
    protocol   = "-1"
    cidr_block = "${aws_subnet.rancher-prod-rds-b.cidr_block}"
  }

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 120
    action     = "deny"
    protocol   = "-1"
    cidr_block = "${aws_subnet.rancher-prod-1.cidr_block}"
  }

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 130
    action     = "deny"
    protocol   = "-1"
    cidr_block = "${aws_subnet.rancher-prod-2.cidr_block}"
  }

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 200
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  egress {
    from_port  = 0
    to_port    = 0
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  tags {
    Name        = "rancher-dev-rds-a"
    Environment = "rancher-dev-rds"
    Terraform   = "True"
  }
}

resource "aws_network_acl" "rancher-prod" {
  vpc_id     = "${aws_vpc.rancher.id}"
  subnet_ids = [
    "${aws_subnet.rancher-prod-1.id}",
    "${aws_subnet.rancher-prod-2.id}"
  ]

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 100
    action     = "deny"
    protocol   = "-1"
    cidr_block = "${aws_subnet.rancher-dev-rds-a.cidr_block}"
  }

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 110
    action     = "deny"
    protocol   = "-1"
    cidr_block = "${aws_subnet.rancher-dev-rds-b.cidr_block}"
  }

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 120
    action     = "deny"
    protocol   = "-1"
    cidr_block = "${aws_subnet.rancher-dev.cidr_block}"
  }

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 200
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  egress {
    from_port  = 0
    to_port    = 0
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  tags {
    Name        = "rancher-prod"
    Environment = "rancher-prod"
    Terraform   = "True"
  }
}

resource "aws_network_acl" "rancher-dev" {
  vpc_id     = "${aws_vpc.rancher.id}"
  subnet_ids = ["${aws_subnet.rancher-dev.id}"]

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 100
    action     = "deny"
    protocol   = "-1"
    cidr_block = "${aws_subnet.rancher-prod-rds-a.cidr_block}"
  }

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 110
    action     = "deny"
    protocol   = "-1"
    cidr_block = "${aws_subnet.rancher-prod-rds-b.cidr_block}"
  }

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 120
    action     = "deny"
    protocol   = "-1"
    cidr_block = "${aws_subnet.rancher-prod-1.cidr_block}"
  }

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 130
    action     = "deny"
    protocol   = "-1"
    cidr_block = "${aws_subnet.rancher-prod-2.cidr_block}"
  }

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 200
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  egress {
    from_port  = 0
    to_port    = 0
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  tags {
    Name        = "rancher-dev"
    Environment = "rancher-dev"
    Terraform   = "True"
  }
}
