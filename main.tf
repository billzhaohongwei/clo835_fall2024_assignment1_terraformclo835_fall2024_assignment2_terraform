# CLO835 - Assignment 1

#  Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

locals {
  default_tags = merge(var.defaultTags, { "env" = var.env })
}

# Retrieve the default VPC ID
data "aws_vpc" "default" {
  default = true
}

# Adding SSH key to Amazon EC2
resource "aws_key_pair" "webKey" {
  key_name   = var.keyName
  public_key = file("${var.keyName}.pub")
}

# Create VM1 in public subnet 1 as displayed in Architecture Diagram
resource "aws_instance" "webServer1" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = lookup(var.instanceType, var.env)
  key_name      = aws_key_pair.webKey.key_name
  //  subnet_id                   = data.aws_subnet.public_subnet.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.my_sg.id]
  user_data                   = file("${path.root}/install_docker.sh")
  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-${var.env}-Webserver1"
    }
  )
}

# Security Group
resource "aws_security_group" "my_sg" {
  name        = "allow_ssh_http"
  description = "Allow SSH and http inbound traffic on specific ports"
  vpc_id      = data.aws_vpc.default.id

  # Allow SSH traffic from everywhere
  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Allow HTTP traffic on port 8081
  ingress {
    description      = "Allow HTTP traffic on port 8081"
    from_port        = 8081
    to_port          = 8081
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # Allow from anywhere (use cautiously)
    ipv6_cidr_blocks = ["::/0"]
  }

  # Allow HTTP traffic on port 8082
  ingress {
    description      = "Allow HTTP traffic on port 8082"
    from_port        = 8082
    to_port          = 8082
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # Allow from anywhere (use cautiously)
    ipv6_cidr_blocks = ["::/0"]
  }

  # Allow HTTP traffic on port 8083
  ingress {
    description      = "Allow HTTP traffic on port 8083"
    from_port        = 8083
    to_port          = 8083
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # Allow from anywhere (use cautiously)
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-sg"
    }
  )
}

# Create AWS ECR repository to store webapp images
resource "aws_ecr_repository" "webapp_repo" {
  name                 = "clo835-assignment1-webapp-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Create AWS ECR repository to store MYSQL images
resource "aws_ecr_repository" "mysql_repo" {
  name                 = "clo835-assignment1-mysql-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}