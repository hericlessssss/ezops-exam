resource "aws_route53_record" "frontend" {
  count   = var.enabled ? 1 : 0
  zone_id = var.hosted_zone_id
  name    = "${var.frontend_subdomain}.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [var.frontend_target]
}

resource "aws_route53_record" "backend" {
  count   = var.enabled ? 1 : 0
  zone_id = var.hosted_zone_id
  name    = "${var.backend_subdomain}.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [var.backend_target]
}
