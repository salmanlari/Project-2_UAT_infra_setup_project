
resource "aws_cloudfront_distribution" "my_web_site" {
  origin {
    domain_name = var.domian_name
    origin_id = var.origin_id

  custom_origin_config {
      http_port                = var.origin_http_port
      https_port               = var.origin_https_port
      origin_protocol_policy   = var.origin_protocol_policy
      origin_ssl_protocols     = var.origin_ssl_protocols
    }
 
 }
  enabled = true

  # logging_config {
  #   include_cookies = false
  #   bucket          = var.log_bucket
  # }

  default_cache_behavior {
    allowed_methods = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods = ["HEAD", "GET"]
    compress = true
    target_origin_id = var.origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }


  viewer_certificate {
    # iam_certificate_id = "${var.elb_cert}"
    # ssl_support_method = "sni-only"
    cloudfront_default_certificate = true
  }
}