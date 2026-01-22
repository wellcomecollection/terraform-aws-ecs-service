module "task_role" {
  source = "./iam_role"

  task_name = var.task_name
}

resource "aws_ecs_task_definition" "task" {
  family                = var.task_name
  container_definitions = jsonencode(var.container_definitions)

  task_role_arn      = module.task_role.task_role_arn
  execution_role_arn = module.task_role.task_execution_role_arn

  network_mode = var.network_mode

  requires_compatibilities = var.launch_types

  cpu    = var.cpu
  memory = var.memory

  dynamic "ephemeral_storage" {
    for_each = var.ephemeral_storage_size != null ? [var.ephemeral_storage_size] : []

    content {
      size_in_gib = ephemeral_storage.value
    }
  }

  # Unused here, but must be set to prevent churn
  tags = {}

  dynamic "volume" {
    for_each = var.volumes

    content {
      name      = volume.value["name"]
      host_path = volume.value["host_path"]
    }
  }

  dynamic "volume" {
    for_each = var.efs_volumes

    content {
      name = volume.value["name"]
      efs_volume_configuration {
        file_system_id = volume.value["file_system_id"]
        root_directory = volume.value["root_directory"]
      }
    }
  }

  dynamic "placement_constraints" {
    for_each = var.placement_constraints

    content {
      type       = placement_constraints.value["type"]
      expression = placement_constraints.value["expression"]
    }
  }
}
