# 📜 Implementation & History Diary

A chronological record of the evolution, modernization, and deployment journey of the EzOps Exam project.

---

## 🗓️ 1. Project Timeline Overview

| Phase | Milestone | Outcome |
| :--- | :--- | :--- |
| **P1** | Source Modernization | Converted original code to use environment variables and Sass. |
| **P2** | Containerization | Dockerized Frontend (with Nginx) and Backend. |
| **P3** | Infrastructure as Code | Built modular Terraform for VPC, EKS, RDS, and CloudFront. |
| **P4** | CI/CD Ecosystem | Established GitHub Actions with OIDC and security scans. |
| **P5** | Production Rollout | Deployed to `test-chico` environment with full SSL and Custom Domains. |

---

## 🏗️ 2. Detailed History Log

### Modernization Steps
- **Backend**: Injected `pg-promise` configuration via environment variables for cloud portability.
- **Frontend**: Migrated to Vue CLI 4.x standards, separated styling into `.scss` modules, and implemented multi-environment build profiles (`.env.staging`, `.env.production`).

### Infrastructure Evolution
- **Modular Terraform**: Created reusable modules to ensure consistency between Staging and Production.
- **Networking**: Implemented a secure VPC structure with NAT Gateways for private pod access to the internet (AWS APIs).
- **Content Delivery**: Optimized frontend delivery with CloudFront OAC, providing a faster and more secure SPA experience.

### Key Fixes & Improvements
- **SSL Enforcement**: Configured ALB listeners to redirect HTTP (80) to HTTPS (443) automatically.
- **RDS Connectivity**: Enabled SSL for database connections to meet high security standards.
- **SPA Routing**: Implemented custom error mapping in CloudFront to prevent "404 on refresh" issues typical of SPAs.
- **OIDC Integration**: Migrated from static IAM keys to secure, keyless OIDC authentication in GitHub Actions.

---

## 🎯 3. Final Result
The project transformed from a local development codebase into a **Production-Ready, Cloud-Native Application** following the best practices of the Well-Architected Framework.
