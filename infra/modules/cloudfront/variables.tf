variable "origin_domain_name" {
  description = "The domain name of the S3 bucket origin"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

# resource "aws_cloudfront_distribution" "s3_distribution" { ... }
