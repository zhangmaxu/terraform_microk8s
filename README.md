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

## Stage 3
Confirm which region you want to depoly(e.g. "us-east-1a", "us-east-1b")

3.1 native to Prod > variables.tf
3.2 change the value of var.azs


## Stage 4
Confirm which region you want to depoly(e.g. "us-east-1a", "us-east-1b")
Please create key pair in advance 

4.1 copy the pem to path: /Prod/xxx.pem
4.2 copy the name of pem to /Prod/variables.tf > var.key_name 



## common command 
Terraform init
Terraform plan
Terraform apply -auto-approve
Terraform destroy -auto-approve