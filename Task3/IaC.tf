provider "aws" {}
variable "centos-ami" {
  default = "ami-0005dd1bdf84d89d0"
}

variable "ubuntu-ami" {
  default = "ami-0d527b8c289b4af7f"
}

### EC2 INSTANCES ###

# Centos
resource "aws_instance" "instance_1" {
  ami                    = var.centos-ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.SG_instance_1.id}"]
  subnet_id              = aws_subnet.prod-subnet-private.id
  user_data              = file("./user_data_1.sh")
  tags = {
    Name = "instance-1.tf"
  }
}

# Ubuntu
resource "aws_instance" "instance_2" {
  ami                    = var.ubuntu-ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.SG_instance_2.id}"]
  subnet_id              = aws_subnet.prod-subnet-public.id
  user_data              = file("./user_data_2.sh")
  tags = {
    Name = "instance-2.tf"
  }
}

### VPC ###

resource "aws_vpc" "prod-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  instance_tenancy     = "default"
  tags = {
    Name = "prod-vpc"
  }
}

### SUBNETS ###

# PRIVATE SUBNET

resource "aws_subnet" "prod-subnet-private" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-central-1a"
  tags = {
    Name = "prod-subnet-private"
  }
}

# PUBLIC SUBNET

resource "aws_subnet" "prod-subnet-public" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true" // if false, makes subnet private
  availability_zone       = "eu-central-1b"
  tags = {
    Name = "prod-subnet-public"
  }
}


### INTERNET GATEWAY ###
resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.prod-vpc.id
  tags = {
    Name = "prod-igw"
  }
}

### ROUTE TABLES ###

#Public
resource "aws_route_table" "prod-public-rtb" {
  vpc_id = aws_vpc.prod-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod-igw.id
  }
  tags = {
    Name = "prod-public-rtb"
  }
}

# ASSOCIATE RTB TO SUBNET

#Public
resource "aws_route_table_association" "prod-rtb-public-subnet" {
  subnet_id      = aws_subnet.prod-subnet-public.id
  route_table_id = aws_route_table.prod-public-rtb.id
}

### SECURITY GROUPS ###

# SG for Centos
resource "aws_security_group" "SG_instance_1" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "SG | instance_1"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.prod-vpc.cidr_block}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.prod-vpc.cidr_block}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.prod-vpc.cidr_block}"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${aws_vpc.prod-vpc.cidr_block}"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.prod-vpc.cidr_block}"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.prod-vpc.cidr_block}"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.prod-vpc.cidr_block}"]
  }

  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${aws_vpc.prod-vpc.cidr_block}"]
  }
}


# SG for Ubuntu
resource "aws_security_group" "SG_instance_2" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "SG | instance_2"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
