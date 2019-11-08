locals {
  mount_points   = jsonencode(var.mount_points)
  log_group_name = var.task_name
  container_name = "app"
  command        = jsonencode(var.command)
}

data "template_file" "definition" {
  template = "${file("${path.module}/task_definition.json.tpl")}"

  vars = {
    log_group_region = var.aws_region
    log_group_name   = module.log_group.name
    log_group_prefix = var.log_group_prefix

    container_image = var.container_image
    container_name  = local.container_name

    secrets = module.secrets.env_vars_string

    port_mappings = jsonencode([
      {
        "containerPort" = var.task_port,

        # TODO: I think we can safely drop both these arguments.
        "hostPort" = var.task_port,
        "protocol" = "tcp"
      }
    ])

    environment_vars = module.env_vars.env_vars_string

    command = local.command

    cpu    = var.cpu
    memory = var.memory

    mount_points = local.mount_points

    user = var.user
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "ecs/${var.task_name}"

  retention_in_days = 7
}

module "env_vars" {
  source = "../modules/env_vars"

  env_vars = var.env_vars
}

module "secrets" {
  source = "../modules/secrets"

  secret_env_vars = var.secret_env_vars

  execution_role_name = var.execution_role_name
}
