#------------------------------------------------------------------------------
# EKS Security Groups
#------------------------------------------------------------------------------

# ---------------------------
# Control Plane Security Group
# ---------------------------
resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.vpc_prefix}-cluster-sg"
  description = "Security group for EKS Control Plane"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_prefix}-cluster-sg"
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
  name        = "${var.vpc_prefix}-node-sg"
  description = "Security group for EKS Worker Nodes"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_prefix}-node-sg"
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
