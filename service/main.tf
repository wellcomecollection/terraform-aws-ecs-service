module "iam_role" {
  source = "./iam_role"

  service_name = aws_ecs_service.service.name
}

resource "aws_service_discovery_service" "service_discovery" {
  name = var.service_name

  health_check_custom_config {
    failure_threshold = var.service_discovery_failure_threshold
  }

  dns_config {
    namespace_id = var.namespace_id

    dns_records {
      ttl  = 5
      type = "A"
    }
  }
}
