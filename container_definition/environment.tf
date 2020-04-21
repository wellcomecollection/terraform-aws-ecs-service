locals {
  environment_keys = keys(var.environment)
  sorted_environment_keys = sort(local.environment_keys)

  sorted_environment = [
  for key in local.sorted_environment_keys :
  {
    name = key
    value = lookup(var.environment, key)
  }
  ]

  final_environment = length(local.sorted_environment_keys) > 0 ? local.sorted_environment_keys : null
}