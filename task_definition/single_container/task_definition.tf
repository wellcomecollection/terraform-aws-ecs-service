module "task_role" {
  source = "../modules/iam_role"

  task_name = var.task_name
}

# The presence of two almost identical blocks of config is working
# around a limitation in Terraform: specifically, we can't make the
# volume and placement_constraints blocks optional.
#
# To get around this, we check the presence of the ebs_volume_name variable.
# If it's present, we create `ebs_task` with this load_balancer block.
# If it's empty, we create `task` without.

resource "aws_ecs_task_definition" "task" {
  count = var.ebs_volume_name == "" ? 1 : 0

  family                = var.task_name
  container_definitions = data.template_file.container_definition.rendered

  task_role_arn      = module.task_role.task_role_arn
  execution_role_arn = module.task_role.task_execution_role_arn

  network_mode = "awsvpc"

  requires_compatibilities = [var.launch_type]

  cpu    = var.cpu
  memory = var.memory
}

resource "aws_ecs_task_definition" "task_with_ebs" {
  count = var.ebs_volume_name == "" ? 0 : 1

  family                = var.task_name
  container_definitions = data.template_file.container_definition.rendered

  task_role_arn      = module.task_role.task_role_arn
  execution_role_arn = module.task_role.task_execution_role_arn

  network_mode = "awsvpc"

  # For now, using EBS/EFS means we need to be on EC2 instance.
  requires_compatibilities = ["EC2"]

  cpu    = var.cpu
  memory = var.memory

  volume {
    name      = var.ebs_volume_name
    host_path = var.ebs_host_path
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ebs.volume exists"
  }
}

locals {
  all_task_definition_arns = concat(
    aws_ecs_task_definition.task.*.arn,
    aws_ecs_task_definition.task_with_ebs.*.arn
  )

  task_definition_arn = local.all_task_definition_arns[0]
}
