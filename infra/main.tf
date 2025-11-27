module "vpc" {
  source = "./vpc"

  vpc_address_space         = var.vpc_address_space
  vpc_prefix                = var.vpc_prefix
  vpc_environment           = var.vpc_environment
  vpc_public_subnet_cidr    = var.vpc_public_subnet_cidr
  vpc_private_subnet_cidr   = var.vpc_private_subnet_cidr
}

module "eks_blue" {
  source = "./eks"

  cluster_name       = var.cluster_blue_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  eks_version        = var.eks_version
  node_instance_type = var.node_instance_type
  desired_capacity   = var.desired_capacity
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
}

module "eks_green" {
  source = "./eks"

  cluster_name       = var.cluster_green_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  eks_version        = var.eks_version
  node_instance_type = var.node_instance_type
  desired_capacity   = var.desired_capacity
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
}

module "acm" {
  source = "./acm"

  acm_domain_name = var.acm_domain_name
  hosted_zone_domain_name = var.hosted_zone_domain_name
}
