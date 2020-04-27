resource "aws_iam_role_policy" "allow_read_secrets" {
  # If there aren't any environment variables, the policy document will be
  # empty and we can skip creating the policy.
  count = length(var.secrets) > 0 ? 1 : 0

  role   = var.role_name
  policy = data.aws_iam_policy_document.read_secrets.json
}
