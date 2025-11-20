
#------------------------------------------------------------------------------
# Junior Engineers Access Entries and Policies
#------------------------------------------------------------------------------

resource "aws_eks_access_entry" "junior_ops_engineer" {
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/junior-Ops-engineer"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "junior_policy" {
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = aws_eks_access_entry.junior_ops_engineer.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

  access_scope {
    type       = "namespace"
    namespaces = ["productpage", "details", "reviews", "ratings"]
  }
}

#------------------------------------------------------------------------------
# Lead Engineers Access Entries and Policies
#------------------------------------------------------------------------------

# Productpage Lead
resource "aws_eks_access_entry" "lead_ops_engineer" {
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/lead-Ops-engineer"
  type          = "STANDARD"
  kubernetes_groups = ["lead-ops-group"]
}

