module "task_role" {
  source = "../modules/iam_role"

  task_name = var.task_name
}

resource "aws_ecs_task_definition" "task" {
  family                = var.task_name
  container_definitions = data.template_file.container_definition.rendered

  task_role_arn      = module.task_role.task_role_arn
  execution_role_arn = module.task_role.task_execution_role_arn

  network_mode = "awsvpc"

  requires_compatibilities = [var.launch_type]

  cpu    = var.cpu
  memory = var.memory

  # This is a slightly obtuse way to make these two blocks conditional.
  # They should only be created if this task definition is using EBS volume
  # mounts; otherwise they should be ignored.
  #
  # This is a kludge around Terraform's "dynamic blocks".
  # See https://www.terraform.io/docs/configuration/expressions.html#dynamic-blocks
  #
  # There's an open feature request on the Terraform repo to add syntactic
  # sugar for this sort of conditional block.  If that ever arises, we should
  # use that instead.  See https://github.com/hashicorp/terraform/issues/21512
  dynamic "volume" {
    for_each = var.ebs_volume_name == "" ? [] : [{}]

    content {
      name      = var.ebs_volume_name
      host_path = var.ebs_host_path
    }
  }

  dynamic "placement_constraints" {
    for_each = var.ebs_volume_name == "" ? [] : [{}]

    content {
      type       = "memberOf"
      expression = "attribute:ebs.volume exists"
    }
  }
}
