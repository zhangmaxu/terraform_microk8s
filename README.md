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
native to Prod > variables.tf
change the value of azs


## Stage 4
Confirm which region you want to depoly(e.g. "us-east-1a", "us-east-1b")
Please create key pair in advance 


