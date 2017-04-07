# Rancher HA Deployment
This repo contains code for deploying a highly available Rancher cluster on AWS. It uses Packer, Ansible and Terraform. 

**warning - not free tier compatible**

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

###### Why not use a module?
This is a totally personal choice. We have a lot of `terraform apply`s triggered via automation and use of modules increases the potential blast radius of changes. It's certainly a tradeoff as you now need multiple applies to get the whole thing built and sometimes to propogate changes. Feel free to fork this repo if you think that's dumb!
