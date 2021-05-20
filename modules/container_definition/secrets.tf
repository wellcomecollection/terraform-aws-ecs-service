locals {
  secrets_keys        = keys(var.secrets)
  sorted_secrets_keys = sort(local.secrets_keys)

  final_secrets = [
    for key in local.sorted_secrets_keys :
    {
      name      = key
      valueFrom = module.secret_arns.with_keys[key]
    }
  ]
}

module "secret_arns" {
  source  = "../secret_arns"
  secrets = var.secrets
}
