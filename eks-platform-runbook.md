# EKS Setup & Blue/Green Deployment Runbook

This Runbook provides a step-by-step guide from setting up an EKS Cluster with Terraform to configuring the AWS Load Balancer Controller (ALB), deploying Bookinfo microservices (Blue/Green), and setting up Datadog Monitoring.

## 1. EKS Cluster Creation (Terraform)

```bash
# Initialize Terraform in the current directory (first time run)
terraform init 

# Build the infrastructure in AWS
terraform apply --auto-approve
```

## 2. EKS Cluster Connectivity Management

```bash
# Kubeconfig Update
aws eks update-kubeconfig --region ap-southeast-1 --name eks-cluster --alias eks-admin --profile eks-admin

```
## 3. Verify Cluster Access

```bash
# Check existing namespaces
kubectl get ns 

# Check system pods
kubectl get all -n kube-system
```
## 4. Deploying Bookinfo Services
Define the necessary Namespaces and RBAC for the microservices.
  
  ### I. Create Namespaces
  ```bash
kubectl create ns details
kubectl create ns reviews
kubectl create ns ratings
kubectl create ns productpage
  ```
  ### II. Apply RBAC and Deploy Blue Services
  ```bash
# Apply RBAC configurations
kubectl apply -f rbac.yaml

# Deploy Bookinfo Blue Version (Original) Microservices
kubectl apply -f blue-bookinfo.yaml

# Apply External Service (Kubernetes Service object)
kubectl apply -f external-svc.yaml -n productpage
  ```
## 5. AWS Load Balancer Controller Installation (ALB)
The LBC will automatically provision an AWS Application Load Balancer (ALB) based on Kubernetes Ingress Resources.
  ### I. Associate IAM OIDC Provider (Prerequisite for IRSA)
  ```bash
# Associate the OIDC provider with EKS for IAM Roles for Service Accounts (IRSA)
eksctl utils associate-iam-oidc-provider --cluster eks-cluster --approve --profile eks-admin
  ```
  ### II. Download Create IAM Policy
  Download the official IAM Policy and create it in AWS.
  ```bash
# Download the policy JSON file
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

# Create the policy in IAM 
# Replace <account-id> with your AWS Account ID.
aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam-policy.json --profile eks-admin

  ```
  ### III. Create IAM Role + Service Account (IRSA)
  ```bash
# Create the IRSA using eksctl
eksctl create iamserviceaccount \
  --cluster eks-cluster \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::<account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve
  ```
  ### IV. Install Controller Using Helm
  ```bash
# Add the Chart Repo
helm repo add eks https://aws.github.io/eks-charts
helm repo update

# Install the Controller
# Replace <vpc-id> with your actual VPC ID.
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=eks-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=ap-southeast-1 \
  --set vpcId=<vpc-id>
  ```
 ### V. Verify Controller Deployment
 ```bash
# Check Deployment status
kubectl get deployment -n kube-system aws-load-balancer-controller

# Check Pod status
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller
  ```
## 5. Apply Ingress Resource and Configure ALB Address in Route 53
### I. Apply Ingress Resource
```bash
# Apply the original Ingress for BLUE deployment (existing microservices)
kubectl apply -f original-ingress.yaml -n productpage

# Verify that AWS Load Balancer Controller created an ALB
kubectl get ingress bookinfo-ingress -n productpage -o wide
  ```
### II. Add ALB DNS to Route 53
```bash
- Go to Route 53 → Hosted Zones

- Select your domain (example: tunlab.xyz)

- Create a Record:

- Record name:
bookinfo.tunlab.xyz (or your preferred subdomain)

- Record type:
CNAME

- Value:
Paste the ALB DNS name from ADDRESS
Example:
k8s-prod-bookinfo-1234567890.elb.amazonaws.com

- TTL: 300 (default) # 60

- Routing policy: Simple

- Save record.

```
After DNS propagates (1–3 min), open:

http://bookinfo.tunlab.xyz