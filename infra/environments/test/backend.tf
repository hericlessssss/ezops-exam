terraform {
  backend "s3" {
    bucket         = "ezops-tfstate-654654369899-us-east-2"
    key            = "test/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "ezops-tflock"
    encrypt        = true
    profile        = "hrclsfss"
  }
}
