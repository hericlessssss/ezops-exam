# AWS Load Balancer Controller Setup Guide

This guide describes how to install the AWS Load Balancer Controller on the EKS cluster using Helm and the IRSA (IAM Roles for Service Accounts) configured via Terraform.

## Prerequisites

1.  **Cluster Access**: `kubectl` configured.
2.  **Helm Installed**: `helm version`
3.  **Role ARN**: Get the ARN from Terraform outputs:
    ```bash
    cd infra/environments/test
    terraform output alb_controller_role_arn
    # Result: arn:aws:iam::<ACCOUNT>:role/test-chico-alb-controller-irsa
    ```

## Installation Steps

### 1. Add Helm Repo
```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update
```

### 2. Install Controller
Replace `<ROLE_ARN>` with the output from Terraform.

```bash
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=test-chico-eks \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=<ROLE_ARN>
```

### 3. Verify Installation
```bash
kubectl get deployment -n kube-system aws-load-balancer-controller
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller
```
*Expected: 2/2 Ready.*

## Next Steps (Ingress)

Once the controller is running, apply the Ingress manifest:

```bash
kubectl apply -f k8s/backend/ingress.yaml
```

Wait 2-3 minutes and retrieve the Load Balancer DNS:
```bash
kubectl get ingress -n test-chico
```

Use this DNS address to update the `backend_target` in Terraform (Route53) and apply again.
