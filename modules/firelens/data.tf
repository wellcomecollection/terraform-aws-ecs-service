data "terraform_remote_state" "infra_shared" {
  backend = "s3"

  config = {
    role_arn = "arn:aws:iam::760097843905:role/platform-read_only"
    bucket   = "wellcomecollection-platform-infra"
    key      = "terraform/platform-infrastructure/shared.tfstate"
    region   = "eu-west-1"
  }
}

locals {
  container_log_configuration = {
    logDriver = "awsfirelens"
    options = {
      Name  = "null"
      Match = "*",
    }

    secretOptions = null
  }

  // These secrets are assigned on a per account basis:
  // https://github.com/wellcomecollection/platform-infrastructure/blob/master/shared/secrets.tf
  // The secrets are copied between accounts to the same identifiers.
  // This results in secrets having the same SSM paths in every account,
  // although those paths refer to the secrets in that particular account.
  shared_secrets_logging = data.terraform_remote_state.infra_shared.outputs.shared_secrets_logging
}
