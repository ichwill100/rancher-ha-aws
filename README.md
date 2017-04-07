# Rancher HA Deployment
This repo contains code for deploying a highly available Rancher cluster on AWS. It uses Packer, Ansible and Terraform. 

###### It also integrates setup of Github OAuth Authentication - if you don't wish to use it, comment out the contents of terraform/asg/server-asg/github-auth.tf

## Usage:
1. git clone
2. pip install docopt
3. `cd ansible && ansible-galaxy install -r requirements.yml -p roles --force`
4. Build AMI - `cd packer && packer build rancher-server.json`
5. (OPTIONAL) create a github Oauth Application to use for signin
6. `mv secrets/example-secrets.json secrets/secrets.json` and populate it with your values
7. `terraform apply` the following:

- terraform/vpc
- terraform/security-groups
- terraform/rancher-rds
- terraform/asg (wait until RDS has finished)

Once Auth has finished setup, if you're using it, you should be ready to login. 