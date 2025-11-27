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

## Follow up complete operational workflow is documented in: 📘 infra/eks-blue-greee-runbook.md

## Architecture

![alt text](manifests/eks-blue-green-diagram-v2.png.png)

---

Repository Structure

This structure reflects the infrastructure setup (infra) using Terraform and Kubernetes Manifests.

```bash
.
├── infra/
│   ├── acces-enteries.tf        # Maps IAM Users/Roles to EKS Access Entries
│   ├── acm/                     # modle for ACM Certificate management
│   ├── eks/                     # module EKS Control Plane and Node Group definitions
│   ├── eks-blue-greee-runbook.md # Full step-by-step Blue/Green deployment operations guide
│   ├── iam-users.tf             # IAM Users for lead & junior engineers
│   ├── main.tf                  # Main Terraform configuration
│   ├── providers.tf             # Terraform provider configuration
│   ├── variables.tf             # Input variables for configuration
│   └── vpc/                     # module VPC, subnets, routing, and networking for the EKS cluster
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

## Follow up complete operational workflow is documented in: 📘 infra/eks-blue-greee-runbook.md