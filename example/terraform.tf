provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::760097843905:role/platform-developer"
  }

  region = "eu-west-1"
}

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }

  required_version = ">= 0.12"
}

data "terraform_remote_state" "infra_shared" {
  backend = "s3"

  config = {
    role_arn = "arn:aws:iam::760097843905:role/platform-read_only"
    bucket   = "wellcomecollection-platform-infra"
    key      = "terraform/platform-infrastructure/shared.tfstate"
    region   = "eu-west-1"
  }
}
