variable "aws-credentials-profile" {}
variable "state-bucket" {}
variable "vpn-cidr" {}

provider "aws" {
  profile = "${var.aws-credentials-profile}"
}

data "aws_availability_zones" "available" {}

data "terraform_remote_state" "vpc" {
    backend = "s3"
    config {
        bucket = "${var.state-bucket}"
        key = "vpc.tfstate"
    }
}
