# EZOps Exam Solution

**Candidate**: Chico
**Project**: End-to-end DevOps Implementation (Infra, K8s, CI/CD, App Modernization)

---

## Overview

This repository contains the complete solution for the EZOps Infrastructure Exam.
The application (Vue.js + Node.js) has been modernized, dockerized, and deployed to AWS using **Three-Tier Architecture** best practices.

### Key Features
*   **Infrastructure as Code**: Terraform modules for creating Reproducible Environments (Staging & Production).
*   **Kubernetes (EKS)**: Backend running on EKS with AWS Load Balancer Controller.
*   **Serverless Frontend**: Protected S3 Static Website via CloudFront + OAC.
*   **Full HTTPS Security**:
    *   **Frontend**: ACM `us-east-1` + CloudFront.
    *   **Backend**: ACM `us-east-2` + ALB.
    *   **Redirects**: Force SSL & Private S3 Buckets.
*   **Quality & Security Gates**: 
    *   **Automated Linting**: Strict code style enforcement for Backend and Frontend.
    *   **Mocked Unit Testing**: High-performance unit tests with mocks ensuring API reliability.
    *   **Dependency Audit**: Automated security scanning for high/critical vulnerabilities on every PR.
    *   **Infrastructure Validation**: Automated Terraform formatting and K8s manifest validation (Kubeconform).
*   **CI/CD**: GitHub Actions workflows with OIDC (Keyless authentication), Environment Protection, and Automated Testing.

---

## Documentation

The `docs/` directory is the single source of truth for this project.

### Rapid Access
*   **[Staging Runbook](docs/runbooks/staging-runbook.md)**: How to operate the current Staging environment.
*   **[Production Runbook](docs/runbooks/production-runbook-ezops.md)**: **How to promote/deploy to EZOps account.**
*   **[Full Diary](docs/diary/full-implementation-history.md)**: Comprehensive detailed history of *everything* that was done.
*   **[Project Timeline Checklist](docs/project_timeline_checklist.md)**: **The complete roadmap of fixes and improvements.**

### Architecture & Reference
*   [Architecture Overview](docs/reference/architecture-overview.md)
*   [DNS & Certificates](docs/reference/dns-and-certificates.md)
*   [CI/CD Pipelines](docs/reference/cicd.md)
*   [Production Readiness Checklist](docs/checklists/production-readiness-checklist.md)

---

## Repository Structure

```tree
.
├── apps/               # Application Source Code
│   ├── backend/        # Node.js Express API (Dockerized)
│   └── frontend/       # Vue.js App (Modernized: Sass, Env Vars, Dockerized)
├── docs/               # Knowledge Base
│   ├── runbooks/       # Operational Guides
│   ├── checklists/     # Verification Steps
│   └── reference/      # Deep Dives
├── infra/              # Terraform IaC
│   ├── modules/        # Reusable Modules (Networking, Compute, DB)
│   └── environments/   # Environment Configs
│       ├── staging/    # Current Active Env
│       └── production/ # Ready for Exam Account
└── k8s/                # Kubernetes Manifests
    ├── staging/        # Staging Resources
    └── production/     # Production Resources (Templates)
```

---

## Status

| Environment | Status | URL |
|-------------|--------|-----|
| **Local** | ✅ Operational | `docker-compose up` |
| **Staging** | ✅ **Active** | [https://app-ezops.gratianovem.com.br](https://app-ezops.gratianovem.com.br) |
| **Production** | ⏸️ **Ready** | Ready to Deploy to Exam Account (See Runbook) |

---

## Local Development

To run the stack locally using Docker Compose:

```bash
make up
# OR
docker-compose up -d --build
```

*   **Frontend**: http://localhost:8080
*   **Backend**: http://localhost:5000/posts (local proxy)

### Local Quality Checks

Before pushing, it is recommended to run:

```bash
# Backend
cd apps/backend && npm run lint:fix && npm test

# Frontend
cd apps/frontend && npm run lint
```
