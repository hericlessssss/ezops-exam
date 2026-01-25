# 🚀 Production Runbook (EZOps Account)

## 📌 Context
This runbook describes the procedure to deploy the full stack to the **Production Environment** (EZOps Exam Account).
*   **Prefix**: `test-chico` (Exam Requirement)
*   **Region**: `us-east-2` (Ohio)
*   **Frontend Domain**: `app.chico.exam.ezopscloud.tech`
*   **Backend Domain**: `api.chico.exam.ezopscloud.tech`

---

## 🔑 Phase 0: Prerequisites & Credentials
**Goal**: Securely configure access to the EZOps AWS Account.

1.  **Configure AWS CLI Profile (Recommended)**
    Avoid exporting keys directly in the shell history.
    ```powershell
    aws configure --profile ezops
    # Paste Access Key, Secret Key, Region (us-east-2), Output (json)
    $env:AWS_PROFILE = "ezops"
    ```
    *Verification:* `aws sts get-caller-identity` (Check Account ID).

2.  **Request ACM Certificates (Manual Step)**
    Before running Terraform, ensure you have the ARNs for the provided exam domain.
    *   **Certificate 1 (Frontend)** in **`us-east-1`** (N. Virginia): `*.exam.ezopscloud.tech` (for CloudFront).
    *   **Certificate 2 (Backend)** in **`us-east-2`** (Ohio): `*.exam.ezopscloud.tech` (for ALB).
    *Note: If the exam provides pre-created certificates, locate their ARNs.*

---

## 🛠️ Phase 1: Infrastructure (Terraform)
**Directory**: `infra/environments/production`

1.  **Initialize**:
    ```powershell
    terraform init
    ```

2.  **Apply (First Pass - Infra)**:
    Pass the variables captured in Phase 0.
    ```powershell
    terraform apply `
      -var="hosted_zone_id=Z0123..." `
      -var="production_acm_arn=arn:aws:acm:us-east-1:..." `  # Frontend Cert
      -var="backend_acm_arn=arn:aws:acm:us-east-2:..."       # Backend Cert (Not used by TF yet, but good to set)
    ```

3.  **Validate**:
    - EKS Cluster `test-chico-eks` is ACTIVE.
    - RDS `test-chico-db` is AVAILABLE.

---

## ☸️ Phase 2: Kubernetes (Bootstrap)
**Directory**: `k8s/production`

1.  **Connect to Cluster**:
    ```powershell
    aws eks update-kubeconfig --name test-chico-eks --region us-east-2
    ```

2.  **Deploy Foundation**:
    ```powershell
    # Install AWS Load Balancer Controller (Follow alb-controller-setup.md if not installed)
    # Apply Namespace
    kubectl apply -f k8s/production/namespace.yaml
    ```

3.  **Secrets Management (Safe Operations)**
    Avoid command history leaks. Use a temporary file or environment variable.
    ```powershell
    # Option A: Interactive (PowerShell)
    $db_pass = Read-Host -Prompt "Enter DB Password"
    kubectl create secret generic ezops-backend-secrets --from-literal=DB_PASSWORD=$db_pass -n test-chico
    ```
    *(Ideally, this would be handled by GitOps or External Secrets in a real scenario).*

4.  **Deploy Backend App**:
    **CRITICAL**: Edit `k8s/production/backend/ingress.yaml` before applying!
    - Replace `alb.ingress.kubernetes.io/certificate-arn` with the **`us-east-2`** ARN.
    ```powershell
    kubectl apply -f k8s/production/backend
    ```

---

## 🔄 Phase 3: The "Chicken-and-Egg" DNS Fix
**Context**: Route53 needs the ALB DNS name, but the ALB is only created AFTER the Ingress is applied.

1.  **Get ALB Hostname**:
    ```powershell
    kubectl get ingress -n test-chico
    # Copy the ADDRESS (e.g., k8s-testchico-....us-east-2.elb.amazonaws.com)
    ```

2.  **Update Terraform**:
    Run Terraform again to update the Route53 `api` record.
    ```powershell
    terraform apply `
      -var="backend_target=k8s-testchico-....us-east-2.elb.amazonaws.com" `
      # ... keep other variables ...
    ```

---

## 🚀 Phase 4: CI/CD & Promotion
Since GitHub Actions workflows `*-production.yml` are configured:
1.  Go to GitHub Repo > Settings > Secrets.
2.  Add Production Secrets:
    - `PROD_FRONTEND_BUCKET_NAME` (From Terraform Output `s3_frontend_bucket_name`)
    - `PROD_CLOUDFRONT_ID` (From Terraform Output `cloudfront_distribution_id`)
3.  Trigger the **Release** on GitHub or manually dispatch the workflow for the `production` environment.

## 🔎 Phase 5: Verification
- **Frontend**: https://app.chico.exam.ezopscloud.tech
- **Backend**: https://api.chico.exam.ezopscloud.tech/health
