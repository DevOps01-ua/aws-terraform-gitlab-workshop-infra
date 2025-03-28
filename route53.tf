resource "aws_route53_zone" "workshops" {
  name = "" #bucket_name

  tags = {
    Environment = "sandbox"
  }
}

resource "aws_route53_record" "workshops_certificate" {
  zone_id = aws_route53_zone.workshops.zone_id
  name    = tolist(aws_acm_certificate.workshops.domain_validation_options)[0].resource_record_name
  type    = "CNAME"
  ttl     = 300
  records = [tolist(aws_acm_certificate.workshops.domain_validation_options)[0].resource_record_value]
  depends_on = [aws_route53_zone.workshops]
}


resource "aws_route53_record" "cloudfront" {
  zone_id = aws_route53_zone.workshops.zone_id
  name    = "" #record-name-for-cloudfront
  type    = "A"
  #records = [aws_cloudfront_distribution.s3_distribution.id]
  alias {
    evaluate_target_health = false
    name                   = "" #cloudfront distribuiton fqdn
    zone_id                = "" #todo change from static value to attribute
  }
}

