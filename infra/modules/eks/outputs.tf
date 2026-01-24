output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = "https://placeholder-eks-endpoint"
}

output "cluster_name" {
  value = var.cluster_name
}
