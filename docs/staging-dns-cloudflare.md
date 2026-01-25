# Staging DNS Setup (Cloudflare)

Since `enable_route53 = false` in Staging, use Cloudflare to route traffic.

## 1. Frontend (App)
Target: CloudFront Distribution Domain (from Terraform Output `frontend_cloudfront_domain`).

**Record**:
- **Type**: `CNAME`
- **Name**: `app` (or `app-stg`) -> `app-stg.yourdomain.com`
- **Target**: `d12345abcdef.cloudfront.net`
- **Proxy Status**: Proxied (Orange Cloud) - Optional, but recommended for SSL/Caching.

## 2. Backend (API)
Target: ALB DNS Name (from `kubectl get ingress`).

**Record**:
- **Type**: `CNAME`
- **Name**: `api` (or `api-stg`) -> `api-stg.yourdomain.com`
- **Target**: `k8s-stgchico-ezopsing-....us-east-2.elb.amazonaws.com`
- **Proxy Status**: DNS Only (Grey Cloud) OR Proxied (Orange Cloud).
  - *Note*: If Proxied, ensure Cloudflare SSL is "Full" or "Flexible" depending on ALB cert. For Staging/Exam, "DNS Only" simplifies connectivity if you haven't set up valid certs on the ALB.
