output "arn" {
  value = aws_ecs_task_definition.task.arn
}

output "task_role_name" {
  value = module.task_role.name
}

output "task_role_arn" {
  value = module.task_role.task_role_arn
}

output "task_execution_role_name" {
  value = module.task_role.task_execution_role_name
}

output "task_execution_role_arn" {
  value = module.task_role.task_execution_role_arn
}