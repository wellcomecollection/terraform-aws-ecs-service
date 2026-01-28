data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  # If a secret name has a colon in it, then it is a reference to
  # a specific key within a JSON object secret.
  #
  # e.g. if you have the secret
  #
  #     SecretId = credentials
  #     SecretValue = {"username": "wellcome", "password": "s3kr1t!"}
  #
  # then the secret "credentials:username" would refer to "wellcome"
  # and "credentials:password" would refer to "s3kr1t!".
  #
  # This module provides a way to construct the correct ARNs for secrets
  # both with and without references.
  #
  # Note: we construct the ARNs by hand rather than using a "data" block
  # so the secrets don't need to exist when we're planning, e.g. if we're
  # creating secrets alongside the ECS service.
  #
  # See "Example referencing a specific key within a secret" here:
  # https://docs.aws.amazon.com/AmazonECS/latest/userguide/specifying-sensitive-data-secrets.html
  secret_reference_parts = {
    for label, secret in var.secrets : label => split(":", secret)
  }
  secret_references = {
    for label, parts in local.secret_reference_parts : label => {
      name = parts[0]
      key  = length(parts) == 2 ? parts[1] : ""
    }
  }

  secret_references_with_keys = {
    for label, parts in local.secret_references :
    label => parts
    if parts["key"] != ""
  }

  aws_region = data.aws_region.current.region
  account_id = data.aws_caller_identity.current.account_id

  ssm_prefix = "/aws/reference/secretsmanager/"

  valuesFrom = {
    for label, secret in local.secret_references : label =>
    secret["key"] == "" ? "${local.ssm_prefix}${secret["name"]}" : "${data.aws_secretsmanager_secret.for_service[label].arn}:${secret["key"]}::"
  }

  arns = {
    for label, secret in local.secret_references : label =>
    "arn:aws:secretsmanager:${local.aws_region}:${local.account_id}:secret:${secret["name"]}"
  }
}

data "aws_secretsmanager_secret" "for_service" {
  for_each = local.secret_references_with_keys
  name     = each.value["name"]
}
