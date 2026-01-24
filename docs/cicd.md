# CI/CD Pipeline Documentation

This document describes the GitHub Actions workflows configured for the project.

## Workflows

### 1. Backend CI/CD (`.github/workflows/backend.yml`)
- **Triggers**: Push to `main`/`master`, Pull Requests (Integration only).
- **Paths**: `apps/backend/**`, `k8s/**`.
- **Jobs**:
  1.  **Continuous Integration**: Installs dependencies (`npm ci`) and runs tests (`npm test`).
  2.  **Deploy**:
      - Authenticates with AWS (OIDC or Keys).
      - Builds Docker image and pushes to ECR (tags: `latest`, `GIT_SHA`).
      - Updates `kubeconfig`.
      - Applies Kubernetes Manifests (`kubectl apply`).
      - Updates Deployment image (`kubectl set image`).
      - Waits for Rollout (`kubectl rollout status`).

### 2. Frontend CI/CD (`.github/workflows/frontend.yml`)
- **Triggers**: Push to `main`/`master`, Pull Requests (Build only).
- **Paths**: `apps/frontend/**`.
- **Jobs**:
  1.  **Build and Deploy**:
      - Installs dependencies (`npm ci`).
      - Builds the static application (`npm run build`).
      - Authenticates with AWS.
      - Syncs `dist/` folder to S3 Bucket (`aws s3 sync`).
      - Invalidates CloudFront cache (`aws cloudfront create-invalidation`).

## Configuration & Secrets

To run these pipelines, you must configure **GitHub Secrets** and **Variables**.

### Repository Secrets
Go to **Settings > Secrets and variables > Actions**.

| Secret Name | Description | Required? |
| :--- | :--- | :--- |
| `AWS_ROLE_ARN` | IAM Role ARN for OIDC Authentication (Recommended). Leave empty to use Access Keys. | Optional |
| `AWS_ACCESS_KEY_ID` | IAM User Access Key (Fallback if Role ARN empty). | Optional |
| `AWS_SECRET_ACCESS_KEY` | IAM User Secret Key (Fallback if Role ARN empty). | Optional |
| `S3_BUCKET_NAME` | Name of the S3 Bucket for Frontend (from Terraform output). | Yes |
| `CLOUDFRONT_DISTRIBUTION_ID` | CloudFront ID for Invalidation (from Terraform output). | Yes |
| `DB_HOST` | Database Endpoint (RDS). | Yes |
| `DB_NAME` | Database Name. | Yes |
| `DB_PORT` | Database Port (e.g., 5432). | Yes |
| `DB_USER` | Database Username. | Yes |
| `DB_PASSWORD` | Database Password. | Yes |

### Recommended: GitHub Environments
Create an Environment named `test` in GitHub Settings to manage these secrets specifically for the exam environment.

## Granting GitHub Actions IAM Role access to EKS

**CRITICAL**: If you use OIDC (`AWS_ROLE_ARN`), the GitHub Actions IAM Role must have permission to access the EKS cluster. Without this, `kubectl` commands will fail with `Forbidden`.

### Option 1: Access Entry (Preferred for newer EKS)
Run this CLI command to map the IAM Role to the `system:masters` group (admin access):
```bash
aws eks create-access-entry --cluster-name test-chico-eks \
  --principal-arn <YOUR_GITHUB_ACTIONS_ROLE_ARN> \
  --type STANDARD \
  --username github-actions

aws eks associate-access-policy --cluster-name test-chico-eks \
  --principal-arn <YOUR_GITHUB_ACTIONS_ROLE_ARN> \
  --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy \
  --access-scope type=cluster
```

### Option 2: `aws-auth` ConfigMap (Legacy/Fallback)
Edit the `aws-auth` ConfigMap in `kube-system` to add the Role ARN:
```yaml
mapRoles:
  - rolearn: <YOUR_GITHUB_ACTIONS_ROLE_ARN>
    username: github-actions
    groups:
      - system:masters
```

## Validation Strategy
1.  **Backend**: Check that the EKS Pods are running the new image tag (matches Git SHA).
    ```bash
    kubectl get pods -n test-chico -o jsonpath="{.items[*].spec.containers[*].image}"
    ```
2.  **Frontend**: Visit the CloudFront URL and verify the site loads. Check S3 bucket timestamp.

