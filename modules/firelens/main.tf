data "aws_region" "current" {}

locals {
  log_group_name = var.namespace
  aws_region     = data.aws_region.current.name
}

resource "aws_cloudwatch_log_group" "log_router" {
  name = local.log_group_name

  retention_in_days = 7
}

module "log_router_container" {
  source = "../../modules/container_definition"
  image  = local.image

  name = "log_router"

  memory_reservation = 50

  // This configuration file can be found in the source container:
  // See https://github.com/wellcomecollection/platform-infrastructure/tree/main/images/fluentbit
  // See local.image to see how the container tag is constructed.
  // Default values are loaded from var.container_tag in variables.tf
  firelens_configuration = {
    type = "fluentbit"
    options = {
      "config-file-type"  = "file"
      "config-file-value" = "/extra.conf"
    }
  }

  environment = {
    SERVICE_NAME = var.namespace
  }

  secrets = local.shared_secrets_logging

  log_configuration = {
    logDriver = "awslogs"

    options = {
      "awslogs-group"         = local.log_group_name,
      "awslogs-region"        = local.aws_region,
      "awslogs-stream-prefix" = "log_router"
    }

    secretOptions = null
  }
}

