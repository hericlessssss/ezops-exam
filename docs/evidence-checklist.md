# Exam Evidence Checklist

Use this checklist to collect and present proofs of your successful implementation.

## 1. Infrastructure (Terraform)
- [ ] **Validation Output**:
  ```bash
  cd infra/environments/test
  terraform fmt -recursive
  terraform validate
  # Capture screenshot of "Success! The configuration is valid."
  ```

- [ ] **Infrastructure Plan**:
  ```bash
  terraform plan
  # Capture partial output showing ~50 resources to add (VPC, EKS, RDS, etc.)
  ```

- [ ] **EC2 Utility Instance**:
  ```bash
  terraform console
  > module.ec2
  # Start instance and show:
  aws ec2 describe-instances --filters "Name=tag:Name,Values=test-chico-utility"
  ```

## 2. CI/CD Pipelines (GitHub Actions)
- [ ] **Backend Workflow Success**:
  - Screenshot of GitHub Actions "Backend CI/CD" run (Green Check).
  - Show "Deploy to EKS" step logs.

- [ ] **Frontend Workflow Success**:
  - Screenshot of GitHub Actions "Frontend CI/CD" run (Green Check).
  - Show "Sync to S3" logs.

- [ ] **ECR Images**:
  ```bash
  aws ecr list-images --repository-name test-chico-backend
  ```

## 3. Kubernetes & Application
- [ ] **Cluster Info**:
  ```bash
  kubectl get nodes -o wide
  ```

- [ ] **Backend Status**:
  ```bash
  kubectl get pods -n test-chico
  kubectl get service -n test-chico
  kubectl get ingress -n test-chico
  ```

- [ ] **Connectivity (App)**:
  - Screenshot of Frontend URL (`app.test-chico...`) loading in browser.
  - `curl -I https://app.test-chico...` (HTTP 200).

- [ ] **Connectivity (API)**:
  - `curl https://api.test-chico.../health` (Returns `OK` or `200`).
  - Screenshot of browser hitting `/posts` (Empty array `[]`).

## 4. Database
- [ ] **Connection**:
  - Show logs of backend pod successfully connecting to DB (no ECONNREFUSED).
