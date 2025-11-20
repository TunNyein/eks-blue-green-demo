# #------------------------------------------------------------------------------
# # Productpage, Details, Reviews, and Ratings Lead and Junior Engineers IAM Users
# #------------------------------------------------------------------------------

# resource "aws_iam_user" "productpage_lead" {
#   name = "productpage-lead-engineer"
# }

# resource "aws_iam_user" "details_lead" {
#   name = "details-lead-engineer"
# }

# resource "aws_iam_user" "reviews_lead" {
#   name = "reviews-lead-engineer"
# }

# resource "aws_iam_user" "ratings_lead" {
#   name = "ratings-lead-engineer"
# }

# resource "aws_iam_user" "productpage_junior" {
#   name = "productpage-junior-engineer"
# }

# resource "aws_iam_user" "details_junior" {
#   name = "details-junior-engineer"
# }

# resource "aws_iam_user" "reviews_junior" {
#   name = "reviews-junior-engineer"
# }

# resource "aws_iam_user" "ratings_junior" {
#   name = "ratings-junior-engineer"
# }

# #------------------------------------------------------------------------------
# # IAM Policy to Allow EKS DescribeCluster Action 
# #------------------------------------------------------------------------------

# resource "aws_iam_policy" "eks_describe" {
#   name        = "eks-describe-cluster"
#   description = "Allow users to describe EKS clusters"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect   = "Allow"
#         Action   = "eks:DescribeCluster"
#         Resource = "*"
#       }
#     ]
#   })
# }

# #------------------------------------------------------------------------------
# # Attach IAM Policy to Users
# #------------------------------------------------------------------------------ 

# resource "aws_iam_user_policy_attachment" "productpage_lead_attach" {
#   user       = aws_iam_user.productpage_lead.name
#   policy_arn = aws_iam_policy.eks_describe.arn
# }

# resource "aws_iam_user_policy_attachment" "details_lead_attach" {
#   user       = aws_iam_user.details_lead.name
#   policy_arn = aws_iam_policy.eks_describe.arn
# }

# resource "aws_iam_user_policy_attachment" "reviews_lead_attach" {
#   user       = aws_iam_user.reviews_lead.name
#   policy_arn = aws_iam_policy.eks_describe.arn
# }

# resource "aws_iam_user_policy_attachment" "ratings_lead_attach" {
#   user       = aws_iam_user.ratings_lead.name
#   policy_arn = aws_iam_policy.eks_describe.arn
# }

# resource "aws_iam_user_policy_attachment" "productpage_junior_attach" {
#   user       = aws_iam_user.productpage_junior.name
#   policy_arn = aws_iam_policy.eks_describe.arn
# }

# resource "aws_iam_user_policy_attachment" "details_junior_attach" {
#   user       = aws_iam_user.details_junior.name
#   policy_arn = aws_iam_policy.eks_describe.arn
# }

# resource "aws_iam_user_policy_attachment" "reviews_junior_attach" {
#   user       = aws_iam_user.reviews_junior.name
#   policy_arn = aws_iam_policy.eks_describe.arn
# }

# resource "aws_iam_user_policy_attachment" "ratings_junior_attach" {
#   user       = aws_iam_user.ratings_junior.name
#   policy_arn = aws_iam_policy.eks_describe.arn
# }

