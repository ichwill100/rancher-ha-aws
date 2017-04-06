resource "null_resource" "cluster" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers {
    rancher_server_asg = "${aws_autoscaling_group.prod-rancher-control.name}"
  }

  provisioner "local-exec" {
    # Bootstrap script called with private_ip of each node in the clutser
    command = <<EOF
PYTHONPATH=. python configure-rancher-github-auth.py \
-u https://${var.secrets["prod_rancher_elb_url"] } \
-o ${var.secrets["github_org_id"] } \
-i ${var.secrets["oauth_client_id"] } \
-s ${var.secrets["oauth_client_secret"] } \
-p ${var.secrets["rancher_ping_timeout"] } \
-a ${var.secrets["rancher_admin_list"] }
EOF
  }
}
