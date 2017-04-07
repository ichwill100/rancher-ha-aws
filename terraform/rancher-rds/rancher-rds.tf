resource "aws_db_instance" "prod-rancher-mysql" {
    identifier             = "prod-rancher-mysql"
    allocated_storage      = 20
    storage_type           = "gp2"
    engine                 = "mysql"
    engine_version         = "5.7.11"
    instance_class         = "db.t2.micro"
    name                   = "prodrancher"
    username               = "${var.secrets["rancher_rds_user"] }"
    password               = "${var.secrets["rancher_rds_pass"] }"
    port                   = 3306
    publicly_accessible    = true
    availability_zone      = "${data.aws_availability_zones.available.names[1]}"
    vpc_security_group_ids = [
        "${data.terraform_remote_state.sgs.prod-rds-sg}"
    ]
    db_subnet_group_name   = "${data.terraform_remote_state.vpc.prod-rds-snetgroup}"
    parameter_group_name   = "default.mysql5.7"
    multi_az               = true
    skip_final_snapshot    = true
    tags {
        Environment        = "production"
        Name               = "rancher-prod"
        Type               = "mysql"
        Terraform          = "true"
    }
}

resource "aws_route53_record" "rds" {
    zone_id = "${data.terraform_remote_state.r53-zone.tastycidr-r53-zoneid}"
    name    = "${var.secrets["rancher_rds_url"] }.${var.secrets["rancher_cname_domain"] }"
    type    = "CNAME"
    ttl     = "300"
    records = ["${aws_db_instance.prod-rancher-mysql.address}"]
}
