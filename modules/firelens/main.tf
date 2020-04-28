module "log_router_container" {
  source = "../../modules/container_definition"
  image  = local.image

  name = "log_router"

  memory_reservation = 50

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
      "awslogs-group"         = var.namespace,
      "awslogs-region"        = "eu-west-1",
      "awslogs-create-group"  = "true",
      "awslogs-stream-prefix" = "log_router"
    }

    secretOptions = null
  }
}

