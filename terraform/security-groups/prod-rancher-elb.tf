resource "aws_security_group" "prod-rancher-elb" {
    name                = "prod-rancher-elb"
    description         = "prod-rancher-elb"
    vpc_id              = "${data.terraform_remote_state.vpc.vpc-id}"

    tags {
        Name            = "prod-rancher-elb"
        Environment     = "prod"
        Terraform       = "True"
    }
}

output "prod-rancher-elb-sg" {
    value = "${aws_security_group.prod-rancher-elb.id}"
}

resource "aws_security_group_rule" "everywhere--prod-rancher-elb_https" {
  type            = "ingress"
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.prod-rancher-elb.id}"
}

resource "aws_security_group_rule" "prod-rancher-elb--everywhere_alltraffic" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.prod-rancher-elb.id}"
}
