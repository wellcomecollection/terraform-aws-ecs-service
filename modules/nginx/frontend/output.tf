output "container_definition" {
  value = module.nginx_container.container_definition
}

output "container_name" {
  value = local.container_name
}

output "container_port" {
  value = local.container_port
}