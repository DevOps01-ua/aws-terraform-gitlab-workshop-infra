resource "aws_acm_certificate" "workshops" {
  domain_name       = "" #domain name for certificate
  validation_method = "DNS"

  tags = {
    Environment = "sandbox"
  }

  lifecycle {
    create_before_destroy = true
  }
  provider = aws.us-east-1
}
