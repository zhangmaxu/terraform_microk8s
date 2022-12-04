terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    shell = {
      source  = "scottwinkler/shell"
      version = "~> 1.0"
    }
  }
  required_version = ">= 0.14.9"
}


#------------------------------------------
#create network environment
#------------------------------------------
resource "aws_vpc" "microk8s_demo" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "${local.owner}-vpc"
  }
}

//create ig
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.microk8s_demo.id

  tags = {
    Name = "${local.owner}-gw"
  }
}

//create subnet
resource "aws_subnet" "microk8s_demo" {
  count = random_shuffle.az.result_count

  vpc_id                  = aws_vpc.microk8s_demo.id
  cidr_block              = local.cidr_block[count.index]
  availability_zone       = random_shuffle.az.result[count.index]
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${local.owner}-subnet-${count.index}"
  }

}

//create route_tale
resource "aws_route_table" "microk8s_demo" {
  vpc_id = aws_vpc.microk8s_demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${local.owner}-microk8s_demo"
  }
}

//binding routetable  
resource "aws_route_table_association" "microk8s_demo" {
  # subnet_id      = aws_subnet.zivAugustsubnet.id
  subnet_id      = aws_subnet.microk8s_demo[0].id
  route_table_id = aws_route_table.microk8s_demo.id
}

#------------------------------------------
#create security group
#------------------------------------------

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.microk8s_demo.id

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.ext_ip_cidr_32]
  }

  ingress {
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.ext_ip_cidr_32]
  }

  ingress {
    description = "https from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.ext_ip_cidr_32]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.owner}-allow_ssh"
  }
}


resource "aws_lb" "microk8s_demo" {
  name                       = "${local.owner_alb[0]}-alb"
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.allow_ssh.id]
  subnets                    = [for subnet in aws_subnet.microk8s_demo : subnet.id]
  enable_deletion_protection = false
}

#------------------------------------------
#create keypair
#------------------------------------------

resource "tls_private_key" "microk8s_demo" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "microk8s_demo" {
  key_name   = local.owner
  public_key = tls_private_key.microk8s_demo.public_key_openssh

  tags = {
    name = "${local.owner}-key_pair"
  }
}

resource "local_sensitive_file" "microk8s_demo" {
  filename        = pathexpand(local.owner)
  file_permission = "0400"
  #   directory_permission = "700"
  # sensitive_content = tls_private_key.sa-demo.private_key_pem # local_file deprecated
  content = tls_private_key.microk8s_demo.private_key_pem
}


#------------------------------------------
#create ec2 instance
#------------------------------------------
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "microk8s_demo" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = var.instance_type
  availability_zone = random_shuffle.az.result[0]
  # subnet_id  = aws_subnet.zivAugustsubnet.id
  subnet_id              = aws_subnet.microk8s_demo[0].id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name               = local.owner
  user_data              = local.user_data
  root_block_device {
    volume_size = "20"
    volume_type = "gp3"
  }

  tags = {
    Name = "${local.owner}-microk8s_demo"
  }
}

#------------------------------------------
#create random_shuffle az
#------------------------------------------
resource "random_shuffle" "az" {
  #   input        = ["us-west-1a", "us-west-1c", "us-west-1d", "us-west-1e"]
  input = [for name in data.aws_availability_zones.available.names : name]

  result_count = 2
}



#------------------------------------------
#data resource
#------------------------------------------
data "aws_availability_zones" "available" {
  state = "available"
}

data "external" "current_ip" {
  program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
}

data "shell_script" "username" {
  lifecycle_commands {
    read = <<-EOF
        echo "{\"username\": \"$(whoami)\"}"
    EOF
  }
}

data "aws_region" "current" {}

locals {
  # azs        = ["us-east-1a", "us-east-1b"]
  owner          = data.shell_script.username.output["username"]
  owner_alb = split("_", data.shell_script.username.output["username"])
  cidr_block     = ["10.0.10.0/24", "10.0.20.0/24"]
  split_ext_ip   = split(".", data.external.current_ip.result.ip)
  ext_ip_cidr_32 = "${data.external.current_ip.result.ip}/32"
  user_data      = <<-EOF
#!/bin/bash
echo "Now Install Microk8s"
sudo snap install microk8s --classic --channel=1.18/stable
echo "Now Configure FW"
sudo ufw allow in on cni0 && sudo ufw allow out on cni0
sleep 1
sudo ufw default allow routed
sleep 1
echo "Now start microk8s service"
sudo microk8s start
sleep 2
microk8s enable dns dashboard storage
sleep 2
EOF
}
