variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "aws_profile" {
  type    = string
  default = "eks-admin"
}

variable "vpc_address_space" { type = string }
variable "vpc_prefix" { type = string }
variable "vpc_environment" { type = string }
variable "vpc_public_subnet_cidr" { type = list(string) }
variable "vpc_private_subnet_cidr" { type = list(string) }

variable "cluster_blue_name" { type = string }
variable "cluster_green_name" { type = string }

variable "eks_version" { type = string }
variable "node_instance_type" { type = string }
variable "desired_capacity" { type = number }
variable "max_capacity" { type = number }
variable "min_capacity" { type = number }

# variable "hosted_zone_id" { type = string }
variable "acm_domain_name" { type = string }
variable "hosted_zone_domain_name" {type = string}

