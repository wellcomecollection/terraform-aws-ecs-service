resource "aws_alb" "load_balancer" {
  name = "example-load-balancer"

  subnets = local.public_subnets

  security_groups = [
    aws_security_group.load_balancer.id,
    aws_security_group.interservice.id
  ]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_alb.load_balancer.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.service.id
    type             = "forward"
  }
}

resource "aws_alb_target_group" "service" {
  name        = "example-service"
  target_type = "ip"
  protocol    = "HTTP"

  deregistration_delay = 10
  port                 = local.host_port
  vpc_id               = local.vpc_id

  health_check {
    path                = "/"
    port                = local.host_port
    protocol            = "HTTP"
    matcher             = 200
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  lifecycle {
    create_before_destroy = true
  }
}