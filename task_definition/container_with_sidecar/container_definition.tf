data "template_file" "container_definition" {
  template = file("${path.module}/task_definition.json.tpl")

  vars = {
    log_group_region = var.aws_region
    log_group_prefix = "ecs"

    # App vars
    app_log_group_name = aws_cloudwatch_log_group.app_log_group.name

    app_container_image = var.app_container_image
    app_container_name  = var.app_container_name

    expose_app_port = var.app_container_port != -1
    app_port_mappings = jsonencode([
      { containerPort = var.app_container_port }
    ])

    app_environment_vars        = module.app_env_vars.env_vars_string
    app_secret_environment_vars = module.app_secret_env_vars.env_vars_string

    app_cpu    = var.app_cpu
    app_memory = var.app_memory

    app_mount_points = jsonencode(var.app_mount_points)

    app_healthcheck = var.app_healthcheck_json

    # Sidecar vars
    sidecar_log_group_name = aws_cloudwatch_log_group.sidecar_log_group.name

    sidecar_container_image = var.sidecar_container_image
    sidecar_container_name  = var.sidecar_container_name

    expose_sidecar_port = var.sidecar_container_port != -1
    sidecar_port_mappings = jsonencode([
      { containerPort = var.sidecar_container_port }
    ])

    sidecar_environment_vars = module.sidecar_env_vars.env_vars_string

    sidecar_secret_environment_vars = module.sidecar_secret_env_vars.env_vars_string

    sidecar_cpu    = var.sidecar_cpu
    sidecar_memory = var.sidecar_memory

    sidecar_mount_points = jsonencode(var.sidecar_mount_points)

    sidecar_depends_on_app_condition = var.sidecar_depends_on_app_condition

    app_user     = var.app_user
    sidecar_user = var.sidecar_user

    # Firelens

    secret_esuser_arn = "arn:aws:secretsmanager:eu-west-1:760097843905:secret:shared/logging/es_user-NzgYRK"
    secret_espass_arn = "arn:aws:secretsmanager:eu-west-1:760097843905:secret:shared/logging/es_pass-Wrmt3C"
    secret_eshost_arn = "arn:aws:secretsmanager:eu-west-1:760097843905:secret:shared/logging/es_host-wFZkP1"
    secret_esport_arn = "arn:aws:secretsmanager:eu-west-1:760097843905:secret:shared/logging/es_port-KAwnVi"
  }
}

# App

resource "aws_cloudwatch_log_group" "app_log_group" {
  name = var.task_name
  retention_in_days = 7
}

module "app_env_vars" {
  source = "../modules/env_vars"

  env_vars = var.app_env_vars
}

module "app_secret_env_vars" {
  source = "../modules/secrets"

  secret_env_vars = var.secret_app_env_vars

  execution_role_name = module.task_role.task_execution_role_name
}

# Sidecar

resource "aws_cloudwatch_log_group" "sidecar_log_group" {
  name = "${var.task_name}/${var.sidecar_name}"

  retention_in_days = 7
}

module "sidecar_env_vars" {
  source = "../modules/env_vars"

  env_vars = var.sidecar_env_vars
}

module "sidecar_secret_env_vars" {
  source = "../modules/secrets"

  secret_env_vars = var.secret_sidecar_env_vars

  execution_role_name = module.task_role.task_execution_role_name
}
