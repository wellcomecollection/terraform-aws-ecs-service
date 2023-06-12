variable "name" {
  type = string
}

variable "autoscaling_target" {
  type = string
}

variable "max_capacity" {
  type = number
}

resource "aws_appautoscaling_scheduled_action" "scale_down" {
  name               = "${var.name}-scheduled_scaling_up"
  service_namespace  = var.autoscaling_target.service_namespace
  resource_id        = var.autoscaling_target.resource_id
  scalable_dimension = var.autoscaling_target.scalable_dimension

  recurrence = "0 19 * * *"

  scalable_target_action {
    min_capacity = 0
    max_capacity = 0
  }
}

resource "aws_appautoscaling_scheduled_action" "scale_up" {
  name               = "${var.name}-scheduled_scaling_down"
  service_namespace  = var.autoscaling_target.service_namespace
  resource_id        = var.autoscaling_target.resource_id
  scalable_dimension = var.autoscaling_target.scalable_dimension

  recurrence = "0 7 * * *"

  scalable_target_action {
    min_capacity = 0
    max_capacity = var.max_capacity
  }
}
