locals {
  environment_keys        = keys(var.environment)
  sorted_environment_keys = sort(local.environment_keys)

  final_environment = [
    for key in local.sorted_environment_keys :
    {
      name  = key
      value = lookup(var.environment, key)
    }
  ]
}
