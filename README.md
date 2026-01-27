# 🚀 EzOps Exam Solution — Cloud-Native Modernization

**Candidate**: Chico  
**Focus**: End-to-End DevOps | Infrastructure as Code | EKS | CI/CD | Security

---

## 🌟 Overview
This project demonstrates a professional, secure, and highly automated modernization of a Node.js/Vue.js application. It follows the **Well-Architected Framework** principles, featuring a Three-Tier architecture deployed on AWS using Terraform and Kubernetes.

### 💎 Key Highlights
*   **Infrastructure as Code (IaC)**: Fully modular Terraform for Reproducible Environments.
*   **Container Orquestration**: High-availability Backend on **Amazon EKS**.
*   **Secure Content Delivery**: Serverless Frontend via **S3 + CloudFront (OAC)**.
*   **Security First**: Keyless **GitHub OIDC** authentication, automated security audits, and mandatory SSL.
*   **Quality Gates**: Strict linting (Hadolint/ESLint) and infra validation (Kubeconform) in every pipeline.

---

## 📖 Project Handbooks
To provide the best navigation experience, the documentation has been unified into four master guides:

| Handbook | Purpose |
| :--- | :--- |
| [**🛠️ Operations Guide**](file:///c:/Users/Chico/Desktop/Dev/EzOps/ezops-exam/docs/handbook_operations.md) | How to deploy, trigger pipelines, and operate the system. |
| [**📔 Technical Reference**](file:///c:/Users/Chico/Desktop/Dev/EzOps/ezops-exam/docs/handbook_technical.md) | Deep dive into Architecture, Inventory, and CI/CD Internals. |
| [**✅ Compliance & Validation**](file:///c:/Users/Chico/Desktop/Dev/EzOps/ezops-exam/docs/handbook_validation.md) | Operational proof, security evidence, and readiness reports. |
| [**📜 Implementation History**](file:///c:/Users/Chico/Desktop/Dev/EzOps/ezops-exam/docs/handbook_history.md) | The journey of modernization, fixes, and chronological milestones. |

---

## 🚦 Environment Status

| Environment | Status | Endpoint |
| :--- | :--- | :--- |
| **Local** | ✅ Operational | `docker-compose up` |
| **Staging** | ✅ **Active** | [https://app-ezops.gratianovem.com.br](https://app-ezops.gratianovem.com.br) |
| **Production** | ✅ **Operational** | [https://chico.exam.ezopscloud.tech](https://chico.exam.ezopscloud.tech) |

---

## 🛠️ Quick Development Start

```bash
# High-speed local spin-up
docker-compose up -d --build

# Run Quality Checks
cd apps/backend && npm run lint && npm test
cd apps/frontend && npm run lint
```

---

## 🏁 Final Conclusion
This repository is the final result of a complete end-to-end DevOps implementation, focusing on **automation, security, and scalability**. Every resource, from VPC to CI/CD workflows, has been carefully crafted and validated for production readiness.

> Made with ☕ and passion for DevOps culture.
