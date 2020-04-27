output "container_definition" {
  value = module.log_router_container.container_definition
}

output "container_log_configuration" {
  value = local.container_log_configuration
}

output "debug_container_log_configuration" {
  value = local.debug_container_log_configuration
}

output "shared_secrets_logging" {
  value = local.shared_secrets_logging
}