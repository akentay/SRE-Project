# main.tf - MedBook SRE End Term Infrastructure
# Kentay Aida | SE-2428

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "medbook_sg" {
  name        = "medbook-sre-sg"
  description = "MedBook SRE Security Group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "MedBook Frontend"
  }
  ingress {
    from_port   = 3000
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Backend API and Grafana"
  }
  ingress {
    from_port   = 9090
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Prometheus, Alertmanager"
  }
  ingress {
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    description = "Docker Swarm manager"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "medbook-sg"
    Project = var.project_name
  }
}

resource "aws_instance" "medbook_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.medbook_sg.id]
  key_name               = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io docker-compose-plugin git curl ansible
    systemctl start docker && systemctl enable docker
    usermod -aG docker ubuntu
    docker swarm init --advertise-addr $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
  EOF

  tags = {
    Name    = "medbook-sre-server"
    Student = "Kentay-Aida-SE2428"
    Course  = "SRE-EndTerm-2026"
  }
}
