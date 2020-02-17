output "arn" {
  value = local.task_definition_arn
}

output "task_role_name" {
  value = module.task_role.name
}

output "task_role_arn" {
  value = module.task_role.task_role_arn
}
