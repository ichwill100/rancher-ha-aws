variable "aws-credentials-profile" {}
variable "state-bucket" {}
data "aws_availability_zones" "available" {}

provider "aws" {
  profile = "${var.aws-credentials-profile}"
}
