provider "aws" {
  region = "us-east-1"
}

# 1. Get Default VPC and Subnet
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# 2. Security Group
resource "aws_security_group" "clipper_sg" {
  name        = "clipper-app-sg"
  description = "Allow web and ssh traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
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

# 3. EC2 Instance
resource "aws_instance" "clipper_app" {
  ami           = "ami-051f8b884c0509276" # Amazon Linux 2023 AMI
  instance_type = "t3.micro"
  
  vpc_security_group_ids = [aws_security_group.clipper_sg.id]
  
  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y docker git
              service docker start
              usermod -a -G docker ec2-user
              
              # Install Docker Compose
              curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              
              # Clone and Run
              git clone https://github.com/clipper-ma-2118/clipper-workspace.git /home/ec2-user/app
              cd /home/ec2-user/app
              docker-compose up -d
              EOF

  tags = {
    Name = "ClipperAppServer"
  }
}

output "public_ip" {
  value = aws_instance.clipper_app.public_ip
}
