# Staging Variables Reference

Key variables configured in `infra/environments/staging/variables.tf`.

| Variable | Default | Description |
| :--- | :--- | :--- |
| `environment` | `staging` | Defines the environment context. |
| `vpc_cidr` | `10.0.0.0/16` | Main network block. |
| `enable_route53` | `false` | **Disabled** for Staging. We use Cloudflare manually. |
| `backend_target` | `""` | Placeholder. In Staging, we don't automatically update this via Terraform. |

## Why no Route53?
To avoid managing Hosted Zones in AWS for Staging and to leverage your existing Cloudflare setup. We simply point CNAMEs to the created resources (ALB / CloudFront).
