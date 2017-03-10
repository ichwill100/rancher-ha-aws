resource "aws_vpc" "rancher" {
  cidr_block           = "172.16.0.0/20"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags {
    Name        = "rancher"
    Environment = "production"
    Terraform   = "True"
  }
}

output "vpc-id" {
  value = "${aws_vpc.rancher.id}"
}
