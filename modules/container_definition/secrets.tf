locals {
  secrets_keys        = keys(var.secrets)
  sorted_secrets_keys = sort(local.secrets_keys)

  // If a secret name has a colon in it, then it is a reference to a specific key within a JSON
  // object secret: before the colon is the secret name, after is the key.
  //
  // See "Example referencing a specific key within a secret" here:
  // https://docs.aws.amazon.com/AmazonECS/latest/userguide/specifying-sensitive-data-secrets.html
  secret_reference_parts = {
    for key, secret in var.secrets : key => split(":", secret)
  }
  secret_references = {
    for key, parts in local.secret_reference_parts : key => {
      name = parts[0]
      key  = length(parts) == 2 ? parts[1] : ""
    }
  }

  secret_arns = {
    for key, secret in local.secret_references : key =>
    secret["key"] == "" ? data.aws_secretsmanager_secret.for_service[key].arn : "${data.aws_secretsmanager_secret.for_service[key].arn}:${secret["key"]}"
  }

  final_secrets = [
    for key in local.sorted_secrets_keys :
    {
      name      = key
      valueFrom = lookup(local.secret_arns, key)
    }
  ]
}

data "aws_secretsmanager_secret" "for_service" {
  for_each = local.secret_references
  name     = each.value["name"]
}
