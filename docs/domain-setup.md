# Domain and DNS Setup Guide

This guide describes how to configure the Domain and DNS for the EzOps Exam infrastructure.

## Architecture
- **Domain**: `example.com` (Default placeholder).
- **Subdomain**: `test-chico` (Environment prefix).
- **Frontend**: `app.test-chico.example.com` (CloudFront).
- **Backend**: `api.test-chico.example.com` (ALB via Route53).

## Prerequisites
1.  **Hosted Zone**: You must have a Route53 Hosted Zone created for your domain.
2.  **ID**: Retrieve the Hosted Zone ID.

## Configuration Steps

### 1. Update Terraform Variables
In `infra/environments/test/terraform.tfvars` (or pass via `-var`):

```hcl
domain_name    = "yourdomain.com"
hosted_zone_id = "Z0123456789ABCDEF"
```

### 2. Frontend DNS
The Frontend DNS (`app.test-chico...`) is automatically created and wired to CloudFront during the initial `terraform apply`.

### 3. Backend DNS (Post-deployment)
The Backend DNS (`api.test-chico...`) points to the AWS Application Load Balancer (ALB). Since the ALB is created by the Kubernetes Ingress Controller *after* the initial infrastructure apply, this is a two-step process.

#### Step 3.1: Deploy Kubernetes Ingress
Apply the ingress manifest:
```bash
kubectl apply -f k8s/backend/ingress.yaml
```

#### Step 3.2: Get ALB DNS Name
Wait a few minutes for the ALB to provision, then run:
```bash
kubectl get ingress -n test-chico -o jsonpath='{.items[0].status.loadBalancer.ingress[0].hostname}'
# Output example: k8s-testchic-ezopsing-abcdef-123456789.us-east-2.elb.amazonaws.com
```

#### Step 3.3: Update Terraform
Run Terraform again to create the backend Route53 record, passing the ALB DNS name:

```bash
terraform apply \
  -var="backend_target=k8s-testchic-ezopsing-abcdef-123456789.us-east-2.elb.amazonaws.com"
```

## Validation
- **Frontend**: Visit `https://app.test-chico.yourdomain.com`.
- **Backend Health**: `curl https://api.test-chico.yourdomain.com/health` -> `OK`.
