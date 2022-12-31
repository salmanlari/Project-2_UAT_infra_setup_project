#loadbalncer

 resource "aws_lb" "dev-lb" {
  name               = var.name
  internal           = var.alb-type
  load_balancer_type = "application"
  security_groups    = var.sg_groups
  subnets = var.snets1
  enable_deletion_protection = false

  tags = {
    Environment = "new-dev-lb"
  }
  
}

#target group

resource "aws_lb_target_group" "dev-tg" {
  name        = var.tg-name
  port        = var.port
  protocol    = "HTTP"
  vpc_id      = var.vpc-id
  target_type = var.tg-type
}



resource "aws_lb_listener" "dev-lb-attach" {
  load_balancer_arn = aws_lb.dev-lb.arn
  port              = var.port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev-tg.arn
  }
}



#####loadbalncer-2

 resource "aws_lb" "dev-lb-2" {
  name               = var.name-2
  internal           = var.alb-type-2
  load_balancer_type = "application"
  security_groups    = var.sg_groups-2
  subnets = var.snets2
  enable_deletion_protection = false

  tags = {
    Environment = "new-dev-lb-2"
  }
  
}

#target group

resource "aws_lb_target_group" "dev-tg-2" {
  name        = var.tg-name-2
  port        = var.port-2
  protocol    = "HTTP"
  vpc_id      = var.vpc-id-2
  target_type = var.tg-type-2
}



resource "aws_lb_listener" "dev-lb-attach-2" {
  load_balancer_arn = aws_lb.dev-lb-2.arn
  port              = var.port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev-tg-2.arn
  }
}