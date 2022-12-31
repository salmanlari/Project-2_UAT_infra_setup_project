#creating launch tamplate


resource "aws_launch_template" "my-launch-tamplate" {
  name_prefix        = "my-lt"
  image_id           = var.ami-id
  instance_type      = var.ec2-instance-type
  # security_groups    = var.sg_groups
  key_name           = var.key-name
}


resource "aws_autoscaling_group" "my-asg" {
     vpc_zone_identifier        = var.pub-snet
  #  availability_zones = each.value ["availability_zones"]
  # availability_zones = var.availability_zones
  desired_capacity   = var.desired_ec2
  max_size           = var.max_ec2
  min_size           = var.min_ec2
   
  launch_template {
    id      = aws_launch_template.my-launch-tamplate.id
    version = "$Latest"
  }
 
   
}


# resource "aws_launch_configuration" "dev-conf" {
#   name_prefix        = "my-lc"
#   image_id           = var.ami-id
#   instance_type      = var.ec2-instance-type
#   security_groups    = var.sg_groups
#   key_name           = var.key-name
#   # user_data = <<-EOF
#   # #!/bin/bash
#   # sudo su -
#   # apt update -y
#   # apt install nginx -y
#   # systemctl restart nginx.service
#   # EOF
#     lifecycle {
#     create_before_destroy = true
#   }
# }


# resource "aws_autoscaling_group" "asg" {
#   vpc_zone_identifier        = var.pub-snet
#   name                       = "app-asg"
#   desired_capacity           = var.desired_ec2
#   max_size                   = var.max_ec2
#   min_size                   = var.min_ec2
#   health_check_grace_period  = var.hc_ec2
#   health_check_type          = "ELB"
#   force_delete               = true
#   launch_configuration       = aws_launch_configuration.dev-conf.id
#   target_group_arns          = [var.tg-arn]
# }


# ##########2

# resource "aws_launch_configuration" "dev-conf-2" {
#   name_prefix        = "my-lc-2"
#   image_id           = var.ami-id-2
#   instance_type      = var.ec2-instance-type-2
#   security_groups    = var.sg_groups-2
#   key_name           = var.key-name-2
#    user_data = <<-EOF
#    #!/bin/bash
#     /opt/tomcat/bin/startup.sh
#   EOF
#     lifecycle {
#     create_before_destroy = true
#   }
# }

# # COPY ecomm-master /opt/tomcat/apache-tomcat-10.0.8/webapps/ROOT/
# resource "aws_autoscaling_group" "asg-2" {
#   vpc_zone_identifier        = var.pub-snet-2
#   name                       = "app-asg-2"
#   desired_capacity           = var.desired_ec2-2
#   max_size                   = var.max_ec2-2
#   min_size                   = var.min_ec2-2
#   health_check_grace_period  = var.hc_ec2-2
#   health_check_type          = "ELB"
#   force_delete               = true
#   launch_configuration       = aws_launch_configuration.dev-conf-2.id
#   target_group_arns          = [var.tg-arn-2]
# }



#creating launch tamplate


