# Staging DNS Setup (Cloudflare)

Since `enable_route53 = false` in Staging, use Cloudflare to route traffic.

## 1. Frontend (App) - Custom Domain with ACM
We used Terraform to provision an **ACM Certificate** in `us-east-1` and attached it to CloudFront.

**Step A: Certificate Validation (Already Done)**
- **Record**: `_58410b3c...app-ezops` -> `_cfd8abe4...acm-validations.aws`
- **Proxy Status**: DNS Only (Grey Cloud) - **Required for ACM Validation**

**Step B: Final CNAME (The App itself)**
Now that the certificate is valid, point the domain to CloudFront.

- **Type**: `CNAME`
- **Name**: `app-ezops` (-> `app-ezops.gratianovem.com.br`)
- **Target**: `d1bs40k4ngrklw.cloudfront.net`
- **Proxy Status**: **Proxied (Orange Cloud)** ☁️
- **SSL/TLS Mode**: **Full** (Encryption End-to-End)

## 2. Backend (API)
Target: ALB DNS Name (from `kubectl get ingress`).

**Record**:
- **Type**: `CNAME`
- **Name**: `api` (or `api-stg`) -> `api-stg.yourdomain.com`
- **Target**: `k8s-stgchico-ezopsing-....us-east-2.elb.amazonaws.com`
- **Proxy Status**: DNS Only (Grey Cloud) OR Proxied (Orange Cloud).
  - *Note*: If Proxied, ensure Cloudflare SSL is "Full" or "Flexible" depending on ALB cert. For Staging/Exam, "DNS Only" simplifies connectivity if you haven't set up valid certs on the ALB.
