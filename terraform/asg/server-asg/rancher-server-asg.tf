data "aws_ami" "prod-rancher-server-ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["rancher-server_*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["${var.secrets["aws_account_id"] }"]
}

resource "aws_launch_configuration" "prod-rancher-server" {
  name_prefix          = "prod-rancher-server_"
  image_id             = "${data.aws_ami.prod-rancher-server-ami.id}"
  instance_type        = "m3.large"
  user_data            = "${file("prod-rancher-server-userdata.sh")}"
  security_groups      = ["${data.terraform_remote_state.sgs.prod-rancher-sg}"]
  key_name             = "${var.secrets["provisioner_latest"] }"
  iam_instance_profile = "${aws_iam_instance_profile.prod-rancher-server.id}"

  lifecycle {
    create_before_destroy = true
  }

  ephemeral_block_device {
    "device_name"  = "/dev/xvdb"
    "virtual_name" = "ephemeral0"
  }
}

resource "aws_autoscaling_group" "prod-rancher-control" {
  availability_zones   = [
    "${data.aws_availability_zones.available.names[1]}",
    "${data.aws_availability_zones.available.names[2]}"
  ]
  name                 = "prod-rancher-control"
  max_size             = 3
  min_size             = 3
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.prod-rancher-server.name}"
  termination_policies = ["OldestInstance"]
  vpc_zone_identifier  = [
    "${data.terraform_remote_state.vpc.prod-rancher-snet-1}",
    "${data.terraform_remote_state.vpc.prod-rancher-snet-2}"
  ]
  load_balancers = [
    "${aws_elb.prod-rancher.name}"
  ]

  lifecycle {
    ignore_changes = ["max_size", "min_size"]
  }

  tag {
    key                 = "Name"
    value               = "prod-rancher-server"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "Production"
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "Ubuntu-Release"
    value               = "16.04"
    propagate_at_launch = true
  }
}
