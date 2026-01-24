# Terraform Ready-to-Apply Guide

This repository is structured for a secure, modular deployment of the EZOps Exam infrastructure.

## Prerequisites

1.  **AWS CLI Configured**: You must have a valid profile (e.g., `hrclsfss`) with necessary permissions.
2.  **Terraform Installed**: Version >= 1.0.0.
3.  **Permissions**: Ensure your user has `AdministratorAccess` or specific permissions for S3, DynamoDB, VPC, EKS, RDS, etc.

## 1. Bootstrap (Remote State)

**Goal**: Create S3 bucket for state storage and DynamoDB table for locking.

1.  Navigate to bootstrap directory:
    ```bash
    cd infra/bootstrap
    ```
2.  Initialize and Apply:
    ```bash
    terraform init
    terraform apply
    ```
    *Note: If `AccessDenied` occurs, check your AWS permissions.*

## 2. Test Environment Deployment

**Goal**: Deploy the actual infrastructure (VPC, EKS, RDS, etc.).

1.  Navigate to test environment directory:
    ```bash
    cd infra/environments/test
    ```
2.  Initialize (connects to remote backend created in step 1):
    ```bash
    terraform init
    ```
3.  Plan and Apply:
    ```bash
    terraform plan -out=tfplan
    terraform apply "tfplan"
    ```

  - **backend**: `test-chico-backend`
  - **frontend**: `test-chico-frontend`

#### How to Push Images

1.  **Authenticate**:
    ```bash
    aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-2.amazonaws.com
    ```
2.  **Tag & Push**:
    ```bash
    docker tag ezops-backend:latest <ACCOUNT_ID>.dkr.ecr.us-east-2.amazonaws.com/test-chico-backend:latest
    docker push <ACCOUNT_ID>.dkr.ecr.us-east-2.amazonaws.com/test-chico-backend:latest
    ```

    docker push <ACCOUNT_ID>.dkr.ecr.us-east-2.amazonaws.com/test-chico-backend:latest
    ```

#### EKS Validation (Kubernetes)

1.  **Update Kubeconfig**:
    ```bash
    aws eks update-kubeconfig --region us-east-2 --name test-chico-eks
    ```
2.  **Verify Cluster**:
    ```bash
    kubectl get nodes
    kubectl get svc
    ```

    kubectl get svc
    ```

#### RDS Validation

1.  **Check Endpoint**:
    ```bash
    aws rds describe-db-instances --query 'DBInstances[*].Endpoint.Address' --profile hrclsfss
    ```
2.  **Test Connectivity** (Requires a pod/instance inside VPC/Cluster):
    ```bash
    nc -zv <RDS_ENDPOINT> 5432
    ```

    nc -zv <RDS_ENDPOINT> 5432
    ```

#### Frontend Deployment

1.  **Build**:
    ```bash
    cd frontend-app
    npm install && npm run build
    ```
2.  **Deploy to S3**:
    ```bash
    aws s3 sync build/ s3://<BUCKET_NAME> --delete
    ```
3.  **Invalidate Cache**:
    ```bash
    aws cloudfront create-invalidation --distribution-id <DIST_ID> --paths "/*"
    ```
4.  **Validate**: Access `https://<CLOUDFRONT_DOMAIN>`

    aws cloudfront create-invalidation --distribution-id <DIST_ID> --paths "/*"
    ```
4.  **Validate**: Access `https://<CLOUDFRONT_DOMAIN>`

#### Route53 Configuration

1.  **Get Hosted Zone ID**:
    ```bash
    aws route53 list-hosted-zones --profile hrclsfss
    ```
2.  **Update `infra/environments/test/variables.tf`**:
    *   Set `hosted_zone_id` = "YOUR_ZONE_ID"
    *   Set `domain_name` = "yourdomain.com"
3.  **Update Backend Target (Post-Apply)**:
    *   Once ALB is created (via Kubernetes Ingress), update `backend_target` in `infra/environments/test/main.tf` with the actual ALB DNS name.

## Module Architecture

- **vpc**: Networking foundation (Subnets, NAT Gateway).
- **ecr**: Docker repositories for Backend and Frontend images.
- **eks**: Managed Kubernetes Cluster for running the Backend API.
- **rds**: Managed PostgreSQL Database for the Backend.
- **s3_frontend**: S3 Bucket configured for static website hosting.
- **cloudfront**: CDN to serve the S3 frontend globally (HTTPS).
- **route53**: DNS records pointing to ALB (Backend) and CloudFront (Frontend).

## Troubleshooting

- **Backend Initialization Error**: Ensure the bootstrap `terraform apply` finished successfully and the bucket name in `infra/environments/test/backend.tf` matches the output from bootstrap.
- **Access Denied**: Verify `aws sts get-caller-identity --profile <YOUR_PROFILE>` returns the expected account.
