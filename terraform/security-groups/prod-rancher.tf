resource "aws_security_group" "prod-rancher" {
  name                = "prod-rancher"
  description         = "prod-rancher"
  vpc_id              = "${data.terraform_remote_state.vpc.vpc-id}"

  tags {
    Name            = "prod-rancher"
    Environment     = "prod"
    Terraform       = "True"
  }
}

output "prod-rancher-sg" {
    value = "${aws_security_group.prod-rancher.id}"
}

resource "aws_security_group_rule" "prod-rancher-elb--prod-rancher_jenkins" {
  type            = "ingress"
  from_port       = 8080
  to_port         = 8080
  protocol        = "tcp"
  source_security_group_id = "${aws_security_group.prod-rancher-elb.id}"
  security_group_id = "${aws_security_group.prod-rancher.id}"
}

resource "aws_security_group_rule" "prod-rancher--allow-clustering-internal" {
  type            = "ingress"
  from_port       = 9345
  to_port         = 9345
  protocol        = "tcp"
  self            = true
  security_group_id = "${aws_security_group.prod-rancher.id}"
}

resource "aws_security_group_rule" "prod-rancher--allow-http-internal" {
  type            = "ingress"
  from_port       = 8080
  to_port         = 8080
  protocol        = "tcp"
  self            = true
  security_group_id = "${aws_security_group.prod-rancher.id}"
}

resource "aws_security_group_rule" "vpn--prod-rancher_ssh" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["${var.secrets["vpn_cidr"] }"]
  security_group_id = "${aws_security_group.prod-rancher.id}"
}

resource "aws_security_group_rule" "prod-rancher-allow-egress-everywhere" {
    type            = "egress"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.prod-rancher.id}"
}
