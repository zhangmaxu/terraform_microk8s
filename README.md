# terraform_microk8s

# Purpose
This code is for creating AWS microk8s environment.
Before running this code, please prepare actions below.

## Stage 1:
Install terraform environment

Mac:
Brew install terraform

Windows:
386 platform:
https://releases.hashicorp.com/terraform/1.3.6/terraform_1.3.6_windows_386.zip
AMD64 platform 
https://releases.hashicorp.com/terraform/1.3.6/terraform_1.3.6_windows_amd64.zip
Step 1: unzip terraform_1.3.6_windows_xx.zip
step 2: From the download, extract the executable to a directory of your choosing (for example, c:\terraform)
step 3: set environmet variables
step 4: open a terminal window
step 5: verify the evironment variable path configuration with terrafrom command "terraform -version"


Linux:
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform

please refer to terraform download link for other Platforms 
ref:
https://developer.hashicorp.com/terraform/downloads

## Stage 2 
2.1 Install awscli environment
Mac:
brew install awscli

Windows:
step 1: download AWSCLIV2.msi from link or run command "msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi" on terminal windows 
ref. https://awscli.amazonaws.com/AWSCLIV2.msi
step 2: double click AWSCLIV2.msi
step 3: follow the indicate to install AWSCLIV2.msi
step 4: open termial windows
step 4: verify AWS configure with aws command "aws --version"
ref:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

2.2 Create Access key ID and Secret access key which will be need in next actions
2.2.1 Sign in to the AWS Management Console and open the IAM console at https://console.aws.amazon.com/iam/.
2.2.2 In the navigation pane, choose Users.
2.2.3 Choose the name of the user whose access keys you want to create, and then choose the Security credentials tab.
2.2.4 In the Access keys section, choose Create access key.
2.2.5 To view the new access key pair, choose Show. You will not have access to the secret access key again after this dialog box closes. Your credentials will look something like this:
Access key ID: AKIAIOSFODNN7EXAMPLE
Secret access key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
2.2.6 To download the key pair, choose Download .csv file. Store the keys in a secure location. You will not have access to the secret access key again after this dialog box closes.
Keep the keys confidential in order to protect your AWS account and never email them. Do not share them outside your organization, even if an inquiry appears to come from AWS or Amazon.com. No one who legitimately represents Amazon will ever ask you for your secret key.
2.2.7 After you download the .csv file, choose Close. When you create an access key, the key pair is active by default, and you can use the pair right away.


2.3 Configure AWS 
aws configure
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE(e.g.)
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY(e.g.)
Default region name [None]: us-west-2(inout which aws region you want to login)
Default output format [None]: json

## Stage 3
3.1 Navigate to /Prod path
3.2 run common command below


## common command 
terraform init
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve