# Deploying EKS with Terraform

## Overview

This project deploys EKS cluster using Terraform. It provisions a VPC (public + private subnets), NAT/IGW, route tables, IAM roles, security groups, an EKS control plane and a managed node group.(Bookinfo demo included).

Key behaviours
- EKS API endpoint access: both private and public access are enabled 

- Worker nodes run in private subnets; Services of type `LoadBalancer` will provision AWS LBs in public subnets (unless annotated as internal) so pods can be reached from the internet.


## Architecture

![alt text](assets/architecture.png)

## Components (files)

- `vpc.tf` — VPC, subnets, IGW, NAT gateway, route tables and associations.
- `data.tf` — AWS availability zones data source.
- `variables.tf` — module variables and default values.
- `IAM-role.tf` — IAM roles and policy attachments for EKS control plane and nodes.
- `security-groups.tf` — control-plane and node security groups and rules.
- `eks.tf` — `aws_eks_cluster` and `aws_eks_node_group` resources.
- `main.tf` — provider config and outputs (kubeconfig snippet).
- `bookinfo.yaml` — demo application (Bookinfo) including `productpage` Service (LoadBalancer).
- `assets/` — visual assets (architecture diagram).

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured and a profile with permissions to create VPC, IAM, EC2, EKS, ELB, etc.
- kubectl installed

Configure AWS profile/region via `variables.tf` 

## Default variable highlights

- `aws_region` (default: ap-southeast-1)
- `aws_profile` (default: master-console-adm)
- `vpc_prefix` (default: team-7)
- `eks_version` (default: 1.33)
- `node_instance_type` (default: t3.large)
- `desired_capacity`, `min_capacity`, `max_capacity` (defaults: 2)

See `variables.tf` for the full list and defaults.

## Deploy

1. Initialize Terraform

   terraform init

2. Plan (example overriding profile/region)

   terraform plan 

3. Apply

   terraform apply 

4. Configure kubectl (example)

   aws eks update-kubeconfig --name <cluster_name> --region ap-southeast-1 --profile your-profile

5. (Optional) Deploy demo Bookinfo application

   kubectl apply -f bookinfo.yaml

## Accessing the productpage (LoadBalancer)

- `bookinfo.yaml` contains a `Service` named `productpage` with `type: LoadBalancer`. When the service provisions, it will create an AWS Load Balancer.
- You do NOT need to change pod targets if the Service `selector` matches Deployment pod labels. Verify the `productpage` Service selector and Deployment labels match.
- Ensure the Service does NOT include `service.beta.kubernetes.io/aws-load-balancer-internal: "true"` annotation if you want a public LB.
- Check status and external IP:

  kubectl get svc productpage
  kubectl describe svc productpage


## Cleanup

terraform destroy 

