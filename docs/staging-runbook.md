# Staging Environment Runbook

This guide details how to set up and deploy the Staging environment (`stg-chico`) in your personal AWS account.

## Prerequisites
1.  **AWS CLI Configured**: Ensure you have credentials for your personal account (`stg`).
2.  **S3/DynamoDB Permissions**: You must be able to create Buckets and DynamoDB tables.
3.  **Cloudflare Access**: To configure DNS (CNAMEs).

## Phase 1: Bootstrap (Remote State)
Create the S3 Bucket and DynamoDB Table for Terraform State.

```bash
cd infra/bootstrap
terraform init
terraform apply
```

**Action Required**: note the outputs:
- `s3_bucket_name` (e.g., `ezops-tfstate-123456789012-us-east-2`)
- `dynamodb_table_name` (e.g., `ezops-tflock-123456789012`)

## Phase 2: Configure Staging Backend (Done)
The `infra/environments/staging/backend.tf` file has been automatically updated with your specific S3 bucket and DynamoDB table.

```hcl
backend "s3" {
  bucket         = "ezops-tfstate-563702590660-us-east-2"
  # ...
  dynamodb_table = "ezops-tflock-563702590660"
}
```
*No action required here unless you destroy/re-create the bootstrap.*

## Phase 3: Infrastructure Deploy
Provision the staging infrastructure.

```bash
cd infra/environments/staging
terraform init
terraform plan -out=tfplan
# Review plan

> **Note on RDS Version**: The configuration now dynamically selects the latest valid PostgreSQL 16.x version available in the region to avoid "InvalidParameterCombination" errors.

## Phase 3.5: Build & Push Images

### Backend (Docker/ECR)
The Kubernetes deployment expects an image in ECR.
Run this in PowerShell from the project root:

```powershell
# 1. Login to ECR
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 563702590660.dkr.ecr.us-east-2.amazonaws.com

# 2. Build Backend
docker build -t stg-chico-backend ./apps/backend

# 3. Tag & Push
docker tag stg-chico-backend:latest 563702590660.dkr.ecr.us-east-2.amazonaws.com/stg-chico-backend:latest
docker push 563702590660.dkr.ecr.us-east-2.amazonaws.com/stg-chico-backend:latest
```

### Frontend (S3/CloudFront)
This step compiles the Vue.js app pointing to the Staging API and uploads it to S3.

**Prerequisite:** Ensure `apps/frontend/.env.staging` exists (I created it for you).

```powershell
cd apps/frontend

# 1. Install Dependencies
npm install

# 2. Build for Staging (Loads .env.staging)
npm run build -- --mode staging

# 3. Sync to S3 (Bucket Name from Terraform Output)
# Replace <BUCKET_NAME> with: stg-chico-frontend-53abeb09
aws s3 sync dist/ s3://stg-chico-frontend-53abeb09 --delete

# 4. Invalidate CloudFront Cache (ID from Terraform Output)
# Replace <DISTRIBUTION_ID> with: EEBZNGWUILDAZ
aws cloudfront create-invalidation --distribution-id EEBZNGWUILDAZ --paths "/*"
```

## Phase 4: Kubernetes Deployment
After infrastructure is ready (`eks_cluster_endpoint` output):

1.  **Update Kubeconfig**:
    ```bash
    aws eks update-kubeconfig --name stg-chico-eks --region us-east-2
    ```
2.  **Install ALB Controller**:
    ```bash
    # 1. Get Role ARN
    $env:ROLE_ARN = "arn:aws:iam::563702590660:role/stg-chico-alb-controller-irsa"
    
    # 2. Add Helm Repo
    helm repo add eks https://aws.github.io/eks-charts
    helm repo update

    # 3. Install
   helm install aws-load-balancer-controller eks/aws-load-balancer-controller `
    -n kube-system `
    --set clusterName=stg-chico-eks `
    --set serviceAccount.create=true `
    --set serviceAccount.name=aws-load-balancer-controller `
    --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=$env:ROLE_ARN
    ```
    *Verify with: `kubectl get deployment -n kube-system aws-load-balancer-controller`*

3.  **Configure Domain**:
    Edit `k8s/staging/backend/ingress.yaml` and update the `host` field to your desired domain (e.g., `api-stg.seudominio.com`).

4.  **Deploy Application**:
    ```powershell
    # 0. Garanta que está na raiz do projeto
    cd C:\Users\Chico\Desktop\Dev\EzOps\ezops-exam

    # 1. Namespace
    kubectl apply -f k8s/staging/namespace.yaml
    
    # 2. Secrets (Ensure you updated DB_PASSWORD in secret.yaml)
    kubectl apply -f k8s/staging/backend/secret.yaml
    
    # 3. App & Ingress
    kubectl apply -f k8s/staging/backend/configmap.yaml
    kubectl apply -f k8s/staging/backend/deployment.yaml
    kubectl apply -f k8s/staging/backend/service.yaml
    kubectl apply -f k8s/staging/backend/ingress.yaml
    ```

## Troubleshooting
**Issue**: Pods stuck in `ImagePullBackOff`?
**Fix**: This means the Docker image wasn't found in ECR.
1. Run **Phase 3.5** to build and push.
2. Restart the deployment to force a fresh pull:
   ```powershell
   kubectl rollout restart deployment/ezops-backend -n stg-chico
   ```

## Phase 5: DNS Setup (Cloudflare)
We successfully implemented a **Custom Domain** (`app-ezops.gratianovem.com.br`) using an AWS ACM Certificate.
See [Staging DNS Guide](staging-dns-cloudflare.md) for the exact CNAME records configured.

## Phase 6: CI/CD Configuration (GitHub Actions)
The workflows `backend-staging.yml` and `frontend-staging.yml` have been created.
To enable them, add the following **Environments** and **Secrets** in your GitHub Repository Settings.

### 1. Create Environment "staging"
Go to Settings -> Environments -> New Environment -> Name: `staging`

### 2. Configure Secrets (Environment or Repository)
Add these secrets to the `staging` environment (recommended) or repository:

| Secret Name | Value (Example/Source) |
| :--- | :--- |
| `AWS_ROLE_ARN` | `arn:aws:iam::563702590660:role/stg-chico-github-actions` (If OIDC) OR Empty if using Keys |
| `AWS_ACCESS_KEY_ID` | Your AWS Access Key |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Key |
| `DB_HOST` | `stg-chico-db.c1miyqamydgg.us-east-2.rds.amazonaws.com` |
| `DB_PORT` | `5432` |
| `DB_NAME` | `blog` |
| `DB_USER` | `postgres` |
| `DB_PASSWORD` | `<YOUR_DB_PASSWORD>` |
| `S3_BUCKET_NAME` | `stg-chico-frontend-53abeb09` |
| `CLOUDFRONT_DISTRIBUTION_ID` | `EEBZNGWUILDAZ` |

### 3. Trigger Pipelines
Push to the `staging` branch to trigger the workflows.
