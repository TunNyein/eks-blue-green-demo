data "aws_route53_zone" "primary" {
  name         = var.hosted_zone_domain_name
  private_zone = false
}
resource "aws_acm_certificate" "app_cert" {
  domain_name       = var.acm_domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.acm_domain_name}-cert"
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.app_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.primary.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "app_cert_validation" {
  certificate_arn         = aws_acm_certificate.app_cert.arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.app_cert.arn
}

output "acm_validated_arn" {
  value = aws_acm_certificate_validation.app_cert_validation.certificate_arn
}
