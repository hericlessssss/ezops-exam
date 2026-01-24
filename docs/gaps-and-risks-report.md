# Gaps & Risks Report

Based on the audit against the Exam PDF.

## 1. Domain Naming Violation (HIGH)
- **Problem**: Current config uses `example.com` placeholders and `test-chico` subdomain hardcoded logic.
- **Requirement**: "Link to access... ex: `<your-name>.exam.ezopscloud.tech`".
- **Risk**: Automatic fail for not following the naming convention or leaving placeholders.
- **Fix**:
  - Introduce `exam_domain` variable (`exam.ezopscloud.tech`).
  - Introduce `dns_label` variable (`chico`).
  - Standardize FQDN: `chico.exam.ezopscloud.tech` (or `api.chico...`).

## 2. Ingress Host Hardcoding (MED)
- **Problem**: `ingress.yaml` has `host: api.test-chico.example.com`.
- **Requirement**: Must align with the Route53 domain.
- **Risk**: Ingress won't route traffic if host header doesn't match.
- **Fix**: Use "Hostless Ingress" (remove strict host rule) to allow the ALB to accept traffic from the DNS record created by Terraform, avoiding circular dependency or manual editing.

## 3. ELB Provisioning Interpretability (LOW)
- **Problem**: The PDF asks to "Provision... ELB" with Terraform. We use EKS + ALB Controller (which provisions ALB via API, not directly via Terraform resource `aws_lb`).
- **Risk**: Avaliador might expect `resource "aws_lb"` in main.tf.
- **Fix**: Explicitly document that "Modern Best Practice" for EKS is using the Controller, and that the Controller IS provisioned via Terraform (Chart/IRSA). This is a defensible technical choice.

## 4. Documentation Language (LOW)
- **Problem**: Some logic verified in PT-BR conversations.
- **Requirement**: Deliverables are config files, but clarity/org is graded.
- **Fix**: Ensure `README.md` and `docs/*` are strictly EN for the "Evaluate" deliverables, saving PT-BR only for context summary.
