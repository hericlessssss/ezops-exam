variable "domain_name" {
  description = "The domain name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

# resource "aws_route53_zone" "main" { ... }
# resource "aws_route53_record" "www" { ... }
