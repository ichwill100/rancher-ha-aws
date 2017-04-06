resource "aws_iam_role" "prod-rancher-server" {
    name = "prod-rancher-server"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "prod-rancher-server" {
    name = "prod-rancher-server"
    role = "${aws_iam_role.prod-rancher-server.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject",
        "s3:Get*",
        "s3:List*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "prod-rancher-server" {
    name = "prod-rancher-server"
    roles = ["${aws_iam_role.prod-rancher-server.name}"]
}
