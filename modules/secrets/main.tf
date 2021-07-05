resource "aws_iam_role_policy" "allow_read_secrets" {
  # If there aren't any environment variables, the policy document will be
  # empty and we can skip creating the policy.
  count = length(var.secrets) > 0 ? 1 : 0

  role   = var.role_name
  policy = data.aws_iam_policy_document.read_secrets.json
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  aws_region     = data.aws_region.current.name
  account_id     = data.aws_caller_identity.current.account_id
  ssm_iam_prefix = "arn:aws:ssm:${local.aws_region}:${local.account_id}:parameter/aws/reference/secretsmanager"
}

data "aws_iam_policy_document" "read_secrets" {
  statement {
    actions = [
      "ssm:GetParameters",
    ]

    # The secret ARNs are of the form
    #
    #     arn:aws:secretsmanager:eu-west-1:1234567890:secret:password
    #
    # And we want the "password" part.
    resources = [
      for _, arn in module.secret_references.arns :
      "${local.ssm_iam_prefix}/${split(":", arn)[6]}"
    ]
  }

  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      for _, arn in module.secret_references.arns :
      "${arn}*"
    ]
  }
}

module "secret_references" {
  source  = "../secret_references"
  secrets = var.secrets
}
