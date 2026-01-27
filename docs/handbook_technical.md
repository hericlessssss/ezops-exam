# 📔 Technical Reference Handbook

This handbook provides a deep dive into the architecture, infrastructure, and CI/CD internals of the EzOps Exam solution.

---

## 🏛️ 1. Architecture Overview

The system follows a modernized **Three-Tier Architecture** pattern:

### Components
- **Frontend (Vue.js)**: A static SPA hosted on **AWS S3** and distributed via **CloudFront** for low latency and high availability.
- **Backend (Node.js)**: A containerized API running on **Amazon EKS (Kubernetes)** inside a private subnet.
- **Database (PostgreSQL)**: A managed **AWS RDS** instance providing secure and persistent data storage.

### Data Flow
1. Client requests the app via the CloudFront URL (`chico.exam.ezopscloud.tech`).
2. CloudFront serves assets from S3 (protected by OAC).
3. The browser-side app makes API calls to the ALB (`api.chico.exam.ezopscloud.tech`).
4. The ALB routes traffic to EKS pods in the private subnet.
5. The Backend connects to RDS using SSL encryption.

---

## 🌐 2. Networking & Infrastructure (Production)

| Component | Detail |
| :--- | :--- |
| **VPC** | `10.1.0.0/16` (2 Public Subnets, 2 Private Subnets) |
| **EKS Cluster** | `test-chico-eks` (v1.29) on `t3.medium` instances. |
| **RDS DB** | `test-chico-db` (PostgreSQL 16.x) |
| **CDN** | CloudFront ID `E30YXCU38H3O22` |
| **Regions** | `us-east-1` (Primary) |
| **Utility Node**| `t3.micro` Jumpbox in Public Subnet for admin tasks. |

---

## ⚙️ 3. Continuous Integration & Delivery

### GitHub Actions Ecosystem
- **OIDC Connection**: Keyless authentication via IAM Roles and OIDC (`id-token: write`).
- **Isolation**: Workflows are strictly isolated using GitHub **Environments** (`staging`, `production`).

### IRSA (IAM Roles for Service Accounts)
We implement security-best-practices by mapping IAM Roles to Kubernetes Service Accounts:
- **Load Balancer Controller**: Mapped to `aws-load-balancer-controller` in `kube-system`.
- **Backend Service**: Potential for future expansion (e.g., S3 access).

---

## 💻 4. Application Logic Internals

### Frontend (SPA)
- **State**: Managed via **Vuex** for consistent data flow.
- **Security**: Uses Axios Interceptors to inject JWT tokens intoทุก request headers.
- **Routing**: Native Vue Router with CloudFront error-path mapping (404 -> index.html).

### Backend (API)
- **CORS**: Dynamically configured via `CORS_ALLOWED_ORIGINS` to prevent unauthorized cross-origin access.
- **Auth**: Passwords are encrypted with **bcryptjs** (10 salt rounds).
- **Health**: Dedicated `/health` endpoint for ALB and K8s liveness probes.

### Pipeline Matrix
| Pipeline | Logic |
| :--- | :--- |
| **CI (Quality)** | Standard JS linting, HADOLINT (Docker), and Trivy security scans. |
| **Deploy Staging** | Automated push-to-main trigger. |
| **Deploy Production** | Tagged release or manual trigger for controlled promotion. |

---

## 🌐 5. DNS & Security Policy

### DNS Management
We utilize **Amazon Route53** for production and **Cloudflare** for staging.
- **Frontend**: A/AAAA Alias records pointing to CloudFront.
- **Backend**: A Alias records pointing to the ALB.

### Security Controls
- **Private S3**: Block Public Access enabled at account level; OAC policy restricted to CloudFront.
- **RDS Isolation**: Instance resides in private subnets with Security Groups restricted to the EKS worker nodes.
- **SSL/TLS**: Mandatory HTTPS enforced at the ALB and CloudFront levels.
