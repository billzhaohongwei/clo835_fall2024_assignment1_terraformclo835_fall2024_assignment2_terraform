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

/*
# Get a public subnet in the default VPC
data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.default.id
}

# Use the first available subnet
data "aws_subnet" "public_subnet" {
  id = data.aws_subnet_ids.public.ids[0]
}
*/

# Adding SSH key to Amazon EC2
resource "aws_key_pair" "webKey" {
  key_name   = var.keyName
  public_key = file("${var.keyName}.pub")
}

# Create VM1 in public subnet 1 as displayed in Architecture Diagram
resource "aws_instance" "webServer1" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instanceType, var.env)
  key_name                    = aws_key_pair.webKey.key_name
//  subnet_id                   = data.aws_subnet.public_subnet.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.my_sg.id]
  //  user_data                   = file("${path.root}/install_httpd.sh")
  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-${var.env}-Webserver1"
    }
  )
}

/*
# Create VM2 in public subnet 2 as displayed in Architecture Diagram
resource "aws_instance" "webServer2" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instanceType, var.env)
  key_name                    = aws_key_pair.webKey.key_name
  subnet_id                   = data.aws_subnet.public_subnet.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.my_sg.id]
  //  user_data                   = file("${path.root}/install_httpd.sh")
  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-${var.env}-Webserver2"
    }
  )
}

# Create VM1 in public subnet 2 as displayed in Architecture Diagram
resource "aws_instance" "webServer3" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instanceType, var.env)
  key_name                    = aws_key_pair.webKey.key_name
  subnet_id                   = data.aws_subnet.public_subnet.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.my_sg.id]
  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-${var.env}-Webserver3"
    }
  )
}
*/

# Security Group
resource "aws_security_group" "my_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
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
