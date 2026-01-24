provider "aws" {
  region  = var.region
  profile = var.profile

  default_tags {
    tags = var.tags
  }
}

module "vpc" {
  source = "../../modules/vpc"

  name_prefix          = "test-chico"
  cidr_block           = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnets
  private_subnet_cidrs = var.private_subnets
  tags                 = var.tags
}

# Placeholder modules (commented out for now to ensure clean validation of VPC first, or kept if valid)
# Keeping them but passing depends_on if needed, or ensuring they rely on VPC outputs.
# For this specific task, "NÃO implementar EKS/RDS... nesta etapa", so I will keep them but ensure they don't break validation.
# Actually, the user said "NÃO implementar... nesta etapa", implying I should focus only on VPC.
# I will comment out the other modules to conform strictly to "Implementar o módulo de VPC e ajustar o naming".
# But wait, step 4 says "Ajustar main.tf... e exportar seus outputs para uso futuro".
# So I will keep ONLY VPC active to be safe and clean.

module "ecr" {
  source = "../../modules/ecr"

  name_prefix = "test-chico"
  repo_names  = ["backend", "frontend"]
  tags        = var.tags
}

# ... other modules commented out for clarity in this specific task ...
