# CI/CD Quality Gates & Workflows

## 🛠️ Overview
Our CI/CD pipeline is designed to enforce strict quality, security, and stability checks before any code reaches production.

## 🚦 Workflows

### 1. `ci.yml` (Continuous Integration)
**Triggers:** Pull Requests (main), Push (main).
**Scope:** Backend, Frontend, Infrastructure.
**Checks:**
- **Linting**: ESLint (Backend/Frontend), Hadolint (Docker), Terraform Fmt (Infra).
- **Testing**: Unit Tests (Jest), Build Verification (Vue).
- **Security**:
  - `npm audit`: Checks for vulnerable dependencies (High/Critical blocks pipeline).
  - `trivy fs`: Scans filesystem for secrets and misconfigurations.
  - `gitleaks`: Scans git history for hardcoded secrets.
- **Compliance**: `kubeconform` validates K8s manifests against the schema.

### 2. `deploy-staging.yml` (Continuous Deployment)
**Triggers:** Push to `main`.
**Steps:**
- **Backend**: Builds Docker Image -> Trivy Image Scan (High/Crit) -> Pushes to ECR -> Deploys to EKS (Staging Namespace).
- **Frontend**: Builds (Staging Mode) -> Syncs to S3 (Split Cache Strategy) -> Invalidates CloudFront.

### 3. `deploy-production.yml` (Release)
**Triggers:** Manual (`workflow_dispatch`) or Release Published.
**Environment:** `production` (Requires Approval in GitHub Settings).
**Steps:** Same as Staging, but targets Production Cluster/Bucket and blocks on ANY vulnerability.

## 🧑‍💻 Local Development
To run checks locally before pushing:

**Backend:**
```bash
cd apps/backend
npm run lint      # Check style
npm test          # Run tests
npm audit         # Check security
```

**Frontend:**
```bash
cd apps/frontend
npm run lint
npm run build     # Verify build passes
```

**Terraform:**
```bash
terraform fmt -recursive infra/
```

## 🛡️ Handling Security Failures
- **False Positives (Secrets):** Update `.gitleaks.toml` with an `[allowlist]`.
- **False Positives (Vulnerabilities):** Add CVE ID to `.trivyignore` (create file at root).
