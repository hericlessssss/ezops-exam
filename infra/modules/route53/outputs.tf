output "frontend_fqdn" {
  description = "Full domain name for the frontend"
  value       = length(aws_route53_record.frontend) > 0 ? aws_route53_record.frontend[0].fqdn : ""
}

output "backend_fqdn" {
  description = "Full domain name for the backend"
  value       = length(aws_route53_record.backend) > 0 ? aws_route53_record.backend[0].fqdn : ""
}
