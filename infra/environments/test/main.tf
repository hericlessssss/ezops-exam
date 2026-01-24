provider "aws" {
  region  = var.region
  profile = var.profile

  default_tags {
    tags = var.tags
  }
}

# Placeholder for future resources (VPC, EKS, etc.)
