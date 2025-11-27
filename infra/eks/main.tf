#------------------------------------------------------------------------------
# EKS IAM Roles
#------------------------------------------------------------------------------

# Role for EKS Control Plane

resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
}

data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

#------------------------------------------------------------------------------
# Role for Worker Nodes
#------------------------------------------------------------------------------

resource "aws_iam_role" "eks_node_role" {
  name = "${var.cluster_name}-node-role"

  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role.json
}

data "aws_iam_policy_document" "eks_node_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_ssm_Policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#------------------------------------------------------------------------------
# EKS Cluster 
#------------------------------------------------------------------------------

resource "aws_eks_cluster" "eks" {
  name     = "${var.cluster_name}-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks_version

  
  access_config {
    authentication_mode = "API"     # or "API_AND_CONFIG_MAP" or "CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {
    subnet_ids = var.private_subnet_ids


    endpoint_public_access  = true   # set to false if private-only
    endpoint_private_access = true   # recommended

    security_group_ids = [aws_security_group.eks_cluster_sg.id]
    

    # Only allowed IPs for public API access
    # public_access_cidrs = var.allowed_api_cidrs

  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy
  ]
}

#------------------------------------------------------------------------------
# Worker Nodes
#------------------------------------------------------------------------------


resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.cluster_name}-nodegroup"

  node_role_arn = aws_iam_role.eks_node_role.arn

  subnet_ids = var.private_subnet_ids

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_capacity
    min_size     = var.min_capacity
  }

  instance_types = [var.node_instance_type]


  depends_on = [
    aws_eks_cluster.eks

  ]
}

# -----------------------------------------
# CoreDNS Add-on
# -----------------------------------------
resource "aws_eks_addon" "coredns" {
  cluster_name      = aws_eks_cluster.eks.name
  addon_name        = "coredns"
  
# let aws manage version Automatically 
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  

  depends_on = [
    aws_eks_node_group.eks_nodes
  ]
}

# -----------------------------------------
# VPC CNI Add-on
# -----------------------------------------
resource "aws_eks_addon" "vpc_cni" {
  cluster_name      = aws_eks_cluster.eks.name
  addon_name        = "vpc-cni"
  
  
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

#   # VPC CNI uses its own IAM role
#   service_account_role_arn = aws_iam_role.vpc_cni_role.arn

  depends_on = [
    aws_eks_node_group.eks_nodes
  ]
}

# -----------------------------------------
# Kube Proxy Add-on
# -----------------------------------------
resource "aws_eks_addon" "kube_proxy" {
  cluster_name      = aws_eks_cluster.eks.name
  addon_name        = "kube-proxy"
  
 
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_node_group.eks_nodes
  ]
}

#------------------------------------------------------------------------------
# EKS Security Groups
#------------------------------------------------------------------------------

# ---------------------------
# Control Plane Security Group
# ---------------------------
resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.cluster_name}-sg"
  description = "Security group for EKS Control Plane"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.cluster_name}-cluster-sg"
  }
}

# Control Plane → allow all outbound
resource "aws_vpc_security_group_egress_rule" "cluster_egress_all" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}



# Allow Worker Nodes → Control Plane (required by EKS)
resource "aws_vpc_security_group_ingress_rule" "nodes_to_controlplane" {
  security_group_id            = aws_security_group.eks_cluster_sg.id
  referenced_security_group_id = aws_security_group.eks_node_sg.id
  ip_protocol                  = "-1"
  description                  = "Worker nodes communicate with EKS Control Plane (all ports)"
}



# ---------------------------
# Worker Node Security Group
# ---------------------------
resource "aws_security_group" "eks_node_sg" {
  name        = "${var.cluster_name}-node-sg"
  description = "Security group for EKS Worker Nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.cluster_name}-node-sg"
  }
}

# Worker Nodes → allow all outbound
resource "aws_vpc_security_group_egress_rule" "node_egress_all" {
  security_group_id = aws_security_group.eks_node_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}



# Control Plane → Worker Nodes (all ports)
resource "aws_vpc_security_group_ingress_rule" "controlplane_to_nodes" {
  security_group_id            = aws_security_group.eks_node_sg.id
  referenced_security_group_id = aws_security_group.eks_cluster_sg.id
  ip_protocol                  = "-1"
  description                  = "EKS Control Plane communicates with Worker Nodes (all ports)"
}

# Worker Node ↔ Worker Node (Node-to-Node traffic)
resource "aws_vpc_security_group_ingress_rule" "nodes_to_nodes" {
  security_group_id            = aws_security_group.eks_node_sg.id
  referenced_security_group_id = aws_security_group.eks_node_sg.id
  ip_protocol                  = "-1"
  description                  = "Allow node-to-node communication (all ports)"
}
