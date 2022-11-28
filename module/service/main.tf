terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


#------------------------------------------
#create network environment
#------------------------------------------
resource "aws_vpc" "microk8s_demo" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.owner}-vpc"
  }
}

//create ig
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.microk8s_demo.id

  tags = {
    Name = "${var.owner}-gw"
  }
}

//create subnet
resource "aws_subnet" "microk8s_demo" {
  count = length(local.azs)

  vpc_id                  = aws_vpc.microk8s_demo.id
  cidr_block              = local.cidr_block[count.index]
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.owner}-subnet-${count.index}"
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
    Name = "${var.owner}-microk8s_demo"
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
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.owner}-allow_ssh"
  }
}


resource "aws_lb" "microk8s_demo" {
  name               = "${var.owner}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_ssh.id]
  subnets = [for subnet in aws_subnet.microk8s_demo : subnet.id]
  enable_deletion_protection = false
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
  availability_zone = local.azs[0]
  # subnet_id  = aws_subnet.zivAugustsubnet.id
  subnet_id              = aws_subnet.microk8s_demo[0].id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name               = var.key_name
  user_data              = local.user_data
  tags = {
    Name = "${var.owner}-microk8s_demo"
  }
}

locals {
  azs        = ["us-east-1a", "us-east-1b"]
  cidr_block = ["10.0.10.0/24", "10.0.20.0/24"]
  user_data  = <<-EOF
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
EOF
}
