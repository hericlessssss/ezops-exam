# Exam Compliance Checklist

This checklist is derived strictly from the "EZOps.cloud - DevOps Engineer Entrance Exam" PDF.

## 1. Application Dockerization
- [ ] **Backend Dockerfile**: Created for `ezops-br/rest-api-ezops-test`.
- [ ] **Frontend Dockerfile**: Created for `ezops-br/vuejs-ezops-test`.
- [ ] **Efficient/Scalable**: Multi-stage builds, minimal images.

## 2. Infrastructure Provisioning (Terraform)
- [ ] **Resources**:
  - [x] VPC
  - [x] Elastic Load Balancer (ELB) -> *Implemented via ALB Controller (requires documentation)*
  - [x] EKS (or ECS)
  - [x] EC2 (Utility instance)
  - [x] CloudFront
  - [x] S3
  - [x] RDS
- [x] **Best Practices**:
  - [x] Non-local state files (S3).
  - [x] State locking (DynamoDB).
  - [x] Naming convention: `test-<yourname>`.
  - [x] Use Terraform Modules.

## 3. Application Hosting
- [ ] **Backend**:
  - [x] Deployed on EKS.
  - [ ] accessible via DNS (Link provided). -> *Pending final domain variable wiring*
  - [x] ALB used.
- [ ] **Frontend**:
  - [x] Deploy on CloudFront + S3 (Serverless).
- [ ] **DNS/Routing**:
  - [ ] Link format: `<your-name>.exam.ezopscloud.tech` (Route53). -> *Needs variable fix*
  - [ ] Configure ELB to handle the link.

## 4. CI/CD Process
- [x] **Tools**: GitHub Actions (or CodePipeline).
- [ ] **Pipeline Steps**:
  - [x] Build Docker images.
  - [x] Deploy Backend to EKS.
  - [x] Deploy Frontend to CloudFront + S3.

## 5. Evaluation Criteria (Self-Check)
- [ ] Practical understanding of Docker, Terraform, K8s, CI/CD.
- [ ] IaC with Terraform (AWS).
- [ ] Version Control & Best Practices.
- [ ] Clarity & Organization.
