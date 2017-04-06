
resource "aws_security_group" "prod-rds" {
    name                = "prod-rds"
    description         = "prod-rds"
    vpc_id              = "${data.terraform_remote_state.vpc.vpc-id}"

    tags {
        Name            = "prod-rds"
        Environment     = "prod"
        Terraform       = "True"
    }
}

output "prod-rds-sg" {
    value = "${aws_security_group.prod-rds.id}"
}


resource "aws_security_group_rule" "vpn--prod-rds_mysql" {
  type            = "ingress"
  from_port       = 3306
  to_port         = 3306
  protocol        = "tcp"
  cidr_blocks     = ["${var.secrets["vpn_cidr"] }"]
  security_group_id = "${aws_security_group.prod-rds.id}"
}

resource "aws_security_group_rule" "prod-rancher--prod-rds_mysql" {
  type            = "ingress"
  from_port       = 3306
  to_port         = 3306
  protocol        = "tcp"
  source_security_group_id = "${aws_security_group.prod-rancher.id}"
  security_group_id = "${aws_security_group.prod-rds.id}"
}