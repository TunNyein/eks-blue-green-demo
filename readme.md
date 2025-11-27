# EKS Blue/Green Deployment Strategy

## Overview

This repository demonstrates a Blue/Green deployment strategy on Amazon EKS using two separate clusters for version separation (Blue and Green). This architecture includes a privileged access model for developers and operators, managed via EKS Access Entries and Kubernetes RBAC.

The project includes:

- BookInfo microservices deployed into separate namespaces.

- AWS Load Balancer Controller (LBC) for provisioning an Application Load Balancer (ALB).

- ExternalDNS for automated DNS management and precise Weighted Traffic Shifting via Route 53.

- IAM + EKS Access Entries + Kubernetes RBAC for enforcing strong access separation.

- Two IAM users are defined for controlled cluster access:

- lead-ops-engineer — full administrative permissions on application namespaces (productpage, details, reviews, ratings, etc.)

- junior-ops-engineer — read-only (view) permissions on all namespaces

## Follow the complete operational guideline in: 📘 infra/eks-blue-green-runbook.md

## Architecture

![alt text](manifests/eks-blue-green-diagram-v2.png.png)

---

## Repository Structure

This structure reflects the infrastructure setup (infra) using Terraform and Kubernetes Manifests.

```bash
.
.
├── infra/
│   ├── acces-enteries.tf        # Maps IAM Users/Roles to EKS Access Entries
│   ├── acm/                     # (MODULE) AWS Certificate Manager configuration
│   ├── eks/                     # (MODULE) EKS Control Plane and Node Group definitions
│   ├── eks-blue-greee-runbook.md # Full step-by-step Blue/Green deployment operations guide
│   ├── iam-users.tf             # IAM Users for lead & junior engineers
│   ├── main.tf                  # Main Terraform configuration
│   ├── providers.tf             # Terraform provider configuration
│   ├── variables.tf             # Input variables for configuration
│   └── vpc/                     # (MODULE) VPC, subnets, routing, and networking for the EKS cluster
│
└── manifests/
    ├── blue-bookinfo/
    │   └── blue-bookinfo.yaml   # Blue (v1) BookInfo Deployment + Service
    │
    ├── external-dns-policy.json # IAM Policy definition for ExternalDNS
    ├── external-svc.yaml        # ExternalService definitions for internal dependencies
    ├── green-bookinfo/
    │   └── green-bookinfo.yaml  # Green (v2) BookInfo Deployment + Service
    │
    ├── ingress/
    │   ├── blue-ingress.yaml    # Ingress definition for Blue Cluster (to be annotated)
    │   └── green-ingress.yaml   # Ingress definition for Green Cluster (to be annotated)
    │
    └── rbac.yaml                # Kubernetes RBAC roles and role bindings
```

## Configuration Variables (infra/terraform.tfvars)

The following variables must be defined to configure the VPC, two EKS clusters (Blue/Green), and the necessary DNS settings. These values are critical inputs consumed by the Terraform modules (vpc/, eks/, acm/).

```bash
# AWS Credentials & Region
aws_region          = "ap-southeast-1"
aws_profile         = "eks-admin"

# VPC Configuration (Inputs for 'vpc/' module)
vpc_prefix          = "eks"
vpc_environment     = "production"
vpc_address_space   = "10.10.0.0/16"
# Public subnets used for ALBs
vpc_public_subnet_cidr  = ["10.10.1.0/24", "10.10.2.0/24"]
# Private subnets used for EKS Worker Nodes
vpc_private_subnet_cidr = ["10.10.101.0/24", "10.10.102.0/24"]

# EKS Cluster & Node Group Configuration (Inputs for 'eks/' module)
cluster_blue_name   = "eks-blue"
cluster_green_name  = "eks-green"
eks_version         = "1.33"
node_instance_type  = "t3.medium"
desired_capacity    = 2
max_capacity        = 2
min_capacity        = 2

# DNS and ACM Configuration (Inputs for 'acm/' and ExternalDNS)
acm_domain_name     = "hellocloud.tunlab.xyz"
hosted_zone_domain_name = "tunlab.xyz"
```
----
👉 Follow the complete operational guideline in: 📘 infra/eks-blue-green-runbook.md