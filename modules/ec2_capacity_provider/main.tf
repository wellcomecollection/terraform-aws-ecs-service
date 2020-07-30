resource "aws_ecs_capacity_provider" "capacity_provider" {
  name = var.name

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.asg.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status                    = "ENABLED"
      maximum_scaling_step_size = 1
      target_capacity           = 100
    }
  }
}
