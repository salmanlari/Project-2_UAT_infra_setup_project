output "tg-arn" {
  value = aws_lb_target_group.dev-tg.arn
}


output "tg-arn-2" {
  value = aws_lb_target_group.dev-tg-2.arn
}

output "lb_dns_output" {
  
value = aws_lb.dev-lb.dns_name
}

#LB-2
output "lb_2_dns_output" {
  value=aws_lb.dev-lb-2.dns_name
  
}
output "lb_2_zone_id_output" {
  value = aws_lb.dev-lb-2.zone_id
  
}