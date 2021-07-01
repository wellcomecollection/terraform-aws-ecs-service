locals {
  container_name = "nginx"
  container_port = 9000

  image = "${var.container_registry}/${var.container_name}:${var.container_tag}"
}
