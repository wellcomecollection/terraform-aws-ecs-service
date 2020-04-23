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

  shared_secrets_logging = data.terraform_remote_state.infra_shared.outputs.shared_secrets_logging
}
