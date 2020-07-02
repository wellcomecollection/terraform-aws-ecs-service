resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = var.cluster_arn
  task_definition = var.task_definition_arn
  desired_count   = var.desired_task_count

  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_group_ids
    assign_public_ip = false
  }

  dynamic "service_registries" {
    for_each = var.service_discovery_namespace_id == null ? [] : [{}]

    content {
      registry_arn = aws_service_discovery_service.service_discovery["single"].arn
    }
  }

  # We can't specify both a launch type and a capacity provider strategy.
  launch_type = var.use_fargate_spot ? null : var.launch_type

  dynamic "capacity_provider_strategy" {
    for_each = var.use_fargate_spot ? [{}] : []

    content {
      capacity_provider = "FARGATE_SPOT"
      weight            = 1
    }
  }

  # This is a slightly obtuse way to make this block conditional.
  # They should only be created if this task definition is using EBS volume
  # mounts; otherwise they should be ignored.
  #
  # This is a kludge around Terraform's "dynamic blocks".
  # See https://www.terraform.io/docs/configuration/expressions.html#dynamic-blocks
  #
  # There's an open feature request on the Terraform repo to add syntactic
  # sugar for this sort of conditional block.  If that ever arises, we should
  # use that instead.  See https://github.com/hashicorp/terraform/issues/21512
  #
  # We condition on container_port rather than target_group_arn, because this should
  # be a static string declared immediately.  If you use target_group_arn, and
  # when you create the module you fill it in dynamically, e..g
  #
  #     target_group_arn = aws_lb_target_group.tcp.arn
  #
  # Terraform can't work out if it's non-empty, and gets upset trying to plan.
  dynamic "load_balancer" {
    for_each = var.container_port == "" ? [] : [{}]

    content {
      target_group_arn = var.target_group_arn
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  tags = var.tags
  propagate_tags = var.propagate_tags

  # The desired_count of our services can be changed externally (e.g. by autoscaling).
  # If Terraform clamps it back down, it can prematurely terminate work, and
  # we have to wait for services to scale back up.
  #
  # Ignoring the change here means Terraform doesn't interfere with autoscaling.
  lifecycle {
    ignore_changes = [
      desired_count,
    ]
  }
}
