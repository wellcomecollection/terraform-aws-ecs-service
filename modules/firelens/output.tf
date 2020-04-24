output "container_definition" {
  value = module.log_router_container.container_definition
}

output "container_log_configuration" {
  value = local.container_log_configuration
}
