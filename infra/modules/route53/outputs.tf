output "frontend_fqdn" {
  description = "Full domain name for the frontend"
  value       = aws_route53_record.frontend.fqdn
}

output "backend_fqdn" {
  description = "Full domain name for the backend"
  value       = aws_route53_record.backend.fqdn
}
