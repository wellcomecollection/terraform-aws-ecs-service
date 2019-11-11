# The presence of two almost identical blocks of config is working
# around a limitation in Terraform: specifically, we can't make the
# load_balancer block optional.
#
# To get around this, we check the presence of the target_group_arn variable.
# If it's present, we create `lb_service` with this load_balancer block.
# If it's empty, we create `service` without.
#
# We condition on container_port rather than target_group_arn, because this should
# be a static string declared immediately.  If you use target_group_arn, and
# when you create the module you fill it in dynamically, e..g
#
#     target_group_arn = aws_lb_target_group.tcp.arn
#
# Terraform can't work out if it's non-empty, and gets upset trying to plan.

resource "aws_ecs_service" "service" {
  count = "${var.container_port == "" ? 1 : 0}"

  name            = local.service_name
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

  # The desired_count of our services can be changed externally (e.g. by autoscaling).
  # If Terraform clamps it back down, it can prematurely terminate work, and
  # we have to wait for services to scale back up.
  #
  # Ignoring the change here means Terraform doesn't interfere with autoscaling.
  lifecycle {
    ignore_changes = [
      "desired_count",
    ]
  }
}

resource "aws_ecs_service" "lb_service" {
  count = "${var.container_port == "" ? 0 : 1}"

  name            = local.service_name
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

  # The desired_count of our services can be changed externally (e.g. by autoscaling).
  # If Terraform clamps it back down, it can prematurely terminate work, and
  # we have to wait for services to scale back up.
  #
  # Ignoring the change here means Terraform doesn't interfere with autoscaling.
  lifecycle {
    ignore_changes = [
      "desired_count",
    ]
  }
}
