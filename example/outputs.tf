output "load_balancer_dns" {
  value = aws_alb.load_balancer.dns_name
}