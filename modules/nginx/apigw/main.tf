module "nginx_container" {
  source = "../../../modules/container_definition"

  image  = local.image
  name   = local.container_name

  memory_reservation = var.memory_reservation

  environment = {
    APP_HOST = "localhost"
    APP_PORT = var.forward_port
  }

  port_mappings = [{
    containerPort = 9000,
    hostPort      = 9000,
    protocol      = "tcp"
  }]

  log_configuration = var.log_configuration
}