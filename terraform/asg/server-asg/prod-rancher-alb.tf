data "aws_acm_certificate" "prod-rancher-elb" {
  domain = "${var.secrets["prod_rancher_elb_url"] }"
  statuses = ["ISSUED"]
}

resource "aws_elb" "prod-rancher" {
  name                        = "prod-rancher"
  cross_zone_load_balancing   = false
  idle_timeout                = 900
  connection_draining         = false
  connection_draining_timeout = 300
  internal                    = false
  security_groups             = [
    "${data.terraform_remote_state.sgs.prod-rancher-elb-sg}"
  ]
  subnets                     = [
    "${data.terraform_remote_state.vpc.prod-rancher-snet-1}",
    "${data.terraform_remote_state.vpc.prod-rancher-snet-2}"
  ]

  listener {
    instance_port      = 8080
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${data.aws_acm_certificate.prod-rancher-elb.arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 15
    target              = "HTTP:8080/ping"
    timeout             = 10
  }

  tags {
    "ELBName" = "prod-rancher"
  }
}


resource "aws_route53_record" "prod-rancher-elb" {
    zone_id = "${data.terraform_remote_state.r53-zone.tastycidr-r53-zoneid}"
    name    = "${var.secrets["prod_rancher_elb_url"] }"
    type    = "CNAME"
    ttl     = "300"
    records = ["${aws_elb.prod-rancher.dns_name}"]
}
