variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "AWS CLI Profile"
  type        = string
  default     = "hrclsfss"
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.1.0.0/16" # Different from Staging (10.0.0.0/16) to allow peering if needed
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  description = "Public Subnet CIDRs"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "private_subnets" {
  description = "Private Subnet CIDRs"
  type        = list(string)
  default     = ["10.1.3.0/24", "10.1.4.0/24"]
}

variable "tags" {
  description = "Common Tags"
  type        = map(string)
  default = {
    Project = "ezops-exam"
    Env     = "production"
    Owner   = "chico"
  }
}

variable "enable_route53" {
  description = "Enable Route53 module"
  type        = bool
  default     = true
}

variable "hosted_zone_id" {
  description = "Route53 Hosted Zone ID (EZOps Account)"
  type        = string
  default     = "" # TO BE FILLED
}

variable "exam_domain" {
  description = "Base domain for the exam"
  type        = string
  default     = "exam.ezopscloud.tech"
}

variable "dns_label" {
  description = "Unique label for this candidate (e.g. chico)"
  type        = string
  default     = "chico"
}

variable "cloudfront_aliases" {
  description = "Alternate domain names (CNAMEs) for CloudFront"
  type        = list(string)
  default     = []
}

variable "backend_target" {
  description = "ALB DNS Name for Backend (from K8s Service/Ingress)"
  type        = string
  default     = ""
}

variable "cloudfront_acm_arn" {
  description = "ARN of an existing ACM Certificate for CloudFront (Frontend) in us-east-1"
  type        = string
  default     = "" # TO BE FILLED
}

variable "backend_acm_arn" {
  description = "ARN of an existing ACM Certificate for ALB (Backend) in us-east-2"
  type        = string
  default     = "" # TO BE FILLED
}
