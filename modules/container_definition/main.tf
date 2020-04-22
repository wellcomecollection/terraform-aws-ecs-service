locals {
  container_definition = {
    essential = var.essential
    name = var.name
    image = var.image
    command = var.command

    cpu = var.cpu
    memory = var.memory

    memoryReservation = var.memory_reservation

    environment = local.final_environment
    secrets = local.final_secrets

    mountPoints = var.mount_points
    portMappings = var.port_mappings
    healthCheck = var.healthcheck
    user = var.user
    dependsOn = var.depends
    tags = var.tags

    logConfiguration = var.log_configuration
    firelensConfiguration = var.firelens_configuration
  }
}
