# resource "aws_eks_access_entry" "productpage_junior" {
#   cluster_name  = aws_eks_cluster.eks.name
#   principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/productpage-junior-engineer"
#   type          = "STANDARD"
# }

# resource "aws_eks_access_policy_association" "productpage_junior_policy" {
#   cluster_name  = aws_eks_cluster.eks.name
#   principal_arn = aws_eks_access_entry.productpage_junior.principal_arn
#   policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

#   access_scope {
#     type       = "namespace"
#     namespaces = ["productpage"]
#   }
# }

# resource "aws_eks_access_entry" "details_junior" {
#   cluster_name  = aws_eks_cluster.eks.name
#   principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/details-junior-engineer"
#   type          = "STANDARD"
# }

# resource "aws_eks_access_policy_association" "details_junior_policy" {
#   cluster_name  = aws_eks_cluster.eks.name
#   principal_arn = aws_eks_access_entry.details_junior.principal_arn
#   policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

#   access_scope {
#     type       = "namespace"
#     namespaces = ["details"]
#   }
# }

# resource "aws_eks_access_entry" "reviews_junior" {
#   cluster_name  = aws_eks_cluster.eks.name
#   principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/reviews-junior-engineer"
#   type          = "STANDARD"
# }

# resource "aws_eks_access_policy_association" "reviews_junior_policy" {
#   cluster_name  = aws_eks_cluster.eks.name
#   principal_arn = aws_eks_access_entry.reviews_junior.principal_arn
#   policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

#   access_scope {
#     type       = "namespace"
#     namespaces = ["reviews"]
#   }
# }

# resource "aws_eks_access_entry" "ratings_junior" {
#   cluster_name  = aws_eks_cluster.eks.name
#   principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/ratings-junior-engineer"
#   type          = "STANDARD"
# }

# resource "aws_eks_access_policy_association" "ratings_junior_policy" {
#   cluster_name  = aws_eks_cluster.eks.name
#   principal_arn = aws_eks_access_entry.ratings_junior.principal_arn
#   policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

#   access_scope {
#     type       = "namespace"
#     namespaces = ["ratings"]
#   }
# }


# #------------------------------------------------------------------------------
# # Lead Engineers Access Entries and Policies
# #------------------------------------------------------------------------------

# # Productpage Lead
# resource "aws_eks_access_entry" "productpage_lead" {
#   cluster_name  = aws_eks_cluster.eks.name
#   principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/productpage-lead-engineer"
#   type          = "STANDARD"
#   kubernetes_groups = ["productpage-lead-group"]
# }

# # Details Lead
# resource "aws_eks_access_entry" "details_lead" {
#   cluster_name  = aws_eks_cluster.eks.name
#   principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/details-lead-engineer"
#   type          = "STANDARD"
#   kubernetes_groups = ["details-lead-group"]
# }

# # Reviews Lead
# resource "aws_eks_access_entry" "reviews_lead" {
#   cluster_name  = aws_eks_cluster.eks.name
#   principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/reviews-lead-engineer"
#   type          = "STANDARD"
#   kubernetes_groups = ["reviews-lead-group"]
# }

# # Ratings Lead
# resource "aws_eks_access_entry" "ratings_lead" {
#   cluster_name  = aws_eks_cluster.eks.name
#   principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/ratings-lead-engineer"
#   type          = "STANDARD"
#   kubernetes_groups = ["ratings-lead-group"]
# }

# #  Productpage Lead Role (full access)
# resource "kubernetes_role" "productpage_lead_role" {
#   metadata {
#     name      = "productpage-lead-role"
#     namespace = "productpage"
#   }

#   rule {
#     api_groups = ["*"]
#     resources  = ["*"]
#     verbs      = ["*"]
#   }
# }

# resource "kubernetes_role_binding" "productpage_lead_binding" {
#   metadata {
#     name      = "productpage-lead-binding"
#     namespace = "productpage"
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "Role"
#     name      = kubernetes_role.productpage_lead_role.metadata[0].name
#   }

#   subject {
#     kind      = "Group"
#     name      = "productpage-lead-group"  # Must match kubernetes_groups in access entry
#     api_group = "rbac.authorization.k8s.io"
#   }
# }

# #  Details Lead Role (full access)

# resource "kubernetes_role" "details_lead_role" {
#   metadata {
#     name      = "details-lead-role"
#     namespace = "details"
#   }

#   rule {
#     api_groups = ["*"]
#     resources  = ["*"]
#     verbs      = ["*"]
#   }
# }

# resource "kubernetes_role_binding" "details_lead_binding" {
#   metadata {
#     name      = "details-lead-binding"
#     namespace = "details"
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "Role"
#     name      = kubernetes_role.details_lead_role.metadata[0].name
#   }

#   subject {
#     kind      = "Group"
#     name      = "details-lead-group"  # Matches kubernetes_groups in access entry
#     api_group = "rbac.authorization.k8s.io"
#   }
# }

# #  Reviews Lead Role (full access)

# resource "kubernetes_role" "reviews_lead_role" {
#   metadata {
#     name      = "reviews-lead-role"
#     namespace = "reviews"
#   }

#   rule {
#     api_groups = ["*"]
#     resources  = ["*"]
#     verbs      = ["*"]
#   }
# }

# resource "kubernetes_role_binding" "reviews_lead_binding" {
#   metadata {
#     name      = "reviews-lead-binding"
#     namespace = "reviews"
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "Role"
#     name      = kubernetes_role.reviews_lead_role.metadata[0].name
#   }

#   subject {
#     kind      = "Group"
#     name      = "reviews-lead-group"
#     api_group = "rbac.authorization.k8s.io"
#   }
# }


# #  Ratings Lead Role (full access)

# resource "kubernetes_role" "ratings_lead_role" {
#   metadata {
#     name      = "ratings-lead-role"
#     namespace = "ratings"
#   }

#   rule {
#     api_groups = ["*"]
#     resources  = ["*"]
#     verbs      = ["*"]
#   }
# }

# resource "kubernetes_role_binding" "ratings_lead_binding" {
#   metadata {
#     name      = "ratings-lead-binding"
#     namespace = "ratings"
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "Role"
#     name      = kubernetes_role.ratings_lead_role.metadata[0].name
#   }

#   subject {
#     kind      = "Group"
#     name      = "ratings-lead-group"
#     api_group = "rbac.authorization.k8s.io"
#   }
# }
