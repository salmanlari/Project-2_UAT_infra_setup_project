
##HOSTES ZONE 53

resource "aws_route53_zone" "primary" {
  name = "xyz.net"
}


#RECORD 53
resource "aws_route53_record" "aws_53" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "demo"
  type    = "A"

  alias {
    name                   = var.cdn_dns_name
    zone_id                = var.cdn_zone_id
    evaluate_target_health = true
  }
}


# route 53 for LB


resource "aws_route53_zone" "internal_53" {
  name = "demo.in"
}

resource "aws_route53_record" "lb_2_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = var.lb-2_dns_name
    zone_id                = var.lb-2_zone_id
    evaluate_target_health = true
  }
}