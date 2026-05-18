# variables.tf — Input variable declarations for MedBook infrastructure
# Kentay Aida | SE-2428 | SRE Course 2026

variable "aws_region" {
  description = "AWS region where infrastructure will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance size (t3.medium = 2 vCPU, 4 GB RAM)"
  type        = string
  default     = "t3.medium"
}

variable "ami_id" {
  description = "Amazon Machine Image ID — Ubuntu 22.04 LTS in us-east-1"
  type        = string
  default     = "ami-0c7217cdde317cfec"
}

variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
  default     = "MedBook-SRE"
}
