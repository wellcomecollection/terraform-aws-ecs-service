locals {
  container_name = "nginx"
  container_port = 80

  // See https://github.com/wellcomecollection/platform-infrastructure/tree/main/images/nginx
  ecr_repo = "760097843905.dkr.ecr.eu-west-1.amazonaws.com/${var.image_name}"
  image    = "${local.ecr_repo}:${var.container_tag}"
}
