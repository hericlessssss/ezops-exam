variable "hosted_zone_id" {
  description = "The ID of the existing hosted zone"
  type        = string
}

variable "domain_name" {
  description = "The domain name (e.g. example.com)"
  type        = string
}

variable "backend_subdomain" {
  description = "Subdomain for the backend API"
  type        = string
  default     = "api"
}

variable "frontend_subdomain" {
  description = "Subdomain for the frontend App"
  type        = string
  default     = "app"
}

variable "backend_target" {
  description = "DNS name (ALB) to route backend traffic to"
  type        = string
}

variable "frontend_target" {
  description = "DNS name (CloudFront) to route frontend traffic to"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
