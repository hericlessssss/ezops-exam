terraform {
  backend "s3" {
    # -------------------------------------------------------------------------
    # INSTRUCTIONS:
    # 1. Run 'terraform apply' in infra/bootstrap.
    # 2. Copy the 's3_bucket_name' and 'dynamodb_table_name' outputs.
    # 3. Replace the PLACEHOLDERS below with your specific values.
    # -------------------------------------------------------------------------

    bucket         = "ezops-tfstate-563702590660-us-east-2"
    key            = "staging/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "ezops-tflock-563702590660"
    encrypt        = true
    profile        = "chico"
  }
}
