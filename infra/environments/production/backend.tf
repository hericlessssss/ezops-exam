terraform {
  backend "s3" {
    # -------------------------------------------------------------------------
    # INSTRUCTIONS:
    # 1. Run 'terraform apply' in infra/bootstrap.
    # 2. Copy the 's3_bucket_name' and 'dynamodb_table_name' outputs.
    # 3. Replace the PLACEHOLDERS below with your specific values.
    # -------------------------------------------------------------------------

    bucket         = "test-chico-tfstate-654654369899-us-east-1"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "test-chico-tflock-654654369899"
    encrypt        = true
    profile        = "hrclsfss"
  }
}
