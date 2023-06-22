output "arn" {
  value = aws_ecs_service.service.id
}

output "name" {
  value = aws_ecs_service.service.name
}
