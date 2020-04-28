module "nginx_container" {
  source = "../../../modules/container_definition"

  image  = local.stable_nginx_apigw_image
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

locals {
  container_name = "nginx"
  container_port = 9000

  // See https://github.com/wellcomecollection/platform/tree/master/nginx
  stable_nginx_apigw_image = "760097843905.dkr.ecr.eu-west-1.amazonaws.com/uk.ac.wellcome/nginx_apigw:f1188c2a7df01663dd96c99b26666085a4192167"
}
