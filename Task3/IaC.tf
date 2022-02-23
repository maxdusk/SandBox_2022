provider "aws" {}

variable "centos-ami" {
  default = "ami-0005dd1bdf84d89d0"
}

variable "ubuntu-ami" {
  default = "ami-0d527b8c289b4af7f"
}

# Centos
resource "aws_instance" "instance_1" {
  ami                    = var.centos-ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.SG_instance_1.id]
  user_data              = file("./user_data_1.sh")
  tags = {
    Name = "instance-1.tf"
  }
}

# Ubuntu
resource "aws_instance" "instance_2" {
  ami                    = var.ubuntu-ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.SG_instance_2.id]
  user_data              = file("./user_data_2.sh")
  tags = {
    Name = "instance-2.tf"
  }

}
# output "ip_internal" {
#   value     = "$${curl http://169.254.169.254/latest/meta-data/local-ipv4}"
#   sensitive = true

# SG for Centos
resource "aws_security_group" "SG_instance_1" {
  tags = {
    Name = "SG | instance_1"
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${aws_instance.instance_2.private_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${aws_instance.instance_2.private_ip}/32"]
  }


}

# SG for Ubuntu
resource "aws_security_group" "SG_instance_2" {
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
    from_port   = 433
    to_port     = 433
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
