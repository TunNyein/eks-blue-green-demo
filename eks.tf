resource "aws_eks_cluster" "eks" {
  name     = "${var.vpc_prefix}-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks_version

  
  access_config {
    authentication_mode = "API"     # or "API_AND_CONFIG_MAP" or "CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {
    subnet_ids = [
      aws_subnet.private_subnet01.id,
      aws_subnet.private_subnet02.id,
    ]


    endpoint_public_access  = true   # set to false if private-only
    endpoint_private_access = true   # recommended

    security_group_ids = [aws_security_group.eks_cluster_sg.id]
    

    # Only allowed IPs for public API access
    public_access_cidrs = var.allowed_api_cidrs

  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy
  ]
}
