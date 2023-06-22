output "arn" {
  value = aws_ecs_service.service.arn
}

output "name" {
  value = aws_ecs_service.service.name
}
