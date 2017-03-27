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

resource "aws_security_group_rule" "prod-rancher-alb--prod-rancher_jenkins" {
  type            = "ingress"
  from_port       = 8080
  to_port         = 8080
  protocol        = "tcp"
  source_security_group_id = "${aws_security_group.prod-rancher-alb.id}"
  security_group_id = "${aws_security_group.prod-rancher.id}"
}

resource "aws_security_group_rule" "vpn--prod-rancher_ssh" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["${var.vpn-cidr}"]
  security_group_id = "${aws_security_group.prod-rancher.id}"
}
