variable "task_name" {
  type = string
}

variable "container_definitions" {}
// This is intentionally untyped.
// If typed you can't have optional nulls which results in some complexity.
// See https://github.com/hashicorp/terraform/issues/19898

variable "launch_types" {
  type = list(string)
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

variable "ebs_volume_name" {
  type    = string
  default = ""
}

variable "ebs_host_path" {
  type    = string
  default = ""
}

variable "efs_volume_name" {
  type    = string
  default = ""
}

variable "efs_host_path" {
  type    = string
  default = ""
}