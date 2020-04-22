locals {
  ssm_arn_prefix     = "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/aws/reference/secretsmanager"
  secrets_arn_prefix = "arn:aws:secretsmanager:eu-west-1:${data.aws_caller_identity.current.account_id}:secret"

  # These locals construct a list of ARNs for the SSM and SecretsManager
  # resources associated with our secret environment variables.
  #
  # This allows us to scope the execution role so each app can only read
  # the secrets that it actually uses.
  #
  ssm_resources     = formatlist("${local.ssm_arn_prefix}/%s", values(var.secrets))
  secrets_resources = formatlist("${local.secrets_arn_prefix}:%s*", values(var.secrets))
}