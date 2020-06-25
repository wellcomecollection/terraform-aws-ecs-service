module "nginx_container" {
  source = "../../../modules/container_definition"

  image = local.image
  name  = local.container_name

  memory_reservation = var.memory_reservation

  environment = {
    APP_HOST = "localhost"
    APP_PORT = var.forward_port
  }

  port_mappings = [{
    containerPort = local.container_port,
    hostPort      = local.container_port,
    protocol      = "tcp"
  }]

  log_configuration = var.log_configuration
}