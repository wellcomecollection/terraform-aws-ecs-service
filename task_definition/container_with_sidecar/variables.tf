variable "task_name" {}
variable "sidecar_name" {}

variable "cpu" {}
variable "memory" {}

variable "use_awslogs" {
  type    = bool
  default = false
}

# App

variable "app_container_image" {}
variable "app_container_port" {
  // Leaving this as the default, -1, will not expose a port on the container
  default = -1
}
variable "app_cpu" {}
variable "app_memory" {}

variable "app_container_name" {
  default = "app"
}

variable "app_mount_points" {
  type    = list(map(string))
  default = []
}

variable "app_env_vars" {
  type    = map(string)
  default = {}
}

variable "secret_app_env_vars" {
  type    = map(string)
  default = {}
}

variable "app_healthcheck_json" {
  type    = string
  default = ""
}

# Sidecar

variable "sidecar_container_image" {}
variable "sidecar_container_port" {
  // Leaving this as the default, -1, will not expose a port on the container
  default = -1
}
variable "sidecar_cpu" {}
variable "sidecar_memory" {}

variable "sidecar_container_name" {
  default = "nginx"
}

variable "sidecar_mount_points" {
  type    = list(map(string))
  default = []
}

variable "sidecar_env_vars" {
  type    = map(string)
  default = {}
}

variable "secret_sidecar_env_vars" {
  type    = map(string)
  default = {}
}

variable "sidecar_depends_on_app_condition" {
  type    = string
  default = ""
}

variable "ebs_volume_name" {
  default = ""
}

variable "ebs_host_path" {
  default = ""
}

variable "efs_volume_name" {
  default = ""
}

variable "efs_host_path" {
  default = ""
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
