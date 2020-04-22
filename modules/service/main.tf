module "iam_role" {
  source = "./iam_role"

  service_name = var.service_name
}

resource "aws_service_discovery_service" "service_discovery" {
  for_each = var.service_discovery_namespace_id == null ? {} : {single="a"}

  name = var.service_name

  health_check_custom_config {
    failure_threshold = var.service_discovery_failure_threshold
  }

  dns_config {
    namespace_id = var.service_discovery_namespace_id

    dns_records {
      ttl  = 5
      type = "A"
    }
  }
}
