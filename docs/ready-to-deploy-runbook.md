# Ready-to-Deploy Runbook

**Objective**: Execute this sequence once AWS permissions are granted to pass the exam.

## 1. Preparation
Ensure you have:
- AWS Credentials (Access Keys) exported in CLI.
- Route53 Hosted Zone ID for your domain.
- `api.ezopscloud.tech` domain details (if provided by exam) or your own.

## 2. Infrastructure Deployment (Phase 1)
Initialize and apply the base infrastructure (VPC, EKS, RDS, S3, CloudFront).

```bash
cd infra/environments/test
terraform init

# Apply with your specific domain details
# REPLACE values with your actual exam data
terraform apply \
  -var="hosted_zone_id=Z0123456789ABCDEF" \
  -var="exam_domain=exam.ezopscloud.tech" \
  -var="dns_label=chico"
```

## 3. Kubernetes Deployment (Phase 2)
Configure `kubectl` and deploy the Ingress Controller and Application.

```bash
# Update Kubeconfig
aws eks update-kubeconfig --name test-chico --region us-east-2

# Install ALB Controller (Pre-requisite)
# (Follow docs/alb-controller-setup.md if not automated)

# Deploy Backend Ingress
kubectl apply -f k8s/backend/ingress.yaml
```

## 4. Final Wiring (Phase 3)
Connect the provisioned ALB to Route53.

```bash
# Get the ALB DNS Name
ALB_DNS=$(kubectl get ingress -n test-chico -o jsonpath='{.items[0].status.loadBalancer.ingress[0].hostname}')
echo "ALB DNS: $ALB_DNS"

# Update Terraform with the ALB Target
terraform apply \
  -var="hosted_zone_id=Z0123456789ABCDEF" \
  -var="exam_domain=exam.ezopscloud.tech" \
  -var="dns_label=chico" \
  -var="backend_target=$ALB_DNS"
```

## 5. Verification
- **Frontend**: https://chico.exam.ezopscloud.tech
- **Backend**: https://api.chico.exam.ezopscloud.tech/health
