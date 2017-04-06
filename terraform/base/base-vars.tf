variable "secrets" { type = "map" }

output "secrets" {
  value = "${var.secrets}"
}

provider "aws" {
  profile = "${var.secrets["aws_credentials_profile"] }"
}

data "aws_availability_zones" "available" {}

data "terraform_remote_state" "vpc" {
    backend = "s3"
    config {
        bucket = "${var.secrets["state_bucket"] }"
        key = "vpc.tfstate"
    }
}

data "terraform_remote_state" "sgs" {
    backend = "s3"
    config {
        bucket = "${var.secrets["state_bucket"] }"
        key = "security-groups.tfstate"
    }
}

data "terraform_remote_state" "r53-zone" {
    backend  =  "s3" 
    config {
        bucket = "${var.secrets["tc_state_bucket"] }"
        key    = "backend/r53-tastycidr.tfstate"
    }
}
