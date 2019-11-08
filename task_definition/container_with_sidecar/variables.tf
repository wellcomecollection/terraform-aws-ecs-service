variable "task_name" {}

# App

variable "app_container_image" {}

variable "app_cpu" {}
variable "app_memory" {}

variable "app_mount_points" {
  type    = "list"
  default = []
}

variable "app_env_vars" {
  type    = "map"
  default = {}
}

variable "secret_app_env_vars" {
  type    = "map"
  default = {}
}

# Sidecar

variable "sidecar_container_image" {}

variable "sidecar_cpu" {}
variable "sidecar_memory" {}

variable "sidecar_mount_points" {
  type    = "list"
  default = []
}

variable "sidecar_env_vars" {
  type    = "map"
  default = {}
}

variable "secret_sidecar_env_vars" {
  type    = "map"
  default = {}
}

variable "app_user" {
  default = "root"
}

variable "sidecar_user" {
  default = "root"
}

variable "launch_type" {
  default = "FARGATE"
}

variable "aws_region" {}
