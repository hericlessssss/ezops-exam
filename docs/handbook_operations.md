# 🛠️ Operations Handbook

This document serves as the central authority for operating, deploying, and maintaining the EzOps Exam solution across all environments.

### 💻 Local Development (Docker Compose)
For rapid local iteration, use the included Makefile:
- `make up`: Spin up the full stack (Frontend on 8080, Backend on 5000, Postgres on 5432).
- `make build`: Rebuild images and restart.
- `make logs`: Stream logs from all containers.

**Note**: The backend maps port `5000` to internal `3000` locally to match the frontend CORS expectations.

---

## 🚀 2. Deployment Quick Start

The project uses a hybrid deployment model: fully automated for Staging and semi-automated/controlled for Production.

### 🌐 Staging Environment (Automated)
- **Automatic Trigger**: Every `push` or `merge` to the `main` branch.
- **Workflow**: `.github/workflows/deploy-staging.yml`
- **Namespace**: `stg-chico`
- **URL**: [https://app-ezops.gratianovem.com.br](https://app-ezops.gratianovem.com.br)

### 💎 Production Environment (Controlled)
- **Trigger A (Manual)**: Go to **Actions** > **Deploy Production** > **Run workflow**.
- **Trigger B (Release)**: Create and publish a new **Release** in GitHub.
- **Namespace**: `test-chico`
- **URL**: [https://chico.exam.ezopscloud.tech](https://chico.exam.ezopscloud.tech)

---

## ☸️ 2. Kubernetes Operations (EKS)

### Cluster Connectivity
To manage the clusters, update your local kubeconfig:
```bash
# Staging (Ohio)
aws eks update-kubeconfig --name stg-chico-eks --region us-east-2

# Production (N. Virginia)
aws eks update-kubeconfig --name test-chico-eks --region us-east-1
```

### Manual Deployment / Rollout
If a manual update is needed after pushing images to ECR:
```bash
# Force a fresh pull (Production example)
kubectl rollout restart deployment/ezops-backend -n test-chico
kubectl rollout status deployment/ezops-backend -n test-chico
```

---

## 🏗️ 3. Infrastructure Management (Terraform)

### Remote State
State is managed in S3 with DynamoDB locking (Region: `us-east-1`).
- **Bucket**: `test-chico-tfstate-...`
- **DynamoDB**: `test-chico-tflock-...`

### Executing Changes
1. Navigate to `infra/environments/[staging|production]`.
2. `terraform init`
3. `terraform apply`

---

## 🛡️ 4. Quality & Security Gates

The CI/CD pipeline (`ci.yml`) enforces the following standards:
- **Linting**: Hadolint (Dockerfile) & ESLint (JS).
- **Security Audit**: `npm audit` (high/critical) & dependency scanning.
- **Infrastructure Validation**: Terraform format check & Kubeconform (K8s Manifests).
- **Secrets Scanning**: Gitleaks and Trivy (filesystem/images).

---

## 🗄️ 6. Database Maintenance

### Automatic Migrations
The backend features a self-healing migration service (`migrationService.js`):
- **On Startup**: It attempts to connect to the RDS/Local proxy with a 10-retry loop.
- **Idempotency**: It executes `apps/backend/database/create.sql` using `IF NOT EXISTS` logic.
- **Seeding**: It automatically seeds an initial admin user and sample posts if they are missing.

### Manual Access (Jumpbox)
A **Utility EC2** instance (`test-chico-utility`) is available in the public subnet for troubleshooting:
1. SSH into the utility instance (requires your private key).
2. Install `postgresql` client: `sudo dnf install postgresql15`.
3. Connect: `psql -h <RDS_ENDPOINT> -U postgres -d blog`.

### Health Checks
- **Backend API**: Send a GET request to `/health`. It should return `200 OK`.
- **Frontend**: Verify `200 OK` and check the `X-Cache` header for CloudFront hits.

### Common Issues
- **ImagePullBackOff**: Verify the ECR login in the GitHub Action or manually.
- **CORS Errors**: Ensure the `CORS_ALLOWED_ORIGINS` in the backend ConfigMap matches the frontend domain.
- **SSL Ingress Errors**: Confirm the ACM Certificate ARN in `ingress.yaml` is from the correct region (`us-east-1` for Prod, `us-east-2` for Stg).
