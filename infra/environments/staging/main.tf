provider "aws" {
  region  = var.region
  profile = var.profile

  default_tags {
    tags = var.tags
  }
}

module "vpc" {
  source = "../../modules/vpc"

  name_prefix          = "stg-chico"
  cidr_block           = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnets
  private_subnet_cidrs = var.private_subnets
  tags                 = var.tags
}

module "eks" {
  source = "../../modules/eks"

  name_prefix         = "stg-chico"
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  tags                = var.tags
  cluster_version     = "1.29"
  node_instance_types = ["t3.medium"]
}

module "rds" {
  source = "../../modules/rds"

  name_prefix                = "stg-chico"
  vpc_id                     = module.vpc.vpc_id
  subnet_ids                 = module.vpc.private_subnet_ids
  tags                       = var.tags
  db_name                    = "blog"
  username                   = "postgres"
  allowed_security_group_ids = [module.eks.cluster_security_group_id]
}

module "ecr" {
  source = "../../modules/ecr"

  name_prefix = "stg-chico"
  repo_names  = ["backend", "frontend"]
  tags        = var.tags
}

module "s3_frontend" {
  source = "../../modules/s3_frontend"

  name_prefix = "stg-chico"
  tags        = var.tags
}

module "cloudfront" {
  source = "../../modules/cloudfront"

  name_prefix                 = "stg-chico"
  bucket_id                   = module.s3_frontend.bucket_id
  bucket_arn                  = module.s3_frontend.bucket_arn
  bucket_regional_domain_name = module.s3_frontend.bucket_regional_domain_name
  tags                        = var.tags
  
  # Custom Domain
  aliases             = ["app-ezops.gratianovem.com.br"]
  acm_certificate_arn = aws_acm_certificate.frontend.arn
}

module "route53" {
  source = "../../modules/route53"

  enabled        = var.enable_route53
  hosted_zone_id = var.hosted_zone_id
  # Standardized: <dns_label>.<exam_domain> (e.g. chico.exam.ezopscloud.tech)
  domain_name     = "${var.dns_label}.${var.exam_domain}"
  frontend_target = module.cloudfront.distribution_domain_name
  backend_target  = var.backend_target != "" ? var.backend_target : "placeholder-alb-dns.us-east-2.elb.amazonaws.com"
  tags            = var.tags
}

# -------------------------------------------------------------
# Utility EC2 Instance (Exam Requirement)
# -------------------------------------------------------------
module "ec2" {
  source = "../../modules/ec2"

  name_prefix   = "stg-chico"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_ids[0] # Public Subnet 0
  instance_type = "t3.micro"

  # Optional: Allow SSH from specific CIDR (e.g., VPN or Office IP)
  # Keeping empty by default for security (No Inbound)
  allow_ssh_cidr = []

  tags = var.tags
}
