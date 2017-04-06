terraform {
  backend "s3" {
    bucket = "rancher-ha-aws-tfstate"
    key    = "prod-rancher-rds.tfstate"
    region = "us-east-1"
  }
}