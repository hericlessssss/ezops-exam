output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private Subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "ecr_repository_urls" {
  description = "Map of ECR repository URLs"
  value       = module.ecr.repository_urls
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = module.rds.db_endpoint
}

output "frontend_cloudfront_domain" {
  description = "CloudFront Domain Name"
  value       = module.cloudfront.distribution_domain_name
}

output "alb_controller_role_arn" {
  description = "IAM Role ARN for AWS Load Balancer Controller"
  value       = module.eks.alb_controller_role_arn
}

output "utility_ec2_id" {
  description = "ID of the Utility EC2 instance"
  value       = module.ec2.instance_id
}

output "utility_ec2_public_ip" {
  description = "Public IP of the Utility EC2 instance"
  value       = module.ec2.public_ip
}


