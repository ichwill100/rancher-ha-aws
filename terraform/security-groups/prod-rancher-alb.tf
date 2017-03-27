resource "aws_security_group" "prod-rancher-alb" {
    name                = "prod-rancher-alb"
    description         = "prod-rancher-alb"
    vpc_id              = "${data.terraform_remote_state.vpc.vpc-id}"

    tags {
        Name            = "prod-rancher-alb"
        Environment     = "prod"
        Terraform       = "True"
    }
}

resource "aws_security_group_rule" "everywhere--prod-rancher-alb_http" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.prod-rancher-alb.id}"
}

resource "aws_security_group_rule" "everywhere--prod-rancher-alb_https" {
  type            = "ingress"
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.prod-rancher-alb.id}"
}

resource "aws_security_group_rule" "prod-rancher-alb--everywhere_alltraffic" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.prod-rancher-alb.id}"
}
