locals {
  secrets_keys        = keys(var.secrets)
  sorted_secrets_keys = sort(local.secrets_keys)

  final_secrets = [
    for key in local.sorted_secrets_keys :
    {
      name      = key
      valueFrom = module.secret_references.valuesFrom[key]
    }
  ]
}

module "secret_references" {
  source  = "../secret_references"
  secrets = var.secrets
}
