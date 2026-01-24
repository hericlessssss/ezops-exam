variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-2"
}

variable "profile" {
  description = "AWS CLI Profile"
  type        = string
  default     = "hrclsfss"
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "ezops-exam"
}

variable "environment" {
  description = "Environment Name"
  type        = string
  default     = "test"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

variable "public_subnets" {
  description = "Public Subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "Private Subnet CIDRs"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "tags" {
  description = "Default tags"
  type        = map(string)
  default = {
    Project = "ezops-exam"
    Owner   = "chico"
    Env     = "test"
  }
}

variable "hosted_zone_id" {
  description = "Route53 Hosted Zone ID"
  type        = string
  default     = "Z00000000000000000000" # Placeholder
}

variable "domain_name" {
  description = "Domain Name"
  type        = string
  default     = "example.com" # Placeholder
}
variable "backend_target" {
  description = "ALB DNS Name for Backend (Post-Deploy)"
  type        = string
  default     = "" # Initially empty, filled after K8s Ingress deploy
}
