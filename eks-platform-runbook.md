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