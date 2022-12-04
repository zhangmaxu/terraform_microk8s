# terraform_microk8s

# Purpose
This code is for creating AWS microk8s environment.
Before running this code, please prepare actions below.

## Stage 1:
Install terraform environment
Mac:
Brew install terraform
ref:
https://developer.hashicorp.com/terraform/downloads

## Stage 2 
Install awscli environment
Mac:
brew install awscli
ref:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
command:
aws configure

## Stage 3
3.1 Natibe to /Prod path
3.2 run common command below


## common command 
terraform init
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve