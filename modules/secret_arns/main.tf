locals {
  // If a secret name has a colon in it, then it is a reference to a specific key within a JSON
  // object secret: before the colon is the secret name, after is the key. This module provides
  // a means to construct the correct ARNs for secret names both with and without specific key
  // references.
  //
  // See "Example referencing a specific key within a secret" here:
  // https://docs.aws.amazon.com/AmazonECS/latest/userguide/specifying-sensitive-data-secrets.html#secrets-examples
  secret_reference_parts = {
    for label, secret in var.secrets : label => split(":", secret)
  }
  secret_references = {
    for label, parts in local.secret_reference_parts : label => {
      name = parts[0]
      key  = length(parts) == 2 ? parts[1] : ""
    }
  }

  arns_without_keys = {
    for label, secret in local.secret_references : label => data.aws_secretsmanager_secret.for_service[label].arn
  }

  arns_with_keys = {
    for label, secret in local.secret_references : label =>
    secret["key"] == "" ? local.arns_without_keys[label] : "${local.arns_without_keys[label]}:${secret["key"]}::"
  }
}

data "aws_secretsmanager_secret" "for_service" {
  for_each = local.secret_references
  name     = each.value["name"]
}
