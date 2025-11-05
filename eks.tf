#------------------------------------------------------------------------------
# EKS Cluster
#------------------------------------------------------------------------------
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.vpc_prefix}-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids = [
      aws_subnet.private_subnet01.id,
      aws_subnet.private_subnet02.id
      
    ]
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy1,
    aws_iam_role_policy_attachment.eks_cluster_policy2
  ]

  tags = {
    Name = "${var.vpc_prefix}-eks-cluster"
  }
}

#------------------------------------------------------------------------------
# EKS Node Group (Managed)
#------------------------------------------------------------------------------
resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.vpc_prefix}-eks-nodes"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  # Nodes will run in Private Subnets (01, 02)
  subnet_ids = [
    aws_subnet.private_subnet01.id,
    aws_subnet.private_subnet02.id
  ]

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_capacity
    min_size     = var.min_capacity
  }

  instance_types = [var.node_instance_type]
  disk_size      = 20

  # remote_access {
  #   ec2_ssh_key = var.ec2_ssh_keypair_name
  # }

  tags = {
    Name = "${var.vpc_prefix}-eks-nodegroup"
  }

  depends_on = [
    aws_eks_cluster.eks_cluster
    # aws_iam_role_policy_attachment.node_policy1,
    # aws_iam_role_policy_attachment.node_policy2,
    # aws_iam_role_policy_attachment.node_policy3,
    # aws_iam_role_policy_attachment.node_policy4
  ]
}