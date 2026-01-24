variable "bucket_name" {
  description = "Name of the S3 bucket for frontend hosting"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

# resource "aws_s3_bucket" "website" { ... }
# resource "aws_s3_bucket_website_configuration" "website" { ... }
