# General
variable "aws_region" {
  description = "AWS region to deploy EKS cluster"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_profile" {
  description = "AWS CLI profile name"
  type        = string
  default     = "eks-admin"
}

# VPC
variable "vpc_address_space" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "vpc_prefix" {
  description = "Prefix for naming VPC resources"
  type        = string
  default     = "eks"
}

variable "vpc_environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "vpc_public_subnet_cidr" {
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  description = "List of public subnet CIDRs."
}

variable "vpc_private_subnet_cidr" {
  type        = list(string)
  default     = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
  description = "List of private subnet CIDRs."
}

# EKS Config

variable "eks_version" {
  type        = string
  default     = "1.33"   
  description = "EKS Kubernetes version"
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 2
}

variable "min_capacity" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 2
}

# variable "allowed_api_cidrs" {
#   type    = list(string)
#   description = "List of CIDR blocks allowed to access the cluster"
#   default = ["203.0.113.10/32"]  # Replace with your allowed IP(s)
# }
  


# variable "ec2_ssh_keypair_name" {
#   type        = string
#   description = "Name of an existing EC2 key pair for SSH access"
#   default     = "aws-vpc-keypair" 

# }