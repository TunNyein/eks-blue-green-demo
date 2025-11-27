
data "aws_caller_identity" "current" {}

locals {
  eks_clusters = {
    blue  = module.eks_blue.cluster_name 
    green = module.eks_green.cluster_name
  }
}

#------------------------------------------------------------------------------
# Junior Engineers Access Entries and Policies (Refactored using for_each)
#------------------------------------------------------------------------------
resource "aws_eks_access_entry" "junior_ops_engineer" {
  for_each      = local.eks_clusters
  cluster_name  = each.value 
  principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/junior-Ops-engineer"
  type          = "STANDARD"
  
  
  depends_on = [
    module.eks_blue,
    module.eks_green
  ]
}

# Junior Engineers Policy Association for ONLY the Blue Cluster (View Policy)
resource "aws_eks_access_policy_association" "junior_policy" {
  for_each      = local.eks_clusters
  cluster_name  = each.value
  principal_arn = aws_eks_access_entry.junior_ops_engineer[each.key].principal_arn 
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

  access_scope {
    type       = "namespace"
    namespaces = ["productpage", "details", "reviews", "ratings"] 
  }
  
  depends_on = [
    module.eks_blue,
    aws_eks_access_entry.junior_ops_engineer,
    module.eks_green
  ]
}

#------------------------------------------------------------------------------
# Lead Engineers Access Entries and Policies
#------------------------------------------------------------------------------

# Blue Cluster Access Entry for Lead Engineer 
resource "aws_eks_access_entry" "lead_ops_engineer_blue" {
  for_each      = local.eks_clusters
  cluster_name  = each.value
  principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/lead-Ops-engineer"
  type              = "STANDARD"
  kubernetes_groups = ["lead-ops-group"]
  
  
  depends_on = [
    module.eks_blue,
    module.eks_green
  ]
}

