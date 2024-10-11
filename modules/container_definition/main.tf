locals {
  filtered_log_configuration = var.log_configuration != null ? { for k, v in var.log_configuration : k => v if v != null } : null

  container_definition = {
    essential = var.essential
    name      = var.name
    image     = var.image
    command   = var.command
    
    entrypoint = var.entrypoint

    cpu    = var.cpu
    memory = var.memory

    memoryReservation = var.memory_reservation

    environment = local.final_environment
    secrets     = local.final_secrets

    mountPoints  = var.mount_points
    portMappings = var.port_mappings
    healthCheck  = var.healthcheck
    user         = var.user
    dependsOn    = var.depends
    tags         = var.tags

    volumesFrom = var.volumes_from

    logConfiguration      = local.filtered_log_configuration
    firelensConfiguration = var.firelens_configuration

    systemControls = var.system_controls
  }

  filtered_container_definition = { for k, v in local.container_definition : k => v if v != null }
}
