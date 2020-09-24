variable "task_name" {
  type = string
}

variable "container_definitions" {}
// This is intentionally untyped.
// If typed you can't have optional nulls which results in some complexity.
// See https://github.com/hashicorp/terraform/issues/19898

variable "launch_types" {
  type    = list(string)
  default = ["FARGATE"]
}

variable "network_mode" {
  default = "awsvpc"
  type    = string
}

variable "cpu" {
  type    = number
  default = null
}

variable "memory" {
  type    = number
  default = null
}

variable "volumes" {
  type = list(object({
    name      = string
    host_path = string
  }))
  default = []
}

variable "efs_volumes" {
  type = list(object({
    name           = string
    file_system_id = string
    root_directory = string
  }))
  default = []
}

variable "placement_constraints" {
  type = list(object({
    type       = string
    expression = string
  }))
  default = []
}
