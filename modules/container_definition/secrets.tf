locals {
  ssm_prefix = "/aws/reference/secretsmanager/"

  secrets_keys        = keys(var.secrets)
  sorted_secrets_keys = sort(local.secrets_keys)
  final_secrets = [
    for key in local.sorted_secrets_keys :
    {
      name      = key
      valueFrom = "${local.ssm_prefix}${lookup(var.secrets, key)}"
    }
  ]
}
