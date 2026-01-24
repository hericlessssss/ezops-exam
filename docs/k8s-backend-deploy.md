# Backend Deployment Guide

This guide details how to deploy the Node.js backend to the EKS cluster using the manifests in `k8s/`.

## Prerequisites

1.  **Cluster Access**: Ensure `kubectl` is configured.
    ```bash
    aws eks update-kubeconfig --region us-east-2 --name test-chico-eks
    ```
2.  **AWS Load Balancer Controller**: Must be installed (see section below) for Ingress to work.

## AWS Load Balancer Controller (One-time Setup)

Before deploying Ingress, install the controller via Helm:

1.  **Create IAM Policy**:
    *(Download policy from AWS documentation first)*
    ```bash
    aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json
    ```
2.  **Create Service Account**:
    ```bash
    eksctl create iamserviceaccount \
      --cluster=test-chico-eks \
      --namespace=kube-system \
      --name=aws-load-balancer-controller \
      --attach-policy-arn=arn:aws:iam::<ACCOUNT_ID>:policy/AWSLoadBalancerControllerIAMPolicy \
      --approve
    ```
3.  **Install via Helm**:
    ```bash
    helm repo add eks https://aws.github.io/eks-charts
    helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
      -n kube-system \
      --set clusterName=test-chico-eks \
      --set serviceAccount.create=false \
      --set serviceAccount.name=aws-load-balancer-controller
    ```

## Deploy Application

### 1. Create Namespace
```bash
kubectl apply -f k8s/namespace.yaml
```

### 2. Configure Secrets
Replace placeholders with actual values from Terraform RDS outputs:
```bash
kubectl create secret generic backend-secrets \
  --namespace test-chico \
  --from-literal=DB_USER='postgres' \
  --from-literal=DB_PASSWORD='<YOUR_RDS_PASSWORD>'
```

### 3. Apply Config & App
Edit `k8s/backend/configmap.yaml` and `k8s/backend/deployment.yaml` to replace placeholders (DB Host, ECR Image URL).
```bash
kubectl apply -f k8s/backend/configmap.yaml
kubectl apply -f k8s/backend/deployment.yaml
kubectl apply -f k8s/backend/service.yaml
```

### 4. Expose via Ingress
```bash
kubectl apply -f k8s/backend/ingress.yaml
```
*Wait for ALB provisioning (~2-5 mins).*

## Validation

1.  **Check Pods**:
    ```bash
    kubectl get pods -n test-chico
    ```
2.  **Check Ingress Address**:
    ```bash
    kubectl get ingress -n test-chico
    ```
    *Copy the ADDRESS (ALB DNS).*
3.  **Test Health**:
    ```bash
    curl http://<ALB_DNS>/health
    ```
    *Expected: 200 OK*
