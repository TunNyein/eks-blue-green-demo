
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


#------------------------------------------------------------------------------
# RBAC for Lead Engineer each namespaces
#------------------------------------------------------------------------------

#  Productpage Lead Role (full access)
resource "kubernetes_role" "productpage_lead_role" {
  metadata {
    name      = "productpage-lead-role"
    namespace = "productpage"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_role_binding" "productpage_lead_binding" {
  metadata {
    name      = "productpage-lead-binding"
    namespace = "productpage"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.productpage_lead_role.metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = "lead-ops-group"  # Must match kubernetes_groups in access entry
    api_group = "rbac.authorization.k8s.io"
  }
}

#  Details Lead Role (full access)

resource "kubernetes_role" "details_lead_role" {
  metadata {
    name      = "details-lead-role"
    namespace = "details"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_role_binding" "details_lead_binding" {
  metadata {
    name      = "details-lead-binding"
    namespace = "details"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.details_lead_role.metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = "lead-ops-group"  # Matches kubernetes_groups in access entry
    api_group = "rbac.authorization.k8s.io"
  }
}

#  Reviews Lead Role (full access)

resource "kubernetes_role" "reviews_lead_role" {
  metadata {
    name      = "reviews-lead-role"
    namespace = "reviews"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_role_binding" "reviews_lead_binding" {
  metadata {
    name      = "reviews-lead-binding"
    namespace = "reviews"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.reviews_lead_role.metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = "lead-ops-group"   # Matches kubernetes_groups in access entry
    api_group = "rbac.authorization.k8s.io"
  }
}


#  Ratings Lead Role (full access)

resource "kubernetes_role" "ratings_lead_role" {
  metadata {
    name      = "ratings-lead-role"
    namespace = "ratings"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_role_binding" "ratings_lead_binding" {
  metadata {
    name      = "ratings-lead-binding"
    namespace = "ratings"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.ratings_lead_role.metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = "lead-ops-group"    # Matches kubernetes_groups in access entry
    api_group = "rbac.authorization.k8s.io"
  }
}
