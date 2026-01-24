# Utility EC2 Instance Documentation

This document describes the "Utility" EC2 instance added to the infrastructure infrastructure to satisfy exam requirements and provide a debug jump host.

## Goal
Provision a minimal, cost-effective EC2 instance within the public subnet to serve as a utility or bastion host for basic connectivity testing.

## Infrastructure Details

### Specifications
- **Instance Type**: `t3.micro` (Low cost).
- **AMI**: Amazon Linux 2023 (Latest stable).
- **Network**: Deployment in `public_subnets[0]` with a Public IP enabled.
- **Security**: 
  - **Inbound**: Default DENY all (No open ports by default).
  - **Outbound**: Allow ALL (for updates/installs).
  - **Access**: Configurable via `allow_ssh_cidr` variable.

### Provisioning
The instance is managed via the Terraform module in `infra/modules/ec2`.

## Operations

### How to Apply
The instance is part of the `test` environment.
```bash
cd infra/environments/test
terraform apply
```

### How to Verify
After applying, Terraform will output the instance ID and Public IP.
```bash
# Output example
utility_ec2_id        = "i-0123456789abcdef0"
utility_ec2_public_ip = "3.12.123.45"

# Check status via AWS CLI
aws ec2 describe-instances --instance-ids <INSTANCE_ID>
```

### How to Access (Optional)
By default, SSH is blocked. To enable access:
1. Update `infra/environments/test/main.tf`:
   ```hcl
   module "ec2" {
     ...
     allow_ssh_cidr = ["YOUR_IP/32"]
     key_name       = "your-key-pair"
   }
   ```
2. Apply changes.
3. SSH into the instance:
   ```bash
   ssh -i key.pem ec2-user@<PUBLIC_IP>
   ```

### How to Destroy
```bash
terraform destroy -target=module.ec2
```
