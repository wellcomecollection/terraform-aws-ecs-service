provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::760097843905:role/platform-developer"
  }

  region  = "eu-west-1"
}

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}