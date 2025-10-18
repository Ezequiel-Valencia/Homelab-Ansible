

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs

resource "aws_cloudfront_distribution" "ezequiel_geo_submission_cache" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for personal site guest book."

  origin {
    domain_name = var.origin_domain_name
    origin_id   = "custom"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  

  default_cache_behavior {
    target_origin_id = "custom"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    

    # Cache policy for JSON API
    min_ttl                = 0
    default_ttl            = 60      # cache for 1 minute by default
    max_ttl                = 300     # cache for up to 5 minutes
  }

  ordered_cache_behavior {
    target_origin_id = "custom"

    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true
    path_pattern = "/api/v1/geoCache/*"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 60      # cache for 1 minute by default
    max_ttl                = 300     # cache for up to 5 minutes
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  price_class = "PriceClass_100"
}
