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
}
