# Why can't we just look at the null-ness of var.service_discovery_namespace_id?
#
# Because if you do and you try to spin up a fresh stack, you get
# an error a bit like:
#
#     The "for_each" value depends on resource attributes that cannot be
#     determined until apply, so Terraform cannot predict how many instances
#     will be created. To work around this, use the -target argument to first
#     apply only the resources that the for_each depends on.
#
# We don't want this module to require using -target, particularly if it's
# nested deep inside some other module, so instead we give a way for callers
# to say "it's okay, I know the service discovery namespace will be there".
#
# See https://github.com/wellcomecollection/platform/issues/5206#issuecomment-870816928
locals {
  enable_service_discovery = var.enable_service_discovery == true ? true : var.service_discovery_namespace_id != null
}

resource "aws_service_discovery_service" "service_discovery" {
  for_each = local.enable_service_discovery ? { single = "a" } : {}

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
