# The presence of two almost identical blocks of config is working
# around a limitation in Terraform: specifically, we can't make the
# load_balancer block optional.
#
# To get around this, we check the presence of the target_group_arn variable.
# If it's present, we create `lb_service` with this load_balancer block.
# If it's empty, we create `service` without.

resource "aws_ecs_service" "service" {
  count = "${var.target_group_arn == "" : 1 ? 0}"

  name            = var.service_name
  cluster         = var.cluster_arn
  task_definition = var.task_definition_arn
  desired_count   = var.desired_task_count

  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent

  launch_type = var.launch_type

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_group_ids
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.service_discovery.arn
  }
}

resource "aws_ecs_service" "lb_service" {
  count = "${var.target_group_arn == "" : 0 ? 1}"

  name            = var.service_name
  cluster         = var.cluster_arn
  task_definition = var.task_definition_arn
  desired_count   = var.desired_task_count

  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent

  launch_type = var.launch_type

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_group_ids
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.service_discovery.arn
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
}
