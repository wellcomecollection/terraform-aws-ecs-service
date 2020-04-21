locals {
  container_definition = {
    essential = var.essential
    name      = var.name

    cpu    = var.cpu
    memory = var.memory

    environment  = local.final_environment
    secrets      = local.final_secrets

    mountPoints  = var.mount_points
    portMappings = var.port_mappings
    healthCheck  = var.healthcheck
    user         = var.user
    dependsOn    = var.depends

    logConfiguration       = var.log_configuration
    firelensConfiguration  = var.firelens_configuration
  }

  json_map = jsonencode(local.container_definition)
}

output "json_map" {
  value = local.json_map
}