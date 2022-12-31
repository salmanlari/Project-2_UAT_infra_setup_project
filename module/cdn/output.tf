output "cdn_dns_name_output" {
  value = aws_cloudfront_distribution.my_web_site.domain_name
}

output "zone_id_output" {
  value = aws_cloudfront_distribution.my_web_site.hosted_zone_id
}