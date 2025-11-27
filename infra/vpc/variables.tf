variable "vpc_address_space" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_prefix" {
  description = "Prefix for naming VPC resources"
  type        = string
}

variable "vpc_environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_public_subnet_cidr" {
  type        = list(string)
  description = "List of public subnet CIDRs."
}

variable "vpc_private_subnet_cidr" {
  type        = list(string)
  description = "List of private subnet CIDRs."
}
