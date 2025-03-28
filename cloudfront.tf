resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = "" #s3_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.static_site_oac.id
    origin_id                = "" #s3_origin_id
    connection_attempts      = 3
    connection_timeout       = 10
  }
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "/index.html"
  web_acl_id = "" #web_acl_id

  aliases = [""] #static-site.x.y.com

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "" ##s3_origin_id
    compress                   = true
    cache_policy_id            = "658327ea-f89d-4fab-a63d-7e88639e58f6"


    viewer_protocol_policy = "https-only"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }


  price_class = "PriceClass_200" #north america and europe


  tags = {
    Environment = "sandbox"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.workshops.arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}


resource "aws_cloudfront_origin_access_control" "static_site_oac" {
  name                              = "" #name
  description                       = "test"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
